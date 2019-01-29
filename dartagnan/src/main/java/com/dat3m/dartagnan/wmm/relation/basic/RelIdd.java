package com.dat3m.dartagnan.wmm.relation.basic;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.program.utils.EventRepository;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;

import java.util.Set;
import java.util.stream.Collectors;

public class RelIdd extends BasicRegRelation {

    public RelIdd(){
        term = "idd";
        forceDoEncode = true;
        isStatic = true;
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet();
            for(Thread t : program.getThreads()){
                Set<Event> events = t.getEventRepository().getEvents(EventRepository.ALL);
                Set<Event> regWriters = events.stream().filter(e -> e instanceof RegWriter).collect(Collectors.toSet());
                Set<Event> regReaders = events.stream().filter(e -> e instanceof RegReaderData).collect(Collectors.toSet());
                for(Event e1 : regWriters){
                    for(Event e2 : regReaders){
                        if(e1.getEId() < e2.getEId() && ((RegReaderData)e2).getDataRegs().contains(((RegWriter)e1).getResultRegister())){
                            maxTupleSet.add(new Tuple(e1, e2));
                        }
                    }
                }
            }
        }
        return maxTupleSet;
    }
}
