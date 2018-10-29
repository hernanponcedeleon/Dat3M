package dartagnan.program.event.linux.rcu;

import dartagnan.program.event.Event;
import dartagnan.program.utils.linux.EType;

public class RCUReadLock extends Event {

    private RCUReadLock clone;

    public RCUReadLock(){
        this(0);
    }

    public RCUReadLock(int condLevel){
        this.condLevel = condLevel;
        this.addFilters(EType.ANY, EType.RCU_LOCK);
    }

    @Override
    public String toString() {
        return "rcu_read_lock";
    }

    @Override
    public String label(){
        return "F[" + EType.RCU_LOCK + "]";
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
