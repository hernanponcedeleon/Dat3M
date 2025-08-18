package com.dat3m.dartagnan.model;

import com.google.common.collect.ImmutableSet;

import java.util.Set;

public final class DomainModel {

    private final ImmutableSet<EventModel> events;

    public DomainModel(Set<EventModel> events) {
        this.events = ImmutableSet.copyOf(events);
    }

    public ImmutableSet<EventModel> getEvents() { return events; }
}
