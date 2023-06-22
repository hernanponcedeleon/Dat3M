package com.dat3m.dartagnan.program.event.lang.catomic;

import com.dat3m.dartagnan.program.event.common.FenceBase;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
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
        return name + "(" + mo + ")\t### C11";
    }


    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public AtomicThreadFence getCopy(){
        return new AtomicThreadFence(this);
    }

    // Visitor
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitAtomicThreadFence(this);
    }
}