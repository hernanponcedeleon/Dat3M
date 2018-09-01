package dartagnan.wmm.relation.basic;

import dartagnan.program.Program;
import dartagnan.program.event.Event;
import dartagnan.program.event.filter.FilterAbstract;
import dartagnan.wmm.relation.utils.Tuple;

import java.util.Collection;
import java.util.HashSet;
import java.util.Set;

public class RelCartesian extends StaticRelation {
    private FilterAbstract filter1;
    private FilterAbstract filter2;

    public RelCartesian(FilterAbstract filter1, FilterAbstract filter2) {
        this.filter1 = filter1;
        this.filter2 = filter2;
        this.term = "(" + filter1 + "*" + filter2 + ")";
    }

    public RelCartesian(FilterAbstract filter1, FilterAbstract filter2, String name) {
        super(name);
        this.filter1 = filter1;
        this.filter2 = filter2;
        this.term = "(" + filter1 + " * " + filter2 + ")";
    }

    @Override
    public Set<Tuple> getMaxTupleSet(Program program){
        if(maxTupleSet == null){
            maxTupleSet = new HashSet<>();
            Collection<Event> eventsStart = program.getEventRepository().getEvents(filter1.toRepositoryCode());
            Collection<Event> eventsEnd = program.getEventRepository().getEvents(filter2.toRepositoryCode());
            for(Event e1 : eventsStart){
                if(filter1.filter(e1)){
                    for(Event e2 : eventsEnd){
                        if(filter2.filter(e2)){
                            maxTupleSet.add(new Tuple(e1, e2));
                        }
                    }
                }
            }
        }
        return maxTupleSet;
    }
}
