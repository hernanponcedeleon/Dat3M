package com.dat3m.dartagnan.task.exploration;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.MemoryCoreEvent;
import com.dat3m.dartagnan.program.event.core.annotations.LoopBound;
import com.dat3m.dartagnan.program.event.core.threading.ThreadCreate;

import java.util.*;

/*
    Static (graph-independent) information about the code of the explored threads.
 */
final class ThreadAnalysis {

    // Threads (by index) with loops without memory writes (e.g. await loops or the retry loops of seqlock readers).
    private final Set<Integer> threadsWithPureLoops = new HashSet<>();
    // For each spin-loop terminator, the event that starts the iterations of its loop (see collectSpinLoopHeaders).
    private final Map<Event, Event> spinLoopHeaders = new HashMap<>();
    private final Set<Event> spinLoopHeaderSet = new HashSet<>();
    // Events from which the thread may still write to memory or create a thread (see collectMayWriteLater).
    private final Set<Event> mayWriteLater = new HashSet<>();

    ThreadAnalysis(List<Thread> threads) {
        for (int t = 0; t < threads.size(); t++) {
            if (hasPureLoop(threads.get(t))) {
                threadsWithPureLoops.add(t);
            }
        }
        threads.forEach(this::collectSpinLoopHeaders);
        collectMayWriteLater(threads);
    }

    boolean hasPureLoop(int thread) {
        return threadsWithPureLoops.contains(thread);
    }

    // The event that starts the iterations of the loop of the spin-loop terminator, or null if unknown.
    Event getSpinLoopHeader(CondJump terminator) {
        return spinLoopHeaders.get(terminator);
    }

    boolean isSpinLoopHeader(Event e) {
        return spinLoopHeaderSet.contains(e);
    }

    // Whether the thread may write to memory (or create a thread) when it continues at the given event.
    boolean mayWriteLater(Event pc) {
        return mayWriteLater.contains(pc);
    }

    // ================================================================================================
    // Pure loops

    private static boolean hasPureLoop(Thread thread) {
        for (Event e : thread.getEvents()) {
            if (e instanceof CondJump jump && isBackJump(jump) && isPureLoop(jump)) {
                return true;
            }
        }
        return false;
    }

    private static boolean isBackJump(CondJump jump) {
        return !jump.isDead() && jump.getLabel().getGlobalId() <= jump.getGlobalId();
    }

    private static boolean isPureLoop(CondJump backJump) {
        for (Event cur = backJump.getLabel(); cur != null && cur != backJump; cur = cur.getSuccessor()) {
            if (cur.hasTag(Tag.WRITE) || cur instanceof ThreadCreate) {
                return false;
            }
        }
        return true;
    }

    // ================================================================================================
    // Spin loops

    /*
        Spin-loop terminators (see DynamicSpinLoopDetection) are placed right before the back jump of their loop,
        so the iterations start at the target of that back jump. Statically side-effect-free loops lose their back
        jump, but are preceded by a LoopBound annotation instead (matched here with the nesting of terminators).
        With nested loops, the thread's current iteration (ThreadState.iterationStart) may be the one of an inner
        loop, so the interpreter determines the iteration that spins from the entry of its own loop.
     */
    private void collectSpinLoopHeaders(Thread thread) {
        for (Event e : thread.getEvents()) {
            if (e instanceof CondJump terminator && terminator.hasTag(Tag.SPINLOOP)) {
                Event header = findBackJumpTarget(terminator);
                if (header == null) {
                    header = findLoopBound(terminator);
                }
                if (header != null) {
                    spinLoopHeaders.put(terminator, header);
                    spinLoopHeaderSet.add(header);
                }
            }
        }
    }

    private static Event findBackJumpTarget(CondJump terminator) {
        for (Event cur = terminator.getSuccessor(); cur != null && !(cur instanceof Label); cur = cur.getSuccessor()) {
            if (cur instanceof CondJump jump && !jump.isDead()) {
                return jump.getLabel().getGlobalId() <= terminator.getGlobalId() ? jump.getLabel() : null;
            }
        }
        return null;
    }

    private static Event findLoopBound(CondJump terminator) {
        int depth = 0;
        for (Event cur = terminator.getPredecessor(); cur != null; cur = cur.getPredecessor()) {
            if (cur instanceof CondJump jump && jump.hasTag(Tag.SPINLOOP)) {
                depth++;
            } else if (cur instanceof LoopBound) {
                if (depth == 0) {
                    return cur;
                }
                depth--;
            }
        }
        return null;
    }

    // ================================================================================================
    // Future writes

    /*
        Backward fixpoint over the control flow of each thread.
        Writes to thread-state words (pthread bookkeeping) are ignored: they are only read by spawning loads and
        join loads, which are never revisited (see TruStExplorer.visitWrite and visitRead).
     */
    private void collectMayWriteLater(List<Thread> threads) {
        final Set<Expression> stateWords = new HashSet<>();
        for (Thread thread : threads) {
            final List<MemoryCoreEvent> spawning = thread.getSpawningEvents();
            if (!spawning.isEmpty()) {
                stateWords.add(spawning.get(0).getAddress());
            }
        }
        for (Thread thread : threads) {
            final List<Event> events = thread.getEvents();
            boolean changed = true;
            while (changed) {
                changed = false;
                for (int i = events.size() - 1; i >= 0; i--) {
                    final Event e = events.get(i);
                    if (!mayWriteLater.contains(e) && (writes(e, stateWords) || mayWriteAfter(e))) {
                        mayWriteLater.add(e);
                        changed = true;
                    }
                }
            }
        }
    }

    private static boolean writes(Event e, Set<Expression> stateWords) {
        if (e instanceof ThreadCreate) {
            return true;
        }
        return e.hasTag(Tag.WRITE) && !(e instanceof MemoryCoreEvent m && stateWords.contains(m.getAddress()));
    }

    private boolean mayWriteAfter(Event e) {
        if (e instanceof CondJump jump && !jump.isDead()) {
            return mayWriteLater.contains(jump.getLabel())
                    || (!jump.isGoto() && mayWriteLater.contains(jump.getSuccessor()));
        }
        return e.getSuccessor() != null && mayWriteLater.contains(e.getSuccessor());
    }
}
