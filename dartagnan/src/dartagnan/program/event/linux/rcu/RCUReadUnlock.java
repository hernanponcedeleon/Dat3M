package dartagnan.program.event.linux.rcu;

import dartagnan.program.event.Event;
import dartagnan.program.utils.linux.EType;

public class RCUReadUnlock extends Event {

    private RCUReadLock lockEvent;

    public RCUReadUnlock(RCUReadLock lockEvent){
        this(lockEvent, 0);
    }

    public RCUReadUnlock(RCUReadLock lockEvent, int condLevel){
        this.lockEvent = lockEvent;
        this.condLevel = condLevel;
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
            clone = new RCUReadUnlock(lockEvent.clone(), condLevel);
            afterClone();
        }
        return (RCUReadUnlock)clone;
    }
}
