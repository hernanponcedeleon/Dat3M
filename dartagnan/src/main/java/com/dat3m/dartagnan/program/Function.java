package com.dat3m.dartagnan.program;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.expression.type.Type;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.utils.SymbolTable;
import com.google.common.base.Preconditions;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;

public class Function {

    protected String name;
    protected Event entry; // Can be null for intrinsics
    protected int id;
    protected Event exit;

    protected FunctionType functionType;
    protected List<Register> parameterRegs;

    protected Program program;
    protected SymbolTable<Register> registers = new SymbolTable<>();
    protected int dummyCount = 0;

    public Function(String name, FunctionType type, List<String> parameterNames, int id, Event entry) {
        Preconditions.checkArgument(type.getParameterTypes().size() == parameterNames.size());
        Preconditions.checkArgument(entry == null || entry.getPredecessor() == null,
                "The entry event of a function is not allowed to have predecessors.");
        this.name = name;
        this.functionType = type;
        this.id = id;
        this.entry = entry;

        parameterRegs = new ArrayList<>(parameterNames.size());
        int paramIndex = 0;
        for (Type paramType : functionType.getParameterTypes()) {
            final Register paramReg = newRegister(parameterNames.get(paramIndex++), paramType);
            parameterRegs.add(paramReg);
        }

        Event cur = entry;
        while (cur != null) {
            cur.setFunction(this);
            exit = cur;
            cur = cur.getSuccessor();
        }
    }

    public String getName() { return this.name; }
    public void setName(String name) { this.name = name; }
    public FunctionType getFunctionType() { return this.functionType; }
    public int getId() { return id; }
    public Program getProgram() { return this.program; }
    public void setProgram(Program program) { this.program = program; }

    public boolean isIntrinsic() { return entry == null; }

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

    public Register newRegister(Type type) {
        return newRegister("DUMMY_REG_" + dummyCount++, type);
    }

    public Register newRegister(String name, Type type) {
        if (registers.containsKey(name)) {
            final String error = String.format("Register %s already exists in function %s", name, this);
            throw new MalformedProgramException(error);
        }
        Register register = new Register(name, id, type);
        registers.put(name, register);
        return register;
    }

    public void append(Event event){
        if (entry == null) {
            entry = exit = event;
            event.setFunction(this);
            event.setSuccessor(null);
            event.setPredecessor(null);
        } else {
            exit.insertAfter(event);
        }
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
        final String prefix = getFunctionType().getReturnType() + " " + getName() + "(";
        final String suffix = ")";
        return parameterRegs.stream().map(r -> r.getType() + " " + r.getName())
                .collect(Collectors.joining(", ", prefix, suffix));

    }
}