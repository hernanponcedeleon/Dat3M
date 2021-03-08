package com.dat3m.dartagnan.wmm.graphRefinement.decoration;

import com.dat3m.dartagnan.program.arch.aarch64.utils.EType;
import com.dat3m.dartagnan.program.event.*;
import com.dat3m.dartagnan.program.Thread;


//A decoration/facade to enhance Event with additional information for refinement
public class EventData implements Comparable<EventData> {
    private final EventMap map; // Not used right now

    private final Event event;
    private EventData readFrom;
    private int id = -1;
    private int localId = -1;
    private long value;
    private long accessedAddress;
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

    public long getAccessedAddress() { return accessedAddress; }
    public void setAccessedAddress(long address) { accessedAddress = address; }

    public long getValue() { return value;}
    public long setValue(long val) { return value = val;}

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

    public boolean isExclusive() { return event.is(EType.EXCL); }

    public boolean isLock() { return event.is(EType.LOCK); }

    public boolean isRMW() { return event.is(EType.RMW); }

    public boolean is(String type) { return event.is(type); }

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
        return "T" + event.getThread().getId() + ":" + localId + "; " + event.toString();
    }

    @Override
    public int compareTo(EventData o) {
        return event.compareTo(o.event);
    }
}
