package com.dat3m.dartagnan.wmm.relation.base.stat;

import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.SolverContext;

import com.dat3m.dartagnan.wmm.utils.TupleSet;

public class RelEmpty extends StaticRelation {

    public RelEmpty(String name) {
        super(name);
        term = name;
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet();
        }
        return maxTupleSet;
    }

    @Override
    protected BooleanFormula encodeApprox(SolverContext ctx) {
        return ctx.getFormulaManager().getBooleanFormulaManager().makeTrue();
    }
}
