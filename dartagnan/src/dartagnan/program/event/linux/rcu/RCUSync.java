package dartagnan.program.event.linux.rcu;

import dartagnan.program.event.Event;
import dartagnan.program.utils.linux.EType;

public class RCUSync extends Event {

    public RCUSync(){
        this(0);
    }

    public RCUSync(int condLevel){
        this.condLevel = condLevel;
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
            clone = new RCUSync(condLevel);
            afterClone();
        }
        return (RCUSync)clone;
    }
}
