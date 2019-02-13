package com.dat3m.dartagnan.wmm.relation.basic;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.MemEvent;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;

import java.util.List;

public class RelAddrDirect extends BasicRegRelation {

    public RelAddrDirect(){
        term = "addrDirect";
        forceDoEncode = true;
        isStatic = true;
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet();
            for(Thread t : program.getThreads()){
                List<Event> events = t.getEventRepository().getEvents(FilterBasic.get(EType.ANY));
                List<Event> regReaders = t.getEventRepository().getEvents(FilterBasic.get(EType.MEMORY));
                for(Event e1 : events){
                    if(e1 instanceof RegWriter){
                        for(Event e2 : regReaders){
                            for(Register register : ((MemEvent)e2).getAddress().getRegs()){
                                if(e1.getEId() < e2.getEId() && register == ((RegWriter)e1).getResultRegister()){
                                    maxTupleSet.add(new Tuple(e1, e2));
                                }
                            }
                        }
                    }
                }
            }
        }
        return maxTupleSet;
    }
}
