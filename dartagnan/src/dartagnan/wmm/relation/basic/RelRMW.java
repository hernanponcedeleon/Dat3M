package dartagnan.wmm.relation.basic;

import dartagnan.program.event.Event;
import dartagnan.program.event.rmw.RMWLoad;
import dartagnan.program.event.rmw.RMWStore;
import dartagnan.program.event.rmw.RMWStoreToAddress;
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
                // TODO: Remove RMWStore after all classes converted to address events
                Event load = null;
                if(store instanceof RMWStore){
                    load = ((RMWStore)store).getLoadEvent();
                } else if (store instanceof RMWStoreToAddress){
                    load = ((RMWStoreToAddress)store).getLoadEvent();
                }
                // Can be null for STXR in Aarch64
                if(load != null){
                    maxTupleSet.add(new Tuple(load, store));
                }
            }
        }
        return maxTupleSet;
    }
}
