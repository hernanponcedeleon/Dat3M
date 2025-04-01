package com.dat3m.dartagnan.program.event.core.threading;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.AbstractEvent;
import com.dat3m.dartagnan.program.event.BlockingEvent;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.google.common.base.Preconditions;

public class ThreadJoin extends AbstractEvent implements RegWriter, BlockingEvent {

    protected Register resultRegister;
    protected Thread joinThread;

    public ThreadJoin(Register resultRegister, Thread joinThread) {
        Preconditions.checkArgument(resultRegister.getType().equals(joinThread.getFunctionType().getReturnType()));
        this.resultRegister = resultRegister;
        this.joinThread = joinThread;
    }

    protected ThreadJoin(ThreadJoin other) {
        super(other);
        this.resultRegister = other.resultRegister;
        this.joinThread = null;
    }

    @Override
    public Register getResultRegister() {
        return this.resultRegister;
    }

    @Override
    public void setResultRegister(Register reg) {
        this.resultRegister = reg;
    }

    public Thread getJoinThread() { return joinThread; }
    public void setJoinThread(Thread joinThread) { this.joinThread = joinThread; }

    @Override
    protected String defaultString() {
        return String.format("%s <- ThreadJoin(%s)", resultRegister, joinThread);
    }

    @Override
    public ThreadJoin getCopy() {
        return new ThreadJoin(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        // TODO
        return visitor.visitEvent(this);
    }

}
