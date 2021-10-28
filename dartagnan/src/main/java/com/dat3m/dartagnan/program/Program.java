package com.dat3m.dartagnan.program;


import com.dat3m.dartagnan.asserts.AbstractAssert;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.memory.Location;
import com.dat3m.dartagnan.program.memory.Memory;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.program.utils.ThreadCache;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.google.common.collect.ImmutableSet;

import java.util.ArrayList;
import java.util.List;


public class Program {

    private String name;
	private AbstractAssert ass;
    private AbstractAssert assFilter;
	private final List<Thread> threads;
	private final ImmutableSet<Location> locations;
	private final Memory memory;
	private Arch arch;
    private ThreadCache cache;
    private boolean isUnrolled;
    private boolean isCompiled;

    public Program(Memory memory, ImmutableSet<Location> locations){
        this("", memory, locations);
    }

	public Program (String name, Memory memory, ImmutableSet<Location> locations) {
		this.name = name;
		this.memory = memory;
		this.locations = locations;
		this.threads = new ArrayList<>();
	}


	public boolean isCompiled(){
        return isCompiled;
    }

    public boolean isUnrolled(){
        return isUnrolled;
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

    public ThreadCache getCache(){
        if(cache == null){
            cache = new ThreadCache(getEvents());
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

    public ImmutableSet<Location> getLocations(){
        return locations;
    }

	public List<Event> getEvents(){
        // TODO: Why don't we use the cache if available?
        List<Event> events = new ArrayList<>();
		for(Thread t : threads){
			events.addAll(t.getCache().getEvents(FilterBasic.get(EType.ANY)));
		}
		return events;
	}

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    public boolean markAsUnrolled() {
        if (isUnrolled) {
            return false;
        }
        isUnrolled = true;
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