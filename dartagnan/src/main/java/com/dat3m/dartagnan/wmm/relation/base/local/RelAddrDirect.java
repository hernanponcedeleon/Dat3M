package com.dat3m.dartagnan.wmm.relation.base.local;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.MemEvent;
import com.dat3m.dartagnan.program.filter.FilterBasic;

import java.util.Collection;

import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.ADDRDIRECT;

public class RelAddrDirect extends BasicRegRelation {

    public RelAddrDirect(){
        term = ADDRDIRECT;
    }

    @Override
    protected Collection<Event> getEvents() {
        return task.getProgram().getCache().getEvents(FilterBasic.get(Tag.MEMORY));
    }

    @Override
    Collection<Register> getRegisters(Event regReader){
        return ((MemEvent) regReader).getAddress().getRegs();
    }
}
