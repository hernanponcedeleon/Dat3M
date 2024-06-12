package com.dat3m.dartagnan.program.event.lang.svcomp;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.AbstractEvent;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.google.common.base.Preconditions;

public class NonDetChoice extends AbstractEvent implements RegWriter {

    protected Register register;
    protected boolean isSigned;

    public NonDetChoice(Register register, boolean isSigned) {
        this.register = Preconditions.checkNotNull(register);
        this.isSigned = isSigned;
    }

    protected NonDetChoice(NonDetChoice other) {
        super(other);
        this.register = other.register;
        this.isSigned = other.isSigned;
    }

    public boolean isSigned() { return isSigned; }

    @Override
    protected String defaultString() {
        return String.format("%s <- *", register);
    }

    @Override
    public Event getCopy() {
        return new NonDetChoice(this);
    }

    @Override
    public Register getResultRegister() {
        return register;
    }

    @Override
    public void setResultRegister(Register reg) {
        this.register = reg;
    }
}
