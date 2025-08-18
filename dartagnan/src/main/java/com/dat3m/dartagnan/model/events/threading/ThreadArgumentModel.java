package com.dat3m.dartagnan.model.events.threading;

import com.dat3m.dartagnan.encoding.TypedValue;
import com.dat3m.dartagnan.model.AbstractEventModel;
import com.dat3m.dartagnan.model.events.RegWriterModel;
import com.dat3m.dartagnan.program.Register;

public final class ThreadArgumentModel extends AbstractEventModel implements RegWriterModel {

    private final Register register;
    private final int argumentIndex;
    private final ThreadCreateModel threadCreate;

    public ThreadArgumentModel(Register register, int argumentIndex, ThreadCreateModel threadCreate) {
        this.register = register;
        this.argumentIndex = argumentIndex;
        this.threadCreate = threadCreate;
    }

    public int getArgumentIndex() { return argumentIndex; }
    public ThreadCreateModel getThreadCreate() { return threadCreate; }

    @Override
    public Register getResultRegister() {
        return register;
    }

    @Override
    public TypedValue<?, ?> getValue() {
        return getThreadCreate().getArguments().get(getArgumentIndex());
    }

    @Override
    public String toString() {
        return String.format("%s {%s} <- ThreadArgument(%s) from %s", register, getValue(), argumentIndex, threadCreate);
    }
}
