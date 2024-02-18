package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
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
import com.dat3m.dartagnan.program.event.metadata.UnrollingId;
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
public class DynamicPureLoopCutting implements ProgramProcessor, FunctionProcessor {

    private static final Logger logger = LogManager.getLogger(DynamicPureLoopCutting.class);

    public static DynamicPureLoopCutting fromConfig(Configuration config) {
        return new DynamicPureLoopCutting();
    }

    /*
        We attach additional data to loop iterations for processing.
     */
    private static class IterationData {
        private LoopAnalysis.LoopIterationInfo iterationInfo;
        private final List<Event> sideEffects = new ArrayList<>();
        private boolean isAlwaysSideEffectFull = false;
    }

    private record AnalysisStats(int numPotentialSpinLoops, int numStaticSpinLoops) {

        private AnalysisStats add(AnalysisStats stats) {
            return new AnalysisStats(this.numPotentialSpinLoops + stats.numPotentialSpinLoops,
                    this.numStaticSpinLoops + stats.numStaticSpinLoops);
        }
    }

    @Override
    public void run(Program program) {
        Preconditions.checkArgument(program.isCompiled(),
                "DynamicPureLoopCutting can only be run on compiled programs.");

        AnalysisStats stats = new AnalysisStats(0, 0);
        final LoopAnalysis loopAnalysis = LoopAnalysis.newInstance(program);
        for (Function func : Iterables.concat(program.getThreads(), program.getFunctions())) {
            final List<IterationData> iterationData = computeIterationDataList(func, loopAnalysis);
            iterationData.forEach(this::reduceToDominatingSideEffects);
            iterationData.forEach(this::insertSideEffectChecks);
            stats = stats.add(collectStats(iterationData));
        }

        // NOTE: We log "potential spin loops" as only those that are not also "static".
        logger.info("Found {} static spin loops and {} potential spin loops.",
                stats.numStaticSpinLoops, (stats.numPotentialSpinLoops - stats.numStaticSpinLoops));
    }

    @Override
    public void run(Function function) {
        final LoopAnalysis loopAnalysis = LoopAnalysis.onFunction(function);
        final List<IterationData> iterationData = computeIterationDataList(function, loopAnalysis);
        iterationData.forEach(this::reduceToDominatingSideEffects);
        iterationData.forEach(this::insertSideEffectChecks);
    }

    private AnalysisStats collectStats(List<IterationData> iterDataList) {
        int numPotentialSpinLoops = 0;
        int numStaticSpinLoops = 0;
        Set<UnrollingId> alreadyDetectedLoops = new HashSet<>(); // To avoid counting the same loop multiple times
        for (IterationData data : iterDataList) {
            if (!data.isAlwaysSideEffectFull) {
                // Potential spinning iteration
                final UnrollingId uIdOfLoop = data.iterationInfo.getIterationStart().getMetadata(UnrollingId.class);
                assert uIdOfLoop != null;
                if (alreadyDetectedLoops.add(uIdOfLoop)) {
                    // A loop we did not count before
                    numPotentialSpinLoops++;
                    if (data.sideEffects.isEmpty()) {
                        numStaticSpinLoops++;
                    }
                }
            }
        }
        return new AnalysisStats(numPotentialSpinLoops, numStaticSpinLoops);
    }

    private void insertSideEffectChecks(IterationData iter) {
        if (iter.isAlwaysSideEffectFull) {
            // No need to insert checks if the iteration is guaranteed to have side effects
            return;
        }
        final LoopAnalysis.LoopIterationInfo iterInfo = iter.iterationInfo;
        final Function func = iterInfo.getContainingLoop().function();
        final int loopNumber = iterInfo.getContainingLoop().loopNumber();
        final int iterNumber = iterInfo.getIterationNumber();
        final List<Event> sideEffects = iter.sideEffects;

        final List<Register> trackingRegs = new ArrayList<>();
        final Type type = TypeFactory.getInstance().getBooleanType();
        Event insertionPoint = iterInfo.getIterationEnd();
        for (int i = 0; i < sideEffects.size(); i++) {
            final Event sideEffect = sideEffects.get(i);
            final Register trackingReg = func.newRegister(String.format("Loop%s_%s_%s", loopNumber, iterNumber, i), type);
            trackingRegs.add(trackingReg);

            final Event execCheck = EventFactory.newExecutionStatus(trackingReg, sideEffect);
            insertionPoint.insertAfter(execCheck);
            insertionPoint = execCheck;
        }

        final ExpressionFactory expressionFactory = ExpressionFactory.getInstance();
        final Expression noSideEffect = trackingRegs.stream()
                .map(Expression.class::cast)
                .reduce(expressionFactory.makeTrue(), expressionFactory::makeAnd);
        final Event assumeSideEffect = newSpinTerminator(noSideEffect, func);
        assumeSideEffect.addTags(Tag.SPINLOOP, Tag.EARLYTERMINATION, Tag.NOOPT);
        final Event spinloopStart = iterInfo.getIterationStart();
        assumeSideEffect.copyAllMetadataFrom(spinloopStart);
        insertionPoint.insertAfter(assumeSideEffect);
    }

    private Event newSpinTerminator(Expression guard, Function func) {
        return func instanceof Thread thread ?
                EventFactory.newJump(guard, (Label) thread.getExit())
                : EventFactory.newAbortIf(guard);
    }

    // ============================= Actual logic =============================

    private List<IterationData> computeIterationDataList(Function function, LoopAnalysis loopAnalysis) {
        final List<IterationData> dataList = loopAnalysis.getLoopsOfFunction(function).stream()
                    .flatMap(loop -> loop.iterations().stream())
                    .map(this::computeIterationData)
                    .collect(Collectors.toList());
        return dataList;
    }

    private IterationData computeIterationData(LoopAnalysis.LoopIterationInfo iteration) {
        final Event iterStart = iteration.getIterationStart();
        final Event iterEnd = iteration.getIterationEnd();

        final IterationData data = new IterationData();
        data.iterationInfo = iteration;
        data.sideEffects.addAll(collectSideEffects(iterStart, iterEnd));

        return data;
    }

    private List<Event> collectSideEffects(Event iterStart, Event iterEnd) {
        List<Event> sideEffects = new ArrayList<>();
        // Unsafe means the loop reads from the registers before writing to them.
        Set<Register> unsafeRegisters = new HashSet<>();
        // Safe means the loop wrote to these register before using them
        Set<Register> safeRegisters = new HashSet<>();

        Event cur = iterStart;
        do {
            if (cur.hasTag(Tag.WRITE) || (cur instanceof FunctionCall call
                    && (!call.isDirectCall() || call.getCalledFunction().getIntrinsicInfo().writesMemory()))) {
                // We assume side effects for all writes, writing intrinsics, or unresolved function calls.
                sideEffects.add(cur);
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
                    sideEffects.add(cur);
                } else {
                    safeRegisters.add(writer.getResultRegister());
                }
            }
        } while ((cur = cur.getSuccessor()) != iterEnd.getSuccessor());
        return sideEffects;
    }


    private void reduceToDominatingSideEffects(IterationData data) {
        if (data.sideEffects.isEmpty()) {
            // There are no side effects.
            return;
        }

        final LoopAnalysis.LoopIterationInfo iter = data.iterationInfo;
        final Event start = iter.getIterationStart();
        final Event end = iter.getIterationEnd();

        if (start.hasTag(Tag.SPINLOOP)) {
            // If the iteration start is tagged as "SPINLOOP", we treat the iteration as side effect free
            data.isAlwaysSideEffectFull = false;
            data.sideEffects.clear();
            return;
        }

        final DominatorTree<Event> preDominatorTree = DominatorAnalysis.computePreDominatorTree(start, end);
        final DominatorTree<Event> postDominatorTree = DominatorAnalysis.computePostDominatorTree(start, end);

        // (1) Delete all side effects that are on exit paths (those have no dominator in the post-dominator tree
        // because they are no predecessor of the end of the loop body).
        final Predicate<Event> isOnExitPath = (e -> postDominatorTree.getImmediateDominator(e) == null);
        data.sideEffects.removeIf(isOnExitPath);

        // (2) Check if always side-effect-full at the end of an iteration directly before entering the next one.
        // This is an approximation: If the end of the iteration is predominated by some side effect
        // then we always observe side effects.
        data.isAlwaysSideEffectFull = Streams.stream(preDominatorTree.getDominators(end))
                .anyMatch(data.sideEffects::contains);
        if (data.isAlwaysSideEffectFull) {
            return;
        }

        // (3) Delete all side effects that are dominated by another one
        // NOTE: This can be implemented more efficiently, but maybe we don't need to.
        for (int i = data.sideEffects.size() - 1; i >= 0; i--) {
            final Event sideEffect = data.sideEffects.get(i);
            final Iterable<Event> dominators = Iterables.concat(
                    preDominatorTree.getStrictDominators(sideEffect),
                    postDominatorTree.getStrictDominators(sideEffect)
            );
            final boolean isDominated = Iterables.tryFind(dominators, data.sideEffects::contains).isPresent();
            if (isDominated) {
                data.sideEffects.remove(i);
            }
        }
    }
}