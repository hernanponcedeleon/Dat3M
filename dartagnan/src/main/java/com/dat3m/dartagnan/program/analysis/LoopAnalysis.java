package com.dat3m.dartagnan.program.analysis;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Label;
import com.google.common.base.Verify;
import com.google.common.collect.ImmutableList;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.program.processing.LoopUnrolling.*;

/*
    This class provides information about Loops in the program.
    It can be used before and after LoopUnrolling.

    Preconditions:
        - All loops are normalized (as checked by LoopFormVerification)
 */
public class LoopAnalysis {

    public static class LoopInfo {
        private Thread thread;
        private String loopName;
        private int loopNumber; // Loop index within thread
        private boolean isUnrolled;
        private final List<LoopIterationInfo> loopIterationInfos = new ArrayList<>();

        public Thread getThread() { return thread; }
        public String getName() { return loopName; }
        public int getLoopNumber() { return loopNumber; }
        public boolean isUnrolled() { return isUnrolled; }
        public List<LoopIterationInfo> getIterations() { return loopIterationInfos; }
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
            return this == containingLoop.getIterations().get(containingLoop.getIterations().size() - 1);
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

    private final Map<Thread, ImmutableList<LoopInfo>> thread2LoopsMap = new HashMap<>();
    public ImmutableList<LoopInfo> getLoopsOfThread(Thread thread) {
        return thread2LoopsMap.get(thread);
    }

    private LoopAnalysis() {}

    public static LoopAnalysis newInstance(Program program) {
        final LoopAnalysis loopAnalysis = new LoopAnalysis();
        loopAnalysis.run(program);
        return loopAnalysis;
    }

    // ---------------------------------------------------------

    private void run(Program program) {
        final Function<Thread, ImmutableList<LoopInfo>> loopFindingAlgo =
                program.isUnrolled() ? this::findUnrolledLoopsInThread : this::findLoopsInThread;

        program.getThreads().forEach(t -> this.thread2LoopsMap.put(t, loopFindingAlgo.apply(t)));
    }

    private ImmutableList<LoopInfo> findUnrolledLoopsInThread(Thread thread) {
        final Map<String, LoopInfo> loopName2InfoMap = new HashMap<>();
        final List<LoopInfo> loops = new ArrayList<>();

        int loopCounter = 0;
        for (Event e : thread.getEvents()) {
            final LoopLabelInfo labelInfo = tryParseLoopLabel(e);
            if (labelInfo == null) {
                continue;
            }

            final String loopName = labelInfo.loopName;
            if (labelInfo.iterationIndex == 1) {
                // We start a new loop
                final LoopInfo loopInfo = new LoopInfo();
                loopInfo.loopNumber = loopCounter++;
                loopInfo.loopName = loopName;
                loopInfo.thread = thread;
                loopInfo.isUnrolled = true;
                // NOTE: Inner loops may get copied while unrolling the outer loop.
                // In that case, the inner loops all may have identical label names
                // So this put-operation may overwrite an old entry, which is okay!
                loopName2InfoMap.put(loopName, loopInfo);
                loops.add(loopInfo);
            }

            final LoopInfo loopInfo = loopName2InfoMap.get(loopName);
            if (labelInfo.isBound) {
                final LoopIterationInfo lastIter = loopInfo.loopIterationInfos.get(loopInfo.loopIterationInfos.size() - 1);
                // We assume the bound marker to be directly before the loop bounding event.
                // NOTE: We consider neither the bound marker nor the bounding event to be part of this iteration.
                lastIter.iterEnd = e.getPredecessor();
            } else {
                final LoopIterationInfo newIter = new LoopIterationInfo();
                newIter.iterNumber = labelInfo.iterationIndex;
                newIter.iterBegin = e;
                newIter.containingLoop = loopInfo;
                loopInfo.loopIterationInfos.add(newIter);
                Verify.verify(newIter.iterNumber == loopInfo.loopIterationInfos.size());

                if (loopInfo.loopIterationInfos.size() > 1) {
                    final LoopIterationInfo prevIter = loopInfo.loopIterationInfos.get(loopInfo.loopIterationInfos.size() - 2);
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

    private ImmutableList<LoopInfo> findLoopsInThread(Thread thread) {
        final List<CondJump> backJumps = thread.getEvents().stream()
                .filter(CondJump.class::isInstance).map(CondJump.class::cast)
                .filter(j -> j.getLabel().getGlobalId() < j.getGlobalId())
                .collect(Collectors.toList());

        final List<LoopInfo> loops = new ArrayList<>();
        int loopCounter = 0;
        for (CondJump backJump : backJumps) {
            final Label target = backJump.getLabel();
            final String loopName = target.getName();
            final LoopInfo loopInfo = new LoopInfo();
            loopInfo.loopNumber = loopCounter++;
            loopInfo.isUnrolled = false;
            loopInfo.thread = thread;
            loopInfo.loopName = loopName;

            final LoopIterationInfo iterInfo = new LoopIterationInfo();
            iterInfo.containingLoop = loopInfo;
            iterInfo.iterBegin = target;
            iterInfo.iterEnd = backJump;
            iterInfo.iterNumber = 1;
            loopInfo.loopIterationInfos.add(iterInfo);

            loops.add(loopInfo);
        }
        return ImmutableList.copyOf(loops);
    }
}
