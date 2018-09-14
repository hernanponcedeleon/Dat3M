package dartagnan.wmm.relation.basic;

import dartagnan.program.Thread;
import dartagnan.program.event.Event;
import dartagnan.program.utils.EventRepository;
import dartagnan.wmm.relation.utils.Tuple;
import dartagnan.wmm.relation.utils.TupleSet;

import java.util.*;
import java.util.stream.Collectors;

public class RelPo extends StaticRelation {

    public RelPo(){
        term = "po";
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet();
            for(Thread t : program.getThreads()){
                List<Event> events = t.getEventRepository().getEvents(EventRepository.EVENT_ALL)
                        .stream().sorted(Comparator.comparing(Event::getEId)).collect(Collectors.toList());

                ListIterator<Event> it1 = events.listIterator();
                while(it1.hasNext()){
                    Event e1 = it1.next();
                    ListIterator<Event> it2 = events.listIterator(it1.nextIndex());
                    while(it2.hasNext()){
                        maxTupleSet.add(new Tuple(e1, it2.next()));
                    }
                }
            }
        }
        return maxTupleSet;
    }
}
