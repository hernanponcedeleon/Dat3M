package com.dat3m.dartagnan.verification.model;

import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.verification.model.event.EventModel;
import com.dat3m.dartagnan.verification.model.event.GenericVisibleEventModel;
import com.dat3m.dartagnan.verification.model.event.MemoryEventModel;

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

    public Thread getThread() {
        return thread;
    }

    public int getId() {
        return thread.getId();
    }

    public String getName() {
        return thread.getName();
    }

    public List<EventModel> getEventModels() {
        return Collections.unmodifiableList(eventList);
    }

    public List<EventModel> getVisibleEventModels() {
        return eventList.stream()
                        .filter(e -> e instanceof MemoryEventModel || e instanceof GenericVisibleEventModel)
                        .toList();
    }
}