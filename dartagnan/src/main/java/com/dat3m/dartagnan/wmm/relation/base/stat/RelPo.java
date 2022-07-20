package com.dat3m.dartagnan.wmm.relation.base.stat;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.filter.FilterAbstract;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;

import java.util.List;

import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.PO;
import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.POWITHLOCALEVENTS;

public class RelPo extends StaticRelation {

    private final FilterAbstract filter;

    public RelPo(){
        this(false);
    }

    public RelPo(boolean includeLocalEvents){
        if(includeLocalEvents){
            term = POWITHLOCALEVENTS;
            filter = FilterBasic.get(Tag.ANY);
        } else {
            term = PO;
            filter = FilterBasic.get(Tag.VISIBLE);
        }
    }

    @Override
    public void initializeRelationAnalysis(RelationAnalysis.Buffer a) {
        TupleSet maxTupleSet = new TupleSet();
        ExecutionAnalysis exec = a.analysisContext().get(ExecutionAnalysis.class);
        for(Thread t : a.task().getProgram().getThreads()) {
            List<Event> events = t.getCache().getEvents(filter);
            for(int i = 0; i < events.size(); i++) {
                Event e1 = events.get(i);
                for(Event e2 : events.subList(i + 1, events.size())) {
                    if(!exec.areMutuallyExclusive(e1, e2)) {
                        maxTupleSet.add(new Tuple(e1, e2));
                    }
                }
            }
        }
        a.send(this, maxTupleSet, maxTupleSet);
    }
}
