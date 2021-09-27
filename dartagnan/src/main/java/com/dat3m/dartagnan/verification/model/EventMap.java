package com.dat3m.dartagnan.verification.model;

import com.dat3m.dartagnan.program.event.Event;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

public class EventMap {

    private final Map<Event, EventData> eventMap;


    public EventMap() {
        eventMap = new HashMap<>();
    }

    public boolean contains(Event e) {
        return eventMap.containsKey(e);
    }

    public Set<Event> getKeys() {
        return eventMap.keySet();
    }

    public EventData remove(Event e) {
        return eventMap.remove(e);
    }

    public void remove(EventData eventData) {
        eventMap.remove(eventData.getEvent());
    }

    public EventData getOrCreate(Event e) {
        return eventMap.computeIfAbsent(e, EventData::new);
    }

    public EventData get(Event e) {
        return eventMap.get(e);
    }

    public Collection<EventData> getValues() {
        return eventMap.values();
    }

    public void clear() {
        eventMap.clear();
    }
}