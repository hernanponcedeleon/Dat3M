package com.dat3m.dartagnan.program;

import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Local;
import com.dat3m.dartagnan.program.utils.ThreadCache;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

import java.util.*;

public class Thread {

    private final int id;
    private Event entry;
    private Event exit;

    private Map<String, Register> registers;
    private Set<Register> initializedRegisters = new HashSet<Register>();
    private ThreadCache cache;

    public Thread(int id, Event entry){
        if(id < 0){
            throw new IllegalArgumentException("Invalid thread ID");
        }
        if(entry == null){
            throw new IllegalArgumentException("Thread entry event must be not null");
        }
        this.id = id;
        this.entry = entry;
        this.exit = this.entry;
        this.registers = new HashMap<>();
    }

    public int getId(){
        return id;
    }

    public ThreadCache getCache(){
        if(cache == null){
            List<Event> events = new ArrayList<>(entry.getSuccessors());
            cache = new ThreadCache(events);
        }
        return cache;
    }

    public Register getRegister(String name){
        return registers.get(name);
    }

    public Register addRegister(String name){
        if(registers.containsKey(name)){
            throw new RuntimeException("Register " + id + ":" + name + " already exists");
        }
        cache = null;
        Register register = new Register(name, id);
        registers.put(register.getName(), register);
        return register;
    }

    public Register addRegisterInitializedToOne(String name){
    	Register register = addRegister(name);
    	initializedRegisters.add(register);
        return register;
    }

    public void initializeRegisters() {
    	for(Register register : initializedRegisters) {
    		Event newEntry = new Local(register, new IConst(1)); 
    		newEntry.setSuccessor(entry);
    		this.entry = newEntry;
    	}
    }
    
    public Event getEntry(){
        return entry;
    }

    public Event getExit(){
        return exit;
    }

    public void append(Event event){
        exit.setSuccessor(event);
        updateExit(event);
        cache = null;
    }

    private void updateExit(Event event){
        exit = event;
        Event next = exit.getSuccessor();
        while(next != null){
            exit = next;
            next = next.getSuccessor();
        }
    }

    @Override
    public int hashCode() {
        return id;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;

        if (obj == null || getClass() != obj.getClass())
            return false;

        return id == ((Thread) obj).id;
    }


    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    public int unroll(int bound, int nextId){
        nextId = entry.unroll(bound, nextId, null);
        updateExit(entry);
        cache = null;
        return nextId;
    }


    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

    public int compile(Arch target, int nextId) {
        nextId = entry.compile(target, nextId, null);
        updateExit(entry);
        cache = null;
        return nextId;
    }


    // Encoding
    // -----------------------------------------------------------------------------------------------------------------

    public BoolExpr encodeCF(Context ctx){
        return entry.encodeCF(ctx, ctx.mkTrue());
    }
}
