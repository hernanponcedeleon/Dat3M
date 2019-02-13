package com.dat3m.dartagnan.program.utils;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.*;
import com.dat3m.dartagnan.program.arch.linux.event.rcu.RCUReadLock;
import com.dat3m.dartagnan.program.arch.linux.event.rcu.RCUReadUnlock;
import com.dat3m.dartagnan.program.arch.linux.event.rcu.RCUSync;
import com.dat3m.dartagnan.program.arch.linux.event.rmw.RMWAbstract;
import com.dat3m.dartagnan.program.arch.pts.event.Read;
import com.dat3m.dartagnan.program.arch.pts.event.Write;
import com.dat3m.dartagnan.program.event.rmw.RMWStore;
import com.dat3m.dartagnan.program.arch.tso.event.Xchg;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.utils.RegWriter;

import java.util.*;
import java.util.stream.Collectors;

public class EventRepository {

    public static final int ALL           = -1;
    public static final int EMPTY         = 0;
    public static final int INIT          = 1;
    public static final int LOAD          = 2;
    public static final int LOCAL         = 4;
    public static final int FENCE         = 8;
    public static final int SKIP          = 16;
    public static final int STORE         = 32;
    public static final int RMW_STORE     = 64;
    public static final int IF            = 128;
    public static final int RCU_LOCK      = 256;
    public static final int RCU_UNLOCK    = 512;
    public static final int RCU_SYNC      = 1024;

    public static final int MEMORY = INIT | LOAD | STORE;
    public static final int RCU = RCU_LOCK | RCU_UNLOCK | RCU_SYNC;
    public static final int VISIBLE = MEMORY | FENCE | RCU;

    private Map<Integer, List<Event>> events = new HashMap<>();
    private Set<Register> registers;
    private Thread thread;

    public EventRepository(Thread thread){
        this.thread = thread;
    }

    public List<Event> getEvents(int mask){
        if(!events.containsKey(mask)){
            if(mask == EMPTY){
                events.put(mask, new ArrayList<>());
            } else if(mask == ALL){
                events.put(ALL, thread.getEvents());
            } else {
                events.put(mask, getEvents(ALL).stream().filter(e -> is(e, mask)).collect(Collectors.toList()));
            }
        }
        return events.get(mask);
    }

    public List<Event> getSortedList(int mask){
        return this.getEvents(mask).stream().sorted().collect(Collectors.toList());
    }

    public void clear(){
        registers = null;
        events.clear();
    }

    private boolean is(Event event, int mask){
        return ((mask & INIT) > 0 && event instanceof Init)
                || ((mask & LOAD) > 0 && (event instanceof Load || event instanceof Read || event instanceof RMWAbstract || event instanceof Xchg))
                || ((mask & LOCAL) > 0 && event instanceof Local)
                || ((mask & FENCE) > 0 && event instanceof Fence)
                || ((mask & SKIP) > 0 && event instanceof Skip)
                || ((mask & STORE) > 0 && (event instanceof Store || event instanceof Write || event instanceof RMWAbstract || event instanceof Xchg))
                || ((mask & RMW_STORE) > 0 && event instanceof RMWStore)
                || ((mask & IF) > 0 && event instanceof If)
                || ((mask & RCU_LOCK) > 0 && event instanceof RCUReadLock)
                || ((mask & RCU_UNLOCK) > 0 && event instanceof RCUReadUnlock)
                || ((mask & RCU_SYNC) > 0 && event instanceof RCUSync);
    }

    public Set<Register> getRegisters(){
        if(registers == null){
            registers = new HashSet<>();
            for(Event e : getEvents(ALL)){
                if(e instanceof RegWriter){
                    registers.add(((RegWriter) e).getResultRegister());
                }
                if(e instanceof MemEvent){
                    IExpr address = ((MemEvent) e).getAddress();
                    if(address instanceof Register){
                        registers.add((Register) address);
                    }
                }
                if(e instanceof RegReaderData){
                    registers.addAll(((RegReaderData) e).getDataRegs());
                }
            }
        }
        return registers;
    }
}
