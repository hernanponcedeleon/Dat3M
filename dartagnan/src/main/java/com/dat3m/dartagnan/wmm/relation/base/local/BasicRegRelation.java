package com.dat3m.dartagnan.wmm.relation.base.local;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.analysis.Dependency;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.ExecutionStatus;
import com.dat3m.dartagnan.wmm.relation.base.stat.StaticRelation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import org.sosy_lab.java_smt.api.BooleanFormula;

import java.util.Collection;
import java.util.HashSet;
import java.util.Set;

import static com.dat3m.dartagnan.configuration.Arch.RISCV;

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
        // We need to track ExecutionStatus events separately, because they induce data-dependencies
        // without reading from a register.
        Set<ExecutionStatus> execStatusRegWriter = new HashSet<>();
        for(Event regReader : getEvents()){
            for(Register register : getRegisters(regReader)) {
            	// Register x0 is hardwired to the constant 0 in RISCV
            	// https://en.wikichip.org/wiki/risc-v/registers,
            	// and thus it generates no dependency, see
            	// https://github.com/herd/herdtools7/issues/408
            	if(task.getProgram().getArch().equals(RISCV) && register.getName().equals("x0")) {
            		continue;
            	}
                Dependency.State r = dep.of(regReader, register);
                for(Event regWriter : r.may) {
                    maxTupleSet.add(new Tuple(regWriter, regReader));
                    if (regWriter instanceof ExecutionStatus) {
                        execStatusRegWriter.add((ExecutionStatus) regWriter);
                    }
                }
                for(Event regWriter : r.must) {
                    minTupleSet.add(new Tuple(regWriter, regReader));
                }
            }
        }

        for (ExecutionStatus execStatus : execStatusRegWriter) {
            if (execStatus.doesTrackDep()) {
                Tuple t = new Tuple(execStatus.getStatusEvent(), execStatus);
                minTupleSet.add(t);
                maxTupleSet.add(t);
            }
        }
    }

    @Override
    public BooleanFormula getSMTVar(Tuple t, EncodingContext context) {
        return context.dependency(t.getFirst(), t.getSecond());
    }
}