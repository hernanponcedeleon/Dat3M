package com.dat3m.dartagnan.wmm.utils.graph;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.wmm.utils.graph.immutable.ImmutableEventGraph;

import java.util.Map;
import java.util.Set;
import java.util.function.BiConsumer;
import java.util.function.BiPredicate;

public interface EventGraph {

    static EventGraph empty() {
        return ImmutableEventGraph.empty();
    }

    boolean isEmpty();

    int size();

    boolean contains(Event e1, Event e2);

    EventGraph inverse();

    EventGraph filter(BiPredicate<Event, Event> f);

    Map<Event, Set<Event>> getOutMap();

    Map<Event, Set<Event>> getInMap();

    Set<Event> getDomain();

    Set<Event> getRange();

    Set<Event> getRange(Event e);

    void apply(BiConsumer<Event, Event> f);

    static EventGraph union(EventGraph... operands) {
        return ImmutableEventGraph.union(operands);
    }

    static EventGraph intersection(EventGraph... operands) {
        return ImmutableEventGraph.intersection(operands);
    }

    static EventGraph difference(EventGraph minuend, EventGraph subtrahend) {
        return ImmutableEventGraph.difference(minuend, subtrahend);
    }
}
