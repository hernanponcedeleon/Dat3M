package com.dat3m.dartagnan.program.event.core.annotations;

import com.dat3m.dartagnan.program.event.Event;

import java.util.ArrayList;
import java.util.List;

import static com.google.common.base.Preconditions.checkState;

public final class TransactionMarker extends CodeAnnotation {

    private final Event original;
    private final TransactionMarker begin;

    public TransactionMarker(Event o, TransactionMarker b) {
        original = o;
        begin = b;
    }

    private TransactionMarker(TransactionMarker other) {
        super(other);
        original = other.original;
        begin = other.begin;
    }

    public List<Event> getTransactionEvents() {
        if (begin == null) {
            return List.of();
        }
        checkState(begin.getFunction() == getFunction() && begin.getGlobalId() < getGlobalId(), "Broken transaction");
        final var events = new ArrayList<Event>();
        for (Event event = begin.getSuccessor(); event != this; event = event.getSuccessor()) {
            events.add(event);
        }
        return events;
    }

    @Override
    protected String defaultString() {
        return begin == null ? "[[begin transaction]]" : "[[end transaction]]";
    }

    @Override
    public Event getCopy() {
        return new TransactionMarker(this);
    }
}
