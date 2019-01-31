package com.dat3m.dartagnan.program.arch.linux.event.rcu;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.arch.linux.utils.EType;

public class RCUReadUnlock extends Event {

    private RCUReadLock lockEvent;

    public RCUReadUnlock(RCUReadLock lockEvent){
        this.condLevel = 0;
        this.lockEvent = lockEvent;
        this.addFilters(EType.ANY, EType.RCU_UNLOCK);
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

    @Override
    public RCUReadUnlock clone() {
        if(clone == null){
            clone = new RCUReadUnlock(lockEvent.clone());
            afterClone();
        }
        return (RCUReadUnlock)clone;
    }
}
