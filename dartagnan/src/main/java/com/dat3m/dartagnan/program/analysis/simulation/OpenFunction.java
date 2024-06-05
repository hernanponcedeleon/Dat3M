package com.dat3m.dartagnan.program.analysis.simulation;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.AggregateType;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.IRHelper;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.analysis.LiveRegistersAnalysis;
import com.dat3m.dartagnan.program.analysis.LoopAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.functions.Return;
import com.dat3m.dartagnan.program.processing.LoopUnrolling;
import com.google.common.collect.Iterables;
import com.google.common.collect.Lists;
import com.google.common.collect.Sets;
import com.google.common.collect.Streams;

import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/*
    An OpenFunction is a function of special shape:

        { OutT1, OutT2, ..., OutTm } f(InT1 in_1, InT2 in_2, ..., InTn in_n) {
            // ... main body ...
            // Exit blocks
            __EXIT#i:
                out_j = 0 // If out_j is not live on this exit
                ...
                reg_cf_exit = i // Designates the exit taken
            goto __RETURN
            // .... More exit blocks
            __RETURN:
            return (out_1, ..., out_(m-1), reg_cf_exit) // Last output shows exit taken
        }
     NOTE: The out_i are registers.
 */
public class OpenFunction {

    public record ExitBlock(Label exitLabel, Set<Register> liveOutputs, int id) { }

    private final Function func;
    private final List<ExitBlock> exitBlocks = new ArrayList<>();

    private OpenFunction(Function func) {
        this.func = func;
    }

    public final Function getFunction() { return func; }
    public final List<ExitBlock> getExitBlocks() { return exitBlocks; }

    public OpenFunction constructLoopBoundedCopy(int bound) {
        final List<LoopAnalysis.LoopInfo> loops = LoopAnalysis.onFunction(func).getLoopsOfFunction(func);
        if (loops.isEmpty()) {
            return this;
        }
        assert loops.size() == 1; // TODO: Extend to multiple loops

        final TypeFactory types = TypeFactory.getInstance();
        final Comparator<Register> regsSorter = Comparator.comparing(Register::getName);
        final LoopAnalysis.LoopIterationInfo loopIter = loops.get(0).iterations().get(0);

        // ---------------- Collect data of looping code ----------------
        final LiveRegistersAnalysis livenessAnalysis = LiveRegistersAnalysis.forFunction(func);
        final Set<Register> loopingRegs = Sets.intersection(
                livenessAnalysis.getLiveRegistersAt(loopIter.getIterationStart()),
                IRHelper.collectWrittenRegisters(loopIter.computeBody())
        );
        final Set<Register> oldOutputRegs = ((Return)func.getExit()).getValue().get().getRegs();

        // ------------- Construct function skeleton -------------
        final AggregateType newOutputType = types.getAggregateType(Sets.union(oldOutputRegs, loopingRegs).stream()
                .sorted(regsSorter).map(Register::getType).toList());
        final Function extendedFunc = new Function(
                func.getName() + "_bounded",
                types.getFunctionType(newOutputType, func.getFunctionType().getParameterTypes()),
                Lists.transform(func.getParameterRegisters(), Register::getName),
                0,
                null
        );
        final Map<Register, Register> registerMap = IRHelper.copyOverRegisters(func.getRegisters(), extendedFunc);
        // NOTE: We remove the special exit register because we will reintroduce it later.
        final List<Register> newOutputRegs = Sets.union(oldOutputRegs, loopingRegs).stream().map(registerMap::get)
                .filter(reg -> reg != getCfExitRegister(extendedFunc))
                .sorted(regsSorter).toList();

        // ------------- Compute new exit blocks -------------
        final List<ExitBlock> newExits = new ArrayList<>();
        final Map<Event, Event> copyMap = new HashMap<>();
        for (ExitBlock exit : this.exitBlocks) {
            final Label exitLabel = exit.exitLabel.getCopy();
            final Set<Register> liveRegs = exit.liveOutputs.stream().map(registerMap::get).collect(Collectors.toSet());
            final int id = exit.id;
            newExits.add(new ExitBlock(exitLabel, liveRegs, id));

            copyMap.put(exit.exitLabel, exitLabel);
        }
        final ExitBlock loopingExit = new ExitBlock(
                EventFactory.newLabel("__EXIT#LOOP_REPEAT"),
                loopingRegs.stream().map(registerMap::get).collect(Collectors.toSet()),
                newExits.size()
        );
        newExits.add(loopingExit);

        // ------------- Copy body up to loop backjump -------------
        // TODO: Extend to cases where the loop backjump is not the final piece of code in the main body.
        //  For this, we need to copy up to the first exit block.
        final List<Event> bodyCopy = IRHelper.copyPath(func.getEntry(),
                loopIter.getIterationEnd().getSuccessor(), copyMap, registerMap);
        extendedFunc.append(bodyCopy);
        extendedFunc.append(EventFactory.newStringAnnotation("------ End body ------"));

        // ------------- Unroll loop & Replace bound event by special exit -------------
        final LoopUnrolling unrolling = LoopUnrolling.newInstance();
        int id = 0;
        for (Event e : extendedFunc.getEvents()) {
            e.setGlobalId(id++);
        }
        unrolling.unrollLoopsInFunction(extendedFunc, bound);
        final Event loopBound = extendedFunc.getExit().getPredecessor();
        assert loopBound.hasTag(Tag.BOUND);
        loopBound.replaceBy(EventFactory.newGoto(loopingExit.exitLabel()));

        // ------------- Add output code (exit blocks + return) -------------
        appendOutputCode(extendedFunc, newOutputRegs, newExits);

        return new OpenFunction(extendedFunc);
    }

    public static OpenFunction fromSnippet(FunctionSnippet snippet) {
        final TypeFactory types = TypeFactory.getInstance();

        final Comparator<Register> regsSorter = Comparator.comparing(Register::getName);
        final List<Register> snipInputRegs = snippet.getInputRegisters().stream().sorted(regsSorter).toList();
        final List<Register> snipOutputRegs = snippet.getAllLiveRegsOnExit().stream().sorted(regsSorter).toList();

        // --------------- Construct function skeleton ---------------
        final String funcName = String.format("%s@[%d, %d]",
                snippet.getFunction().getName(), snippet.getStart().getGlobalId(), snippet.getEnd().getGlobalId()
        );
        final Type outputType = types.getAggregateType(Lists.newArrayList(
                Iterables.concat(Iterables.transform(snipOutputRegs, Register::getType), List.of(getCfExitRegType()))
        ));
        final FunctionType funcType = types.getFunctionType(outputType, Lists.transform(snipInputRegs, Register::getType));
        final List<String> paramNames = Lists.transform(snipInputRegs, Register::getName);
        final Function func = new Function(funcName, funcType, paramNames, 0, null);

        // --------------- Copy over registers ---------------
        final Map<Register, Register> registerMap = IRHelper.copyOverRegisters(snippet.getRegisters(), func);

        // ------------ Compute exit blocks for instrumentation ------------
        final List<ExitBlock> exitBlocks = new ArrayList<>();
        {
            final Label standardExitLabel = EventFactory.newLabel(getExitLabelName(0));
            final Set<Register> liveOutputs = snippet.getLiveRegsAtRegularExit().stream().map(registerMap::get).collect(Collectors.toSet());
            exitBlocks.add(new ExitBlock(standardExitLabel, liveOutputs, 0));
        }

        final Map<Event, Event> exitUpdateMap = new HashMap<>();
        int nextExitNum = 1;
        for (Map.Entry<CondJump, Set<Register>> externalJumps : snippet.getLiveRegsAtJumpExitMap().entrySet()) {
            final CondJump jump = externalJumps.getKey();
            final Label externalLabel = jump.getLabel();

            if (!exitUpdateMap.containsKey(externalLabel)) {
                final int exitNum = nextExitNum++;
                final Label exitLabel = EventFactory.newLabel(getExitLabelName(exitNum));
                final Set<Register> liveOutputs = externalJumps.getValue().stream().map(registerMap::get).collect(Collectors.toSet());
                exitBlocks.add(new ExitBlock(exitLabel, liveOutputs, exitNum));

                exitUpdateMap.put(externalLabel, exitLabel);
            }
        }

        // --------------- Copy over body ---------------
        func.append(EventFactory.newStringAnnotation("------ Begin body ------"));
        final List<Event> bodyCopy = IRHelper.copyPath(snippet.getStart(), snippet.getEnd().getSuccessor(), exitUpdateMap, registerMap);
        func.getExit().insertAfter(bodyCopy);
        func.append(EventFactory.newStringAnnotation("------ End body ------"));

        //TODO: Translate AbortIf and Return correctly.
        //  AbortIf: Exit with all variables dead
        //  Return: Exit with only return expression live.
        // TODO 2: Handle non-inlined function calls properly

        // ------------- Add output code (exit blocks + return) -------------
        appendOutputCode(func, Lists.transform(snipOutputRegs, registerMap::get), exitBlocks);

        final OpenFunction openFunction = new OpenFunction(func);
        openFunction.exitBlocks.addAll(exitBlocks);
        openFunction.func.validate();
        return openFunction;
    }

    // ------------------------------------------------------------------------------------------------
    // Utility

    private static void appendOutputCode(Function func, List<Register> totalOutputRegs, List<ExitBlock> exits) {
        final ExpressionFactory exprs = ExpressionFactory.getInstance();
        final Label retLabel = makeReturnLabel();
        final Expression newReturnExpr = exprs.makeConstruct(
                Streams.concat(totalOutputRegs.stream(), Stream.of((Expression)getCfExitRegister(func))).toList()
        );

        for (ExitBlock exit : exits) {
            func.append(constructExitCode(func, exit, totalOutputRegs, retLabel));
        }
        func.append(retLabel);
        func.append(EventFactory.newFunctionReturn(newReturnExpr));
    }

    private static List<Event> constructExitCode(Function func, ExitBlock exit, List<Register> totalOutputRegs, Label retLabel) {
        final ExpressionFactory exprs = ExpressionFactory.getInstance();
        final List<Event> body = new ArrayList<>();
        body.add(exit.exitLabel());
        for (Register output : totalOutputRegs) {
            if (!exit.liveOutputs().contains(output)) {
                body.add(EventFactory.newLocal(output, exprs.makeGeneralZero(output.getType())));
            }
        }
        final Register cfExitReg = getCfExitRegister(func);
        body.add(EventFactory.newLocal(cfExitReg, exprs.makeValue(exit.id(), (IntegerType) cfExitReg.getType())));
        body.add(EventFactory.newGoto(retLabel));
        return body;
    }

    private static Label makeReturnLabel() {
        return EventFactory.newLabel("__RETURN");
    }

    private static String getExitLabelName(int numExit) {
        return "__EXIT#" + numExit;
    }

    private static String getCfExitLabelName() {
        return "__reg_cf_exit";
    }

    private static IntegerType getCfExitRegType() {
        return TypeFactory.getInstance().getArchType();
    }

    private static Register getCfExitRegister(Function func) {
        return func.getOrNewRegister(getCfExitLabelName(), getCfExitRegType());
    }

}
