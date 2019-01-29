package com.dat3m.dartagnan.parsers.utils;

import com.google.common.collect.ImmutableSet;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Local;
import com.dat3m.dartagnan.program.event.MemEvent;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.program.memory.Address;
import com.dat3m.dartagnan.program.memory.Memory;
import com.dat3m.dartagnan.program.utils.EventRepository;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AliasAnalysis {

    public void calculateLocationSets(Program program, Memory memory){
        ImmutableSet<Address> maxAddressSet = memory.getAllAddresses();
        Map<Register, List<Event>> regWrites = new HashMap<>();

        for(Event e : program.getEventRepository().getEvents(EventRepository.ALL)){
            if(e instanceof RegWriter){
                Register register = ((RegWriter)e).getResultRegister();
                regWrites.putIfAbsent(register, new ArrayList<>());
                regWrites.get(register).add(e);
            }
        }

        for(Event e : program.getEventRepository().getEvents(EventRepository.MEMORY)){
            IExpr address = ((MemEvent) e).getAddress();
            if(address instanceof Register){
                if(!regWrites.containsKey(address)){
                    throw new RuntimeException("Address register " + address + " has not been initialised");
                }
                List<Event> events = regWrites.get(address);
                if(events.size() == 1){
                    Event regWrite = events.get(0);
                    if(regWrite instanceof Local){
                        ExprInterface expr = ((Local)regWrite).getExpr();
                        if(expr instanceof Address){
                            ((MemEvent) e).setMaxAddressSet(ImmutableSet.of((Address) expr));
                            continue;
                        }
                    }
                }
                ((MemEvent) e).setMaxAddressSet(maxAddressSet);
            } else if (address instanceof Address){
                ((MemEvent) e).setMaxAddressSet(ImmutableSet.of((Address) address));
            } else {
                ((MemEvent) e).setMaxAddressSet(maxAddressSet);
            }
        }
    }
}
