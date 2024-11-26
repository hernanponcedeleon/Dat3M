package com.dat3m.dartagnan.verification.model;

import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.verification.model.event.EventModel;

import java.util.Collections;
import java.util.List;


public class ThreadModel {
    private final Thread thread;
    private final List<EventModel> eventList;

    public ThreadModel(Thread thread, List<EventModel> eventList) {
        this.thread = thread;
        this.eventList = eventList;
    }

    public int getId() {
        return thread.getId();
    }

    public List<EventModel> getEventList() {
        return Collections.unmodifiableList(eventList);
    }

    public List<EventModel> getVisibleEventList() {
        return eventList.stream().filter(e -> e.hasTag(Tag.VISIBLE)).toList();
    }

    public List<EventModel> getEventModelsToShow() {
        return eventList.stream()
                        .filter(e -> e.hasTag(Tag.VISIBLE) || e.isLocal() || e.isAssert())
                        .toList();
    }
}