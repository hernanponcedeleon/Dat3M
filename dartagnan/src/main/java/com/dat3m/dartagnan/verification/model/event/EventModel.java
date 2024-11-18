package com.dat3m.dartagnan.verification.model.event;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;


public interface EventModel extends Comparable<EventModel> {
    Event getEvent();

    Thread getThread();

    int getId();
    void setId(int id);

    int getLocalId();
    void setLocalId(int localId);

    boolean wasExecuted();
    void setWasExecuted(boolean executed);

    boolean isMemoryEvent();
    boolean isInit();
    boolean isWrite();
    boolean isRead();
    boolean isFence();
    boolean isExclusive();
    boolean isRMW();
    boolean isJump();
    boolean isAssert();
    boolean isLocal();
    boolean isRegReader();
    boolean isRegWriter();
    boolean hasTag(String tag);
}