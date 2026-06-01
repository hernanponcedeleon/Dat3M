package com.dat3m.dartagnan.wmm.utils.graph.mutable;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.collections.IndexedDomain;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;

import java.util.Arrays;
import java.util.Comparator;
import java.util.Set;
import java.util.function.BiPredicate;
import java.util.stream.IntStream;

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
        if (other instanceof IndexedEventGraph o) {
            return new IndexedEventGraph(o);
        }
        return MapEventGraph.from(other);
    }

    static MutableEventGraph union(EventGraph... operands) {
        if (operands.length > 0 && operands[0] instanceof IndexedEventGraph firstOperand) {
            final IndexedDomain<Event> firstDomain = firstOperand.eventDomain();
            if (Arrays.stream(operands, 1, operands.length)
                    .allMatch(operand -> operand instanceof IndexedEventGraph o && o.eventDomain().isCompatible(firstDomain))) {
                final IndexedDomain<Event> largestDomain = Arrays.stream(operands)
                        .map(o -> ((IndexedEventGraph) o).eventDomain())
                        .max(Comparator.comparingInt(IndexedDomain::size)).orElseThrow();
                final MutableEventGraph union = new IndexedEventGraph(largestDomain);
                for (EventGraph operand : operands) {
                    union.addAll(operand);
                }
                return union;
            }
        }
        return MapEventGraph.union(operands);
    }

    static MutableEventGraph intersection(EventGraph... operands) {
        final int index = IntStream.range(0, operands.length)
                .filter(i -> operands[i] instanceof IndexedEventGraph)
                .findAny().orElse(-1);
        if (index == -1) {
            return MapEventGraph.intersection(operands);
        }
        final MutableEventGraph intersection = from((IndexedEventGraph) operands[index]);
        for (int i = 0; i < operands.length; i++) {
            if (i != index) {
                intersection.retainAll(operands[i]);
            }
        }
        return intersection;
    }

    static MutableEventGraph difference(EventGraph minuend, EventGraph subtrahend) {
        if (minuend instanceof IndexedEventGraph m) {
            final MutableEventGraph difference = new IndexedEventGraph(m);
            difference.removeAll(subtrahend);
            return difference;
        }
        return MapEventGraph.difference(minuend, subtrahend);
    }
}
