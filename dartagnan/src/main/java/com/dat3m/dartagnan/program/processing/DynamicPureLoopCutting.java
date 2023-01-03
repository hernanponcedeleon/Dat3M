package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.GlobalSettings;
import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.BOpBin;
import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.MemEvent;
import com.dat3m.dartagnan.program.event.core.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.google.common.base.Preconditions;
import com.google.common.base.Verify;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Sets;

import java.math.BigInteger;
import java.util.*;
import java.util.function.BiPredicate;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

/*
    This pass instruments loops that do not cause a side effect in an iteration to terminate, i.e., to avoid spinning.
    In other words, only the last loop iteration is allowed to be side-effect free.

    This pass is correct but has the following issues.
    TODO:
     (1) This dynamic termination of spinning loops is not considered in Liveness checking.
     (2) The pass runs on already unrolled loops and instruments each iteration separately.
         It would be better to let it transform not-yet-unrolled loops by inserting
         the necessary checks. However, one has to be careful about handling nested loops correctly
         because they cause cyclic control-flow within a loop which the current implementation
         of "dominator trees" does not handle.
     (3) There are more optimizations to do...
 */
public class DynamicPureLoopCutting implements ProgramProcessor {

    // Helper classes
    static class Loop {
        Thread thread;
        int loopNumber = 0;
        boolean hasAlwaysSideEffects = false;
        final List<LoopIteration> iterations = new ArrayList<>();
    }

    static class LoopIteration {
        Loop loop;
        int iterationNumber;
        Label startLabel;
        // The following is only set for the non-last iteration
        final List<Event> sideEffects = new ArrayList<>();
        final List<Event> trueExitPoints = new ArrayList<>();
        Label endLabel = null;
    }

    public static DynamicPureLoopCutting fromConfig() {
        return new DynamicPureLoopCutting();
    }

    @Override
    public void run(Program program) {
        Preconditions.checkArgument(program.isCompiled(),
                "DynamicPureLoopCutting can only be run on compiled programs.");

        for (Thread thread : program.getThreads()) {
            final List<Loop> loops = findLoops(thread);
            loops.forEach(this::reduceToDominatingSideEffects);
            loops.forEach(this::insertSideEffectChecks);
        }

        // Update cIds
        int cId = 0;
        program.clearCache(true);
        for (Event e : program.getEvents()) {
            e.setCId(cId++);
        }
    }

    private void insertSideEffectChecks(Loop loop) {
        if (!loop.hasAlwaysSideEffects) {
            loop.iterations.subList(0, loop.iterations.size() - 1).forEach(this::insertSideEffectChecks);
        }
    }

    private void insertSideEffectChecks(LoopIteration iter) {
        Preconditions.checkNotNull(iter.endLabel);
        final Thread thread = iter.loop.thread;
        final int loopNumber = iter.loop.loopNumber;
        final int iterNumber = iter.iterationNumber;

        List<Register> dummyRegs = new ArrayList<>();
        Event insertionPoint = iter.endLabel.getPredecessor();
        for (int i = 0; i < iter.sideEffects.size(); i++) {
            final Event sideEffect = iter.sideEffects.get(i);
            final Register dummyReg = new Register(
                    String.format("Loop%s_%s_%s", loopNumber, iterNumber, i), thread.getId(), GlobalSettings.ARCH_PRECISION);
            dummyRegs.add(dummyReg);

            final Event execCheck = EventFactory.newExecutionStatus(dummyReg, sideEffect);
            insertionPoint.insertAfter(execCheck);
            insertionPoint = execCheck;
        }

        BExpr atLeastOneSideEffect = new BConst(false);
        for (Register reg : dummyRegs) {
            atLeastOneSideEffect = new BExprBin(atLeastOneSideEffect, BOpBin.OR,
                    new Atom(reg, COpBin.EQ, new IValue(BigInteger.ZERO, GlobalSettings.ARCH_PRECISION)));
        }
        final CondJump assumeSideEffect = EventFactory.newJumpUnless(atLeastOneSideEffect, (Label) thread.getExit());
        assumeSideEffect.addFilters(Tag.BOUND, Tag.EARLYTERMINATION, Tag.NOOPT);
        // TODO: Is it sufficient to tag this jump as "SPINLOOP" to get proper spinloop detection?
        insertionPoint.insertAfter(assumeSideEffect);
    }


    // ============================= Actual logic =============================

    // Compute all loops in a thread
    private List<Loop> findLoops(Thread thread) {
        //NOTE: This needs to get updated if the unrolling code renames the loop labels differently
        final String iterNumberSeparator = "itr_";

        int loopCounter = 0;
        final Map<String, Loop> labelName2LoopMap = new HashMap<>();
        final List<Loop> loops = new ArrayList<>();
        for (Event e : thread.getEvents()) {
            if (!(e instanceof Label && ((Label)e).getName().lastIndexOf(iterNumberSeparator) >= 0)) {
                // No loop label
                continue;
            }
            final Label loopLabel = (Label) e;
            final int iterNumberSeparatorIndex = loopLabel.getName().lastIndexOf(iterNumberSeparator);
            final int iterNumber = Integer.parseInt(loopLabel.getName()
                    .substring(iterNumberSeparatorIndex + iterNumberSeparator.length()));
            final String loopName = loopLabel.getName().substring(0, iterNumberSeparatorIndex);

            if (iterNumber == 1) {
                final Loop loop = new Loop();
                loop.thread = thread;
                loop.loopNumber = loopCounter++;
                labelName2LoopMap.put(loopName, loop);
                loops.add(loop);
            }
            final Loop loop = labelName2LoopMap.get(loopName);
            Verify.verifyNotNull(loop,
                    "Found intermediate loop iteration {} before encountering loop beginning.", loopLabel.getName());
            final LoopIteration iter = new LoopIteration();
            iter.loop = loop;
            iter.iterationNumber = iterNumber;
            iter.startLabel = loopLabel;
            if (!loop.iterations.isEmpty()) {
                loop.iterations.get(loop.iterations.size() - 1).endLabel = iter.startLabel;
            }
            loop.iterations.add(iter);
        }

        loops.forEach(this::populateLoopSideEffectsAndExitPoints);
        return loops;
    }

    private void populateLoopSideEffectsAndExitPoints(Loop loop) {
        loop.iterations.subList(0, loop.iterations.size() - 1).forEach(this::populateLoopIteration);
    }
    private void populateLoopIteration(LoopIteration iteration) {
        Preconditions.checkNotNull(iteration.endLabel);
        final Label start = iteration.startLabel;
        final Label end = iteration.endLabel;

        iteration.sideEffects.addAll(collectSideEffects(start, end));

        Event cur = start;
        while ((cur = cur.getSuccessor()) != end) {
            if (cur instanceof CondJump) {
                final CondJump jump = (CondJump) cur;
                final Label jumpTarget = jump.getLabel();
                if (jump.isGoto() && jumpTarget.getCId() > end.getCId()) {
                    iteration.trueExitPoints.add(jump);
                }
            }
        }
    }

    private List<Event> collectSideEffects(Label iterStart, Label iterEnd) {
        List<Event> sideEffects = new ArrayList<>();
        // Unsafe means the loop read from the registers before writing to them.
        Set<Register> unsafeRegisters = new HashSet<>();
        // Safe means the loop wrote to these register before using them
        Set<Register> safeRegisters = new HashSet<>();

        Event cur = iterStart;
        while ((cur = cur.getSuccessor()) != iterEnd) {
            if (cur instanceof MemEvent) {
                if (cur.is(Tag.WRITE)) {
                    sideEffects.add(cur); // Writes always cause side effects
                    continue;
                } else {
                    final Set<Register> addrRegs = ((MemEvent) cur).getAddress().getRegs();
                    unsafeRegisters.addAll(Sets.difference(addrRegs, safeRegisters));
                }
            }

            if (cur instanceof RegReaderData) {
                final Set<Register> dataRegs = ((RegReaderData) cur).getDataRegs();
                unsafeRegisters.addAll(Sets.difference(dataRegs, safeRegisters));
            }

            if (cur instanceof RegWriter) {
                final RegWriter writer = (RegWriter) cur;
                if (unsafeRegisters.contains(writer.getResultRegister())) {
                    // The loop writes to a register it previously read from.
                    // This means the next loop iteration will observe the newly written value,
                    // hence the loop is not side effect free.
                    sideEffects.add(cur);
                } else {
                    safeRegisters.add(writer.getResultRegister());
                }
            }
        }
        return sideEffects;
    }


    private void reduceToDominatingSideEffects(Loop loop) {
        for (int i = 0; i < loop.iterations.size() - 1; i++) {
            final LoopIteration iter = loop.iterations.get(i);
            reduceToDominatingSideEffects(loop, iter);
            if (loop.hasAlwaysSideEffects) {
                break;
            }
        }
    }

    private void reduceToDominatingSideEffects(Loop loop, LoopIteration iter) {
        final Label start = iter.startLabel;
        final Label end = iter.endLabel;
        final List<Event> iterEvents = start.getSuccessors().stream().takeWhile(e -> e != end).collect(Collectors.toList());
        iterEvents.add(end);

        // to compute the pre-dominator tree ...
        final Map<Event, List<Event>> immPredMap = new HashMap<>();
        immPredMap.put(iterEvents.get(0), List.of());
        for (Event e : iterEvents.subList(1, iterEvents.size())) {
            final List<Event> preds = new ArrayList<>();
            final Event pred = e.getPredecessor();
            if (!(pred instanceof CondJump && ((CondJump)pred).isGoto())) {
                preds.add(pred);
            }
            if (e instanceof Label) {
                preds.addAll(((Label)e).getJumpSet());
            }
            immPredMap.put(e, preds);
        }

        // to compute the post-dominator tree ...
        final List<Event> reversedOrderEvents = new ArrayList<>(Lists.reverse(iterEvents));
        final Map<Event, List<Event>> immSuccMap = new HashMap<>();
        immSuccMap.put(reversedOrderEvents.get(0), List.of());
        for (Event e : iterEvents) {
            for (Event pred : immPredMap.get(e)) {
                immSuccMap.computeIfAbsent(pred, key -> new ArrayList<>()).add(e);
            }
        }

        // We delete all side effects that are guaranteed to lead to an exit point, i.e.,
        // those that never reach a subsequent iteration.
        reversedOrderEvents.forEach(e -> immSuccMap.putIfAbsent(e, List.of()));
        List<Event> exitPoints = new ArrayList<>(iter.trueExitPoints);
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


        final Map<Event, Event> preDominatorTree = computeDominatorTree(iterEvents, immPredMap::get);

        {
            // Check if always side-effect-full
            // This is an approximation: If the end of the iteration is predominated by some side effect
            // then we always observe side effects.
            Event dom = end;
            while ((dom = preDominatorTree.get(dom)) != start) {
                if (iter.sideEffects.contains(dom)) {
                    // A special case where the loop is always side-effect-full
                    // There is no need to proceed further
                    loop.hasAlwaysSideEffects = true;
                    return;
                }
            }
        }

        // Remove all side effects that are guaranteed to exit the loop.
        iter.sideEffects.removeIf(e -> !immSuccMap.containsKey(e));

        // Delete all pre-dominated side effects
        for (final Event e : List.copyOf(iter.sideEffects)) {
            Event dom = e;
            while ((dom = preDominatorTree.get(dom)) != start) {
                assert dom != null;
                if (iter.sideEffects.contains(dom)) {
                    iter.sideEffects.remove(e);
                    break;
                }
            }
        }

        // Delete all post-dominated side effects
        final Map<Event, Event> postDominatorTree = computeDominatorTree(reversedOrderEvents, immSuccMap::get);
        for (final Event e : List.copyOf(iter.sideEffects)) {
            Event dom = e;
            while ((dom = postDominatorTree.get(dom)) != end) {
                assert dom != null;
                if (iter.sideEffects.contains(dom)) {
                    iter.sideEffects.remove(e);
                    break;
                }
            }
        }
    }


    private Map<Event, Event> computeDominatorTree(List<Event> events, Function<Event, ? extends Collection<Event>> predsFunc) {
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
