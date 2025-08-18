package com.dat3m.dartagnan.model.events.threading;

import com.dat3m.dartagnan.model.AbstractEventModel;

public final class ThreadStartModel extends AbstractEventModel {

    private final ThreadCreateModel creator;

    public ThreadStartModel(ThreadCreateModel creator) {
        this.creator = creator;
    }

    public ThreadCreateModel getCreator() { return creator; }

    @Override
    public String toString() {
        return String.format("ThreadStart%s", creator == null ? "" : String.format(" by %s", creator));
    }

}
