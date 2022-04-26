package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.filter.FilterAbstract;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.google.common.collect.ImmutableList;

import java.util.*;

public class EventCache {

    private final Map<FilterAbstract, ImmutableList<Event>> events = new HashMap<>();

    public EventCache(List<Event> events){
        this.events.put(FilterBasic.get(Tag.ANY), ImmutableList.copyOf(events));
    }

    public ImmutableList<Event> getEvents(FilterAbstract filter){
        if(!events.containsKey(filter)){
            ImmutableList.Builder<Event> builder = new ImmutableList.Builder<>();
            for(Event e : getEvents(FilterBasic.get(Tag.ANY))){
                if(filter.filter(e)){
                    builder.add(e);
                }
            }
            events.put(filter, builder.build());
        }
        return events.get(filter);
    }
}