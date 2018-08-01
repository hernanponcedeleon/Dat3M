package dartagnan.program.event.filter;

import dartagnan.program.event.Event;

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