package dartagnan.wmm.relation.basic;

import dartagnan.program.event.Event;
import dartagnan.program.event.rmw.RMWStore;
import dartagnan.program.utils.EventRepository;
import dartagnan.wmm.utils.Tuple;
import dartagnan.wmm.utils.TupleSet;

public class RelRMW extends BasicRelation {

    public RelRMW(){
        term = "rmw";
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet();
            for(Event store : program.getEventRepository().getEvents(EventRepository.RMW_STORE)){
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
