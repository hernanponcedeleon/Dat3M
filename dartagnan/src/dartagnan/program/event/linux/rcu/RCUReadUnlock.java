package dartagnan.program.event.linux.rcu;

import dartagnan.program.event.Event;
import dartagnan.program.event.filter.FilterUtils;

public class RCUReadUnlock extends Event {

    private RCUReadLock lockEvent;

    public RCUReadUnlock(RCUReadLock lockEvent){
        this(lockEvent, 0);
    }

    public RCUReadUnlock(RCUReadLock lockEvent, int condLevel){
        this.lockEvent = lockEvent;
        this.condLevel = condLevel;
        this.addFilters(FilterUtils.EVENT_TYPE_ANY);
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
        return "F[rcu-unlock]";
    }

    @Override
    public RCUReadUnlock clone() {
        return new RCUReadUnlock(lockEvent.clone(), condLevel);
    }
}
