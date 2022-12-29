package com.dat3m.dartagnan.wmm.relation.base.memory;

import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.MemEvent;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;

import java.util.Collection;

import static com.dat3m.dartagnan.program.event.Tag.MEMORY;
import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.LOC;

public class RelLoc extends Relation {

    public RelLoc(){
        term = LOC;
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitSameAddress(this);
    }

    @Override
    public TupleSet getMinTupleSet(){
        if(minTupleSet == null){
            AliasAnalysis alias = analysisContext.get(AliasAnalysis.class);
            minTupleSet = new TupleSet();
            for (Tuple t : getMaxTupleSet()) {
                if (alias.mustAlias((MemEvent) t.getFirst(), (MemEvent) t.getSecond())) {
                    minTupleSet.add(t);
                }
            }
        }
        return minTupleSet;
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            AliasAnalysis alias = analysisContext.get(AliasAnalysis.class);
            maxTupleSet = new TupleSet();
            Collection<Event> events = task.getProgram().getCache().getEvents(FilterBasic.get(MEMORY));
            for(Event e1 : events){
                for(Event e2 : events){
                    if(alias.mayAlias((MemEvent) e1, (MemEvent)e2)){
                        maxTupleSet.add(new Tuple(e1, e2));
                    }
                }
            }
            removeMutuallyExclusiveTuples(maxTupleSet);
        }
        return maxTupleSet;
    }
}
