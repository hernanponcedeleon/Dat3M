package com.dat3m.dartagnan.program.analysis;

import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Label;
import com.google.common.base.Verify;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.Iterables;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static com.dat3m.dartagnan.program.processing.LoopUnrolling.*;

/*
    This class provides information about Loops in the program.
    It can be used before and after LoopUnrolling.

    Preconditions:
        - All loops are normalized (as checked by LoopFormVerification)
 */
public class LoopAnalysis {

    public record LoopInfo(Function function, String loopName, int loopNumber,
                           boolean isUnrolled, List<LoopIterationInfo> iterations) {
    }

    public static class LoopIterationInfo {
        private LoopInfo containingLoop;
        private Event iterBegin;
        private Event iterEnd;
        private int iterNumber;

        public LoopInfo getContainingLoop() { return containingLoop; }
        public Event getIterationStart() { return iterBegin; }
        public Event getIterationEnd() { return iterEnd; }
        public int getIterationNumber() { return iterNumber; }
        public boolean isLast() {
            return this == containingLoop.iterations().get(containingLoop.iterations().size() - 1);
        }

        public List<Event> computeBody() {
            final List<Event> body = new ArrayList<>();
            final Event terminator = getIterationEnd().getSuccessor();
            Event cur = getIterationStart();
            do {
                body.add(cur);
            } while ((cur = cur.getSuccessor()) != terminator);
            return body;
        }
    }

    private static class LoopLabelInfo {
        private String loopName;
        private boolean isBound;
        private int iterationIndex;
    }

    // ---------------------------------------------------------

    private final Map<Function, ImmutableList<LoopInfo>> func2LoopsMap = new HashMap<>();
    public ImmutableList<LoopInfo> getLoopsOfFunction(Function func) {
        return func2LoopsMap.get(func);
    }

    private LoopAnalysis() {}

    public static LoopAnalysis newInstance(Program program) {
        final LoopAnalysis loopAnalysis = new LoopAnalysis();
        loopAnalysis.run(program);
        return loopAnalysis;
    }

    public static LoopAnalysis onFunction(Function function) {
        final LoopAnalysis loopAnalysis = new LoopAnalysis();
        loopAnalysis.run(function);
        return loopAnalysis;
    }

    // ---------------------------------------------------------

    private void run(Program program) {
        final java.util.function.Function<Function, ImmutableList<LoopInfo>> loopFindingAlgo =
                program.isUnrolled() ? this::findUnrolledLoopsInFunction : this::findLoopsInFunction;

        Iterables.concat(program.getThreads(), program.getFunctions())
                .forEach(t -> this.func2LoopsMap.put(t, loopFindingAlgo.apply(t)));
    }

    private void run(Function function) {
        final Program program = function.getProgram();
        final java.util.function.Function<Function, ImmutableList<LoopInfo>> loopFindingAlgo =
                program.isUnrolled() ? this::findUnrolledLoopsInFunction : this::findLoopsInFunction;

        this.func2LoopsMap.put(function, loopFindingAlgo.apply(function));
    }

    private ImmutableList<LoopInfo> findUnrolledLoopsInFunction(Function function) {
        final Map<String, LoopInfo> loopName2InfoMap = new HashMap<>();
        final List<LoopInfo> loops = new ArrayList<>();

        int loopCounter = 0;
        for (Event e : function.getEvents()) {
            final LoopLabelInfo labelInfo = tryParseLoopLabel(e);
            if (labelInfo == null) {
                continue;
            }

            final String loopName = labelInfo.loopName;
            if (labelInfo.iterationIndex == 1) {
                // We start a new loop
                final LoopInfo loopInfo = new LoopInfo(function, loopName, loopCounter++, true, new ArrayList<>());
                // NOTE: Inner loops may get copied while unrolling the outer loop.
                // In that case, the inner loops all may have identical label names
                // So this put-operation may overwrite an old entry, which is okay!
                loopName2InfoMap.put(loopName, loopInfo);
                loops.add(loopInfo);
            }

            final LoopInfo loopInfo = loopName2InfoMap.get(loopName);
            if (labelInfo.isBound) {
                final LoopIterationInfo lastIter = loopInfo.iterations.get(loopInfo.iterations.size() - 1);
                // We assume the bound marker to be directly before the loop bounding event.
                // NOTE: We consider neither the bound marker nor the bounding event to be part of this iteration.
                lastIter.iterEnd = e.getPredecessor();
            } else {
                final LoopIterationInfo newIter = new LoopIterationInfo();
                newIter.iterNumber = labelInfo.iterationIndex;
                newIter.iterBegin = e;
                newIter.containingLoop = loopInfo;
                loopInfo.iterations.add(newIter);
                Verify.verify(newIter.iterNumber == loopInfo.iterations.size());

                if (loopInfo.iterations.size() > 1) {
                    final LoopIterationInfo prevIter = loopInfo.iterations.get(loopInfo.iterations.size() - 2);
                    prevIter.iterEnd = e.getPredecessor(); // The previous iteration ends directly before the new starts
                }
            }
        }

        return ImmutableList.copyOf(loops);
    }

    // A loop-related label has the form
    // "origLabel.loop/bound OR origLabel.loop/itr_N"
    private LoopLabelInfo tryParseLoopLabel(Event eventToParse) {
        if (!(eventToParse instanceof Label label && label.getName().contains(LOOP_LABEL_IDENTIFIER))) {
            return null;
        }
        final int labelInfoIndex = label.getName().lastIndexOf(LOOP_INFO_SEPARATOR);
        if (labelInfoIndex < 0) {
            // This can happen if a loop was partially eliminated by another pass (i.e., the backjump gets deleted)
            return null;
        }
        final String loopName = label.getName().substring(0, labelInfoIndex);
        final String labelInfo = label.getName().substring(labelInfoIndex + LOOP_INFO_SEPARATOR.length());

        final LoopLabelInfo info = new LoopLabelInfo();
        info.loopName = loopName;
        if (labelInfo.contains(LOOP_INFO_BOUND_SUFFIX)) {
            info.isBound = true;
            info.iterationIndex = -1;
        } else if (labelInfo.contains(LOOP_INFO_ITERATION_SUFFIX)) {
            final int iterNumberInfoIndex = labelInfo.lastIndexOf(LOOP_INFO_ITERATION_SUFFIX);
            info.iterationIndex = Integer.parseInt(labelInfo
                    .substring(iterNumberInfoIndex + LOOP_INFO_ITERATION_SUFFIX.length()));
            info.isBound = false;
        } else {
            throw new IllegalArgumentException("Unrecognized loop label: " + label.getName());
        }

        return info;
    }

    private ImmutableList<LoopInfo> findLoopsInFunction(Function function) {
        final List<CondJump> backJumps = function.getEvents(CondJump.class).stream()
                .filter(j -> j.getLabel().getLocalId() < j.getLocalId())
                .toList();

        final List<LoopInfo> loops = new ArrayList<>();
        int loopCounter = 0;
        for (CondJump backJump : backJumps) {
            final Label target = backJump.getLabel();
            final String loopName = target.getName();
            final LoopInfo loopInfo = new LoopInfo(function, loopName, loopCounter++, false, new ArrayList<>());

            final LoopIterationInfo iterInfo = new LoopIterationInfo();
            iterInfo.containingLoop = loopInfo;
            iterInfo.iterBegin = target;
            iterInfo.iterEnd = backJump;
            iterInfo.iterNumber = 1;
            loopInfo.iterations.add(iterInfo);

            loops.add(loopInfo);
        }
        return ImmutableList.copyOf(loops);
    }
}
