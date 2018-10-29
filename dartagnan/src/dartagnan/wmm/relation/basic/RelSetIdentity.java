package dartagnan.wmm.relation.basic;

import dartagnan.program.event.Event;
import dartagnan.wmm.filter.FilterAbstract;
import dartagnan.program.utils.EventRepository;
import dartagnan.wmm.utils.Tuple;
import dartagnan.wmm.utils.TupleSet;

public class RelSetIdentity extends BasicRelation {

    protected FilterAbstract filter;

    public static String makeTerm(FilterAbstract filter){
        return "[" + filter + "]";
    }

    public RelSetIdentity(FilterAbstract filter) {
        this.filter = filter;
        term = makeTerm(filter);
    }

    public RelSetIdentity(FilterAbstract filter, String name) {
        super(name);
        this.filter = filter;
        term = makeTerm(filter);
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet();
            for(Event e1 : program.getEventRepository().getEvents(EventRepository.ALL)){
                if(filter.filter(e1)){
                    maxTupleSet.add(new Tuple(e1, e1));
                }
            }
        }
        return maxTupleSet;
    }
}
