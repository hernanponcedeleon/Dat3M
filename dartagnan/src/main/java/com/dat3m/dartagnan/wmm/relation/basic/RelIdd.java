package com.dat3m.dartagnan.wmm.relation.basic;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import com.microsoft.z3.BoolExpr;

import java.util.*;

public class RelIdd extends BasicRegRelation {

    public RelIdd(){
        term = "idd";
        forceDoEncode = true;
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            mkMaxTupleSet(program.getCache().getEvents(FilterBasic.get(EType.REG_READER)));
        }
        return maxTupleSet;
    }

    @Override
    protected BoolExpr encodeApprox() {
        return doEncodeApprox(program.getCache().getEvents(FilterBasic.get(EType.REG_READER)));
    }

    @Override
    Collection<Register> getRegisters(Event regReader){
        return ((RegReaderData) regReader).getDataRegs();
    }
}
