package com.dat3m.dartagnan.program;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.IntLiteral;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.expression.type.Type;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.expression.type.VoidType;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.processing.Intrinsics;
import com.google.common.base.Preconditions;

import java.util.*;
import java.util.stream.Collectors;

public class Function implements Expression {

    protected String name;
    protected Event entry; // Can be null for intrinsics
    protected int id;
    protected Event exit;

    protected FunctionType functionType;
    protected List<Register> parameterRegs;

    protected Intrinsics.Info intrinsicInfo;

    protected Program program;
    protected Map<String, Register> registers = new HashMap<>();
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

    @Override
    public Type getType() {
        return TypeFactory.getInstance().getArchType();
    }

    public String getName() { return this.name; }
    public void setName(String name) { this.name = name; }

    public FunctionType getFunctionType() { return this.functionType; }
    public List<Register> getParameterRegisters() {
        return Collections.unmodifiableList(parameterRegs);
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public Program getProgram() { return this.program; }
    public void setProgram(Program program) { this.program = program; }

    public boolean hasBody() { return entry != null; }
    public boolean hasReturnValue() { return !(functionType.getReturnType() instanceof VoidType); }

    public boolean isIntrinsic() { return !hasBody() && intrinsicInfo != null; }
    public Intrinsics.Info getIntrinsicInfo() { return intrinsicInfo; }
    public void setIntrinsicInfo(Intrinsics.Info info) { this.intrinsicInfo = info; }

    public Event getEntry() { return entry; }
    public Event getExit() { return exit; }

    public List<Event> getEvents() {
        return entry == null ? List.of() : entry.getSuccessors();
    }

    public <T extends Event> List<T> getEvents(Class<T> cls) {
        return getEvents().stream().filter(cls::isInstance).map(cls::cast).collect(Collectors.toList());
    }

    public List<Event> getEventsWithAllTags(String... tags) {
        final List<String> tagList = Arrays.asList(tags);
        return getEvents().stream().filter(e -> e.getTags().containsAll(tagList)).collect(Collectors.toList());
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
        Register register = new Register(name, this, type);
        registers.put(name, register);
        return register;
    }

    public Register getOrNewRegister(String name, Type type) {
        final Register found = registers.get(name);
        if (found == null) {
            return newRegister(name, type);
        }
        Preconditions.checkState(found.getType().equals(type),
                "Register type mismatch: Got %s, expected %s.", found.getType(), type);
        return found;
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

    public void validate() {
        final var labelNames = new HashSet<String>();
        for (Event ev : getEvents()) {
            if (ev.getFunction() != this) {
                final String error = String.format("Event %s belongs to function %s but was found in function %s",
                        ev, ev.getFunction(), this);
                throw new MalformedProgramException(error);
            }
            if (ev instanceof CondJump jump) {
                if (this != jump.getLabel().getFunction()) {
                    final String error = String.format("Jump %s targets label %s of a different function",
                            jump, jump.getLabel());
                    throw new MalformedProgramException(error);
                }
            }
            if (ev instanceof Label label) {
                if (!labelNames.add(label.getName())) {
                    final String error = String.format("Multiple labels with name %s in function %s",
                            label.getName(), this);
                    throw new MalformedProgramException(error);
                }
            }
        }
    }

    @Override
    public String toString() {
        final String prefix = getFunctionType().getReturnType() + " " + getName() + "(";
        final String suffix = getFunctionType().isVarArgs() ? ", ...)" : ")";
        return parameterRegs.stream().map(r -> r.getType() + " " + r.getName())
                .collect(Collectors.joining(", ", prefix, suffix));
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public IntLiteral reduce() {
        throw new UnsupportedOperationException("Cannot reduce functions");
    }

    // TODO: Ugly function, but we need it for now to create copies of functions.
    public void copyDummyCountFrom(Function func) {
        this.dummyCount = func.dummyCount;
    }
}
