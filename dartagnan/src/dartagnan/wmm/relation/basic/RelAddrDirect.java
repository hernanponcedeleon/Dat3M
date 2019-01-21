package dartagnan.wmm.relation.basic;

import dartagnan.program.Register;
import dartagnan.program.Thread;
import dartagnan.program.event.Event;
import dartagnan.program.event.MemEvent;
import dartagnan.program.event.utils.RegWriter;
import dartagnan.program.utils.EventRepository;
import dartagnan.wmm.utils.Tuple;
import dartagnan.wmm.utils.TupleSet;

import java.util.Set;
import java.util.stream.Collectors;

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
                Set<Event> events = t.getEventRepository().getEvents(EventRepository.ALL);
                Set<Event> regWriters = events.stream().filter(e -> e instanceof RegWriter).collect(Collectors.toSet());
                Set<Event> regReaders = t.getEventRepository().getEvents(EventRepository.MEMORY);
                for(Event e1 : regWriters){
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
        return maxTupleSet;
    }
}
