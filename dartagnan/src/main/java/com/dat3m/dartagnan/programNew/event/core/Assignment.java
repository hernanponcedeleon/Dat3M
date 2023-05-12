package com.dat3m.dartagnan.programNew.event.core;

import com.dat3m.dartagnan.expr.Expression;
import com.dat3m.dartagnan.programNew.Register;
import com.dat3m.dartagnan.programNew.event.AbstractEvent;

import java.util.HashSet;
import java.util.Set;

// TODO: "abstract" is only here to avoid providing a complete implementation for now
public abstract class Assignment extends AbstractEvent implements Register.Reader, Register.Writer {

    private Register resultRegister;
    private Expression value;

    private Assignment(Register resultRegister, Expression value) {
        this.resultRegister = resultRegister;
        this.value = value;
    }

    @Override
    public Set<Register.Read> getRegisterReads() {
        Set<Register.Read> regReads = new HashSet<>();
        Register.collectRegisterReads(value, Register.UsageType.DATA, regReads);
        return regReads;
    }

    @Override
    public Register getResultRegister() {
        return resultRegister;
    }
}
