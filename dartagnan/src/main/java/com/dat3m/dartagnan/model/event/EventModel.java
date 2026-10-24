package com.dat3m.dartagnan.model.event;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.model.ThreadModel;


public interface EventModel extends Comparable<EventModel> {
    Event getEvent();

    ThreadModel getThreadModel();

    int getId();
}