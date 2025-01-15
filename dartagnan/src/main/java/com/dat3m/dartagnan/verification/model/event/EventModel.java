package com.dat3m.dartagnan.verification.model.event;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.verification.model.ThreadModel;


public interface EventModel extends Comparable<EventModel> {
    Event getEvent();

    ThreadModel getThreadModel();

    int getId();
}