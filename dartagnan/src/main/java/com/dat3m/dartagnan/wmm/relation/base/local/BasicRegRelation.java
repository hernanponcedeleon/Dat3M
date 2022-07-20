package com.dat3m.dartagnan.wmm.relation.base.local;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.analysis.Dependency;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.relation.base.stat.StaticRelation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;

import java.util.Collection;

abstract class BasicRegRelation extends StaticRelation {

    abstract Collection<Register> getRegisters(Event regReader);

    protected abstract Collection<Event> getEvents(Program program);

    @Override
    public void initializeRelationAnalysis(RelationAnalysis.Buffer a) {
        TupleSet maxTupleSet = new TupleSet();
        TupleSet minTupleSet = new TupleSet();
        Dependency dep = a.analysisContext().requires(Dependency.class);
        for(Event regReader : getEvents(a.task().getProgram())){
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
        a.send(this, maxTupleSet, minTupleSet);
    }
}