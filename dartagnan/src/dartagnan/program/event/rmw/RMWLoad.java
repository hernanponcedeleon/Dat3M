package dartagnan.program.event.rmw;

import dartagnan.program.Location;
import dartagnan.program.Register;
import dartagnan.program.utils.ClonableWithMemorisation;
import dartagnan.program.event.Load;

public class RMWLoad extends Load implements ClonableWithMemorisation {

    private RMWLoad clone;

    public RMWLoad(Register reg, Location loc, String atomic) {
        super(reg, loc, atomic);
    }

    @Override
    public void resetPreparedClone(){
        clone = null;
    }

    @Override
    public RMWLoad clone() {
        if(clone == null){
            clone = new RMWLoad(reg.clone(), loc.clone(), atomic);
            clone.setCondLevel(condLevel);
            clone.setHLId(getHLId());
            clone.setUnfCopy(getUnfCopy());
        }
        return clone;
    }
}
