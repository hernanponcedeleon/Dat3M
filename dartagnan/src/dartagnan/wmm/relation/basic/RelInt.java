package dartagnan.wmm.relation.basic;

import dartagnan.program.Thread;
import dartagnan.program.event.Event;
import dartagnan.program.utils.EventRepository;
import dartagnan.wmm.utils.Tuple;
import dartagnan.wmm.utils.TupleSet;

import java.util.Collection;

public class RelInt extends BasicRelation {

    public RelInt(){
        term = "int";
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet();
            for(Thread t : program.getThreads()){
                Collection<Event> events = t.getEventRepository().getEvents(EventRepository.EVENT_VISIBLE);
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
