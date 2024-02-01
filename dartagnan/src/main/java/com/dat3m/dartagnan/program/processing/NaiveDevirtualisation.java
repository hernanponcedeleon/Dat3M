package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.processing.ExprTransformer;
import com.dat3m.dartagnan.expression.processing.ExpressionInspector;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.functions.FunctionCall;
import com.dat3m.dartagnan.program.memory.Memory;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.google.common.base.Verify;
import com.google.common.collect.Iterables;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.*;
import java.util.stream.Collectors;

/*
    This pass performs "devirtualisation" (replacing indirect/dynamic function calls by direct/static calls).
    It does so in the following way:
        - Every non-standard use (i.e., no direct call) of a function expression is registered.
        - All registered functions get an address value assigned.
        - All non-standard uses are replaced by their address values.
        - Every indirect call is replaced by a switch statement over all registered functions that have a matching type.
          Each case of the switch statement contains a direct call to the corresponding function.

     TODO: We also need to devirtualize intrinsic functions that expect function pointers.
      For now, we only devirtualize pthread_create based on its third parameter.
      More generally, we could extend IntrinsicInfo to tell for each intrinsic which parameters are function pointers and
      need devirtualization.
 */
public class NaiveDevirtualisation implements ProgramProcessor {

    private static final Logger logger = LogManager.getLogger(NaiveDevirtualisation.class);

    private int nextAvailableFuncAddress = 8; // We use 8-aligned addresses

    private NaiveDevirtualisation() {
    }

    public static NaiveDevirtualisation newInstance() { return new NaiveDevirtualisation(); }

    @Override
    public void run(Program program) {
        final FunctionCollector functionCollector = new FunctionCollector();
        final FunctionToAddressTransformer toAddressTransformer = new FunctionToAddressTransformer();

        findAndTransformAddressTakenFunctionsInMemory(program.getMemory(), functionCollector, toAddressTransformer);
        for (Function func : Iterables.concat(program.getThreads(), program.getFunctions())) {
            findAndTransformAddressTakenFunctions(func, functionCollector, toAddressTransformer);
        }

        for (Function func : Iterables.concat(program.getThreads(), program.getFunctions())) {
            devirtualise(func, toAddressTransformer.func2AddressMap);
        }
    }

    private void findAndTransformAddressTakenFunctionsInMemory(
            Memory memory, FunctionCollector functionCollector, FunctionToAddressTransformer toAddressTransformer
    ) {
        for (MemoryObject memoryObject : memory.getObjects()) {
            for (Integer field : memoryObject.getStaticallyInitializedFields()) {
                functionCollector.reset();
                final Expression initValue = memoryObject.getInitialValue(field).accept(functionCollector);

                for (Function func : functionCollector.collectedFunctions) {
                    assignAddressToFunction(func, toAddressTransformer.func2AddressMap);
                }

                if (!functionCollector.collectedFunctions.isEmpty()) {
                    memoryObject.setInitialValue(field, initValue.accept(toAddressTransformer));
                }
            }
        }
    }

    private void findAndTransformAddressTakenFunctions(
            Function function, FunctionCollector functionCollector, FunctionToAddressTransformer toAddressTransformer
    ) {
        for (Event e : function.getEvents()) {
            functionCollector.reset();
            applyTransformerToEvent(e, functionCollector);
            for (Function func : functionCollector.collectedFunctions) {
                assignAddressToFunction(func, toAddressTransformer.func2AddressMap);
            }

            if (!functionCollector.collectedFunctions.isEmpty()) {
                applyTransformerToEvent(e, toAddressTransformer);
            }
        }
    }

    private boolean assignAddressToFunction(Function func, Map<Function, IntLiteral> func2AddressMap) {
        final IntegerType ptrType = TypeFactory.getInstance().getArchType();
        final ExpressionFactory expressions = ExpressionFactory.getInstance();
        if (!func2AddressMap.containsKey(func)) {
            logger.debug("Assigned address \"{}\" to function \"{}\"", nextAvailableFuncAddress, func);
            func2AddressMap.put(func, expressions.makeValue(nextAvailableFuncAddress, ptrType));
            nextAvailableFuncAddress += 8;
            return true;
        }
        return false;
    }

    private void applyTransformerToEvent(Event e, ExpressionVisitor<Expression> transformer) {
        if (e instanceof FunctionCall call) {
            if (call.isDirectCall() && call.getCalledFunction().getIntrinsicInfo() == Intrinsics.Info.P_THREAD_CREATE) {
                // We avoid transforming functions passed as call target to pthread_create
                // However, we still collect the last argument of the call, because it
                // is the argument passed to the created thread (which might be a pointer to a function).
                final Expression transformed = call.getArguments().get(call.getArguments().size() - 1).accept(transformer);
                call.getArguments().set(call.getArguments().size() - 1, transformed);
            } else {
                call.getArguments().replaceAll(arg -> arg.accept(transformer));
            }
        } else if (e instanceof RegReader reader) {
            reader.transformExpressions(transformer);
        }
    }

    private void devirtualise(Function function, Map<Function, IntLiteral> func2AddressMap) {
        final ExpressionFactory expressions = ExpressionFactory.getInstance();

        int devirtCounter = 0;
        for (FunctionCall call : function.getEvents(FunctionCall.class)) {
            if (!needsDevirtualization(call)) {
                continue;
            }

            final List<Function> possibleTargets = getPossibleTargets(call, func2AddressMap);
            // FIXME: Here we remove the calling function itself so as to avoid trivial recursion.
            //  However, indirect/mutual recursion is not prevented by this!
            if (possibleTargets.removeIf(f -> f == function)) {
                logger.warn("Found potentially recursive dynamic call \"{}\". " +
                        "Dartagnan (unsoundly) assumes the recursive call cannot happen.", call);
            }

            if (possibleTargets.isEmpty()) {
                logger.warn("Cannot resolve dynamic call \"{}\", no matching functions found.", call);
            }

            logger.trace("Devirtualizing call \"{}\" with possible targets: {}", call, possibleTargets);

            final List<Label> caseLabels = new ArrayList<>(possibleTargets.size());
            final List<CondJump> caseJumps = new ArrayList<>(possibleTargets.size());
            final Expression funcPtr = getFunctionPointer(call);
            // Construct call table
            for (Function possibleTarget : possibleTargets) {
                final IntLiteral targetAddress = func2AddressMap.get(possibleTarget);
                final Label caseLabel = EventFactory.newLabel(String.format("__Ldevirt_%s#%s", targetAddress.getValue(), devirtCounter));
                final CondJump caseJump = EventFactory.newJump(expressions.makeEQ(funcPtr, targetAddress), caseLabel);
                caseLabels.add(caseLabel);
                caseJumps.add(caseJump);
            }

            final Event noMatch = EventFactory.newAssert(expressions.makeFalse(), "Invalid function pointer");
            final Label endLabel = EventFactory.newLabel(String.format("__Ldevirt_end#%s", devirtCounter));

            final List<Event> callReplacement = new ArrayList<>();
            callReplacement.add(EventFactory.newStringAnnotation("=== Devirtualized call ==="));
            callReplacement.addAll(caseJumps);
            callReplacement.add(noMatch);
            for (int i = 0; i < caseLabels.size(); i++) {
                callReplacement.add(caseLabels.get(i));
                callReplacement.add(devirtualiseCall(call, possibleTargets.get(i)));
                callReplacement.add(EventFactory.newGoto(endLabel));
            }
            callReplacement.add(endLabel);
            callReplacement.add(EventFactory.newStringAnnotation("=== End of devirtualized call ==="));

            call.replaceBy(callReplacement);
            callReplacement.forEach(e -> e.copyAllMetadataFrom(call));

            devirtCounter++;
        }
    }

    private boolean needsDevirtualization(FunctionCall call) {
        return !call.isDirectCall() ||
                (call.getCalledFunction().getIntrinsicInfo() == Intrinsics.Info.P_THREAD_CREATE
                && !(call.getArguments().get(2) instanceof Function));
    }

    private List<Function> getPossibleTargets(FunctionCall call, Map<Function, IntLiteral> func2AddressMap) {
        final List<Function> possibleTargets;
        if (!call.isDirectCall()) {
            possibleTargets = func2AddressMap.keySet().stream()
                    .filter(f -> f.getFunctionType() == call.getCallType()).collect(Collectors.toList());
        } else if (call.getCalledFunction().getIntrinsicInfo() == Intrinsics.Info.P_THREAD_CREATE) {
            final TypeFactory types = TypeFactory.getInstance();
            final Type ptrType = types.getPointerType();
            final Type threadType = types.getFunctionType(ptrType, List.of(ptrType));
            possibleTargets = func2AddressMap.keySet().stream()
                    .filter(f -> f.getFunctionType() == threadType).collect(Collectors.toList());
        } else {
            possibleTargets = List.of();
            throwInternalError(call);
        }

        return possibleTargets;
    }

    private FunctionCall devirtualiseCall(FunctionCall virtCall, Function devirtCallTarget) {
        final FunctionCall devirtCall = virtCall.getCopy();
        setFunctionPointer(devirtCall, devirtCallTarget);
        return devirtCall;
    }

    private Expression getFunctionPointer(FunctionCall call) {
        if (!call.isDirectCall()) {
            return call.getCallTarget();
        } else if (call.getCalledFunction().getIntrinsicInfo() == Intrinsics.Info.P_THREAD_CREATE) {
            return call.getArguments().get(2);
        }
        throwInternalError(call);
        return null;
    }

    private void setFunctionPointer(FunctionCall call, Expression functionPtr) {
        if (!call.isDirectCall()) {
            call.setCallTarget(functionPtr);
        } else if (call.getCalledFunction().getIntrinsicInfo() == Intrinsics.Info.P_THREAD_CREATE) {
            call.setArgument(2, functionPtr);
        } else {
            throwInternalError(call);
        }
    }

    @SuppressWarnings("all")
    private void throwInternalError(FunctionCall virtCall) {
        Verify.verify(false, "Encountered unexpected virtual function call: " + virtCall);
    }


    private static class FunctionCollector implements ExpressionInspector {

        private final Set<Function> collectedFunctions = new HashSet<>();

        public void reset() { collectedFunctions.clear(); }

        @Override
        public Expression visitFunction(Function function) {
            collectedFunctions.add(function);
            return function;
        }
    }

    private static class FunctionToAddressTransformer extends ExprTransformer {

        private final Map<Function, IntLiteral> func2AddressMap = new HashMap<>();

        @Override
        public Expression visitFunction(Function function) {
            return func2AddressMap.containsKey(function) ? func2AddressMap.get(function) : function;
        }
    }

}
