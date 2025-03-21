package com.dat3m.dartagnan.program.filter;

import com.dat3m.dartagnan.program.event.Event;

public class DifferenceFilter extends Filter {

    private final Filter filter1;
    private final Filter filter2;

    DifferenceFilter(Filter filterPresent, Filter filterAbsent){
        this.filter1 = filterPresent;
        this.filter2 = filterAbsent;
    }

    @Override
    public boolean apply(Event event){
        return filter1.apply(event) && !filter2.apply(event);
    }

    @Override
    public String toString() {
        return ((filter1 instanceof TagFilter) ? filter1 : "( " + filter1 + " )")
                + " \\ " + ((filter2 instanceof TagFilter) ? filter2 : "( " + filter2 + " )");
    }

    @Override
    public int hashCode() {
        return filter1.hashCode() ^ filter2.hashCode();
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        } else if (obj == null || getClass() != obj.getClass()) {
            return false;
        }

        DifferenceFilter fObj = (DifferenceFilter) obj;
        return fObj.filter1.equals(filter1) && fObj.filter2.equals(filter2);
    }
}