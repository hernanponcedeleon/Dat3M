package com.dat3m.dartagnan.model.events.threading;

import com.dat3m.dartagnan.encoding.TypedValue;
import com.dat3m.dartagnan.model.AbstractEventModel;
import com.dat3m.dartagnan.model.ThreadModel;
import com.google.common.collect.ImmutableList;

import java.util.List;

public final class ThreadCreateModel extends AbstractEventModel {

    private final ThreadModel spawnedThread;
    private final ImmutableList<TypedValue<?, ?>> arguments;

    public ThreadCreateModel(ThreadModel thread, List<TypedValue<?, ?>> arguments) {
        this.spawnedThread = thread;
        this.arguments = ImmutableList.copyOf(arguments);
    }

    public ImmutableList<TypedValue<?, ?>> getArguments() { return arguments; }
    public ThreadModel getSpawnedThread() { return spawnedThread; }

    @Override
    public String toString() {
        return String.format("ThreadCreate(%s, %s)",
                spawnedThread,
                arguments.stream().map(TypedValue::toString).collect(java.util.stream.Collectors.joining(", ")));
    }

}
