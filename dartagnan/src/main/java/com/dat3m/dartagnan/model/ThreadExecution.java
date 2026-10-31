package com.dat3m.dartagnan.model;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.BlockingEvent;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.google.common.base.Preconditions;

import java.util.*;

/*
    The executed path of a single thread: all executed events in program order.
 */
public final class ThreadExecution {

    private final Thread thread;
    private final List<Event> trace;
    private final Map<Event, Integer> positions;
    private final List<BlockingEvent> blockedEvents;
    // For each register, the positions of its executed writers in increasing order.
    private final Map<Register, int[]> writerPositions;

    ThreadExecution(Thread thread, List<Event> trace, List<BlockingEvent> blockedEvents) {
        this.thread = thread;
        this.trace = List.copyOf(trace);
        this.blockedEvents = List.copyOf(blockedEvents);

        final Map<Event, Integer> positions = new HashMap<>();
        final Map<Register, List<Integer>> writers = new HashMap<>();
        for (int i = 0; i < trace.size(); i++) {
            final Event e = trace.get(i);
            Preconditions.checkArgument(e.getThread() == thread, "Event %s does not belong to %s", e, thread);
            positions.put(e, i);
            if (e instanceof RegWriter writer) {
                writers.computeIfAbsent(writer.getResultRegister(), _ -> new ArrayList<>()).add(i);
            }
        }
        this.positions = positions;
        final Map<Register, int[]> writerPositions = new HashMap<>();
        writers.forEach((reg, pos) -> writerPositions.put(reg, pos.stream().mapToInt(Integer::intValue).toArray()));
        this.writerPositions = writerPositions;
    }

    public Thread getThread() {
        return thread;
    }

    public List<Event> getTrace() {
        return trace;
    }

    public boolean hasStarted() {
        return !trace.isEmpty();
    }

    public boolean contains(Event e) {
        return positions.containsKey(e);
    }

    // Position of the event within this thread's trace.
    public int getPosition(Event e) {
        final Integer pos = positions.get(e);
        Preconditions.checkArgument(pos != null, "Event %s is not executed in %s", e, thread);
        return pos;
    }

    // Executed blocking events that are blocked, i.e., the thread got stuck at them.
    public List<BlockingEvent> getBlockedEvents() {
        return blockedEvents;
    }

    public boolean isBlocked() {
        return !blockedEvents.isEmpty();
    }

    // The last executed writer of the register strictly before the given position (if any).
    Optional<RegWriter> getLastWriterBefore(Register register, int position) {
        final int[] writers = writerPositions.get(register);
        if (writers == null) {
            return Optional.empty();
        }
        final int idx = Arrays.binarySearch(writers, position);
        // Either exact match (writer at "position" itself, which must not count) or insertion point.
        final int last = (idx >= 0 ? idx : -idx - 1) - 1;
        return last < 0 ? Optional.empty() : Optional.of((RegWriter) trace.get(writers[last]));
    }

    Optional<RegWriter> getLastWriter(Register register) {
        return getLastWriterBefore(register, trace.size());
    }

    @Override
    public String toString() {
        return String.format("%s: %d events", thread, trace.size());
    }
}
