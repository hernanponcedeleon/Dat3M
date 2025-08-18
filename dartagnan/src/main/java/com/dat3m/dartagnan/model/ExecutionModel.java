package com.dat3m.dartagnan.model;

import com.google.common.collect.ImmutableList;

import java.util.List;

public final class ExecutionModel {

    private final ImmutableList<ThreadModel> threads;
    private final ImmutableList<MemoryObjectModel> memoryObjects;
    private final ImmutableList<RelationModel> relations;

    public ExecutionModel(List<ThreadModel> threads,
                          List<MemoryObjectModel> memoryObjects,
                          List<RelationModel> relations) {
        this.threads = ImmutableList.copyOf(threads);
        this.memoryObjects = ImmutableList.copyOf(memoryObjects);
        this.relations = ImmutableList.copyOf(relations);

        threads.forEach(t -> t.setExecution(this));
    }

    public ImmutableList<ThreadModel> getThreads() { return threads; }
    public ImmutableList<MemoryObjectModel> getMemoryObjects() { return memoryObjects; }
    public ImmutableList<RelationModel> getRelations() { return relations; }

}
