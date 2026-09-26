package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.IRHelper;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.functions.FunctionCall;
import com.dat3m.dartagnan.program.event.functions.ValueFunctionCall;
import com.google.common.collect.ImmutableList;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.math.BigInteger;
import java.util.*;
import java.util.function.BiPredicate;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import static com.dat3m.dartagnan.configuration.OptionNames.REMOVE_ASSERTION_OF_TYPE;
import static com.dat3m.dartagnan.program.event.EventFactory.*;
import static com.google.common.base.Preconditions.checkArgument;

/**
 * Manages a collection of all functions that the verifier can define itself,
 * if the input program does not already provide a definition.
 * Also defines the semantics of most intrinsics,
 * except some thread-library primitives, which are instead defined in {@link ThreadCreation}.
 */
@Options
public class Intrinsics {

    private static final Logger logger = LoggerFactory.getLogger(Intrinsics.class);

    @Option(name = REMOVE_ASSERTION_OF_TYPE,
            description = "Remove assertions of type [user, overflow, invalidderef, unknown_function].",
            toUppercase=true,
            secure = true)
    private EnumSet<AssertionType> notToInline = EnumSet.noneOf(AssertionType.class);

    private enum AssertionType { USER, OVERFLOW, INVALIDDEREF, UNKNOWN_FUNCTION }

    private final boolean detectMixedSizeAccesses;

    private static final TypeFactory types = TypeFactory.getInstance();
    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();

    private Intrinsics(boolean msa) {
        detectMixedSizeAccesses = msa;
    }

    public static Intrinsics newInstance() {
        return new Intrinsics(false);
    }
    
    public static Intrinsics fromConfig(Configuration config, boolean detectMixedSizeAccesses)
            throws InvalidConfigurationException {
        Intrinsics instance = new Intrinsics(detectMixedSizeAccesses);
        config.inject(instance);
        return instance;
    }

    public ProgramProcessor markIntrinsicsPass() {
        return this::markIntrinsics;
    }

    /*
        This pass runs early in the processing chain and resolves intrinsics whose semantics
        can be captured by a context-insensitive sequence of other events.

        TODO: We could insert the definitions here directly into the function declarations of the intrinsics.
     */
    public FunctionProcessor earlyInliningPass() {
        return this::inlineEarly;
    }

    /*
        This pass runs late in the processing chain, in particular after regular inlining, unrolling, SCCP, and thread creation.
        Thus, the following conditions should be met:
        - The intrinsics are live (reachable) and have constant input if possible.
        - All code duplications ran: The replacement of the intrinsic will not get copied again.
          This allows this pass to set up global state per replaced intrinsic without getting invalidated later.
     */
    public ProgramProcessor lateInliningPass() {
        return this::inlineLate;
    }

    // --------------------------------------------------------------------------------------------------------
    // Marking

    public enum Info {
        // --------------------------- pthread threading ---------------------------
        P_THREAD_SELF(List.of("pthread_self", "__VERIFIER_tid"), false, false, true, false, Intrinsics::inlinePthreadSelf),
        P_THREAD_EQUAL("pthread_equal", false, false, true, false, Intrinsics::inlinePthreadEqual),
        // --------------------------- __VERIFIER ---------------------------
        LLVM_OBJECTSIZE("llvm.objectsize", false, false, true, false, null),
        LLVM_MEMCPY("llvm.memcpy", true, true, true, false, Intrinsics::inlineMemCpy),
        LLVM_MEMSET("llvm.memset", true, false, true, false, Intrinsics::inlineMemSet),
        // --------------------------- Misc ---------------------------
        STD_MEMCPY("memcpy", true, true, true, false, Intrinsics::inlineMemCpy),
        STD_MEMCPYS("memcpy_s", true, true, true, false, Intrinsics::inlineMemCpyS),
        STD_MEMSET(List.of("memset", "__memset_chk"), true, false, true, false, Intrinsics::inlineMemSet),
        STD_MEMCMP("memcmp", false, true, true, false, Intrinsics::inlineMemCmp),
        // ------------------------- Unknown function ---------------------------
        MISSING(List.of(), false, false, false, true, Intrinsics::inlineUnknownFunction),
        ;

        private final List<String> variants;
        private final boolean writesMemory;
        private final boolean readsMemory;
        private final boolean alwaysReturns;
        private final boolean isEarly;
        private final Replacer replacer;

        Info(List<String> variants, boolean writesMemory, boolean readsMemory, boolean alwaysReturns, boolean isEarly,
                Replacer replacer) {
            this.variants = variants;
            this.writesMemory = writesMemory;
            this.readsMemory = readsMemory;
            this.alwaysReturns = alwaysReturns;
            this.isEarly = isEarly;
            this.replacer = replacer;
        }

        Info(String name, boolean writesMemory, boolean readsMemory, boolean alwaysReturns, boolean isEarly,
                Replacer replacer) {
            this(List.of(name), writesMemory, readsMemory, alwaysReturns, isEarly, replacer);
        }

        public List<String> variants() {
            return variants;
        }

        public boolean writesMemory() {
            return writesMemory;
        }

        public boolean readsMemory() {
            return readsMemory;
        }

        public boolean alwaysReturns() {
            return alwaysReturns;
        }

        public boolean isEarly() {
            return isEarly;
        }

        private boolean matches(String funcName) {
            boolean isPrefix = switch(this) {
                case  LLVM_MEMCPY, LLVM_MEMSET, LLVM_OBJECTSIZE -> true;
                default -> false;
            };
            BiPredicate<String, String> matchingFunction = isPrefix ? String::startsWith : String::equals;
            return variants.stream().anyMatch(v -> matchingFunction.test(funcName, v));
        }
    }


    @FunctionalInterface
    private interface Replacer {
        List<Event> replace(Intrinsics self, FunctionCall call);
    }

    private void markIntrinsics(Program program) {
        final var missingSymbols = new TreeSet<String>();
        for (Function func : program.getFunctions()) {
            if (!func.hasBody()) {
                final String funcName = func.getName();
                Arrays.stream(Info.values())
                        .filter(info -> info.matches(funcName))
                        .findFirst()
                        .ifPresentOrElse(func::setIntrinsicInfo, () -> {
                            missingSymbols.add(funcName);
                            func.setIntrinsicInfo(Info.MISSING);});
            }
        }
        if (!missingSymbols.isEmpty()) {
            logger.warn("{}. Detecting calls to unknown functions requires --property=program_spec.",
                    missingSymbols.stream().collect(Collectors.joining(", ", "Unknown intrinsics ", "")));
        }
    }

    private void replace(FunctionCall call, Replacer replacer) {
        if (replacer == null) {
            throw new MalformedProgramException(
                    String.format("Intrinsic \"%s\" without replacer", call.getCalledFunction().getName()));
        }
        final List<Event> replacement = replacer.replace(this, call);
        if (replacement.isEmpty()) {
            call.tryDelete();
        } else if (replacement.get(0) != call) {
            if (!call.getUsers().isEmpty() && call.getUsers().stream().allMatch(ExecutionStatus.class::isInstance)) {
                final Map<Event, Event> updateMapping = Map.of(call, replacement.get(0));
                ImmutableList.copyOf(call.getUsers()).forEach(user -> user.updateReferences(updateMapping));
            }
            // NOTE: We deliberately do not use the call markers, because (1) we want to distinguish between
            // intrinsics and normal calls, and (2) we do not want to have intrinsics in the call stack.
            // We may want to change this behaviour though.
            call.insertBefore(EventFactory.newStringAnnotation(
                    String.format("=== Calling intrinsic %s ===", call.getCalledFunction().getName())
            ));
            call.insertAfter(EventFactory.newStringAnnotation(
                    String.format("=== Returning from intrinsic %s ===", call.getCalledFunction().getName())
            ));
            IRHelper.replaceWithMetadata(call, replacement);
        }
    }

    // --------------------------------------------------------------------------------------------------------
    // Simple early intrinsics

    private void inlineEarly(Function function) {
        for (final FunctionCall call : function.getEvents(FunctionCall.class)) {
            if (!call.isDirectCall()) {
                continue;
            }
            final Intrinsics.Info info = call.getCalledFunction().getIntrinsicInfo();
            if (info != null && info.isEarly()) {
                replace(call, info.replacer);
            }
        }
    }

    private List<Event> inlinePthreadSelf(FunctionCall call) {
        // This intrinsics is mainly defined by ThreadCreation.
        assert call.getArguments().isEmpty();
        final Register resultRegister = getResultRegister(call);
        final Expression tidExpr = call.getThread().getRegister(ThreadCreation.THREAD_SELF_REGISTER_NAME);
        assert tidExpr != null : "Non-POSIX thread %s".formatted(call.getThread());
        return List.of(newLocal(resultRegister, expressions.makeCast(tidExpr, resultRegister.getType())));
    }

    private List<Event> inlinePthreadEqual(FunctionCall call) {
        final Register resultRegister = getResultRegisterAndCheckArguments(2, call);
        final Expression leftId = call.getArguments().get(0);
        final Expression rightId = call.getArguments().get(1);
        final Expression equation = expressions.makeEQ(leftId, rightId);
        return List.of(
                EventFactory.newLocal(resultRegister, expressions.makeCast(equation, resultRegister.getType()))
        );
    }

    private List<Event> inlineAssert(AssertionType skip, String errorMsg) {
        final Expression condition = expressions.makeFalse();
        final Event assertion = notToInline.contains(skip) ? null : EventFactory.newAssert(condition, errorMsg);
        final Event abort = EventFactory.newAbortIf(expressions.makeTrue());
        abort.addTags(Tag.EXCEPTIONAL_TERMINATION);
        return eventSequence(assertion, abort);
    }



    private List<Event> inlineUnknownFunction(FunctionCall call) {
        final List<Event> replacement = new ArrayList<>();
        if (call instanceof ValueFunctionCall) {
            replacement.addAll(inlineCallAsNonDet(call));
        }
        replacement.addAll(inlineAssert(AssertionType.UNKNOWN_FUNCTION,
            "Calling unknown function " + call.getCalledFunction().getName()));
        return replacement;
    }


    // --------------------------------------------------------------------------------------------------------
    // Simple late intrinsics

    private void inlineLate(Program program) {
        program.getThreads().forEach(this::inlineLate);
    }

    private void inlineLate(Function function) {
        for (final FunctionCall call : function.getEvents(FunctionCall.class)) {
            if (!call.isDirectCall()) {
                continue;
            }
            final Intrinsics.Info info = call.getCalledFunction().getIntrinsicInfo();
            if (info != null && !info.isEarly()) {
                replace(call, info.replacer);
            } else {
                final String error = String.format("Undefined function %s", call.getCalledFunction().getName());
                throw new UnsupportedOperationException(error);
            }
        }
    }

    private List<Event> inlineCallAsNonDet(FunctionCall call) {
        return List.of(
                EventFactory.newSignedNonDetChoice(getResultRegister(call), true)
        );
    }

    // Handles both std.memcpy and llvm.memcpy
    // https://en.cppreference.com/w/c/string/byte/memcpy
    private List<Event> inlineMemCpy(FunctionCall call) {
        final Function caller = call.getFunction();
        final Expression dest = call.getArguments().get(0);
        final Expression src = call.getArguments().get(1);
        final Expression countExpr = call.getArguments().get(2);
        // final Expression isVolatile = call.getArguments.get(3) // LLVM's memcpy has an extra argument

        final List<Event> replacement = new ArrayList<>();
        insertMemCopy(replacement, src, dest, countExpr, caller, call);
        if (call instanceof ValueFunctionCall valueCall) {
            // std.memcpy returns the destination address, llvm.memcpy has no return value
            replacement.add(EventFactory.newLocal(valueCall.getResultRegister(), dest));
        }

        return replacement;
    }

    // https://en.cppreference.com/w/c/string/byte/memcpy
    private List<Event> inlineMemCpyS(FunctionCall call) {
        // Cast guaranteed to success by the return type of memcpy_s
        final Register resultRegister = ((ValueFunctionCall)call).getResultRegister();
        final Function caller = call.getFunction();
        final Expression dest = call.getArguments().get(0);
        final Expression destszExpr = call.getArguments().get(1);
        final Expression src = call.getArguments().get(2);
        final Expression countExpr = call.getArguments().get(3);

        // Runtime checks
        final Expression nullExpr = expressions.makeZero(types.getArchType());
        final Expression destIsNull = expressions.makeEQ(dest, nullExpr);
        final Expression srcIsNull = expressions.makeEQ(src, nullExpr);

        // We assume RSIZE_MAX = 2^64-1
        final Expression rsize_max = expressions.makeValue(BigInteger.ONE.shiftLeft(64).subtract(BigInteger.ONE), types.getArchType());
        // These parameters have type rsize_t/size_t which we model as types.getArchType(), thus the cast
        final Expression castDestszExpr = expressions.makeCast(destszExpr, types.getArchType());
        final Expression castCountExpr = expressions.makeCast(countExpr, types.getArchType());

        final Expression invalidDestsz = expressions.makeGT(castDestszExpr, rsize_max, false);
        final Expression countGtMax = expressions.makeGT(castCountExpr, rsize_max, false);
        final Expression countGtdestszExpr = expressions.makeGT(castCountExpr, castDestszExpr, false);
        final Expression invalidCount = expressions.makeOr(countGtMax, countGtdestszExpr);
        final Expression overlap = expressions.makeAnd(
                expressions.makeGT(expressions.makeAdd(src, castCountExpr), dest, false),
                expressions.makeGT(expressions.makeAdd(dest, castCountExpr), src, false));

        final List<Event> replacement = new ArrayList<>();
        
        final Label check1 = EventFactory.newLabel("__memcpy_s_check_1");
        final Label check1fail = EventFactory.newLabel("__memcpy_s_fail_1");
        final Label check2 = EventFactory.newLabel("__memcpy_s_check_2");
        final Label check2fail = EventFactory.newLabel("__memcpy_s_fail_2");
        final Label success = EventFactory.newLabel("__memcpy_s_success");
        final Label end = EventFactory.newLabel("__memcpy_s_end");

        final Expression returnCodeFail = expressions.makeOne((IntegerType)resultRegister.getType());
        final Expression returnCodeSuccess = expressions.makeZero((IntegerType)resultRegister.getType());

        // If dest == NULL or destsz > RSIZE_MAX,
        // return error > 0.
        final CondJump check1part1 = EventFactory.newJump(destIsNull, check1fail);
        final CondJump check1part2 = EventFactory.newJumpUnless(invalidDestsz, check2);
        final CondJump skipRest1 = EventFactory.newGoto(end);
        final Local retError1 = EventFactory.newLocal(resultRegister, returnCodeFail);
        replacement.addAll(List.of(
            check1,
            check1part1,
            check1part2,
            check1fail,
            retError1,
            skipRest1
        ));

        // Otherwise, if src == NULL || count > destsz || overlap(src, dest),
        // return error > 0 and zero out [dest, dest+destsz).
        final CondJump check2part1 = EventFactory.newJump(srcIsNull, check2fail);
        final CondJump check2part2 = EventFactory.newJump(invalidCount, check2fail);
        final CondJump check2part3 = EventFactory.newJumpUnless(overlap, success);
        final CondJump skipRest2 = EventFactory.newGoto(end);
        final Local retError2 = EventFactory.newLocal(resultRegister, returnCodeFail);
        replacement.addAll(List.of(
            check2,
            check2part1,
            check2part2,
            check2part3,
            check2fail
        ));

        // Otherwise, return error = 0 and do the actual copy.
        forEachMemSpan(replacement, destszExpr, call, (offset, type) -> {
            final Expression destAddr = expressions.makeAdd(dest, offset);
            final Expression zero = expressions.makeZero(type);
            replacement.add(EventFactory.newStore(destAddr, zero));
        });
        replacement.addAll(List.of(
            retError2,
            skipRest2
        ));

        final Local retSuccess = EventFactory.newLocal(resultRegister, returnCodeSuccess);
        replacement.add(success);
        insertMemCopy(replacement, src, dest, countExpr, caller, call);
        replacement.addAll(List.of(
            retSuccess,
            end
        ));

        return replacement;
    }

    private void insertMemCopy(List<Event> replacement, Expression src, Expression dest, Expression count,
            Function caller, FunctionCall call) {
        forEachMemSpan(replacement, count, call, (offset, type) -> {
            final Expression srcAddr = expressions.makeAdd(src, offset);
            final Expression destAddr = expressions.makeAdd(dest, offset);
            final Register register = caller.newUniqueRegister("__memcpy", type);
            final Event load = EventFactory.newLoad(register, srcAddr);
            final Event store = EventFactory.newStore(destAddr, register);
            replacement.addAll(List.of(load, store));
        });
    }

    // https://en.cppreference.com/w/c/string/byte/memcmp
    private List<Event> inlineMemCmp(FunctionCall call) {
        final Function caller = call.getFunction();
        final Expression src1 = call.getArguments().get(0);
        final Expression src2 = call.getArguments().get(1);
        final Expression countExpr = call.getArguments().get(2);
        final Register returnReg = ((ValueFunctionCall)call).getResultRegister();
        // Stores the result in eight bits.
        final Register cmpReg = caller.newUniqueRegister("__memcmp_cmp", types.getByteType());
        // When this intrinsics is implemented with multibyte accesses, this determines the comparison order.
        final boolean bigEndian = caller.getProgram().getMemory().isBigEndian();
        assert bigEndian != caller.getProgram().getMemory().isLittleEndian();

        final List<Event> replacement = new ArrayList<>();
        final Label endCmp = EventFactory.newLabel("__memcmp_end");
        // Initialize the register for when `countExpr` is zero.
        replacement.add(EventFactory.newLocal(cmpReg, expressions.makeZero(types.getByteType())));
        // Compare all bytes in order.
        forEachMemSpan(replacement, countExpr, call, (offset, type) -> {
            final Expression src1Addr = expressions.makeAdd(src1, offset);
            final Expression src2Addr = expressions.makeAdd(src2, offset);
            final Register regSrc1 = caller.newUniqueRegister("__memcmp_src1", type);
            final Register regSrc2 = caller.newUniqueRegister("__memcmp_src2", type);
            replacement.add(EventFactory.newLoad(regSrc1, src1Addr));
            replacement.add(EventFactory.newLoad(regSrc2, src2Addr));
            // Iterate in byte order.
            final int bitWidth = type.getBitWidth();
            for (int cmpByte = 0; cmpByte < bitWidth; cmpByte += 8) {
                final int cmpOffset = bigEndian ? bitWidth - 8 - cmpByte : cmpByte;
                final Expression byte1 = expressions.makeIntExtract(regSrc1, cmpOffset, cmpOffset + 8 - 1);
                final Expression byte2 = expressions.makeIntExtract(regSrc2, cmpOffset, cmpOffset + 8 - 1);
                replacement.add(EventFactory.newLocal(cmpReg, expressions.makeSub(byte1, byte2)));
                replacement.add(EventFactory.newJump(expressions.makeNEQ(byte1, byte2), endCmp));
            }
        });
        replacement.add(endCmp);
        replacement.add(EventFactory.newLocal(returnReg, expressions.makeCast(cmpReg, returnReg.getType())));

        return replacement;
    }

    // Handles, std.memset, llvm.memset and __memset_chk (checked memset)
    private List<Event> inlineMemSet(FunctionCall call) {
        final Expression dest = call.getArguments().get(0);
        final Expression fillExpr = call.getArguments().get(1);
        final Expression countExpr = call.getArguments().get(2);
        // final Expression isVolatile = call.getArguments.get(3) // LLVM's memset has an extra argument
        // final Expression boundExpr = call.getArguments.get(3) // __memset_chk has an extra argument

        //FIXME: Handle memset_chk correctly. For now, we ignore the bound check parameter because that one is
        // usually provided by llvm.objectsize which we cannot resolve for now. Since we usually assume UB-freedom,
        // the check can be ignored for the most part.
        if (call.getCalledFunction().getName().equals("__memset_chk")) {
            logger.warn("Treating call to \"__memset_chk\" as call to \"memset\": skipping bound checks.");
        }

        final List<Event> replacement = new ArrayList<>();

        // Generate stores
        final Expression fillByte = expressions.makeIntegerCast(fillExpr, types.getByteType(), false);
        final Map<Integer, Expression> fillByBitWidth = new HashMap<>();
        fillByBitWidth.put(8, fillByte);
        forEachMemSpan(replacement, countExpr, call, (offset, type) -> {
            final Expression destAddr = expressions.makeAdd(dest, offset);
            final Expression fill = fillByBitWidth.computeIfAbsent(type.getBitWidth(),
                    n -> expressions.makeIntConcat(IntStream.range(0, n / 8).mapToObj(x -> fillByte).toList()));

            replacement.add(newStore(destAddr, fill));
        });

        if (call instanceof ValueFunctionCall valueCall) {
            // `std.memset` returns the destination address, `llvm.memset` has no return value.
            replacement.add(EventFactory.newLocal(valueCall.getResultRegister(), dest));
        }

        return replacement;
    }

    private interface MemAction { void run(Expression offsetBytes, IntegerType accessType); }

    // Used for memory operations with dynamic size.
    // Uses `countExpr` to divide the maximal byte range of the operation into consecutive smaller spans.
    // Performs `action` for either each span, or each byte, depending on the support for mixed size accesses.
    // Checks `countExpr` dynamically at the start of each next span.
    // The resulting program takes the form of an unrolled loop.
    private void forEachMemSpan(List<Event> replacement, Expression countExpr, FunctionCall call, MemAction action) {
        final Slice count = computeValueSpace(countExpr, call);
        checkArgument(0 <= count.start && count.start <= count.end && 0 < count.step, "Invalid count %s: %s", count, call);
        checkArgument(countExpr.getType() instanceof IntegerType, "Non-integer count expression: %s", call);
        if ((count.end - count.start) % count.step != 0) {
            logger.warn("Suspicious count {}: {}", count, call);
        }
        final IntegerType countType = (IntegerType) countExpr.getType();
        // Process the first span [0,count.start-1].
        // If `countExpr` is a positive constant, this is enabled.
        // The span does not need any checks for `countExpr`.
        if (count.start > 0) {
            translateMemSpan(expressions.makeZero(countType), count.start, countType, action);
        }
        // Each remaining span needs one check for `countExpr`.
        // If `countExpr` is a constant, this is disabled.
        // This is implemented as a loop.
        if (count.start + count.step < count.end) {
            final Register offsetRegister = call.getFunction().newUniqueRegister("__offset", countType);
            final Expression stepExpr = expressions.makeValue(count.step, countType);
            final Expression countReached = expressions.makeLTE(countExpr, offsetRegister, false);
            final Expression loopBound = expressions.makeValue((count.end - count.start) / count.step, countType);
            final Label loopEntry = EventFactory.newLabel("__start");
            final Label loopExit = EventFactory.newLabel("__end");
            replacement.add(EventFactory.newLocal(offsetRegister, expressions.makeValue(count.start, countType)));
            replacement.add(EventFactory.newLoopBound(loopBound));
            replacement.add(loopEntry);
            replacement.add(EventFactory.newIfJump(countReached, loopExit, loopExit));
            translateMemSpan(offsetRegister, count.step, countType, action);
            replacement.add(EventFactory.newLocal(offsetRegister, expressions.makeAdd(offsetRegister, stepExpr)));
            replacement.add(EventFactory.newGoto(loopEntry));
            replacement.add(loopExit);
        }
        // Mark all events to not generate `si`-pairs if torn with mixed-sized accesses.
        for (Event event : replacement) {
            if (event.hasTag(Tag.MEMORY)) {
                event.addTags(Tag.NO_INSTRUCTION);
            }
        }
    }

    // Describes the sums of `start` with some multiple of `step`, that are lower than `end`.
    private record Slice(int start, int end, int step) {}

    // Over-approximates the set of possible values for a count argument of a dynamic-sized memory operation.
    private Slice computeValueSpace(Expression countExpr, FunctionCall call) {
        if (countExpr instanceof IntLiteral literal) {
            final int value = literal.getValueAsInt();
            return new Slice(value, value + 1, 1);
        }
        //TODO: Perform loop unrolling after these intrinsics, when adding support for this.
        throw new UnsupportedOperationException("Cannot handle dynamic count argument: %s".formatted(call));
    }

    private void translateMemSpan(Expression initialOffset, int bytes, IntegerType countType, MemAction action) {
        // Perform `action` either byte-wise or for the entire byte span.
        final int restBytes = detectMixedSizeAccesses ? bytes : 1;
        final IntegerType restType = types.getIntegerType(8 * restBytes);
        for (int offset = 0; offset < bytes; offset += restBytes) {
            final Expression offsetBytes = expressions.makeValue(offset, countType);
            action.run(expressions.makeAdd(initialOffset, offsetBytes), restType);
        }
    }

    private Register getResultRegisterAndCheckArguments(int expectedArgumentCount, FunctionCall call) {
        checkArguments(expectedArgumentCount, call);
        return getResultRegister(call);
    }

    private void checkArguments(int expectedArgumentCount, FunctionCall call) {
        checkArgument(call.getArguments().size() == expectedArgumentCount, "Wrong function type at %s", call);
    }

    private Register getResultRegister(FunctionCall call) {
        checkArgument(call instanceof ValueFunctionCall, "Unexpected value discard at intrinsic \"%s\"", call);
        return ((ValueFunctionCall) call).getResultRegister();
    }
}
