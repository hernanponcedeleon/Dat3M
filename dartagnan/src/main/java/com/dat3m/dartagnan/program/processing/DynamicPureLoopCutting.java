package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.LoopAnalysis;
import com.dat3m.dartagnan.program.event.*;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.functions.FunctionCall;
import com.dat3m.dartagnan.program.event.metadata.UnrollingId;
import com.google.common.base.Preconditions;
import com.google.common.base.Verify;
import com.google.common.collect.Iterables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Sets;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;

import java.util.*;
import java.util.function.BiPredicate;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

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
        private final List<Event> guaranteedExitPoints = new ArrayList<>();
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
        iteration.computeBody().stream()
                .filter(CondJump.class::isInstance).map(CondJump.class::cast)
                .filter(j -> j.isGoto() && j.getLabel().getGlobalId() > iterEnd.getGlobalId())
                .forEach(data.guaranteedExitPoints::add);

        return data;
    }

    private List<Event> collectSideEffects(Event iterStart, Event iterEnd) {
        List<Event> sideEffects = new ArrayList<>();
        // Unsafe means the loop read from the registers before writing to them.
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

    // ----------------------- Dominator-related -----------------------

    private void reduceToDominatingSideEffects(IterationData data) {
        final LoopAnalysis.LoopIterationInfo iter = data.iterationInfo;
        final Event start = iter.getIterationStart();
        final Event end = iter.getIterationEnd();

        if (start.hasTag(Tag.SPINLOOP)) {
            // If the iteration start is tagged as "SPINLOOP", we treat the iteration as side effect free
            data.isAlwaysSideEffectFull = false;
            data.sideEffects.clear();
            return;
        }

        final List<Event> iterBody = iter.computeBody();
        // to compute the pre-dominator tree ...
        final Map<Event, List<Event>> immPredMap = new HashMap<>();
        immPredMap.put(iterBody.get(0), List.of());
        for (Event e : iterBody.subList(1, iterBody.size())) {
            final List<Event> preds = new ArrayList<>();
            final Event pred = e.getPredecessor();
            if (!(pred instanceof CondJump jump && jump.isGoto())) {
                preds.add(pred);
            }
            if (e instanceof Label label) {
                preds.addAll(label.getJumpSet());
            }
            immPredMap.put(e, preds);
        }

        // to compute the post-dominator tree ...
        final List<Event> reversedOrderEvents = new ArrayList<>(Lists.reverse(iterBody));
        final Map<Event, List<Event>> immSuccMap = new HashMap<>();
        immSuccMap.put(reversedOrderEvents.get(0), List.of());
        for (Event e : iterBody) {
            for (Event pred : immPredMap.get(e)) {
                immSuccMap.computeIfAbsent(pred, key -> new ArrayList<>()).add(e);
            }
        }

        // We delete all side effects that are guaranteed to lead to an exit point, i.e.,
        // those that never reach a subsequent iteration.
        reversedOrderEvents.forEach(e -> immSuccMap.putIfAbsent(e, List.of()));
        List<Event> exitPoints = new ArrayList<>(data.guaranteedExitPoints);
        boolean changed = true;
        while (changed) {
            changed = !exitPoints.isEmpty();
            for (Event exit : exitPoints) {
                assert immSuccMap.get(exit).isEmpty();
                immSuccMap.remove(exit);
                immPredMap.get(exit).forEach(pred -> immSuccMap.get(pred).remove(exit));
            }
            exitPoints = immSuccMap.keySet().stream().filter(e -> e != end && immSuccMap.get(e).isEmpty()).collect(Collectors.toList());
        }
        reversedOrderEvents.removeIf(e -> ! immSuccMap.containsKey(e));


        final Map<Event, Event> preDominatorTree = computeDominatorTree(iterBody, immPredMap::get);

        {
            // Check if always side-effect-full
            // This is an approximation: If the end of the iteration is predominated by some side effect
            // then we always observe side effects.
            Event dom = end;
            do {
                if (data.sideEffects.contains(dom)) {
                    // A special case where the loop is always side-effect-full
                    // There is no need to proceed further
                    data.isAlwaysSideEffectFull = true;
                    return;
                }
            } while ((dom = preDominatorTree.get(dom)) != start);
        }

        // Remove all side effects that are guaranteed to exit the loop.
        data.sideEffects.removeIf(e -> !immSuccMap.containsKey(e));

        // Delete all pre-dominated side effects
        for (final Event e : List.copyOf(data.sideEffects)) {
            Event dom = e;
            while ((dom = preDominatorTree.get(dom)) != start) {
                assert dom != null;
                if (data.sideEffects.contains(dom)) {
                    data.sideEffects.remove(e);
                    break;
                }
            }
        }

        // Delete all post-dominated side effects
        final Map<Event, Event> postDominatorTree = computeDominatorTree(reversedOrderEvents, immSuccMap::get);
        for (final Event e : List.copyOf(data.sideEffects)) {
            Event dom = e;
            while ((dom = postDominatorTree.get(dom)) != end) {
                assert dom != null;
                if (data.sideEffects.contains(dom)) {
                    data.sideEffects.remove(e);
                    break;
                }
            }
        }
    }

    private Map<Event, Event> computeDominatorTree(List<Event> events,
                                                   java.util.function.Function<Event, ? extends Collection<Event>> predsFunc) {
        Preconditions.checkNotNull(events);
        Preconditions.checkNotNull(predsFunc);
        if (events.isEmpty()) {
            return Map.of();
        }

        // Compute natural ordering on <events>
        final Map<Event, Integer> orderingMap = Maps.uniqueIndex(IntStream.range(0, events.size()).boxed()::iterator, events::get);
        @SuppressWarnings("ConstantConditions")
        final BiPredicate<Event, Event> leq = (x, y) -> orderingMap.get(x) <= orderingMap.get(y);

        // Compute actual dominator tree
        final Map<Event, Event> dominatorTree = new HashMap<>();
        dominatorTree.put(events.get(0), events.get(0));
        for (Event cur : events.subList(1, events.size())) {
            final Collection<Event> preds = predsFunc.apply(cur);
            Verify.verify(preds.stream().allMatch(dominatorTree::containsKey),
                    "Error: detected predecessor outside of the provided event list.");
            final Event immDom = preds.stream().reduce(null, (x, y) -> commonDominator(x, y, dominatorTree, leq));
            dominatorTree.put(cur, immDom);
        }

        return dominatorTree;
    }

    private Event commonDominator(Event a, Event b, Map<Event, Event> dominatorTree, BiPredicate<Event, Event> leq) {
        Preconditions.checkArgument(a != null || b != null);
        if (a == null) {
            return b;
        } else if (b == null) {
            return a;
        }

        while (a != b) {
            if (leq.test(a, b)) {
                b = dominatorTree.get(b);
            } else {
                a = dominatorTree.get(a);
            }
        }
        return a; // a==b
    }
}