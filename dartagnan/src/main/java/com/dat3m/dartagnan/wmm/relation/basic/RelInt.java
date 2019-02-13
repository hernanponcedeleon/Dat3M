package com.dat3m.dartagnan.wmm.relation.basic;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;

import java.util.Collection;

public class RelInt extends BasicRelation {

    public RelInt(){
        term = "int";
        isStatic = true;
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet();
            for(Thread t : program.getThreads()){
                Collection<Event> events = t.getEventRepository().getEvents(FilterBasic.get(EType.VISIBLE));
                for(Event e1 : events){
                    for(Event e2 : events){
                        maxTupleSet.add(new Tuple(e1, e2));
                    }
                }
            }
        }
        return maxTupleSet;
    }
}
