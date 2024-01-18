package com.dat3m.dartagnan.program.filter;

import com.dat3m.dartagnan.program.event.Event;

public class UnionFilter extends Filter {

    private final Filter filter1;
    private final Filter filter2;

    UnionFilter(Filter filter1, Filter filter2){
        this.filter1 = filter1;
        this.filter2 = filter2;
    }

    @Override
    public boolean apply(Event event){
        return filter1.apply(event) || filter2.apply(event);
    }

    @Override
    public String toString(){
        return (filter1 instanceof TagFilter ? filter1.toString() : "( " + filter1.toString() + " )")
                + " + " + (filter2 instanceof TagFilter ? filter2.toString() : "( " + filter2.toString() + " )");
    }

    @Override
    public int hashCode() {
        return filter1.hashCode() | filter2.hashCode();
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        } else if (obj == null || getClass() != obj.getClass()) {
            return false;
        }

        UnionFilter fObj = (UnionFilter) obj;
        return fObj.filter1.equals(filter1) && fObj.filter2.equals(filter2);
    }
}
