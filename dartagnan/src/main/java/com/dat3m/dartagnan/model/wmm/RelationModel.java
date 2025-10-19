package com.dat3m.dartagnan.model.wmm;

import com.dat3m.dartagnan.model.EventModel;
import com.google.common.collect.ImmutableMap;

import java.util.Map;
import java.util.Set;

public final class RelationModel implements PredicateModel {

    private final String name;
    private final ImmutableMap<EventModel, Set<EventModel>> edges;

    public RelationModel(String name, Map<EventModel, Set<EventModel>> edges) {
        this.name = name;
        this.edges = ImmutableMap.copyOf(edges);
    }

    public String getName() { return name; }
    public ImmutableMap<EventModel, Set<EventModel>> getEvents() { return edges; }

    public boolean contains(EventModel a, EventModel b) {
        return edges.getOrDefault(a, Set.of()).contains(b);
    }

    @Override
    public String toString() {
        StringBuilder builder = new StringBuilder();
        edges.forEach((a, set) ->
                    set.forEach( b -> builder.append(String.format("%s    ==>    %s\n", a, b))));
        return String.format("%s {\n%s}", name, builder);
    }
}
