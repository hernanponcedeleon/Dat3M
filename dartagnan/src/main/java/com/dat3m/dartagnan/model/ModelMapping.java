package com.dat3m.dartagnan.model;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.wmm.Relation;
import com.google.common.collect.ImmutableBiMap;

import java.util.Map;

public class ModelMapping {

    private final ImmutableBiMap<Event, EventModel> event2Model;
    private final ImmutableBiMap<Thread, ThreadModel> thread2Model;
    private final ImmutableBiMap<MemoryObject, MemoryObjectModel> memoryObject2Model;
    private final ImmutableBiMap<Relation, RelationModel> relation2Model;

    public ModelMapping(Map<Event, EventModel> event2Model,
                        Map<Thread, ThreadModel> thread2Model,
                        Map<MemoryObject, MemoryObjectModel> memoryObject2Model,
                        Map<Relation, RelationModel> relation2Model) {
        this.event2Model = ImmutableBiMap.copyOf(event2Model);
        this.thread2Model = ImmutableBiMap.copyOf(thread2Model);
        this.memoryObject2Model = ImmutableBiMap.copyOf(memoryObject2Model);
        this.relation2Model = ImmutableBiMap.copyOf(relation2Model);
    }

    public ImmutableBiMap<Event, EventModel> getEvent2Model() {
        return event2Model;
    }

    public ImmutableBiMap<Thread, ThreadModel> getThread2Model() {
        return thread2Model;
    }

    public ImmutableBiMap<MemoryObject, MemoryObjectModel> getMemoryObject2Model() {
        return memoryObject2Model;
    }

    public ImmutableBiMap<Relation, RelationModel> getRelation2Model() {
        return relation2Model;
    }
}
