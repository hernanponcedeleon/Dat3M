package com.dat3m.dartagnan.program;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.Type;
import com.dat3m.dartagnan.program.event.core.Event;
import com.google.common.base.Preconditions;

import java.util.*;
import java.util.stream.Collectors;

public class Function {

    protected String name;
    protected Event entry; // Can be null for intrinsics
    protected int id;
    protected Event exit;

    protected FunctionType functionType;
    protected List<Register> parameterRegs;

    protected Program program;
    protected Map<String, Register> registers = new HashMap<>();
    protected int dummyCount = 0;

    public Function(String name, FunctionType type, List<String> parameterNames, int id, Event entry) {
        Preconditions.checkArgument(type.getParameterTypes().size() == parameterNames.size());
        this.name = name;
        this.functionType = type;
        this.id = id;
        this.entry = entry;

        parameterRegs = new ArrayList<>(parameterNames.size());
        int paramIndex = 0;
        for (Type paramType : functionType.getParameterTypes()) {
            //TODO: avoid cast to IntegerType
            final Register paramReg = newRegister(parameterNames.get(paramIndex), (IntegerType) paramType);
            parameterRegs.add(paramReg);
        }

        updateExit(entry);
    }

    public String getName() { return this.name; }
    public void setName(String name) { this.name = name; }
    public FunctionType getFunctionType() { return this.functionType; }
    public int getId() { return id; }
    public Program getProgram() { return this.program; }
    public void setProgram(Program program) { this.program = program; }

    public Event getEntry() { return entry; }

    public Event getExit() { return exit; }

    public List<Event> getEvents() {
        return entry.getSuccessors();
    }

    public <T extends Event> List<T> getEvents(Class<T> cls) {
        return getEvents().stream().filter(cls::isInstance).map(cls::cast).collect(Collectors.toList());
    }

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
            final String error = String.format("Register %s already exists in function %s", name, this);
            throw new MalformedProgramException(error);
        }
        Register register = new Register(name, id, type);
        registers.put(name, register);
        return register;
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
    public String toString() {
        return id + ":" + getName();
    }
}
