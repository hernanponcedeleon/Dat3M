package com.dat3m.dartagnan.wmm.utils.graph;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.wmm.utils.graph.immutable.ImmutableEventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.immutable.ImmutableMapEventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.immutable.LazyEventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.mutable.MapEventGraph;

import java.util.Arrays;
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
        operands = Arrays.stream(operands).filter(o -> !o.isEmpty()).toArray(EventGraph[]::new);
        if (operands.length == 0) {
            return empty();
        }
        if (Arrays.stream(operands).anyMatch(LazyEventGraph.class::isInstance)) {
            return LazyEventGraph.union(operands);
        }
        if (Arrays.stream(operands).anyMatch(MapEventGraph.class::isInstance)) {
            return MapEventGraph.union(operands);
        }
        return ImmutableMapEventGraph.union(operands);
    }

    static EventGraph intersection(EventGraph... operands) {
        if (Arrays.stream(operands).anyMatch(EventGraph::isEmpty)) {
            return empty();
        }
        if (Arrays.stream(operands).allMatch(LazyEventGraph.class::isInstance)) {
            return LazyEventGraph.intersection(operands);
        }
        if (Arrays.stream(operands).anyMatch(MapEventGraph.class::isInstance)) {
            return MapEventGraph.intersection(operands);
        }
        return ImmutableMapEventGraph.intersection(operands);
    }

    static EventGraph difference(EventGraph minuend, EventGraph subtrahend) {
        if (minuend.isEmpty()) {
            return empty();
        }
        if (minuend instanceof LazyEventGraph) {
            return LazyEventGraph.difference(minuend, subtrahend);
        }
        if (minuend instanceof MapEventGraph || subtrahend instanceof MapEventGraph) {
            return MapEventGraph.difference(minuend, subtrahend);
        }
        return ImmutableMapEventGraph.difference(minuend, subtrahend);
    }
}
