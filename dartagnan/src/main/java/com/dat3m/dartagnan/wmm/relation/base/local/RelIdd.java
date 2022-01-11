package com.dat3m.dartagnan.wmm.relation.base.local;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.utils.RegReaderData;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.Collection;

import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.IDD;

public class RelIdd extends BasicRegRelation {

    public RelIdd(){
        term = IDD;
        forceDoEncode = true;
    }

    @Override
    public TupleSet getMinTupleSet() {
        if(minTupleSet == null){
            mkTupleSets(task.getProgram().getCache().getEvents(FilterBasic.get(EType.REG_READER)));
        }
        return minTupleSet;
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            mkTupleSets(task.getProgram().getCache().getEvents(FilterBasic.get(EType.REG_READER)));
        }
        return maxTupleSet;
    }

    @Override
    protected BooleanFormula encodeApprox(SolverContext ctx) {
        return doEncodeApprox(task.getProgram().getCache().getEvents(FilterBasic.get(EType.REG_READER)), ctx);
    }

    @Override
    Collection<Register> getRegisters(Event regReader){
        return ((RegReaderData) regReader).getDataRegs();
    }
}
