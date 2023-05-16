package com.dat3m.dartagnan.prototype.program.event.core.threading;

import com.dat3m.dartagnan.prototype.expr.Expression;
import com.dat3m.dartagnan.prototype.program.Register;
import com.dat3m.dartagnan.prototype.program.event.AbstractEvent;
import com.dat3m.dartagnan.prototype.program.event.Event;
import com.dat3m.dartagnan.prototype.program.event.EventUser;
import com.google.common.base.Preconditions;

import java.util.Set;

/*
    The ThreadArgument event allows us to transfer the arguments of a ThreadCreate event
    to the actual thread that is spawned by the creation event.
    Importantly, the argument expression is evaluated at the ThreadCreate event rather than locally at the
    ThreadArgument event.
 */
// TODO: "abstract" is only here to avoid providing a complete implementation for now
public abstract class ThreadArgument extends AbstractEvent implements Register.Writer, EventUser {

    private Register resultRegister;
    private ThreadCreate threadCreate;
    private int argumentIndex;

    private ThreadArgument(Register resultRegister, ThreadCreate threadCreate, int argumentIndex) {
        Preconditions.checkArgument(0 <= argumentIndex && argumentIndex < threadCreate.getArguments().size());
        this.resultRegister = resultRegister;
        this.threadCreate = threadCreate;
        this.argumentIndex = argumentIndex;
    }

    public ThreadCreate getThreadCreationEvent() { return threadCreate; }
    public int getArgumentIndex() { return argumentIndex; }
    public Expression getArgumentExpression() { return threadCreate.getArguments().get(argumentIndex); }

    @Override
    public Register getResultRegister() {
        return resultRegister;
    }

    @Override
    public Set<Event> getReferencedEvents() {
        return Set.of(threadCreate);
    }
}
