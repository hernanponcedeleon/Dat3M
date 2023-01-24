package com.dat3m.dartagnan.program;


import com.dat3m.dartagnan.asserts.AbstractAssert;
import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.memory.Memory;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class Program {

    private String name;
	private AbstractAssert ass;
    private AbstractAssert assFilter;
	private final List<Thread> threads;
	private final Memory memory;
	private Arch arch;
    private int unrollingBound = 0;
    private boolean isCompiled;
    private SourceLanguage format;
    private final List<Event> eventCache = new ArrayList<>();

    public Program(Memory memory, SourceLanguage format){
        this("", memory, format);
    }

	public Program (String name, Memory memory, SourceLanguage format) {
		this.name = name;
		this.memory = memory;
		this.threads = new ArrayList<>();
		this.format = format;
	}

	public SourceLanguage getFormat(){
        return format;
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

    /**
     * Recomputes the {@code thread}-and-{@code successor}-ordered list of events in this program.
     * Called after a manipulation on this program has finished.
     * This method is not thread-safe.
     * @param clearThreadCaches Also calls {@link Thread#clearCache()} for all threads.
     * @see #getEvents()
     */
    public void clearCache(boolean clearThreadCaches) {
        if (clearThreadCaches) {
            for (Thread t : threads) {
                t.clearCache();
            }
        }
        eventCache.clear();
    }

    public List<Thread> getThreads() {
        return threads;
    }

    /**
     * Iterates all events in this program.
     *
     * @return {@code thread}-and-{@code successor}-ordered complete sequence of all events in this program.
     */
	public List<Event> getEvents() {
        updateCache();
		return List.copyOf(eventCache);
	}

    /**
     * Iterates a subset of events in this program.
     *
     * @param cls Class of events to be selected.
     * @return {@code thread}-and-{@code successor}-ordered complete sequence of all events of class {@code cls} in this program.
     * @param <T> Desired subclass of {@link Event}.
     */
    public <T extends Event> List<T> getEvents(Class<T> cls) {
        updateCache();
        return eventCache.stream().filter(cls::isInstance).map(cls::cast).collect(Collectors.toList());
    }

    private void updateCache() {
        if (eventCache.isEmpty()) {
            for (Thread t : threads) {
                t.updateCache();
                eventCache.addAll(t.eventCache);
            }
        }
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

    public enum SourceLanguage {LITMUS, BOOGIE;}
}