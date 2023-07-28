package com.dat3m.dartagnan.program;


import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.expression.INonDet;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.memory.Memory;
import com.dat3m.dartagnan.program.specification.AbstractAssert;
import com.google.common.base.Preconditions;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

public class Program {

    public enum SourceLanguage {LITMUS, BOOGIE;}

    private String name;
    private AbstractAssert spec;
    private AbstractAssert filterSpec; // Acts like "assume" statements, filtering out executions
    private final List<Thread> threads;
    private final List<Function> functions;
    private final List<INonDet> constants = new ArrayList<>();
    private final Memory memory;
    private Arch arch;
    private int unrollingBound = 0;
    private boolean isCompiled;
    private final SourceLanguage format;

    public Program(Memory memory, SourceLanguage format) {
        this("", memory, format);
    }

    public Program(String name, Memory memory, SourceLanguage format) {
        this.name = name;
        this.memory = memory;
        this.threads = new ArrayList<>();
        this.functions = new ArrayList<>();
        this.format = format;
    }

    public SourceLanguage getFormat() {
        return format;
    }

    public boolean isCompiled() {
        return isCompiled;
    }

    public boolean isUnrolled() {
        return unrollingBound > 0;
    }

    public int getUnrollingBound() {
        return unrollingBound;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setArch(Arch arch) {
        this.arch = arch;
    }

    public Arch getArch() {
        return arch;
    }

    public Memory getMemory() {
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

    public void addThread(Thread t) {
        threads.add(t);
        t.setProgram(this);
    }

    public void addFunction(Function func) {
        Preconditions.checkArgument(!(func instanceof Thread), "Use addThread to add threads to the program");
        functions.add(func);
        func.setProgram(this);
    }

    public List<Thread> getThreads() {
        return threads;
    }

    public List<Function> getFunctions() { return functions; }

    public void addConstant(INonDet constant) {
        constants.add(constant);
    }

    public Collection<INonDet> getConstants() {
        return Collections.unmodifiableCollection(constants);
    }

    public List<Event> getThreadEvents() {
        Preconditions.checkState(!threads.isEmpty(), "The program has no threads yet.");
        List<Event> events = new ArrayList<>();
        for (Function func : threads) {
            events.addAll(func.getEvents());
        }
        return events;
    }

    public <T extends Event> List<T> getThreadEvents(Class<T> cls) {
        return getThreadEvents().stream().filter(cls::isInstance).map(cls::cast).collect(Collectors.toList());
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