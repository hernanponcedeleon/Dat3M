package com.dat3m.dartagnan.wmm.relation.base.stat;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.filter.FilterAbstract;
import com.dat3m.dartagnan.program.filter.FilterBasic;
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
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitProgramOrder(this, filter);
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet();
            for(Thread t : task.getProgram().getThreads()){
                List<Event> events = t.getCache().getEvents(filter);
                for (int i = 0; i < events.size(); i++) {
                    Event e1 = events.get(i);
                    for (int j = i + 1; j < events.size(); j++) {
                        Event e2 = events.get(j);
                        maxTupleSet.add(new Tuple(e1, e2));
                    }
                }
            }
            removeMutuallyExclusiveTuples(maxTupleSet);
        }
        return maxTupleSet;
    }
}
