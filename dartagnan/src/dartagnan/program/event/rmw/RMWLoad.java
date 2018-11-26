package dartagnan.program.event.rmw;

import dartagnan.program.memory.Location;
import dartagnan.program.Register;
import dartagnan.program.event.Load;
import dartagnan.program.event.utils.RegWriter;
import dartagnan.program.utils.EType;

public class RMWLoad extends Load implements RegWriter {

    public RMWLoad(Register reg, Location loc, String atomic) {
        super(reg, loc, atomic);
        addFilters(EType.RMW);
    }

    @Override
    public void beforeClone(){
        clone = null;
    }

    @Override
    public RMWLoad clone() {
        if(clone == null){
            clone = new RMWLoad(reg.clone(), loc.clone(), atomic);
            afterClone();
        }
        return (RMWLoad)clone;
    }
}
