package com.dat3m.dartagnan.program;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.program.event.core.Event;
import com.google.common.base.Preconditions;

import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class Thread {

    private String name;
    private final int id;
    private final Event entry;
    private Event exit;
    
	protected Program program; // The program this thread belongs to

    private final Map<String, Register> registers;
    private int dummyCount = 0;

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

    public List<Event> getEvents() {
        return entry.getSuccessors();
    }

    public <T extends Event> List<T> getEvents(Class<T> cls) {
        return getEvents().stream().filter(cls::isInstance).map(cls::cast).collect(Collectors.toList());
    }

	public Program getProgram() {
		return program;
	}

	public void setProgram(Program program) {
		Preconditions.checkNotNull(program);
		this.program = program;
	}

    /**
     * Lists all registers of this thread.
     * @return
     * Read-only container of all currently defined registers of this thread.
     */
    public Collection<Register> getRegisters() {
        return registers.values();
    }

    public Register getRegister(String name){
        return registers.get(name);
    }

    public Register newRegister(IntegerType type) {
        return newRegister("DUMMY_REG_" + dummyCount++, type);
    }

    public Register newRegister(String name, IntegerType type) {
        if (registers.containsKey(name)) {
            throw new MalformedProgramException("Register " + id + ":" + name + " already exists");
        }
        Register register = new Register(name, id, type);
        registers.put(name, register);
        return register;
    }

    public Event getEntry(){
        return entry;
    }

    public Event getExit(){
        return exit;
    }

    public void append(Event event){
        exit.insertAfter(event);
    }

    public void updateExit(Event event){
        exit = event;
        Event next;
        while((next = exit.getSuccessor()) != null){
            exit = next;
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

    @Override
    public String toString() {
        return String.format("T%d:%s", id, name);
    }
}
