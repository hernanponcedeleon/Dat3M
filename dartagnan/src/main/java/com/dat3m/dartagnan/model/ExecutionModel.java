package com.dat3m.dartagnan.model;

import com.dat3m.dartagnan.model.wmm.PredicateModel;
import com.google.common.collect.ImmutableList;

import java.util.List;

public final class ExecutionModel {

    private final ImmutableList<ThreadModel> threads;
    private final ImmutableList<MemoryObjectModel> memoryObjects;
    private final ImmutableList<PredicateModel> predicates;

    public ExecutionModel(List<ThreadModel> threads,
                          List<MemoryObjectModel> memoryObjects,
                          List<PredicateModel> predicates) {
        this.threads = ImmutableList.copyOf(threads);
        this.memoryObjects = ImmutableList.copyOf(memoryObjects);
        this.predicates = ImmutableList.copyOf(predicates);

        threads.forEach(t -> t.setExecution(this));
    }

    public ImmutableList<ThreadModel> getThreads() { return threads; }
    public ImmutableList<MemoryObjectModel> getMemoryObjects() { return memoryObjects; }
    public ImmutableList<PredicateModel> getPredicates() { return predicates; }

}
