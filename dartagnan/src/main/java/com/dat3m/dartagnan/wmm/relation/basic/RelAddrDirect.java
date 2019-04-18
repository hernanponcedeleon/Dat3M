package com.dat3m.dartagnan.wmm.relation.basic;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.MemEvent;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import com.microsoft.z3.BoolExpr;

import java.util.*;

public class RelAddrDirect extends BasicRegRelation {

    public RelAddrDirect(){
        term = "addrDirect";
        forceDoEncode = true;
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            mkMaxTupleSet(program.getCache().getEvents(FilterBasic.get(EType.MEMORY)));
        }
        return maxTupleSet;
    }

    @Override
    protected BoolExpr encodeApprox() {
        return doEncodeApprox(program.getCache().getEvents(FilterBasic.get(EType.MEMORY)));
    }

    @Override
    Collection<Register> getRegisters(Event regReader){
        return ((MemEvent) regReader).getAddress().getRegs();
    }
}
