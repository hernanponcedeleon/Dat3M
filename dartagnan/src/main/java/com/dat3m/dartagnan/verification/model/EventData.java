package com.dat3m.dartagnan.verification.model;

import com.dat3m.dartagnan.program.event.*;

import static com.dat3m.dartagnan.program.arch.aarch64.utils.EType.EXCL;
import static com.dat3m.dartagnan.program.utils.EType.*;

import java.math.BigInteger;

import com.dat3m.dartagnan.program.Thread;


//EventData represents all data associated with an event in a concrete model.

public class EventData implements Comparable<EventData> {
    private final Event event;
    private EventData readFrom;
    private int id = -1;
    private int localId = -1;
    private BigInteger value;
    private BigInteger accessedAddress;
    private int importance;
    private boolean wasExecuted;

    EventData(Event e) {
        this.event = e;
    }

    public Event getEvent() {
    	return event;
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

    public BigInteger getValue() {
    	return value;
    }
    
    void setValue(BigInteger val) {
    	value = val;
    }

    public EventData getReadFrom() {
    	return readFrom;
    }
    
    void setReadFrom(EventData store) {
    	readFrom = store;
    }

    public int getImportance() {
    	return importance;
    }
    
    void setImportance(int importance) {
    	this.importance = importance;
    }

    public boolean wasExecuted() {
    	return wasExecuted;
    }

    void setWasExecuted(boolean flag) {
    	wasExecuted = flag;
    }

    public Thread getThread() {
    	return event.getThread();
    }

    public boolean isMemoryEvent() {
        return event instanceof MemEvent;
    }

    public boolean isWrite() { return event.is(WRITE); }

    public boolean isInit() {
        return event.is(INIT);
    }

    public boolean isRead() { return event.is(READ); }

    public boolean isFence() {
        return event.is(FENCE);
    }

    public boolean isJump() {
        return event.is(JUMP);
    }

    public boolean isIfElse() {
        return event instanceof If;
    }

    public boolean isExclusive() {
    	return event.is(EXCL);
    }

    public boolean isLock() {
    	return event.is(LOCK);
    }

    public boolean isRMW() {
    	return event.is(RMW);
    }

    public boolean is(String type) {
    	return event.is(type);
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
        return "T" + event.getThread().getId() + ":" + localId /*+ "; " + event.toString()*/;
    }

    @Override
    public int compareTo(EventData o) {
        return event.compareTo(o.event);
    }
}
