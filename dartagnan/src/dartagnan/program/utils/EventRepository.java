package dartagnan.program.utils;

import dartagnan.expression.IExpr;
import dartagnan.program.Register;
import dartagnan.program.Thread;
import dartagnan.program.event.*;
import dartagnan.program.event.linux.rcu.RCUReadLock;
import dartagnan.program.event.linux.rcu.RCUReadUnlock;
import dartagnan.program.event.linux.rcu.RCUSync;
import dartagnan.program.event.linux.rmw.RMWAbstract;
import dartagnan.program.event.pts.Read;
import dartagnan.program.event.pts.Write;
import dartagnan.program.event.rmw.RMWStore;
import dartagnan.program.event.tso.Xchg;
import dartagnan.program.event.utils.RegReaderData;
import dartagnan.program.event.utils.RegWriter;

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

    private Map<Integer, Set<Event>> sets = new HashMap<>();
    private Set<Register> registers;
    private Thread thread;

    public EventRepository(Thread thread){
        this.thread = thread;
    }

    public Set<Event> getEvents(int mask){
        if(!sets.containsKey(mask)){
            if(mask == EMPTY){
                sets.put(mask, new HashSet<>());
            } else if(mask == ALL){
                sets.put(ALL, thread.getEvents());
            } else {
                sets.put(mask, getEvents(ALL).stream().filter(e -> is(e, mask)).collect(Collectors.toSet()));
            }
        }
        return sets.get(mask);
    }

    public List<Event> getSortedList(int mask){
        return this.getEvents(mask).stream().sorted().collect(Collectors.toList());
    }

    public void clear(){
        registers = null;
        sets.clear();
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
