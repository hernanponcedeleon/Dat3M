package com.dat3m.dartagnan.program;

import com.dat3m.dartagnan.program.event.BoundEvent;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Jump;
import com.dat3m.dartagnan.program.event.Label;
import com.dat3m.dartagnan.program.utils.ThreadCache;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

import java.util.*;

public class Thread {

    private final int id;
    private final Event entry;
    private Event exit;

    private Map<String, Register> registers;
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

    public void clearCache(){
        cache = null;
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

	public void reduce() {
		Event current = entry;
		while(current != null) {
			Event next = current.getSuccessor();
			if(next == null) {
				break;
			}
			Event next2 = next.getSuccessor();
			if(next2 == null) {
				break;
			}
			Event next3 = next2.getSuccessor();

			// If the loop is empty, we remove it and the next two events which we added just to handle loop unrolling (which does not exists anymore)
			if(current instanceof Label && next instanceof Jump && ((Jump)next).getLabel().equals(current)) {
				if(next2 instanceof BoundEvent && next3 instanceof Jump) {
					current.setSuccessor(next3.getSuccessor());
				}
			}
			
			// We remove trivial jumps
			if(next instanceof Jump && next2.equals(((Jump)next).getLabel())) {
				// If nobody else refers to the label, we can also remove the label
				if(((Label)next2).getReferences().size() == 1) {
					current.setSuccessor(next2.getSuccessor());
				} else {
					current.setSuccessor(next2);
				}
			}
			current = current.getSuccessor();
		}
		cache = null;
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
