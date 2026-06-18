package com.dat3m.dartagnan.wmm.utils.graph;

import com.dat3m.dartagnan.program.event.Event;

public abstract class AbstractEventGraph implements EventGraph {

    @Override
    public boolean equals(Object other) {
        return this == other || other instanceof EventGraph o && getOutMap().equals(o.getOutMap());
    }

    @Override
    public int hashCode() {
        throw new UnsupportedOperationException(EventGraph.class.getSimpleName() + " should not be used as a key");
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder("[");
        for (Event e1 : getDomain().stream().sorted().toList()) {
            for (Event e2 : getRange(e1).stream().sorted().toList()) {
                sb.append("(").append(e1.getGlobalId()).append(",").append(e2.getGlobalId()).append(")");
            }
        }
        return sb.append("]").toString();
    }
}
