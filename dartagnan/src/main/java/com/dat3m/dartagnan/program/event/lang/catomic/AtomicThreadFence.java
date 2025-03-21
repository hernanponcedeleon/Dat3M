package com.dat3m.dartagnan.program.event.lang.catomic;

import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.common.FenceBase;
import com.google.common.base.Preconditions;

public class AtomicThreadFence extends FenceBase {

    public AtomicThreadFence(String mo) {
        super("atomic_thread_fence", mo);
        Preconditions.checkArgument(!mo.isEmpty(), "Atomic events cannot have empty memory order");
    }

    private AtomicThreadFence(AtomicThreadFence other){
        super(other);
    }

    @Override
    public String defaultString() {
        return String.format("%s(%s)\t### C11", name, mo);
    }

    @Override
    public AtomicThreadFence getCopy(){
        return new AtomicThreadFence(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitAtomicThreadFence(this);
    }
}