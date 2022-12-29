package com.dat3m.dartagnan.wmm.relation.base.stat;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;

import java.util.List;

import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.EXT;

public class RelExt extends StaticRelation {

    public RelExt(){
        term = EXT;
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitExternal(this);
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet();
            List<Thread> threads = task.getProgram().getThreads();

            for (int i = 0; i < threads.size(); i++) {
                Thread t1 = threads.get(i);
                for (int j = i + 1; j < threads.size(); j++) {
                    Thread t2 = threads.get(j);
                    for(Event e1 : t1.getCache().getEvents(FilterBasic.get(Tag.VISIBLE))){
                        for(Event e2 : t2.getCache().getEvents(FilterBasic.get(Tag.VISIBLE))){
                            maxTupleSet.add(new Tuple(e1, e2));
                            maxTupleSet.add(new Tuple(e2, e1));
                        }
                    }
                }
            }
        }
        return maxTupleSet;
    }
}
