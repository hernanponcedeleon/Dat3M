package com.dat3m.dartagnan.solver.caat4wmm;

import com.dat3m.dartagnan.solver.caat.domain.Domain;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.verification.model.ExecutionModel;

import java.util.Collection;
import java.util.List;

public class EventDomain implements Domain<EventData> {

    private final ExecutionModel executionModel;
    private final List<EventData> eventList;

    public EventDomain(ExecutionModel model) {
        this.executionModel = model;
        eventList = model.getEventList();
    }

    public ExecutionModel getExecution() {
        return executionModel;
    }

    @Override
    public int size() {
        return eventList.size();
    }

    @Override
    public Collection<EventData> getElements() {
        return eventList;
    }

    @Override
    public int getId(Object obj) {
        if (obj instanceof EventData evData) {
            return evData.getId();
        } else {
            throw new IllegalArgumentException(obj + " is not of type EventData");
        }
    }

    @Override
    public EventData getObjectById(int id) {
        return eventList.get(id);
    }
}
