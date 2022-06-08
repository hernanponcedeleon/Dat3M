package com.dat3m.dartagnan.wmm.relation.base.stat;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;

import java.util.List;

import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.INT;

public class RelInt extends StaticRelation {

    public RelInt(){
        term = INT;
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet();
            ExecutionAnalysis exec = analysisContext.get(ExecutionAnalysis.class);
            for(Thread t : task.getProgram().getThreads()) {
                List<Event> events = t.getCache().getEvents(FilterBasic.get(Tag.VISIBLE));
                for (Event e1 : events) {
                    for (Event e2 : events) {
                        if(!exec.areMutuallyExclusive(e1, e2)) {
                            maxTupleSet.add(new Tuple(e1, e2));
                        }
                    }
                }
            }
        }
        return maxTupleSet;
    }
}
