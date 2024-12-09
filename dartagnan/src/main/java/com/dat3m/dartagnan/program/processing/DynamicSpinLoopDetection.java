package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.AggregateType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.LiveRegistersAnalysis;
import com.dat3m.dartagnan.program.analysis.LoopAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.functions.FunctionCall;
import com.google.common.base.Preconditions;
import com.google.common.collect.Iterables;
import com.google.common.collect.Lists;
import com.google.common.collect.Sets;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/*
    This pass instruments loops that do not cause a side effect in an iteration to terminate, i.e., to avoid spinning.
    In other words, only the last loop iteration is allowed to be side-effect free.

    Instrumentation:
        loop_header:
            __localLiveSnapshot <- ( <list of writable live registers> )  // To track local side effects
            __globalSideEffect  <- false                                  // To track global side effects
            // ---------- Loop body ----------
            ...
            __globalSideEffect <- true  // Store is a guaranteed global effect
            store(...)
            ...
            // ---------- Backjump ----------
            // Local side effect if value of any live register changed.
            __localSideEffect <- __localLiveSnapshot != ( <list of writable live registers> )
            if (!(__localSideEffect || __globalSideEffect)) goto END_OF_T ### SPINLOOP
            goto loop_header

    NOTE: "<list of writable live registers>" refers to those registers
           (1) that are live inside or after the loop
       and (2) that are potentially written to inside the loop (i.e. are not invariant).


    NOTE: This pass is required to detect liveness violations.
 */
public class DynamicSpinLoopDetection implements ProgramProcessor {

    private static final Logger logger = LogManager.getLogger(DynamicSpinLoopDetection.class);

    public static DynamicSpinLoopDetection fromConfig(Configuration config) {
        return new DynamicSpinLoopDetection();
    }

    @Override
    public void run(Program program) {
        Preconditions.checkArgument(!program.isUnrolled(),
                "DynamicSpinLoopDetection cannot be run on already unrolled programs.");

        final LoopAnalysis loopAnalysis = LoopAnalysis.newInstance(program);
        AnalysisStats stats = new AnalysisStats(0);
        for (Function func : Iterables.concat(program.getFunctions(), program.getThreads())) {
            final List<LoopData> loops = computeLoopData(func, loopAnalysis);
            final LiveRegistersAnalysis liveRegsAna =  LiveRegistersAnalysis.forFunction(func);
            loops.forEach(loop -> this.collectSideEffects(loop, liveRegsAna));
            loops.forEach(this::instrumentLoop);
            stats = stats.add(collectStats(loops));
        }
        IdReassignment.newInstance().run(program); // Reassign ids for the instrumented code.

        logger.info("Found {} static spin loops.", stats.numStaticSpinLoops());
    }

    // ==================================================================================================
    // Internals

    private List<LoopData> computeLoopData(Function func, LoopAnalysis loopAnalysis) {
        final List<LoopAnalysis.LoopInfo> loops = loopAnalysis.getLoopsOfFunction(func);
        return loops.stream().map(LoopData::new).toList();
    }

    private void collectSideEffects(LoopData loop, LiveRegistersAnalysis liveRegsAna) {
        final Set<Register> writtenRegisters = new HashSet<>();
        Event cur = loop.getStart();
        do {
            if (cur instanceof RegWriter writer) {
                writtenRegisters.add(writer.getResultRegister());
            }
            if (cur.hasTag(Tag.WRITE) || (cur instanceof FunctionCall call &&
                    (!call.isDirectCall()
                            || !call.getCalledFunction().isIntrinsic()
                            || call.getCalledFunction().getIntrinsicInfo().writesMemory()))) {
                // We assume side effects for all writes, writing intrinsics, and non-intrinsic function calls.
                loop.globalSideEffects.add(cur);
            }
        } while ((cur = cur.getSuccessor()) != loop.getEnd().getSuccessor());

        // Every live register that is written to is a potential local side effect.
        loop.writtenLiveRegisters.addAll(Sets.intersection(
                writtenRegisters,
                liveRegsAna.getLiveRegistersAt(loop.getStart())
        ));
    }

    private void instrumentLoop(LoopData loop) {
        final TypeFactory types = TypeFactory.getInstance();
        final ExpressionFactory expressions = ExpressionFactory.getInstance();

        final Function func = loop.loopInfo.function();
        final int loopNum = loop.loopInfo.loopNumber();

        final AggregateType liveRegsType = types.getAggregateType(Lists.transform(loop.writtenLiveRegisters, Register::getType));
        final Expression liveRegistersVector = expressions.makeConstruct(liveRegsType, loop.writtenLiveRegisters);
        final Register entryLiveStateRegister = func.newRegister("__localLiveSnapshot#" + loopNum, liveRegsType);
        final Register tempReg = func.newRegister("__possiblySideEffectless#" + loopNum, types.getBooleanType());
        final Register globalSideEffectReg = func.newRegister("__globalSideEffect#" + loopNum, types.getBooleanType());

        // ---------------- Instrumentation ----------------
        // Init tracking registers
        loop.getStart().insertAfter(List.of(
                EventFactory.newLocal(entryLiveStateRegister, liveRegistersVector),
                EventFactory.newLocal(globalSideEffectReg, expressions.makeFalse())
        ));

        // Track global side effects
        for (Event sideEffect : loop.globalSideEffects) {
            final List<Event> updateSideEffect = new ArrayList<>();
            if (sideEffect.cfImpliesExec()) {
                updateSideEffect.add(EventFactory.newLocal(globalSideEffectReg, expressions.makeTrue()));
            } else {
                updateSideEffect.addAll(List.of(
                        EventFactory.newExecutionStatus(tempReg, sideEffect),
                        EventFactory.newLocal(globalSideEffectReg, expressions.makeOr(globalSideEffectReg, expressions.makeNot(tempReg)))
                ));

            }
            sideEffect.getPredecessor().insertAfter(updateSideEffect);
        }

        // Check if any local or global side effects occurred. If not, spin!
        final Register localSideEffectReg = func.newRegister("__localSideEffect#" + loopNum, types.getBooleanType());
        final Expression hasSideEffect = expressions.makeOr(localSideEffectReg, globalSideEffectReg);

        final Event assignLocalSideEffectReg = EventFactory.newLocal(localSideEffectReg, expressions.makeNEQ(entryLiveStateRegister, liveRegistersVector));
        final Event assumeSideEffect = newSpinTerminator(expressions.makeNot(hasSideEffect), loop);
        loop.getEnd().getPredecessor().insertAfter(List.of(
                assignLocalSideEffectReg,
                assumeSideEffect
        ));

        // Special case: If the loop is fully side-effect-free, we can set its unrolling bound to 1.
        if (loop.isSideEffectFree()) {
            final Event loopBound = EventFactory.Svcomp.newLoopBound(expressions.makeValue(1, types.getArchType()));
            loop.getStart().getPredecessor().insertAfter(loopBound);
        }
    }

    private Event newSpinTerminator(Expression guard, LoopData loop) {
        final Function func = loop.getStart().getFunction();
        final Event terminator = func instanceof Thread thread ?
                EventFactory.newJump(guard, (Label) thread.getExit())
                : EventFactory.newAbortIf(guard);
        terminator.addTags(Tag.SPINLOOP, Tag.NONTERMINATION);
        terminator.copyAllMetadataFrom(loop.getStart());
        return terminator;
    }

    private AnalysisStats collectStats(List<LoopData> loops) {
        int numStaticSpinLoops = Math.toIntExact(loops.stream().filter(LoopData::isSideEffectFree).count());
        return new AnalysisStats(numStaticSpinLoops);
    }

    // ==================================================================================================
    // Inner data structures

    private static class LoopData {
        private final LoopAnalysis.LoopInfo loopInfo;
        private final List<Event> globalSideEffects = new ArrayList<>();
        private final List<Register> writtenLiveRegisters = new ArrayList<>();

        public boolean isSideEffectFree() {
            return writtenLiveRegisters.isEmpty() && globalSideEffects.isEmpty();
        }

        private LoopData(LoopAnalysis.LoopInfo loopInfo) {
            this.loopInfo = loopInfo;
        }

        private Event getStart() { return loopInfo.iterations().get(0).getIterationStart(); }
        private Event getEnd() { return loopInfo.iterations().get(0).getIterationEnd(); }

        @Override
        public String toString() {
            return String.format("(%d: %s) --to--> (%d: %s)",
                    getStart().getLocalId(), getStart(), getEnd().getLocalId(), getEnd());
        }
    }

    private record AnalysisStats(int numStaticSpinLoops) {

        private AnalysisStats add(AnalysisStats stats) {
            return new AnalysisStats(this.numStaticSpinLoops + stats.numStaticSpinLoops);
        }
    }
}