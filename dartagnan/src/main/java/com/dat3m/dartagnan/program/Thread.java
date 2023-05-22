package com.dat3m.dartagnan.program;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.expression.type.Type;
import com.google.common.base.Preconditions;

import java.util.*;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.program.event.Tag.NOOPT;

public class Thread {

    private final Program program; // The program this thread belongs to
	private String name;
    private final int id;
    private final Event entry;
    private Event exit;
    private final Map<String, Register> registers;
    private int dummyCount = 0;

    Thread(Program program, String name, int id, Event entry){
    	Preconditions.checkArgument(id >= 0, "Invalid thread ID");
    	Preconditions.checkNotNull(entry, "Thread entry event must be not null");
        entry.setThread(this);
        this.program = program;
        this.name = name;
        this.id = id;
        this.entry = entry;
        this.exit = this.entry;
        this.registers = new HashMap<>();
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

    public String getEndLabelName() {
        return "END_OF_T" + id;
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

    /**
     * Lists all registers of this thread.
     * @return
     * Read-only container of all currently defined registers of this thread.
     */
    public Collection<Register> getRegisters() {
        return registers.values();
    }

    public Optional<Register> getRegister(String name){
        return Optional.ofNullable(registers.get(name));
    }

    public Register newRegister(Type type) {
        return newRegister("DUMMY_REG_" + dummyCount++, type);
    }

    public Register newRegister(String name, Type type) {
        if(registers.containsKey(name)){
            throw new MalformedProgramException("Register " + id + ":" + name + " already exists");
        }
        Register register = new Register(name, id, type);
        registers.put(register.getName(), register);
        return register;
    }

    public Register getOrNewRegister(String name, Type type) {
        return registers.computeIfAbsent(name, k -> new Register(k, id, type));
    }

    public Event getEntry(){
        return entry;
    }

    public Event getExit(){
        return exit;
    }

    public void append(Event event) {
        if (program.getFormat().equals(Program.SourceLanguage.LITMUS)) {
            event.addTags(NOOPT);
        }
        exit.setSuccessor(event);
        event.setThread(this);
        updateExit(event);
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
}
