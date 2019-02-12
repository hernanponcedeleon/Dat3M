package com.dat3m.dartagnan.program.utils;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.*;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableSet;

import java.util.*;

public class EventRepository {

    private Map<String, ImmutableList<Event>> events = new HashMap<>();
    private ImmutableSet<Register> registers;

    public EventRepository(Thread thread){
        List<Event> allEvents = thread.getEvents();
        allEvents.sort(Comparator.comparing(Event::getEId));
        events.put(EType.ANY, ImmutableList.copyOf(allEvents));
    }

    public ImmutableList<Event> getEvents(String type){
        if(!events.containsKey(type)){
            ImmutableList.Builder<Event> builder = new ImmutableList.Builder<>();

            // TODO: Composite filter
            if(type.equals(EType.MEMORY)){
                for(Event e : getEvents(EType.ANY)){
                    if(e.is(EType.WRITE) || e.is(EType.READ)){
                        builder.add(e);
                    }
                }

                // TODO: Composite filter
            } else if(type.equals(EType.VISIBLE)){
                for(Event e : getEvents(EType.ANY)){
                    if(e.is(EType.WRITE) || e.is(EType.READ) || e.is(EType.FENCE)
                            || e.is(com.dat3m.dartagnan.program.arch.linux.utils.EType.RCU_LOCK)
                            || e.is(com.dat3m.dartagnan.program.arch.linux.utils.EType.RCU_UNLOCK)
                            || e.is(com.dat3m.dartagnan.program.arch.linux.utils.EType.RCU_SYNC)
                    ){
                        builder.add(e);
                    }
                }

            } else {
                for(Event e : getEvents(EType.ANY)){
                    if(e.is(type)){
                        builder.add(e);
                    }
                }
            }
            events.put(type, builder.build());
        }
        return events.get(type);
    }

    public Set<Register> getRegisters(){
        if(registers == null){
            ImmutableSet.Builder<Register> builder = new ImmutableSet.Builder<>();
            for(Event e : getEvents(EType.ANY)){
                if(e instanceof RegWriter){
                    builder.add(((RegWriter) e).getResultRegister());
                }
                if(e instanceof MemEvent){
                    IExpr address = ((MemEvent) e).getAddress();
                    builder.addAll(address.getRegs());
                }
                if(e instanceof RegReaderData){
                    builder.addAll(((RegReaderData) e).getDataRegs());
                }
            }
            registers = builder.build();
        }
        return registers;
    }
}
