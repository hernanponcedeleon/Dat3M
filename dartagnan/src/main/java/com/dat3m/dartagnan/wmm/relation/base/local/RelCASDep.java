package com.dat3m.dartagnan.wmm.relation.base.local;

import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.relation.base.stat.StaticRelation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;

import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.CASDEP;

public class RelCASDep extends StaticRelation {

    public RelCASDep(){
        term = CASDEP;
    }

    @Override
    public void initializeRelationAnalysis(RelationAnalysis.Buffer a) {
        TupleSet maxTupleSet = new TupleSet();
        for(Event e : a.task().getProgram().getCache().getEvents(FilterBasic.get(Tag.IMM.CASDEPORIGIN))){
            // The target of a CASDep is always the successor of the origin
            maxTupleSet.add(new Tuple(e, e.getSuccessor()));
        }
        a.send(this, maxTupleSet, maxTupleSet);
    }
}