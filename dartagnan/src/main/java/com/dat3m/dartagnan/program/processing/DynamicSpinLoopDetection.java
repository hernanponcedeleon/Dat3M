package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.AggregateType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.analysis.CycleBoundAnalysis;
import com.dat3m.dartagnan.program.analysis.ExitGuardAnalysis;
import com.dat3m.dartagnan.program.analysis.LiveRegistersAnalysis;
import com.dat3m.dartagnan.program.analysis.LoopAnalysis;
import com.dat3m.dartagnan.program.event.*;
import com.dat3m.dartagnan.program.event.core.Local;
import com.google.common.base.Preconditions;
import com.google.common.collect.Iterables;
import com.google.common.collect.Lists;
import com.google.common.collect.Sets;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.util.*;

import static com.dat3m.dartagnan.configuration.OptionNames.SPINLOOP_EXIT_GUARD_MAX_STEPS;

/*
    This pass instruments loops that do not cause a side effect in an iteration to terminate, i.e., to avoid spinning.
    In other words, only the last loop iteration is allowed to be side-effect-free.

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


    NOTE: This pass is required to detect termination violations involving side-effect-free spinning.

    Static bound of 1:
        If a loop has no written live registers and every global side effect is "exit-guarded", i.e.,
        no path on which the side effect executes reaches the back-jump, then every iteration that reaches the
        back-jump is side-effect-free and gets cut by the instrumentation above.
        Hence, the second iteration is unreachable and we can annotate the loop with a bound of 1.
        Typical example is a CAS loop that re-reads its expected value in every iteration:
            do { r = load(x); } while (!CAS(x, r, f(r)));
        The store of the CAS only executes on success, which leaves the loop.
 */
@Options
public class DynamicSpinLoopDetection implements ProgramProcessor {

    private static final Logger logger = LoggerFactory.getLogger(DynamicSpinLoopDetection.class);

    @Option(name = SPINLOOP_EXIT_GUARD_MAX_STEPS,
            description = "Maximal number of steps the exit-guard analysis explores per side effect before giving up" +
                    " (the loop is then not statically bounded). Defaults to 10000.",
            secure = true)
    private int exitGuardMaxSteps = 10_000;

    public static DynamicSpinLoopDetection fromConfig(Configuration config) throws InvalidConfigurationException {
        final DynamicSpinLoopDetection pass = new DynamicSpinLoopDetection();
        config.inject(pass);
        return pass;
    }

    @Override
    public void run(Program program) {
        Preconditions.checkArgument(!program.isUnrolled(),
                "DynamicSpinLoopDetection cannot be run on already unrolled programs.");

        final LoopAnalysis loopAnalysis = LoopAnalysis.newInstance(program);
        AnalysisStats stats = new AnalysisStats(0, 0);
        for (Function func : Iterables.concat(program.getFunctions(), program.getThreads())) {
            final List<LoopData> loops = computeLoopData(func, loopAnalysis);
            final LiveRegistersAnalysis liveRegsAna =  LiveRegistersAnalysis.forFunction(func);
            loops.forEach(loop -> this.collectSideEffects(loop, liveRegsAna));
            loops.forEach(this::instrumentLoop);
            stats = stats.add(collectStats(loops));
        }
        IdReassignment.newInstance().run(program); // Reassign ids for the instrumented code.

        logger.info("Found {} static spin loops.", stats.numStaticSpinLoops());
        logger.info("Found {} loops with finitely many side-effect-free loop states (cycle bounded).", stats.numCycleBoundedLoops());
    }

    // ==================================================================================================
    // Internals

    private List<LoopData> computeLoopData(Function func, LoopAnalysis loopAnalysis) {
        final List<LoopAnalysis.LoopInfo> loops = loopAnalysis.getLoopsOfFunction(func);
        return loops.stream().map(LoopData::new).toList();
    }

    private void collectSideEffects(LoopData loop, LiveRegistersAnalysis liveRegsAna) {
        final Set<Register> writtenRegisters = new HashSet<>();
        final Set<Register> readRegisters = new HashSet<>();
        Event cur = loop.getStart();
        do {
            if (cur instanceof RegReader reader) {
                reader.getRegisterReads().stream().map(Register.Read::register).forEach(readRegisters::add);
            }
            if (cur instanceof RegWriter writer) {
                writtenRegisters.add(writer.getResultRegister());
            }
            if (cur.hasTag(Tag.WRITE) || (cur instanceof CallEvent call &&
                    (!call.isDirectCall()
                            || !call.getDirectCallTarget().isIntrinsic()
                            || call.getDirectCallTarget().getIntrinsicInfo().writesMemory()))) {
                // We assume side effects for all writes, writing intrinsics, and non-intrinsic function calls.
                loop.globalSideEffects.add(cur);
            }
        } while ((cur = cur.getSuccessor()) != loop.getEnd().getSuccessor());

        // Every live register that is written to is a potential local side effect.
        final Set<Register> writtenLiveRegisters = Sets.intersection(
                writtenRegisters,
                liveRegsAna.getLiveRegistersAt(loop.getStart())
        );
        loop.writtenLiveRegisters.addAll(writtenLiveRegisters);

        // Every written live register that is also read within the loop is potentially live on backjump.
        // (This is a rough approximation).
        loop.writtenLiveOnBackjumpRegisters.addAll(Sets.intersection(
                writtenLiveRegisters,
                readRegisters
        ));

        // Check if all global side effects are guaranteed to leave the loop (e.g., successful CAS).
        if (!loop.globalSideEffects.isEmpty()) {
            final ExitGuardAnalysis exitGuardAnalysis = ExitGuardAnalysis.forLoop(loop.loopInfo, exitGuardMaxSteps);
            loop.allSideEffectsExitGuarded = loop.globalSideEffects.stream().allMatch(exitGuardAnalysis::isExitGuarded);
        }

        // Loops with loop-carried registers but write-free back edges: if the number of distinct loop-carried
        // states is finite (M), any execution with M back jumps repeats a state, and the iterations in between
        // are side-effect-free as a whole. Such executions are redundant (unless we check termination), so we can
        // unroll M times and ignore the bound event (see LoopUnrolling and ProgramEncoder.isRedundantBound).
        if (!writtenLiveRegisters.isEmpty() && loop.hasWriteFreeBackEdges()) {
            final long numStates = CycleBoundAnalysis.countLoopCarriedStates(loop.loopInfo, loop.writtenLiveRegisters);
            if (numStates <= Integer.MAX_VALUE) {
                loop.cycleBound = (int) numStates;
            }
        }
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
        for (Register liveReg : loop.writtenLiveRegisters) {
            final Event initReg = func.getProgram().registersAreZeroInitialized()
                    ? EventFactory.newLocal(liveReg, expressions.makeGeneralZero(liveReg.getType()))
                    : EventFactory.newNonDetChoice(liveReg);
            loop.getStart().getFunction().getEntry().insertAfter(initReg);
        }
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
            sideEffect.insertBefore(updateSideEffect);
        }

        // Check if any local or global side effects occurred. If not, spin!
        final Register localSideEffectReg = func.newRegister("__localSideEffect#" + loopNum, types.getBooleanType());
        final Expression hasSideEffect = expressions.makeOr(localSideEffectReg, globalSideEffectReg);

        final Event assignLocalSideEffectReg = EventFactory.newLocal(localSideEffectReg, expressions.makeNEQ(entryLiveStateRegister, liveRegistersVector));
        final Event assumeSideEffect = newSpinTerminator(expressions.makeNot(hasSideEffect), loop);
        loop.getEnd().insertBefore(List.of(
                assignLocalSideEffectReg,
                assumeSideEffect
        ));

        // Special snapshot event for non-termination detection
        if (!loop.writtenLiveOnBackjumpRegisters.isEmpty()) {
            loop.getEnd().insertBefore(
                    EventFactory.Special.newStateSnapshot(loop.writtenLiveOnBackjumpRegisters)
            );
        }

        // Static bounds: a loop whose back-jumping iterations are all side-effect-free is bounded by 1.
        // A loop with finitely many loop-carried states is bounded by that number (cut at the bound).
        final int staticBound = loop.isStaticSpinLoop() ? 1 : loop.cycleBound;
        if (staticBound > 0) {
            loop.getStart().insertBefore(EventFactory.newLoopBound(expressions.makeValue(staticBound, types.getArchType())));
            if (!loop.isStaticSpinLoop()) {
                loop.getStart().addTags(Tag.CYCLE_BOUNDED);
            }
        }
    }

    private Event newSpinTerminator(Expression guard, LoopData loop) {
        final Event terminator = EventFactory.newAbortIf(guard, Tag.SPINLOOP, Tag.NONTERMINATION, Tag.NO_CARRY_DEPS);
        terminator.copyAllMetadataFrom(loop.getStart());
        return terminator;
    }

    private AnalysisStats collectStats(List<LoopData> loops) {
        int numStaticSpinLoops = Math.toIntExact(loops.stream().filter(LoopData::isStaticSpinLoop).count());
        int numCycleBoundedLoops = Math.toIntExact(loops.stream().filter(l -> l.cycleBound > 0).count());
        return new AnalysisStats(numStaticSpinLoops, numCycleBoundedLoops);
    }

    // ==================================================================================================
    // Inner data structures

    private static class LoopData {
        private final LoopAnalysis.LoopInfo loopInfo;
        private final List<Event> globalSideEffects = new ArrayList<>();
        private final List<Register> writtenLiveRegisters = new ArrayList<>();
        private final List<Register> writtenLiveOnBackjumpRegisters = new ArrayList<>();
        private boolean allSideEffectsExitGuarded = false;
        private int cycleBound = 0;

        // No iteration that reaches the back jump executes a global side effect.
        public boolean hasWriteFreeBackEdges() {
            return globalSideEffects.isEmpty() || allSideEffectsExitGuarded;
        }

        // Every iteration that reaches the back jump is side-effect-free (and hence cut by the instrumentation).
        public boolean isStaticSpinLoop() {
            return writtenLiveRegisters.isEmpty() && hasWriteFreeBackEdges();
        }

        private LoopData(LoopAnalysis.LoopInfo loopInfo) {
            this.loopInfo = loopInfo;
        }

        private Event getStart() { return loopInfo.iterations().getFirst().getIterationStart(); }
        private Event getEnd() { return loopInfo.iterations().getFirst().getIterationEnd(); }

        @Override
        public String toString() {
            return String.format("(%d: %s) --to--> (%d: %s)",
                    getStart().getLocalId(), getStart(), getEnd().getLocalId(), getEnd());
        }
    }

    private record AnalysisStats(int numStaticSpinLoops, int numCycleBoundedLoops) {

        private AnalysisStats add(AnalysisStats stats) {
            return new AnalysisStats(this.numStaticSpinLoops + stats.numStaticSpinLoops,
                    this.numCycleBoundedLoops + stats.numCycleBoundedLoops);
        }
    }
}