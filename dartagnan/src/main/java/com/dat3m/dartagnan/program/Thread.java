package com.dat3m.dartagnan.program;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.program.utils.EventCache;
import com.google.common.base.Preconditions;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Thread {

	private String name;
    private final int id;
    private final Event entry;
    private Event exit;

    private final Map<String, Register> registers;
    private EventCache cache;

    public Thread(String name, int id, Event entry){
    	Preconditions.checkArgument(id >= 0, "Invalid thread ID");
    	Preconditions.checkNotNull(entry, "Thread entry event must be not null");
        entry.setThread(this);
        this.name = name;
        this.id = id;
        this.entry = entry;
        this.exit = this.entry;
        this.registers = new HashMap<>();
    }

    public Thread(int id, Event entry){
    	this(String.valueOf(id), id, entry);
    }

    public String getName(){
        return name;
    }

    public void setName(String name){
        this.name = name;
    }

    public int getId(){
        return id;
    }

    public EventCache getCache(){
        if(cache == null){
            cache = new EventCache(entry.getSuccessors());
        }
        return cache;
    }

    public List<Event> getEvents() {
        return getCache().getEvents(FilterBasic.get(EType.ANY));
    }

    public void clearCache(){
        cache = null;
    }

    public Register getRegister(String name){
        return registers.get(name);
    }

    public Register addRegister(String name, int precision){
        if(registers.containsKey(name)){
            throw new MalformedProgramException("Register " + id + ":" + name + " already exists");
        }
        cache = null;
        Register register = new Register(name, id, precision);
        registers.put(register.getName(), register);
        return register;
    }

    public Event getEntry(){
        return entry;
    }

    public Event getExit(){
        return exit;
    }

    public void append(Event event){
        exit.setSuccessor(event);
        event.setThread(this);
        updateExit(event);
        cache = null;
    }

    public void updateExit(Event event){
        exit = event;
        Event next = exit.getSuccessor();
        while(next != null){
            exit = next;
            exit.setThread(this);
            next = next.getSuccessor();
        }
    }

    @Override
    public int hashCode() {
        return id;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        } else if (obj == null || getClass() != obj.getClass()) {
            return false;
        }

        return id == ((Thread) obj).id;
    }
}
