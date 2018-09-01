package dartagnan.wmm.relation.basic;

import dartagnan.program.Program;
import dartagnan.program.event.Event;
import dartagnan.program.utils.EventRepository;
import dartagnan.wmm.relation.utils.Tuple;

import java.util.Collection;
import java.util.HashSet;
import java.util.Set;

public class RelLoc extends StaticRelation {

    public RelLoc(){
        term = "loc";
    }

    @Override
    public Set<Tuple> getMaxTupleSet(Program program){
        if(maxTupleSet == null){
            maxTupleSet = new HashSet<>();
            Collection<Event> events = program.getEventRepository().getEvents(EventRepository.EVENT_MEMORY);
            for(Event e1 : events){
                for(Event e2 : events){
                    if(!e1.getEId().equals(e2.getEId()) && e1.getLoc() == e2.getLoc()){
                        maxTupleSet.add(new Tuple(e1, e2));
                    }
                }
            }
        }
        return maxTupleSet;
    }
}
