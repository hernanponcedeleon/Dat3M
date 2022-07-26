package com.dat3m.dartagnan.wmm.relation.base.local;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.analysis.Dependency;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.ExecutionStatus;
import com.dat3m.dartagnan.wmm.relation.base.stat.StaticRelation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.SolverContext;

import static com.dat3m.dartagnan.configuration.Arch.RISCV;

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
            for(Register register : getRegisters(regReader)) {
            	// Register x0 is hardwired to the constant 0 in RISCV
            	// https://en.wikichip.org/wiki/risc-v/registers
            	// and thus it generates no dependency, see
            	// https://github.com/herd/herdtools7/issues/408
            	if(task.getProgram().getArch().equals(RISCV) && register.getName().equals("x0")) {
            		continue;
            	}
                Dependency.State r = dep.of(regReader, register);
                for(Event regWriter : r.may) {
                    maxTupleSet.add(new Tuple(regWriter, regReader));
                    if(regWriter instanceof ExecutionStatus && ((ExecutionStatus)regWriter).getTrackDep()) {
                    	maxTupleSet.add(new Tuple(((ExecutionStatus)regWriter).getStatusEvent(), regWriter));
                    }
                }
                for(Event regWriter : r.must) {
                    minTupleSet.add(new Tuple(regWriter, regReader));
                }
            }
        }
    }

    @Override
    public BooleanFormula getSMTVar(Tuple t, SolverContext ctx) {
        return minTupleSet.contains(t) ? 
        		getExecPair(t, ctx) :
        		maxTupleSet.contains(t) ?
        				task.getProgramEncoder().dependencyEdge(t.getFirst(), t.getSecond(), ctx) :
        				ctx.getFormulaManager().getBooleanFormulaManager().makeFalse();
    }

    @Override
    protected BooleanFormula encodeApprox(SolverContext ctx) {
        return ctx.getFormulaManager().getBooleanFormulaManager().makeTrue();
    }
}