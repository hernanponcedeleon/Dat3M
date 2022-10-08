package com.dat3m.dartagnan.wmm.relation.base.stat;

import com.dat3m.dartagnan.wmm.relation.RelationNameRepository;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.SolverContext;

public class RelEmpty extends StaticRelation {

    public RelEmpty() {
        term = RelationNameRepository.EMPTY;
    }

    public RelEmpty(String name) {
        super(name);
        term = name;
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitEmpty(this);
    }

    @Override
    public TupleSet getMinTupleSet(){
        if(minTupleSet == null){
            minTupleSet = new TupleSet();
        }
        return minTupleSet;
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet();
        }
        return maxTupleSet;
    }
}
