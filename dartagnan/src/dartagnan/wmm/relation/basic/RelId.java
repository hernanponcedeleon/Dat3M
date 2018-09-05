package dartagnan.wmm.relation.basic;

import dartagnan.program.event.Event;
import dartagnan.program.utils.EventRepository;
import dartagnan.wmm.relation.utils.Tuple;

import java.util.HashSet;
import java.util.Set;

public class RelId extends StaticRelation {

    public RelId(){
        term = "id";
    }

    @Override
    public Set<Tuple> getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new HashSet<>();
            for(Event e : program.getEventRepository().getEvents(EventRepository.EVENT_ALL)){
                maxTupleSet.add(new Tuple(e, e));
            }
        }
        return maxTupleSet;
    }
}
