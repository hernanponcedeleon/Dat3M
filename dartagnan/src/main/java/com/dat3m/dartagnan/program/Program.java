package com.dat3m.dartagnan.program;


import com.dat3m.dartagnan.asserts.AbstractAssert;
import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.program.event.EventCache;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.dat3m.dartagnan.program.memory.Memory;

import java.util.ArrayList;
import java.util.List;

public class Program {

    private String name;
	private AbstractAssert ass;
    private AbstractAssert assFilter;
	private final List<Thread> threads;
	private final Memory memory;
	private Arch arch;
    private EventCache cache;
    private int unrollingBound = 0;
    private boolean isCompiled;

    public Program(Memory memory){
        this("", memory);
    }

	public Program (String name, Memory memory) {
		this.name = name;
		this.memory = memory;
		this.threads = new ArrayList<>();
	}

	public boolean isCompiled(){
        return isCompiled;
    }

    public boolean isUnrolled(){
        return unrollingBound > 0;
    }

    public int getUnrollingBound(){
        return unrollingBound;
    }

	public String getName(){
        return name;
    }

	public void setName(String name){
	    this.name = name;
    }

	public void setArch(Arch arch){
	    this.arch = arch;
    }

	public Arch getArch(){
	    return arch;
    }

    public Memory getMemory(){
        return this.memory;
    }

    public AbstractAssert getAss() {
        return ass;
    }

    public void setAss(AbstractAssert ass) {
        this.ass = ass;
    }

    public AbstractAssert getAssFilter() {
        return assFilter;
    }

    public void setAssFilter(AbstractAssert ass) {
        this.assFilter = ass;
    }

    public void add(Thread t) {
		threads.add(t);
	}

    public EventCache getCache(){
        if(cache == null){
            cache = new EventCache(getEvents());
        }
        return cache;
    }

    public void clearCache(boolean clearThreadCaches){
        if (clearThreadCaches) {
            for (Thread t : threads) {
                t.clearCache();
            }
        }
    	cache = null;
    }

    public List<Thread> getThreads() {
        return threads;
    }

	public List<Event> getEvents(){
        // TODO: Why don't we use the cache if available?
        List<Event> events = new ArrayList<>();
		for(Thread t : threads){
			events.addAll(t.getCache().getEvents(FilterBasic.get(Tag.ANY)));
		}
		return events;
	}

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    public boolean markAsUnrolled(int bound) {
        if (unrollingBound > 0) {
            return false;
        }
        unrollingBound = bound;
        return true;
    }

    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

    public boolean markAsCompiled() {
        if (isCompiled) {
            return false;
        }
        isCompiled = true;
        return true;
    }
}