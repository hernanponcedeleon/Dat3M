package com.dat3m.dartagnan.analysis.saturation.reasoning;

import com.dat3m.dartagnan.verification.model.EventData;

/*
This encodes events as literals. An event literal is simply the events exec-variable.
 */
public class EventLiteral extends AbstractLiteral {

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
        if (obj == this) {
            return true;
        } else if (!(obj instanceof EventLiteral)) {
            return false;
        }

        EventLiteral other = (EventLiteral) obj;
        return this.eventData.equals(other.eventData);
    }

    @Override
    public String toString() {
        return eventData.toString();
    }

}
