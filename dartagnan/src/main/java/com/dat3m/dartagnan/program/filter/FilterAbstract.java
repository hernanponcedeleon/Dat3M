package com.dat3m.dartagnan.program.filter;

import com.dat3m.dartagnan.program.event.core.Event;

public abstract class FilterAbstract {

    protected String name;

    public String getName(){
        return name;
    }

    public void setName(String name){
        this.name = name;
    }

    public abstract boolean filter(Event e);
}