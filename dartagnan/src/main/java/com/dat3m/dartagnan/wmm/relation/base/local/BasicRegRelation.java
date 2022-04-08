package com.dat3m.dartagnan.wmm.relation.base.local;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.analysis.Dependency;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.wmm.relation.base.stat.StaticRelation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.Collection;

abstract class BasicRegRelation extends StaticRelation {

    abstract Collection<Register> getRegisters(Event regReader);

    protected abstract Collection<Event> getEvents();

    @Override
    public TupleSet getMinTupleSet() {
        if(minTupleSet == null){
            mkTupleSets();
        }
        return minTupleSet;
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            mkTupleSets();
        }
        return maxTupleSet;
    }

    private void mkTupleSets() {
        maxTupleSet = new TupleSet();
        minTupleSet = new TupleSet();
        Dependency dep = analysisContext.requires(Dependency.class);
        for(Event regReader : getEvents()){
            for(Register register : getRegisters(regReader)){
                for(Event regWriter : dep.may(regReader, register)) {
                    maxTupleSet.add(new Tuple(regWriter, regReader));
                }
                for(Event regWriter : dep.must(regReader, register)) {
                    minTupleSet.add(new Tuple(regWriter, regReader));
                }
            }
        }
    }

    @Override
    public BooleanFormula getSMTVar(Tuple t, SolverContext ctx) {
        return minTupleSet.contains(t) ? getExecPair(t, ctx)
        : maxTupleSet.contains(t) ? analysisContext.get(Dependency.class).getSMTVar(t.getFirst(), t.getSecond(), ctx)
        : ctx.getFormulaManager().getBooleanFormulaManager().makeFalse();
    }

    @Override
    protected BooleanFormula encodeApprox(SolverContext ctx) {
        return ctx.getFormulaManager().getBooleanFormulaManager().makeTrue();
    }
}