package com.dat3m.dartagnan.wmm.relation.basic;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.utils.EventRepository;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;

public class RelId extends BasicRelation {

    public RelId(){
        term = "id";
        isStatic = true;
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet();
            for(Event e : program.getEventRepository().getEvents(EventRepository.VISIBLE)){
                maxTupleSet.add(new Tuple(e, e));
            }
        }
        return maxTupleSet;
    }
}
