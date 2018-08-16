package dartagnan.program.event.rcu;

import dartagnan.program.event.Event;
import dartagnan.program.event.filter.FilterUtils;

public class RCUReadLock extends Event {

    public RCUReadLock(){
        this(0);
    }

    public RCUReadLock(int condLevel){
        this.condLevel = condLevel;
        this.addFilters(FilterUtils.EVENT_TYPE_ANY);
    }

    public String toString() {
        return "rcu_read_lock";
    }

    public RCUReadLock clone() {
        return new RCUReadLock(condLevel);
    }
}
