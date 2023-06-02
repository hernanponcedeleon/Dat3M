package com.dat3m.dartagnan.program;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.event.core.AbstractEvent;
import com.google.common.base.Preconditions;

import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class Thread {

    private static final TypeFactory types = TypeFactory.getInstance();
    private String name;
    private final int id;
    private final AbstractEvent entry;
    private AbstractEvent exit;
    
	protected Program program; // The program this thread belongs to

    private final Map<String, Register> registers;
    private int dummyCount = 0;

    public Thread(String name, int id, AbstractEvent entry){
    	Preconditions.checkArgument(id >= 0, "Invalid thread ID");
    	Preconditions.checkNotNull(entry, "Thread entry event must be not null");
        entry.setThread(this);
        this.name = name;
        this.id = id;
        this.entry = entry;
        this.exit = this.entry;
        this.registers = new HashMap<>();
    }

    public Thread(int id, AbstractEvent entry){
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

    public List<AbstractEvent> getEvents() {
        return entry.getSuccessors();
    }

    public <T extends AbstractEvent> List<T> getEvents(Class<T> cls) {
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

    @Deprecated
    public Register newRegister(int precision) {
        return newRegister(precision < 0 ? types.getIntegerType() : types.getIntegerType(precision));
    }

    public Register newRegister(IntegerType type) {
        return newRegister("DUMMY_REG_" + dummyCount++, type);
    }

    @Deprecated
    public Register newRegister(String name, int precision) {
        IntegerType type = precision < 0 ? types.getIntegerType() : types.getIntegerType(precision);
        return newRegister(name, type);
    }

    public Register newRegister(String name, IntegerType type) {
        if (registers.containsKey(name)) {
            throw new MalformedProgramException("Register " + id + ":" + name + " already exists");
        }
        Register register = new Register(name, id, type);
        registers.put(name, register);
        return register;
    }

    public AbstractEvent getEntry(){
        return entry;
    }

    public AbstractEvent getExit(){
        return exit;
    }

    public void append(AbstractEvent event){
        exit.setSuccessor(event);
        event.setThread(this);
        updateExit(event);
    }

    public void updateExit(AbstractEvent event){
        exit = event;
        AbstractEvent next = exit.getSuccessor();
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
