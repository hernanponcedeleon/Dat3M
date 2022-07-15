package com.dat3m.dartagnan.wmm.relation.base.local;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.analysis.Dependency;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.wmm.relation.base.stat.StaticRelation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.Collection;

import static com.dat3m.dartagnan.encoding.ProgramEncoder.execution;

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
                Dependency.State r = dep.of(regReader, register);
                for(Event regWriter : r.may) {
                    maxTupleSet.add(new Tuple(regWriter, regReader));
                }
                for(Event regWriter : r.must) {
                    minTupleSet.add(new Tuple(regWriter, regReader));
                }
            }
        }
    }

    @Override
    public BooleanFormula getSMTVar(Tuple t, SolverContext ctx) {
        ExecutionAnalysis exec = analysisContext.requires(ExecutionAnalysis.class);
        return minTupleSet.contains(t) ?
                execution(t.getFirst(), t.getSecond(), exec, ctx) :
        		maxTupleSet.contains(t) ?
        				task.getProgramEncoder().dependencyEdge(t.getFirst(), t.getSecond()) :
        				ctx.getFormulaManager().getBooleanFormulaManager().makeFalse();
    }

    @Override
    protected BooleanFormula encodeApprox(SolverContext ctx) {
        return ctx.getFormulaManager().getBooleanFormulaManager().makeTrue();
    }
}