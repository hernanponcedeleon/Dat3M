package com.dat3m.dartagnan.prototype.program.event.core.threading;


import com.dat3m.dartagnan.prototype.expr.Expression;
import com.dat3m.dartagnan.prototype.program.Register;
import com.dat3m.dartagnan.prototype.program.event.AbstractEvent;

import java.util.HashSet;
import java.util.Set;

/*
    ThreadReturn essentially amounts to a FunctionReturn event.
    We use it to signify that a thread, rather than a simple function, returns.
    ThreadReturns are constructed in two ways:
        (1) FunctionReturn events are converted to ThreadReturn events for thread-executed functions
        (2) pthread_exit(retVal) is compiled down to ThreadReturn.
 */
public abstract class ThreadReturn extends AbstractEvent implements Register.Reader {
    /*
        Can be NULL if the thread has no return value.
        TODO: Maybe this should never be NULL and instead should return at least a "NULLPTR"?
     */
    private Expression returnValue;

    private ThreadReturn(Expression returnValue) {
        this.returnValue = returnValue;
    }

    public Expression getReturnValue() { return returnValue; }

    @Override
    public Set<Register.Read> getRegisterReads() {
        if (returnValue == null) {
            return Set.of();
        }
        Set<Register.Read> regReads = new HashSet<>();
        Register.collectRegisterReads(returnValue, Register.UsageType.DATA, regReads);
        return regReads;
    }
}
