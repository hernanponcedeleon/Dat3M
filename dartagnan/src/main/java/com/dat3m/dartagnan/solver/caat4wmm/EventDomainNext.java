package com.dat3m.dartagnan.solver.caat4wmm;

import com.dat3m.dartagnan.solver.caat.domain.Domain;
import com.dat3m.dartagnan.verification.model.event.EventModel;
import com.dat3m.dartagnan.verification.model.ExecutionModelNext;

import java.util.Collection;
import java.util.List;


public class EventDomainNext implements Domain<EventModel> {
    private final ExecutionModelNext executionModel;
    private final List<EventModel> eventList;

    public EventDomainNext(ExecutionModelNext executionModel) {
        this.executionModel = executionModel;
        eventList = executionModel.getEventList();
    }

    @Override
    public int size() {
        return eventList.size();
    }

    @Override
    public Collection<EventModel> getElements() {
        return eventList;
    }

    @Override
    public int getId(Object obj) {
        if (obj instanceof EventModel em) {
            return em.getId();
        } else {
            throw new IllegalArgumentException(obj + " is not of type EventModel");
        }
    }

    @Override
    public EventModel getObjectById(int id) {
        return eventList.get(id);
    }
}