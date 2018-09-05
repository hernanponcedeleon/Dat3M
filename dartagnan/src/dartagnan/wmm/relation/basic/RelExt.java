package dartagnan.wmm.relation.basic;

import dartagnan.program.Thread;
import dartagnan.program.event.Event;
import dartagnan.program.utils.EventRepository;
import dartagnan.wmm.relation.utils.Tuple;

import java.util.Collection;
import java.util.HashSet;
import java.util.Set;

public class RelExt extends StaticRelation {

    public RelExt(){
        term = "ext";
    }

    @Override
    public Set<Tuple> getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new HashSet<>();
            for(Thread t1 : program.getThreads()){
                Collection<Event> eventsT1 = t1.getEventRepository().getEvents(EventRepository.EVENT_ALL);
                for(Thread t2 : program.getThreads()){
                    if(t1 != t2){
                        Collection<Event> eventsT2 = t2.getEventRepository().getEvents(EventRepository.EVENT_ALL);
                        for(Event e1 : eventsT1){
                            for(Event e2 : eventsT2){
                                maxTupleSet.add(new Tuple(e1, e2));
                            }
                        }
                    }
                }
            }
        }
        return maxTupleSet;
    }
}
