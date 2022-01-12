package com.dat3m.dartagnan.wmm.relation.base.local;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.MemEvent;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.Collection;

import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.ADDRDIRECT;

public class RelAddrDirect extends BasicRegRelation {

    public RelAddrDirect(){
        term = ADDRDIRECT;
        forceDoEncode = true;
    }

    @Override
    public TupleSet getMinTupleSet() {
        if(minTupleSet == null){
            mkTupleSets(task.getProgram().getCache().getEvents(FilterBasic.get(Tag.MEMORY)));
        }
        return minTupleSet;
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            mkTupleSets(task.getProgram().getCache().getEvents(FilterBasic.get(Tag.MEMORY)));
        }
        return maxTupleSet;
    }

    @Override
    protected BooleanFormula encodeApprox(SolverContext ctx) {
        return doEncodeApprox(task.getProgram().getCache().getEvents(FilterBasic.get(Tag.MEMORY)), ctx);
    }

    @Override
    Collection<Register> getRegisters(Event regReader){
        return ((MemEvent) regReader).getAddress().getRegs();
    }
}
