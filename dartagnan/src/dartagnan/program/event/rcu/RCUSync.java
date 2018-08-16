package dartagnan.program.event.rcu;

import dartagnan.program.event.Event;
import dartagnan.program.event.filter.FilterUtils;

public class RCUSync extends Event {

    public RCUSync(){
        this(0);
    }

    public RCUSync(int condLevel){
        this.condLevel = condLevel;
        this.addFilters(FilterUtils.EVENT_TYPE_ANY, FilterUtils.EVENT_TYPE_SYNC_RCU);
    }

    public String toString() {
        return "synchronize_rcu";
    }

    public RCUSync clone() {
        return new RCUSync(condLevel);
    }
}
