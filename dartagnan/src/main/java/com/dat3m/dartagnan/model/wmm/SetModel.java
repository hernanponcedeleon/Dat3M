package com.dat3m.dartagnan.model.wmm;

import com.dat3m.dartagnan.model.EventModel;
import com.google.common.collect.ImmutableSet;

import java.util.Set;

public final class SetModel implements PredicateModel {

    private final String name;
    private final ImmutableSet<EventModel> events;

    public SetModel(String name, Set<EventModel> events) {
        this.name = name;
        this.events = ImmutableSet.copyOf(events);
    }

    public String getName() { return name; }
    public ImmutableSet<EventModel> getEvents() { return events; }

    public boolean contains(EventModel a) {
        return events.contains(a);
    }

    @Override
    public String toString() {
        StringBuilder builder = new StringBuilder();
        events.forEach(a -> builder.append(String.format("%s\n", a)));
        return String.format("%s {\n%s}", name, builder);
    }
}
