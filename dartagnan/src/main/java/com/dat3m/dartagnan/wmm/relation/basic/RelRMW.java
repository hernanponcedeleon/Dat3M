package com.dat3m.dartagnan.wmm.relation.basic;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.rmw.RMWStore;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;

import java.util.ArrayList;
import java.util.List;

public class RelRMW extends BasicRelation {

    public RelRMW(){
        term = "rmw";
        isStatic = true;
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet();

            // TODO: Use composite filter
            List<Event> rmwStore = new ArrayList<>(program.getEventRepository().getEvents(EType.RMW));
            rmwStore.retainAll(program.getEventRepository().getEvents(EType.WRITE));

            for(Event store : rmwStore){
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
