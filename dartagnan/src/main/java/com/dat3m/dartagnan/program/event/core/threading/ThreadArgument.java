package com.dat3m.dartagnan.program.event.core.threading;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.*;
import com.google.common.base.Preconditions;
import org.sosy_lab.java_smt.api.BooleanFormula;

import java.util.Map;
import java.util.Set;

public class ThreadArgument extends AbstractEvent implements RegWriter, EventUser {

    protected Register register;
    protected ThreadCreate creator;
    protected int argIndex;

    public ThreadArgument(Register register, ThreadCreate creator, int argIndex) {
        Preconditions.checkArgument(register.getType().equals(creator.getArguments().get(argIndex).getType()));
        this.register = register;
        this.creator = creator;
        this.argIndex = argIndex;

        creator.registerUser(this);
    }

    protected ThreadArgument(ThreadArgument other) {
        super(other);
        this.register = other.register;
        this.creator = other.creator;
        this.argIndex = other.argIndex;

        creator.registerUser(this);
    }

    public ThreadCreate getCreator() { return creator; }
    public int getIndex() { return argIndex; }

    @Override
    public Register getResultRegister() {
        return register;
    }

    @Override
    public void setResultRegister(Register reg) {
        this.register = reg;
    }

    @Override
    public String defaultString() {
        return String.format("%s := Argument(%s) from %s", register, argIndex, creator);
    }

    @Override
    public BooleanFormula encodeExec(EncodingContext context) {
        return context.getBooleanFormulaManager().and(
                super.encodeExec(context),
                context.equal(context.result(this),
                        context.encodeExpressionAt(creator.getArguments().get(argIndex), creator)));
    }


    @Override
    public ThreadArgument getCopy() {
        return new ThreadArgument(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        // TODO
        return visitor.visitEvent(this);
    }

    @Override
    public Set<Event> getReferencedEvents() {
        return Set.of(creator);
    }

    @Override
    public void updateReferences(Map<Event, Event> updateMapping) {
        creator = (ThreadCreate) EventUser.moveUserReference(this, creator, updateMapping);
    }
}