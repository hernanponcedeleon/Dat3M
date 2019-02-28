package com.dat3m.dartagnan.program.arch.linux.event.rcu;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.arch.linux.utils.EType;

public class RCUReadLock extends Event {

    public RCUReadLock(){
        this.addFilters(EType.ANY, EType.VISIBLE, EType.RCU_LOCK);
    }

    private RCUReadLock(RCUReadLock other){
        super(other);
    }

    @Override
    public String toString() {
        return "rcu_read_lock";
    }

    @Override
    public String label(){
        return EType.RCU_LOCK;
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    protected RCUReadLock mkCopy(){
        return new RCUReadLock(this);
    }
}
