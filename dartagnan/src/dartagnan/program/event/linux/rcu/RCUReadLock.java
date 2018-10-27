package dartagnan.program.event.linux.rcu;

import dartagnan.program.event.Event;
import dartagnan.program.event.filter.FilterUtils;

public class RCUReadLock extends Event {

    private RCUReadLock clone;

    public RCUReadLock(){
        this(0);
    }

    public RCUReadLock(int condLevel){
        this.condLevel = condLevel;
        this.addFilters(FilterUtils.EVENT_TYPE_ANY);
    }

    @Override
    public String toString() {
        return "rcu_read_lock";
    }

    @Override
    public String label(){
        return "F[rcu-lock]";
    }

    @Override
    public void beforeClone(){
        clone = null;
    }

    @Override
    public RCUReadLock clone() {
        if(clone == null){
            clone = new RCUReadLock(condLevel);
        }
        return clone;
    }
}
