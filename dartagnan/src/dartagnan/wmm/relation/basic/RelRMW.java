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
                maxTupleSet.add(new Tuple(((RMWStore)store).getLoadEvent(), store));
            }
        }
        return maxTupleSet;
    }
}
