package com.dat3m.dartagnan.programNew.event.core;

import com.dat3m.dartagnan.programNew.event.AbstractEvent;

// TODO: "abstract" is only here to avoid providing a complete implementation for now
public abstract class Fence extends AbstractEvent {

    private String fenceName;

    public String getFenceName() { return fenceName; }

    private Fence() { }
}
