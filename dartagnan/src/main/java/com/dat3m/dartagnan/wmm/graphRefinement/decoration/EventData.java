package com.dat3m.dartagnan.wmm.graphRefinement.decoration;

import com.dat3m.dartagnan.program.arch.pts.event.Read;
import com.dat3m.dartagnan.program.event.*;
import com.dat3m.dartagnan.program.Thread;


// Not used yet.
// The intended usage is to add an EventData field to the existing implementation of Event
// and use this field to attach additional information for the current refinement.
public class EventData implements Comparable<EventData> {
    private EventMap map;

    private Event event;
    private EventData readFrom;
    private int id;
    private int localId;
    private int accessedAddress;
    private int importance;
    private boolean wasExecuted;

    EventData(Event e, EventMap eventMap) {
        this.event = e;
        this.map = eventMap;
    }

    public Event getEvent() { return event; }

    public int getId() { return id; }
    public void setId(int newId) { id = newId; }

    public int getLocalId() { return localId; }
    public void setLocalId(int newId) { localId = newId; }

    public int getAccessedAddress() { return accessedAddress; }
    public void setAccessedAddress(int address) { accessedAddress = address; }

    public EventData getReadFrom() { return readFrom; }
    public void setReadFrom(EventData store) { readFrom = store; }

    public int getImportance() { return importance; }
    public void setImportance(int importance) { this.importance = importance; }

    public boolean wasExecuted() { return wasExecuted; }
    public void setWasExecuted(boolean flag) { wasExecuted = flag; }

    public Thread getThread() { return event.getThread(); }

    public boolean isMemoryEvent() {
        return event instanceof MemEvent;
    }

    public boolean isWrite() {
        return event instanceof Store || event instanceof Init; //event.is(EType.WRITE);
    }

    public boolean isInit() {
        return event instanceof Init;
    }

    public boolean isRead() {
        return event instanceof Load; // event.is(EType.READ)
    }

    public boolean isFence() {
        return event instanceof Fence;
    }

    public boolean isJump() {
        return event instanceof CondJump;
    }

    public boolean isIfElse() {
        return event instanceof If;
    }

    @Override
    public int hashCode() {
        return event.hashCode();
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this)
            return true;
        if (obj == null || obj.getClass() != this.getClass())
            return false;
        return this.event.equals(((EventData)obj).event);
    }

    @Override
    public String toString() {
        return "T" + event.getThread().getId() + ":" + localId;
    }

    @Override
    public int compareTo(EventData o) {
        return event.compareTo(o.event);
    }
}
