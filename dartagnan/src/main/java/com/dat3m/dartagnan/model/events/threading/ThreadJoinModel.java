package com.dat3m.dartagnan.model.events.threading;

import com.dat3m.dartagnan.encoding.TypedValue;
import com.dat3m.dartagnan.model.AbstractEventModel;
import com.dat3m.dartagnan.model.ThreadModel;
import com.dat3m.dartagnan.model.events.BlockingEventModel;
import com.dat3m.dartagnan.model.events.RegWriterModel;
import com.dat3m.dartagnan.program.Register;

public final class ThreadJoinModel extends AbstractEventModel implements RegWriterModel, BlockingEventModel {

    private final Register register;
    private final TypedValue<?, ?> value;
    private final ThreadModel joinedThread;
    private final boolean isBlocked;

    public ThreadJoinModel(Register register, TypedValue<?, ?> value, ThreadModel joinedThread, boolean isBlocked) {
        this.register = register;
        this.value = value;
        this.joinedThread = joinedThread;
        this.isBlocked = isBlocked;
    }

    public ThreadModel getJoinedThread() { return joinedThread; }
    @Override
    public boolean isBlocked() { return isBlocked; }

    @Override
    public Register getResultRegister() {
        return register;
    }

    @Override
    public TypedValue<?, ?> getValue() {
        return value;
    }

    @Override
    public String toString() {
        if (isBlocked) {
            return String.format("ThreadJoin(%s) # blocked", joinedThread);
        } else {
            return String.format("%s {%s} <- ThreadJoin(%s)", register, value, joinedThread);
        }
    }
}
