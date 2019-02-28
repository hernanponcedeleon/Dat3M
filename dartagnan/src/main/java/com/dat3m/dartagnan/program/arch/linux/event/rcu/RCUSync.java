package com.dat3m.dartagnan.program.arch.linux.event.rcu;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.arch.linux.utils.EType;

public class RCUSync extends Event {

    public RCUSync(){
        this.addFilters(EType.ANY, EType.VISIBLE, EType.RCU_SYNC);
    }

    private RCUSync(RCUSync other){
        super(other);
    }

    @Override
    public String toString() {
        return "synchronize_rcu";
    }

    @Override
    public String label(){
        return EType.RCU_SYNC;
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    protected RCUSync mkCopy(){
        return new RCUSync(this);
    }
}
