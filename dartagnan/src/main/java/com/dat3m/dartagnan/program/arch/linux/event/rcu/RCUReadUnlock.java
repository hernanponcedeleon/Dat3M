package com.dat3m.dartagnan.program.arch.linux.event.rcu;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.arch.linux.utils.EType;

public class RCUReadUnlock extends Event {

    private RCUReadLock lockEvent;

    public RCUReadUnlock(RCUReadLock lockEvent){
        this.lockEvent = lockEvent;
        this.addFilters(EType.ANY, EType.VISIBLE, EType.RCU_UNLOCK);
    }

    private RCUReadUnlock(RCUReadUnlock other){
        super(other);
        this.lockEvent = (RCUReadLock)other.lockEvent.getCopy();
    }

    public RCUReadLock getLockEvent(){
        return lockEvent;
    }

    @Override
    public String toString() {
        return "rcu_read_unlock";
    }

    @Override
    public String label(){
        return EType.RCU_UNLOCK;
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    protected RCUReadUnlock mkCopy(){
        return new RCUReadUnlock(this);
    }
}
