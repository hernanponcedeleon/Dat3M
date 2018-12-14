package dartagnan.program.event.linux.rcu;

import dartagnan.program.event.Event;
import dartagnan.program.utils.linux.EType;

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
