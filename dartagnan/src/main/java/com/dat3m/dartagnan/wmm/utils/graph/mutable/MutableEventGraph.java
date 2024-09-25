package com.dat3m.dartagnan.wmm.utils.graph.mutable;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;

import java.util.Set;
import java.util.function.BiPredicate;

public interface MutableEventGraph extends EventGraph {

    @Override
    MutableEventGraph inverse();

    @Override
    MutableEventGraph filter(BiPredicate<Event, Event> f);

    boolean add(Event e1, Event e2);

    boolean remove(Event e1, Event e2);

    boolean addAll(EventGraph other);

    boolean removeAll(EventGraph other);

    boolean retainAll(EventGraph other);

    boolean addRange(Event e, Set<Event> range);

    boolean removeIf(BiPredicate<Event, Event> f);

    static MutableEventGraph from(EventGraph other) {
        return MapEventGraph.from(other);
    }

    static MutableEventGraph union(EventGraph... operands) {
        return MapEventGraph.union(operands);
    }

    static MutableEventGraph intersection(EventGraph... operands) {
        return MapEventGraph.intersection(operands);
    }

    static MutableEventGraph difference(EventGraph minuend, EventGraph subtrahend) {
        return MapEventGraph.difference(minuend, subtrahend);
    }
}
