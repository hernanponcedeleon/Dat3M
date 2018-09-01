package dartagnan.wmm.relation.basic;

import dartagnan.program.Program;
import dartagnan.program.event.Event;
import dartagnan.program.event.rmw.RMWStore;
import dartagnan.program.utils.EventRepository;
import dartagnan.wmm.relation.utils.Tuple;

import java.util.HashSet;
import java.util.Set;

public class RelRMW extends StaticRelation {

    public RelRMW(){
        term = "rmw";
    }

    @Override
    public Set<Tuple> getMaxTupleSet(Program program){
        if(maxTupleSet == null){
            maxTupleSet = new HashSet<>();
            for(Event store : program.getEventRepository().getEvents(EventRepository.EVENT_RMW_STORE)){
                maxTupleSet.add(new Tuple(((RMWStore)store).getLoadEvent(), store));
            }
        }
        return maxTupleSet;
    }
}
