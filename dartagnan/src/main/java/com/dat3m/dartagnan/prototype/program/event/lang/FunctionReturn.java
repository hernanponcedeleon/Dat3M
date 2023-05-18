package com.dat3m.dartagnan.prototype.program.event.lang;

import com.dat3m.dartagnan.prototype.expr.Expression;
import com.dat3m.dartagnan.prototype.program.Register;
import com.dat3m.dartagnan.prototype.program.event.AbstractEvent;

import java.util.HashSet;
import java.util.Set;

// TODO: "abstract" is only here to avoid providing a complete implementation for now
public abstract class FunctionReturn extends AbstractEvent implements Register.Reader {

    /*
        Can be NULL if the function has no return value.
     */
    private Expression returnValue;

    private FunctionReturn(Expression returnValue) {
        this.returnValue = returnValue;
    }

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
