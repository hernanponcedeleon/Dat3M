package com.dat3m.dartagnan.wmm.filter;

import com.dat3m.dartagnan.program.event.Event;

import java.util.HashMap;
import java.util.Map;

public class FilterBasic extends FilterAbstract {

    private final static Map<String, FilterBasic> instances = new HashMap<>();

    public static FilterBasic get(String param){
        instances.putIfAbsent(param, new FilterBasic(param));
        return instances.get(param);
    }

    private final String param;

    private FilterBasic(String param){
        this.param = param;
    }

    @Override
    public boolean filter(Event e){
        return e.is(param);
    }

    @Override
    public String toString(){
        return param;
    }

    @Override
    public int hashCode() {
        return param.hashCode();
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;

        if (obj == null || getClass() != obj.getClass())
            return false;

        FilterBasic fObj = (FilterBasic) obj;
        return fObj.param.equals(param);
    }
}
