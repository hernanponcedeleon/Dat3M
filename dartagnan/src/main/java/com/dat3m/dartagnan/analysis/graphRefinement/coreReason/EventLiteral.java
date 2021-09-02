package com.dat3m.dartagnan.analysis.graphRefinement.coreReason;

import com.dat3m.dartagnan.verification.model.EventData;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.SolverContext;

/*
This encodes events as literals. An event literal is simply the events exec-variable.
 */
public class EventLiteral implements CoreLiteral {

    private final EventData eventData;

    public EventData getEventData() {
        return eventData;
    }

    public EventLiteral(EventData e) {
        this.eventData = e;
    }

    @Override
    public int hashCode() {
        return eventData.hashCode();
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this)
            return true;
        if (!(obj instanceof EventLiteral))
            return false;

        EventLiteral other = (EventLiteral) obj;
        return this.eventData.equals(other.eventData);
    }

    @Override
    public String toString() {
        return eventData.toString();
    }

    @Override
    public BooleanFormula getBooleanFormula(SolverContext ctx) {
        return eventData.getEvent().exec();
    }

    @Override
    public boolean hasOpposite() {
        return false;
    }

    @Override
    public CoreLiteral getOpposite() {
        return null;
    }
}
