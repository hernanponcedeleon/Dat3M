package dartagnan.program.event.linux.rcu;

import dartagnan.program.utils.ClonableWithMemorisation;
import dartagnan.program.event.Event;
import dartagnan.program.event.filter.FilterUtils;

public class RCUReadLock extends Event implements ClonableWithMemorisation {

    private RCUReadLock clone;

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

    public void resetPreparedClone(){
        clone = null;
    }

    public RCUReadLock clone() {
        if(clone == null){
            clone = new RCUReadLock(condLevel);
        }
        return clone;
    }
}
