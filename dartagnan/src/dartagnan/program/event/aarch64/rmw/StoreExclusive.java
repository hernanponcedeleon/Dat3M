package dartagnan.program.event.aarch64.rmw;

import dartagnan.expression.ExprInterface;
import dartagnan.program.Location;
import dartagnan.program.Register;
import dartagnan.program.event.rmw.RMWLoad;
import dartagnan.program.event.rmw.RMWStore;
import dartagnan.program.event.utils.RegWriter;

public class StoreExclusive extends RMWStore implements RegWriter {

    private RMWLoad loadEvent;
    private Register statusReg;

    public StoreExclusive(Register statusReg, Location location, ExprInterface val, String atomic){
        super(null, location, val, atomic);
        this.statusReg = statusReg;
    }

    public StoreExclusive setLoadEvent(RMWLoad load){
        this.loadEvent = load;
        return this;
    }

    @Override
    public Register getWrittenReg(){
        return statusReg;
    }

    @Override
    public StoreExclusive clone() {
        StoreExclusive newStore = new StoreExclusive(statusReg.clone(), loc.clone(), val.clone(), atomic);
        if(loadEvent != null){
            newStore.setLoadEvent(loadEvent.clone());
        }
        newStore.condLevel = condLevel;
        newStore.setHLId(getHLId());
        newStore.setUnfCopy(getUnfCopy());
        return newStore;
    }
}
