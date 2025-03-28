package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.program.event.AbstractEvent;
import com.dat3m.dartagnan.program.event.Event;

import java.util.ArrayList;
import java.util.List;

import static com.google.common.base.Preconditions.checkState;

/**
 * Instances of this class occur in pairs, where the link is owned by the later event.
 * The "begin" boundary must be a dominator of the "end" boundary, but the opposite may not be true.
 *
 * <p>
 * Visible events enclosed by such a pair are said to originate from the same instruction.
 * In execution graphs, they shall be {@code si}-related.
 */
public final class InstructionBoundary extends AbstractEvent {

    private final InstructionBoundary begin;

    public InstructionBoundary(Void ignore, InstructionBoundary b) {
        begin = b;
    }

    private InstructionBoundary(InstructionBoundary other) {
        super(other);
        begin = other.begin;
    }

    public List<Event> getTransactionEvents() {
        if (begin == null) {
            return List.of();
        }
        checkState(begin.getFunction() == getFunction() && begin.getGlobalId() < getGlobalId(), "Broken instruction");
        final var events = new ArrayList<Event>();
        for (Event event = begin.getSuccessor(); event != this; event = event.getSuccessor()) {
            events.add(event);
        }
        return events;
    }

    @Override
    protected String defaultString() {
        final String format = begin == null ? "=== begin instruction %d ===" : "=== end instruction %d ===";
        return String.format(format, (begin == null ? this : begin).getGlobalId());
    }

    @Override
    public Event getCopy() {
        return new InstructionBoundary(this);
    }
}
