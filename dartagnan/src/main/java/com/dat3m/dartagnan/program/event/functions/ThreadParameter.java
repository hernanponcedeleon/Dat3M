package com.dat3m.dartagnan.program.event.functions;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventUser;
import com.dat3m.dartagnan.program.event.core.AbstractEvent;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.google.common.base.Preconditions;
import org.sosy_lab.java_smt.api.BooleanFormula;

import java.util.Map;
import java.util.Set;

public class ThreadParameter extends AbstractEvent implements RegWriter, EventUser {

    protected Register register;
    protected ThreadCreationArguments arguments;
    protected int argIndex;

    public ThreadParameter(Register register, ThreadCreationArguments args, int argIndex) {
        Preconditions.checkArgument(register.getType().equals(args.getArguments().get(argIndex).getType()));
        this.register = register;
        this.arguments = args;
        this.argIndex = argIndex;

        arguments.registerUser(this);
    }

    protected ThreadParameter(ThreadParameter other) {
        super(other);
        this.register = other.register;
        this.arguments = other.arguments;
        this.argIndex = other.argIndex;

        arguments.registerUser(this);
    }

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
        return String.format("%s := ThreadParameter(%s) from %s", register, argIndex, arguments);
    }

    @Override
    public BooleanFormula encodeExec(EncodingContext context) {
        return context.getBooleanFormulaManager().and(
                super.encodeExec(context),
                context.equal(context.result(this),
                        context.encodeExpressionAt(arguments.getArguments().get(argIndex), arguments)));
    }


    @Override
    public ThreadParameter getCopy() {
        return new ThreadParameter(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        // TODO
        return visitor.visitEvent(this);
    }

    @Override
    public Set<Event> getReferencedEvents() {
        return Set.of(arguments);
    }

    @Override
    public void updateReferences(Map<Event, Event> updateMapping) {
        arguments = (ThreadCreationArguments) EventUser.moveUserReference(this, arguments, updateMapping);
    }
}