package com.dat3m.dartagnan.verification.model.event;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.verification.model.ThreadModel;


public interface EventModel extends Comparable<EventModel> {
    Event getEvent();

    ThreadModel getThread();

    int getId();

    boolean isMemoryEvent();
    boolean isInit();
    boolean isWrite();
    boolean isRead();
    boolean isFence();
    boolean isExclusive();
    boolean isRMW();
    boolean isVisible();
    boolean isJump();
    boolean isAssert();
    boolean isLocal();
    boolean isRegReader();
    boolean isRegWriter();
}