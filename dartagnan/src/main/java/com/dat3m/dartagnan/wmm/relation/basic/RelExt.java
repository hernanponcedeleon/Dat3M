package com.dat3m.dartagnan.wmm.relation.basic;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;

import java.util.Collection;

public class RelExt extends BasicRelation {

    public RelExt(){
        term = "ext";
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet();
            for(Thread t1 : program.getThreads()){
                Collection<Event> eventsT1 = t1.getCache().getEvents(FilterBasic.get(EType.VISIBLE));
                for(Thread t2 : program.getThreads()){
                    if(t1 != t2){
                        Collection<Event> eventsT2 = t2.getCache().getEvents(FilterBasic.get(EType.VISIBLE));
                        for(Event e1 : eventsT1){
                            for(Event e2 : eventsT2){
                                maxTupleSet.add(new Tuple(e1, e2));
                            }
                        }
                    }
                }
            }
        }
        return maxTupleSet;
    }
}
