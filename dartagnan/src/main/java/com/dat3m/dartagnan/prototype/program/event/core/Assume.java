package com.dat3m.dartagnan.prototype.program.event.core;

import com.dat3m.dartagnan.prototype.expr.Expression;
import com.dat3m.dartagnan.prototype.program.Register;
import com.dat3m.dartagnan.prototype.program.event.AbstractEvent;

import java.util.HashSet;
import java.util.Set;

// TODO: "abstract" is only here to avoid providing a complete implementation for now
public abstract class Assume extends AbstractEvent implements Register.Reader {

    private Expression assumption;

    private Assume(Expression assumption) {
    }

    @Override
    public Set<Register.Read> getRegisterReads() {
        Set<Register.Read> regReads = new HashSet<>();
        Register.collectRegisterReads(assumption, Register.UsageType.OTHER, regReads);
        return regReads;
    }
}
