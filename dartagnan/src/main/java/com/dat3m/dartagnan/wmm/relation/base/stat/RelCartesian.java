package com.dat3m.dartagnan.wmm.relation.base.stat;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.equivalence.BranchEquivalence;
import com.dat3m.dartagnan.wmm.filter.FilterAbstract;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;

import java.util.List;

public class RelCartesian extends StaticRelation {
    private final FilterAbstract filter1;
    private final FilterAbstract filter2;

    public FilterAbstract getFirstFilter() {
    	return filter1;
    }
    
    public FilterAbstract getSecondFilter() {
    	return filter2;
    }

    public static String makeTerm(FilterAbstract filter1, FilterAbstract filter2){
        return "(" + filter1 + "*" + filter2 + ")";
    }

    public RelCartesian(FilterAbstract filter1, FilterAbstract filter2) {
        this.filter1 = filter1;
        this.filter2 = filter2;
        this.term = makeTerm(filter1, filter2);
    }

    public RelCartesian(FilterAbstract filter1, FilterAbstract filter2, String name) {
        super(name);
        this.filter1 = filter1;
        this.filter2 = filter2;
        this.term = makeTerm(filter1, filter2);
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet();
            List<Event> l1 = task.getProgram().getCache().getEvents(filter1);
            List<Event> l2 = task.getProgram().getCache().getEvents(filter2);
            BranchEquivalence eq = task.getBranchEquivalence();
            for(Event e1 : l1){
                for(Event e2 : l2){
                    if (!eq.areMutuallyExclusive(e1, e2)) {
                        maxTupleSet.add(new Tuple(e1, e2));
                    }
                }
            }
        }
        return maxTupleSet;
    }
}
