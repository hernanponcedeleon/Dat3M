package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.DominatorAnalysis;
import com.dat3m.dartagnan.program.analysis.LoopAnalysis;
import com.dat3m.dartagnan.program.event.*;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.functions.FunctionCall;
import com.dat3m.dartagnan.program.event.lang.svcomp.SpinStart;
import com.dat3m.dartagnan.utils.DominatorTree;
import com.google.common.base.Preconditions;
import com.google.common.collect.Iterables;
import com.google.common.collect.Sets;
import com.google.common.collect.Streams;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.function.Predicate;
import java.util.stream.Collectors;

/*
    This pass instruments loops that do not cause a side effect in an iteration to terminate, i.e., to avoid spinning.
    In other words, only the last loop iteration is allowed to be side-effect free.

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
        AnalysisStats stats = new AnalysisStats(0, 0);
        for (Function func : Iterables.concat(program.getFunctions(), program.getThreads())) {
            final List<LoopData> loops = computeLoopData(func, loopAnalysis);
            loops.forEach(this::collectSideEffects);
            loops.forEach(this::reduceToDominatingSideEffects);
            loops.forEach(this::instrumentLoop);
            stats = stats.add(collectStats(loops));
        }
        IdReassignment.newInstance().run(program); // Reassign ids for the instrumented code.

        // NOTE: We log "potential spin loops" as only those that are not also "static".
        logger.info("Found {} static spin loops and {} potential spin loops.",
                stats.numStaticSpinLoops, (stats.numPotentialSpinLoops - stats.numStaticSpinLoops));
    }

    // ==================================================================================================
    // Internals

    private List<LoopData> computeLoopData(Function func, LoopAnalysis loopAnalysis) {
        final List<LoopAnalysis.LoopInfo> loops = loopAnalysis.getLoopsOfFunction(func);
        return loops.stream().map(LoopData::new).toList();
    }

    private void collectSideEffects(LoopData loop) {
        // Loop shape is: loopStart -> Calling intrinsic __VERIFIER_spin_start -> #__VERIFIER_spin_start
        if (loop.getStart().getSuccessor().getSuccessor() instanceof SpinStart) {
            // A user-placed annotation guarantees absence of side effects.

            // This checks assumes the following implementation of await_while
            // #define await_while(cond)                                                  \
            // for (int tmp = (__VERIFIER_loop_begin(), 0); __VERIFIER_spin_start(),  \
            //     tmp = cond, __VERIFIER_spin_end(!tmp), tmp;)
            return;
        }

        // FIXME: The reasoning about safe/unsafe registers is not correct because
        //  we do not traverse the control-flow but naively go top-down through the loop.
        //  We need to use proper dominator reasoning!

        // Unsafe means the loop reads from the registers before writing to them.
        Set<Register> unsafeRegisters = new HashSet<>();
        // Safe means the loop wrote to these register before using them
        Set<Register> safeRegisters = new HashSet<>();

        Event cur = loop.getStart();
        do {
            if (cur.hasTag(Tag.WRITE) || (cur instanceof FunctionCall call &&
                    (!call.isDirectCall()
                            || !call.getCalledFunction().isIntrinsic()
                            || call.getCalledFunction().getIntrinsicInfo().writesMemory()))) {
                // We assume side effects for all writes, writing intrinsics, and non-intrinsic function calls.
                loop.sideEffects.add(cur);
                continue;
            }

            if (cur instanceof RegReader regReader) {
                final Set<Register> dataRegs = regReader.getRegisterReads().stream()
                        .map(Register.Read::register).collect(Collectors.toSet());
                unsafeRegisters.addAll(Sets.difference(dataRegs, safeRegisters));
            }

            if (cur instanceof RegWriter writer) {
                if (unsafeRegisters.contains(writer.getResultRegister())) {
                    // The loop writes to a register it previously read from.
                    // This means the next loop iteration will observe the newly written value,
                    // hence the loop is not side effect free.
                    loop.sideEffects.add(cur);
                } else {
                    safeRegisters.add(writer.getResultRegister());
                }
            }
        } while ((cur = cur.getSuccessor()) != loop.getEnd().getSuccessor());

    }

    private void reduceToDominatingSideEffects(LoopData loop) {
        if (loop.sideEffects.isEmpty()) {
            return;
        }

        final List<Event> sideEffects = loop.sideEffects;
        final Event start = loop.getStart();
        final Event end = loop.getEnd();

        final DominatorTree<Event> preDominatorTree = DominatorAnalysis.computePreDominatorTree(start, end);
        final DominatorTree<Event> postDominatorTree = DominatorAnalysis.computePostDominatorTree(start, end);

        // (1) Delete all side effects that are on exit paths (those have no dominator in the post-dominator tree
        // because they are no predecessor of the end of the loop body).
        final Predicate<Event> isOnExitPath = (e -> postDominatorTree.getImmediateDominator(e) == null);
        sideEffects.removeIf(isOnExitPath);

        // (2) Check if always side-effect-full at the end of an iteration directly before entering the next one.
        // This is an approximation: If the end of the iteration is predominated by some side effect
        // then we always observe side effects.
        loop.isAlwaysSideEffectful = Streams.stream(preDominatorTree.getDominators(end)).anyMatch(sideEffects::contains);
        if (loop.isAlwaysSideEffectful) {
            return;
        }

        // (3) Delete all side effects that are dominated by another one
        // NOTE: This can be implemented more efficiently, but maybe we don't need to.
        for (int i = sideEffects.size() - 1; i >= 0; i--) {
            final Event sideEffect = sideEffects.get(i);
            final Iterable<Event> dominators = Iterables.concat(
                    preDominatorTree.getStrictDominators(sideEffect),
                    postDominatorTree.getStrictDominators(sideEffect)
            );
            final boolean isDominated = Iterables.tryFind(dominators, sideEffects::contains).isPresent();
            if (isDominated) {
                sideEffects.remove(i);
            }
        }
    }

    private void instrumentLoop(LoopData loop) {
        if (loop.isAlwaysSideEffectful) {
            return;
        }

        final TypeFactory types = TypeFactory.getInstance();
        final ExpressionFactory expressions = ExpressionFactory.getInstance();
        final Function func = loop.loopInfo.function();
        final int loopNum = loop.loopInfo.loopNumber();
        final Register trackingReg = func.newRegister("__sideEffect#" + loopNum, types.getBooleanType());

        final Event init = EventFactory.newLocal(trackingReg, expressions.makeFalse());
        loop.getStart().insertAfter(init);
        for (Event sideEffect : loop.sideEffects) {
            final Event updateSideEffect = EventFactory.newLocal(trackingReg, expressions.makeTrue());
            sideEffect.getPredecessor().insertAfter(updateSideEffect);
        }

        final Event assumeSideEffect = newSpinTerminator(expressions.makeNot(trackingReg), func);
        assumeSideEffect.copyAllMetadataFrom(loop.getStart());
        loop.getEnd().getPredecessor().insertAfter(assumeSideEffect);

        // Special case: If the loop is fully side-effect-free, we can set its unrolling bound to 1.
        if (loop.sideEffects.isEmpty()) {
            final Event loopBound = EventFactory.Svcomp.newLoopBound(expressions.makeValue(1, types.getArchType()));
            loop.getStart().getPredecessor().insertAfter(loopBound);
        }
    }

    private Event newSpinTerminator(Expression guard, Function func) {
        final Event terminator = func instanceof Thread thread ?
                EventFactory.newJump(guard, (Label) thread.getExit())
                : EventFactory.newAbortIf(guard);
        terminator.addTags(Tag.SPINLOOP, Tag.EARLYTERMINATION, Tag.NOOPT);
        return terminator;
    }

    private AnalysisStats collectStats(List<LoopData> loops) {
        int numPotentialSpinLoops = 0;
        int numStaticSpinLoops = 0;
        for (LoopData loop : loops) {
            if (!loop.isAlwaysSideEffectful) {
                numPotentialSpinLoops++;
                if (loop.sideEffects.isEmpty()) {
                    numStaticSpinLoops++;
                }
            }
        }
        return new AnalysisStats(numPotentialSpinLoops, numStaticSpinLoops);
    }

    // ==================================================================================================
    // Inner data structures

    private static class LoopData {
        private final LoopAnalysis.LoopInfo loopInfo;
        private final List<Event> sideEffects = new ArrayList<>();
        private boolean isAlwaysSideEffectful = false;

        private LoopData(LoopAnalysis.LoopInfo loopInfo) {
            this.loopInfo = loopInfo;
        }

        private Event getStart() { return loopInfo.iterations().get(0).getIterationStart(); }
        private Event getEnd() { return loopInfo.iterations().get(0).getIterationEnd(); }

        @Override
        public String toString() {
            return String.format("(%d: %s) --to--> (%d: %s)",
                    getStart().getGlobalId(), getStart(), getEnd().getGlobalId(), getEnd());
        }
    }

    private record AnalysisStats(int numPotentialSpinLoops, int numStaticSpinLoops) {

        private AnalysisStats add(AnalysisStats stats) {
            return new AnalysisStats(this.numPotentialSpinLoops + stats.numPotentialSpinLoops,
                    this.numStaticSpinLoops + stats.numStaticSpinLoops);
        }
    }
}