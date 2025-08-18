package com.dat3m.dartagnan.model;

import com.google.common.base.Preconditions;

import java.util.ArrayList;
import java.util.List;

public final class ThreadModel {

    private final String name;
    private final int tid;
    private final List<EventModel> events = new ArrayList<>();

    private transient ExecutionModel execution;

    public int getThreadId() { return tid; }
    public ExecutionModel getExecution() { return execution; }

    public ThreadModel(String name, int id) {
        this.name = name;
        this.tid = id;
    }

    public List<EventModel> getEvents() {
        return events;
    }

    @Override
    public String toString() {
        return name + "#" + tid;
    }

    // --------------------------------------------------------------------------------------------------------------
    // Intern

    void append(EventModel event) {
        Preconditions.checkNotNull(event);
        ((AbstractEventModel) event).setThread(this);
        events.add(event);
    }

    void setExecution(ExecutionModel execution) {
        this.execution = execution;
    }
}
