package com.dat3m.dartagnan.program;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.program.event.CondJump;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.program.utils.ThreadCache;
import com.dat3m.dartagnan.program.utils.preprocessing.BranchReordering;
import com.dat3m.dartagnan.program.utils.preprocessing.DeadCodeElimination;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.google.common.base.Preconditions;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Thread {

	private String name;
    private final int id;
    private final Event entry;
    private Event exit;

    private final Map<String, Register> registers;
    private ThreadCache cache;

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

    public void simplify() {
        entry.simplify(null);
        cache = null;
    }

    public int setFId(int nextId) {
        nextId = entry.setFId(0);
        cache = null;
        return nextId;
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
        Preconditions.checkNotNull(target, "Target cannot be null.");
        nextId = entry.compile(target, nextId, null);
        updateExit(entry);
        cache = null;
        return nextId;
    }

    // Encoding
    // -----------------------------------------------------------------------------------------------------------------

    public BooleanFormula encodeCF(SolverContext ctx){
    	BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
		BooleanFormula enc = bmgr.makeTrue();
    	BooleanFormula guard = bmgr.makeTrue();
    	for(Event e : entry.getSuccessors()) {
    		enc = bmgr.and(enc, e.encodeCF(ctx, guard));
    		guard = e.cf();
    		if(e instanceof CondJump) {
    			guard = bmgr.and(guard, bmgr.not(((CondJump)e).getGuard().toBoolFormula(e, ctx)));
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
