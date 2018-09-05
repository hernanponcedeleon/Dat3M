package dartagnan.wmm.relation.basic;

import dartagnan.program.Thread;
import dartagnan.program.event.Event;
import dartagnan.program.utils.EventRepository;
import dartagnan.wmm.relation.utils.Tuple;

import java.util.Collection;
import java.util.HashSet;
import java.util.Set;

public class RelInt extends StaticRelation {

    public RelInt(){
        term = "int";
    }

    @Override
    public Set<Tuple> getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new HashSet<>();
            for(Thread t : program.getThreads()){
                Collection<Event> events = t.getEventRepository().getEvents(EventRepository.EVENT_ALL);
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
