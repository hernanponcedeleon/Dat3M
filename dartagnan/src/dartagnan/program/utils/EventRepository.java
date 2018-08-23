package dartagnan.program.utils;

import dartagnan.program.Thread;
import dartagnan.program.event.*;
import dartagnan.program.event.linux.rcu.*;
import dartagnan.program.event.linux.rmw.RMWAbstract;
import dartagnan.program.event.rmw.RMWStore;
import dartagnan.program.event.rmw.Xchg;

import java.util.*;
import java.util.stream.Collectors;

public class EventRepository {

    public static final int EVENT_ALL           = 0;
    public static final int EVENT_INIT          = 1;
    public static final int EVENT_LOAD          = 2;
    public static final int EVENT_LOCAL         = 4;
    public static final int EVENT_FENCE         = 8;
    public static final int EVENT_SKIP          = 16;
    public static final int EVENT_STORE         = 32;
    public static final int EVENT_RMW_STORE     = 64;
    public static final int EVENT_IF            = 128;
    public static final int EVENT_RCU_LOCK      = 256;
    public static final int EVENT_RCU_UNLOCK    = 512;
    public static final int EVENT_RCU_SYNC      = 1024;

    public static final int EVENT_MEMORY = EVENT_INIT | EVENT_LOAD | EVENT_STORE;
    public static final int EVENT_RCU = EVENT_RCU_LOCK | EVENT_RCU_UNLOCK | EVENT_RCU_SYNC;
    public static final int EVENT_VISIBLE = EVENT_MEMORY | EVENT_FENCE | EVENT_RCU;

    private Map<Integer, Set<Event>> sets = new HashMap<>();
    private Thread thread;

    public EventRepository(Thread thread){
        this.thread = thread;
    }

    public Set<Event> getEvents(int mask){
        if(!sets.containsKey(mask)){
            if(mask == EVENT_ALL){
                sets.put(EVENT_ALL, thread.getEvents());
            } else {
                sets.put(mask, getEvents(EVENT_ALL).stream().filter(e -> is(e, mask)).collect(Collectors.toSet()));
            }
        }
        return sets.get(mask);
    }

    public void clear(){
        sets.clear();
    }

    private boolean is(Event event, int mask){
        return ((mask & EVENT_INIT) > 0 && event instanceof Init)
                || ((mask & EVENT_LOAD) > 0 && (event instanceof Load || event instanceof Read || event instanceof RMWAbstract || event instanceof Xchg))
                || ((mask & EVENT_LOCAL) > 0 && event instanceof Local)
                || ((mask & EVENT_FENCE) > 0 && event instanceof Fence)
                || ((mask & EVENT_SKIP) > 0 && event instanceof Skip)
                || ((mask & EVENT_STORE) > 0 && (event instanceof Store || event instanceof Write || event instanceof RMWAbstract || event instanceof Xchg))
                || ((mask & EVENT_RMW_STORE) > 0 && event instanceof RMWStore)
                || ((mask & EVENT_IF) > 0 && event instanceof If)
                || ((mask & EVENT_RCU_LOCK) > 0 && event instanceof RCUReadLock)
                || ((mask & EVENT_RCU_UNLOCK) > 0 && event instanceof RCUReadUnlock)
                || ((mask & EVENT_RCU_SYNC) > 0 && event instanceof RCUSync);
    }
}
