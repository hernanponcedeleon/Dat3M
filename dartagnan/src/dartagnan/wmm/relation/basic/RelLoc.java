package dartagnan.wmm.relation.basic;

import dartagnan.program.event.Event;
import dartagnan.program.utils.EventRepository;
import dartagnan.wmm.utils.Tuple;
import dartagnan.wmm.utils.TupleSet;

import java.util.Collection;

public class RelLoc extends BasicRelation {

    public RelLoc(){
        term = "loc";
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet();
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
