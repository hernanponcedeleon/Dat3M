package com.dat3m.dartagnan.model;

import com.dat3m.dartagnan.model.wmm.PredicateModel;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.wmm.Relation;
import com.google.common.collect.ImmutableBiMap;

// TODO: Maybe extend ExecutionModel instead?
public final class MappedExecutionModel {

    private final ExecutionModel executionModel;
    private final ModelMapping modelMapping;

    public MappedExecutionModel(ExecutionModel executionModel,
                                ModelMapping modelMapping) {
        this.executionModel = executionModel;
        this.modelMapping = modelMapping;
    }

    public ExecutionModel getExecutionModel() {
        return executionModel;
    }

    public ImmutableBiMap<Event, EventModel> getEvent2Model() {
        return modelMapping.getEvent2Model();
    }

    public ImmutableBiMap<Thread, ThreadModel> getThread2Model() {
        return modelMapping.getThread2Model();
    }

    public ImmutableBiMap<MemoryObject, MemoryObjectModel> getMemoryObject2Model() {
        return modelMapping.getMemoryObject2Model();
    }

    public ImmutableBiMap<Relation, PredicateModel> getRelation2Model() {
        return modelMapping.getPredicate2Model();
    }

}
