package com.dat3m.dartagnan.wmm.utils.graph.immutable;

import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;

import java.util.Arrays;

public interface ImmutableEventGraph extends EventGraph {

    static ImmutableEventGraph empty() {
        return ImmutableMapEventGraph.empty();
    }

    static ImmutableEventGraph from(EventGraph other) {
        if (other instanceof ImmutableEventGraph iOther) {
            return iOther;
        }
        return ImmutableMapEventGraph.from(other);
    }

    static ImmutableEventGraph union(EventGraph... operands) {
        operands = Arrays.stream(operands).filter(o -> !o.isEmpty()).toArray(EventGraph[]::new);
        if (operands.length == 0) {
            return ImmutableEventGraph.empty();
        }
        if (operands.length == 1) {
            return ImmutableEventGraph.from(operands[0]);
        }
        if (Arrays.stream(operands).anyMatch(LazyEventGraph.class::isInstance)) {
            return LazyEventGraph.union(operands);
        }
        return ImmutableMapEventGraph.union(operands);
    }

    static ImmutableEventGraph intersection(EventGraph... operands) {
        if (Arrays.stream(operands).anyMatch(EventGraph::isEmpty)) {
            return ImmutableEventGraph.empty();
        }
        if (operands.length == 1) {
            return ImmutableEventGraph.from(operands[0]);
        }
        if (Arrays.stream(operands).allMatch(LazyEventGraph.class::isInstance)) {
            return LazyEventGraph.intersection(operands);
        }
        return ImmutableMapEventGraph.intersection(operands);
    }

    static ImmutableEventGraph difference(EventGraph minuend, EventGraph subtrahend) {
        if (minuend.isEmpty() || subtrahend.isEmpty()) {
            return ImmutableEventGraph.from(minuend);
        }
        if (minuend instanceof LazyEventGraph) {
            return LazyEventGraph.difference(minuend, subtrahend);
        }
        return ImmutableMapEventGraph.difference(minuend, subtrahend);
    }
}
