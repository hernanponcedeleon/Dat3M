package com.dat3m.dartagnan.wmm.relation.basic;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.rmw.RMWStore;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.wmm.filter.FilterAbstract;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.filter.FilterIntersection;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;

public class RelRMW extends BasicRelation {

    public RelRMW(){
        term = "rmw";
        isStatic = true;
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet();
            FilterAbstract filter = FilterIntersection.get(FilterBasic.get(EType.RMW), FilterBasic.get(EType.WRITE));
            for(Event store : program.getEventRepository().getEvents(filter)){
                Event load = ((RMWStore)store).getLoadEvent();
                // Can be null for STXR in Aarch64
                if(load != null){
                    maxTupleSet.add(new Tuple(load, store));
                }
            }
        }
        return maxTupleSet;
    }
}
