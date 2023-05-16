package com.dat3m.dartagnan.prototype.program.event.core.control;

import com.dat3m.dartagnan.prototype.program.event.AbstractEvent;

public abstract class Label extends AbstractEvent {

    private String name;

    public Label(String name) {
        this.name = name;
    }

    public String getName() { return this.name; }
}
