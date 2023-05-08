package com.dat3m.dartagnan.program;


import com.dat3m.dartagnan.expression.INonDet;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.specification.AbstractAssert;
import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.memory.Memory;
import com.google.common.base.Preconditions;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

public class Program {

    public enum SourceLanguage { LITMUS, BOOGIE; }

    private String name;
    private AbstractAssert spec;
    private AbstractAssert filterSpec; // Acts like "assume" statements, filtering out executions
    private final List<Thread> threads;
    private final Memory memory;
    private final Collection<INonDet> constants = new ArrayList<>();
    private Arch arch;
    private int unrollingBound = 0;
    private boolean isCompiled;
    private SourceLanguage format;

    public Program(SourceLanguage format) {
        this("", new Memory(), format);
    }

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

    public INonDet newConstant(int precision, boolean signed, BigInteger min, BigInteger max) {
        int id = constants.size();
        INonDet constant = new INonDet(id, precision, signed, min, max);
        constants.add(constant);
        return constant;
    }

    public Memory getMemory(){
        return this.memory;
    }

    public AbstractAssert getSpecification() {
        return spec;
    }
    public void setSpecification(AbstractAssert spec) {
        this.spec = spec;
    }

    public AbstractAssert getFilterSpecification() {
        return filterSpec;
    }
    public void setFilterSpecification(AbstractAssert spec) {
        Preconditions.checkArgument(spec == null || AbstractAssert.ASSERT_TYPE_FORALL.equals(spec.getType()));
        this.filterSpec = spec;
    }

    public Thread newThread(String name) {
        return newThread(name, EventFactory.newSkip());
    }

    public Thread newThread(String name, Event entry) {
        //TODO assert unique name
        int id = threads.size();
        Thread thread = new Thread(this, name, id, entry);
        threads.add(thread);
        return thread;
    }

    public Optional<Thread> getThread(String name) {
        return threads.stream().filter(thread -> thread.getName().equals(name)).findAny();
    }

    public Thread getOrNewThread(String name) {
        Optional<Thread> fetched = getThread(name);
        return fetched.orElseGet(() -> newThread(name));
    }

    public List<Thread> getThreads() {
        return threads;
    }

    /**
     * Iterates all events in this program.
     *
     * @return {@code globalId}-ordered complete sequence of all events in this program.
     */
    public List<Event> getEvents() {
        List<Event> events = new ArrayList<>();
        for (Thread t : threads) {
            events.addAll(t.getEvents());
        }
        return events;
    }

    /**
     * Iterates a subset of events in this program.
     *
     * @param cls Class of events to be selected.
     * @return {@code globalId}-ordered complete sequence of all events of class {@code cls} in this program.
     * @param <T> Desired subclass of {@link Event}.
     */
    public <T extends Event> List<T> getEvents(Class<T> cls) {
        return getEvents().stream().filter(cls::isInstance).map(cls::cast).collect(Collectors.toList());
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