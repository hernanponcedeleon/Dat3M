package dartagnan.program.utils;

import dartagnan.program.Program;
import dartagnan.program.Thread;
import dartagnan.program.event.*;
import dartagnan.program.event.rmw.RMWStore;

import java.util.*;
import java.util.stream.Collectors;

public class EventRepository {

    public static final int EVENT_ALL           = 0;
    public static final int EVENT_INIT          = 1;
    public static final int EVENT_LOAD          = 2;
    public static final int EVENT_LOCAL         = 4;
    public static final int EVENT_MEMORY        = 8;
    public static final int EVENT_FENCE         = 16;
    public static final int EVENT_SKIP          = 32;
    public static final int EVENT_STORE         = 64;
    public static final int EVENT_RMW_STORE     = 128;
    public static final int EVENT_IF            = 256;

    private Map<Integer, Set<Event>> sets = new HashMap<>();
    private Program program;

    public EventRepository(Program program){
        this.program = program;
    }

    public Set<Event> getEvents(int mask){
        if(!sets.containsKey(mask)){
            if(mask == EVENT_ALL){
                Set<Event> events = new HashSet<>();
                for(Thread t : program.getThreads()){
                    events.addAll(t.getEvents());
                }
                sets.put(EVENT_ALL, events);
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
                || ((mask & EVENT_LOAD) > 0 && event instanceof Load)
                || ((mask & EVENT_LOCAL) > 0 && event instanceof Local)
                || ((mask & EVENT_MEMORY) > 0 && event instanceof MemEvent)
                || ((mask & EVENT_FENCE) > 0 && event instanceof Fence)
                || ((mask & EVENT_SKIP) > 0 && event instanceof Skip)
                || ((mask & EVENT_STORE) > 0 && event instanceof Store)
                || ((mask & EVENT_RMW_STORE) > 0 && event instanceof RMWStore)
                || ((mask & EVENT_IF) > 0 && event instanceof If);
    }
}
