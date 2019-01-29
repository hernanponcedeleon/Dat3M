package com.dat3m.dartagnan.parsers.utils.branch;

import com.dat3m.dartagnan.program.event.Event;

public class Label extends Event {

    private final String name;

    public Label(String name){
        this.name = name;
    }

    @Override
    public String toString(){
        return name + ":";
    }

    @Override
    public Label clone() {
        return new Label(name);
    }
}
