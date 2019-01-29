package com.dat3m.dartagnan.program.event.linux.rcu;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.utils.linux.EType;

public class RCUSync extends Event {

    public RCUSync(){
        this.condLevel = 0;
        this.addFilters(EType.ANY, EType.RCU_SYNC);
    }

    @Override
    public String toString() {
        return "synchronize_rcu";
    }

    @Override
    public String label(){
        return EType.RCU_SYNC;
    }

    @Override
    public RCUSync clone() {
        if(clone == null){
            clone = new RCUSync();
            afterClone();
        }
        return (RCUSync)clone;
    }
}
