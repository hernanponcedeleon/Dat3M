package com.dat3m.dartagnan.model;

import com.google.common.collect.ImmutableMap;

import java.util.Map;
import java.util.Set;

public final class RelationModel {

    private final String name;
    private final ImmutableMap<EventModel, Set<EventModel>> events;

    public RelationModel(String name, Map<EventModel, Set<EventModel>> events) {
        this.name = name;
        this.events = ImmutableMap.copyOf(events);
    }

    public boolean contains(EventModel a, EventModel b) {
        return events.getOrDefault(a, Set.of()).contains(b);
    }

    @Override
    public String toString() {
        StringBuilder builder = new StringBuilder();
        events.forEach((a, set) ->
                set.forEach( b -> builder.append(String.format("%s    ==>    %s\n", a, b))));
        return String.format("%s {\n%s}", name, builder);
    }
}
