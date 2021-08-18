package com.dat3m.dartagnan.wmm.filter;

import com.dat3m.dartagnan.program.event.Event;

import java.util.HashMap;
import java.util.Map;

public class FilterMinus extends FilterAbstract {

    private final static Map<String, FilterMinus> instances = new HashMap<>();

    public static FilterMinus get(FilterAbstract filter1, FilterAbstract filter2){
        String key = mkName(filter1, filter2);
        return instances.computeIfAbsent(key, k -> new FilterMinus(filter1, filter2));
    }

    private static String mkName(FilterAbstract filter1, FilterAbstract filter2){
        return ((filter1 instanceof FilterBasic) ? filter1 : "( " + filter1 + " )")
                + " \\ " + ((filter2 instanceof FilterBasic) ? filter2 : "( " + filter2 + " )");
    }

    private final FilterAbstract filter1;
    private final FilterAbstract filter2;

    private FilterMinus(FilterAbstract filterPresent, FilterAbstract filterAbsent){
        this.filter1 = filterPresent;
        this.filter2 = filterAbsent;
    }

    @Override
    public boolean filter(Event e){
        return filter1.filter(e) && !filter2.filter(e);
    }

    @Override
    public String toString(){
        return mkName(filter1, filter2);
    }

    @Override
    public int hashCode() {
        return filter1.hashCode() ^ filter2.hashCode();
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;

        if (obj == null || getClass() != obj.getClass())
            return false;

        FilterMinus fObj = (FilterMinus) obj;
        return fObj.filter1.equals(filter1) && fObj.filter2.equals(filter2);
    }
}