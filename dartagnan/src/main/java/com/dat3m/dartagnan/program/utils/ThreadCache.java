package com.dat3m.dartagnan.program.utils;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.*;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.wmm.filter.FilterAbstract;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableSet;

import java.util.*;

public class ThreadCache {

    private Map<FilterAbstract, ImmutableList<Event>> events = new HashMap<>();
    private ImmutableSet<Register> registers;

    public ThreadCache(List<Event> events){
        this.events.put(FilterBasic.get(EType.ANY), ImmutableList.copyOf(events));
    }

    public ImmutableList<Event> getEvents(FilterAbstract filter){
        if(!events.containsKey(filter)){
            ImmutableList.Builder<Event> builder = new ImmutableList.Builder<>();
            for(Event e : getEvents(FilterBasic.get(EType.ANY))){
                if(filter.filter(e)){
                    builder.add(e);
                }
            }
            events.put(filter, builder.build());
        }
        return events.get(filter);
    }

    public ImmutableSet<Register> getRegisters(){
        if(registers == null){
            ImmutableSet.Builder<Register> builder = new ImmutableSet.Builder<>();
            for(Event e : getEvents(FilterBasic.get(EType.ANY))){
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
