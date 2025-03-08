package com.dat3m.dartagnan.verification.model;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.CondJump;

import java.math.BigInteger;

import static com.dat3m.dartagnan.program.event.Tag.*;


//EventData represents all data associated with an event in a concrete model.
public class EventData implements Comparable<EventData> {
    private final Event event;
    private EventData readFrom;
    private int id = -1;
    private int localId = -1;
    private Object value;
    private BigInteger accessedAddress;
    private int coIndex = Integer.MIN_VALUE;
    private boolean wasExecuted;

    EventData(Event e) {
        this.event = e;
    }

    public Event getEvent() {
    	return event;
    }
    public Thread getThread() {
        return event.getThread();
    }

    public int getId() {
    	return id;
    }
    void setId(int newId) {
    	id = newId;
    }

    public int getLocalId() {
    	return localId;
    }
    void setLocalId(int newId) {
    	localId = newId;
    }

    public BigInteger getAccessedAddress() {
    	return accessedAddress;
    }
    void setAccessedAddress(BigInteger address) {
    	accessedAddress = address;
    }

    public Object getValue() {
    	return value;
    }
    void setValue(Object val) {
    	value = val;
    }

    public EventData getReadFrom() {
    	return readFrom;
    }
    void setReadFrom(EventData store) {
    	readFrom = store;
    }

    public boolean wasExecuted() {
    	return wasExecuted;
    }
    void setWasExecuted(boolean flag) {
    	wasExecuted = flag;
    }

    public int getCoherenceIndex() { return coIndex; }
    void setCoherenceIndex(int index) { coIndex = index; }

    public boolean isMemoryEvent() { return event.hasTag(MEMORY); }
    public boolean isInit() {
        return event.hasTag(INIT);
    }
    public boolean isWrite() { return event.hasTag(WRITE); }
    public boolean isRead() { return event.hasTag(READ); }
    public boolean isFence() { return event.hasTag(FENCE); }
    public boolean isJump() {
        return event instanceof CondJump;
    }
    public boolean isExclusive() {
    	return event.hasTag(EXCL);
    }
    public boolean isRMW() {
    	return event.hasTag(RMW);
    }

    public boolean hasTag(String tag) {
    	return event.hasTag(tag);
    }

    @Override
    public int hashCode() {
        return id;
    }

    @Override
    public boolean equals(Object obj) {
        // EventData instances are unique per event.
        return this == obj;
    }

    @Override
    public String toString() {
        return String.format("T%d:%d", event.getThread().getId(), localId);
    }

    @Override
    public int compareTo(EventData o) {
        return this.getId() - o.getId();
    }
}
