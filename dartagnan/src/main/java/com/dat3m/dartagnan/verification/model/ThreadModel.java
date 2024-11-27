package com.dat3m.dartagnan.verification.model;

import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.verification.model.event.EventModel;

import java.util.Collections;
import java.util.List;
import java.util.ArrayList;


public class ThreadModel {
    private final Thread thread;
    private final List<EventModel> eventList;

    public ThreadModel(Thread thread) {
        this.thread = thread;
        this.eventList = new ArrayList<>();
    }

    public void addEvent(EventModel event) {
        eventList.add(event);
    }

    public int getId() {
        return thread.getId();
    }

    public String getName() {
        return thread.getName();
    }

    public List<EventModel> getEventList() {
        return Collections.unmodifiableList(eventList);
    }

    public List<EventModel> getVisibleEventList() {
        return eventList.stream().filter(e -> e.isVisible()).toList();
    }

    public List<EventModel> getEventModelsToShow() {
        return eventList.stream()
                        .filter(e -> e.isVisible() || e.isLocal() || e.isAssert())
                        .toList();
    }
}