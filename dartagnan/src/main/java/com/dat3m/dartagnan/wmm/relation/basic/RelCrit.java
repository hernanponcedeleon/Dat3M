package com.dat3m.dartagnan.wmm.relation.basic;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.arch.linux.event.rcu.RCUReadUnlock;
import com.dat3m.dartagnan.program.utils.EventRepository;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;

public class RelCrit extends BasicRelation {

    public RelCrit(){
        term = "crit";
        isStatic = true;
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet();
            for(Event unlock : program.getEventRepository().getEvents(EventRepository.RCU_UNLOCK)){
                maxTupleSet.add(new Tuple(((RCUReadUnlock)unlock).getLockEvent(), unlock));
            }
        }
        return maxTupleSet;
    }
}
