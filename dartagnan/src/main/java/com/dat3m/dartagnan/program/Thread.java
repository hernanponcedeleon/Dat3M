package com.dat3m.dartagnan.program;

import com.dat3m.dartagnan.program.event.CondJump;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.If;
import com.dat3m.dartagnan.program.utils.preprocessing.BranchReordering;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.program.utils.ThreadCache;
import com.dat3m.dartagnan.program.utils.preprocessing.DeadCodeElimination;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

import java.util.*;

public class Thread {

	private final String name;
    private final int id;
    private final Event entry;
    private Event exit;

    private final Map<String, Register> registers;
    private ThreadCache cache;

    public Thread(String name, int id, Event entry){
        if(id < 0){
            throw new IllegalArgumentException("Invalid thread ID");
        }
        if(entry == null){
            throw new IllegalArgumentException("Thread entry event must be not null");
        }
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

    public int getId(){
        return id;
    }

    public ThreadCache getCache(){
        if(cache == null){
            cache = new ThreadCache(entry.getSuccessors());
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
            throw new RuntimeException("Register " + id + ":" + name + " already exists");
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
        if (this == obj)
            return true;

        if (obj == null || getClass() != obj.getClass())
            return false;

        return id == ((Thread) obj).id;
    }

    public void simplify() {
        entry.simplify(null);
        cache = null;
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    public int unroll(int bound, int nextId){
    	while(bound > 0) {
    		entry.unroll(bound, null);
    		bound--;
    	}
        nextId = entry.setUId(nextId);
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
    	BoolExpr enc = ctx.mkTrue();
    	Stack<If> ifStack = new Stack<>();
    	BoolExpr guard = ctx.mkTrue();
    	for(Event e : entry.getSuccessors()) {
    		if(!ifStack.isEmpty()) {
        		If lastIf = ifStack.peek();
        		if(e.equals(lastIf.getMainBranchEvents().get(0))) {
        			guard = ctx.mkAnd(lastIf.cf(), lastIf.getGuard().toZ3Bool(lastIf, ctx));
        		}
        		if(e.equals(lastIf.getElseBranchEvents().get(0))) {
        			guard = ctx.mkAnd(lastIf.cf(), ctx.mkNot(lastIf.getGuard().toZ3Bool(lastIf, ctx)));
        		}
        		if(e.equals(lastIf.getSuccessor())) {
        			guard = ctx.mkOr(lastIf.getExitMainBranch().getCfCond(), lastIf.getExitElseBranch().getCfCond());
        			ifStack.pop();
        		}    			
    		}
    		enc = ctx.mkAnd(enc, e.encodeCF(ctx, guard));
    		guard = e.cf();
    		if(e instanceof CondJump) {
    			guard = ctx.mkAnd(guard, ctx.mkNot(((CondJump)e).getGuard().toZ3Bool(e, ctx)));
    		}
    		if(e instanceof If) {
    			ifStack.add((If)e);
    		}
    	}
        return enc;
    }


    // -----------------------------------------------------------------------------------------------------------------
    // -------------------------------- Preprocessing -----------------------------------
    // -----------------------------------------------------------------------------------------------------------------

    public int eliminateDeadCode(int startId) {
        new DeadCodeElimination(this).apply(startId);
        clearCache();
        return getExit().getOId() + 1;
    }
    
    public void reorderBranches() {
        new BranchReordering(this).apply();
    }

}
