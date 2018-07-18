package dartagnan.program.event.rmw;

import dartagnan.expression.AConst;
import dartagnan.program.event.Load;
import dartagnan.program.Location;
import dartagnan.program.Register;
import dartagnan.program.event.Store;

public class RMWStore extends Store {

    private Load loadEvent;

    public RMWStore(Load loadEvent, Location loc, Register reg, String atomic) {
        super(loc, reg, atomic);
        this.loadEvent = loadEvent;
    }

    public RMWStore(Load loadEvent, Location loc, AConst val, String atomic) {
        super(loc, val, atomic);
        this.loadEvent = loadEvent;
    }

    public Load getLoadEvent(){
        return loadEvent;
    }

    public RMWStore clone() {
        RMWStore newStore;
        Location newLoc = loc.clone();
        Load newLoad = loadEvent.clone();
        if(reg != null){
            Register newReg = reg.clone();
            newStore = new RMWStore(newLoad, newLoc, newReg, atomic);
        } else {
            AConst newVal = val.clone();
            newStore = new RMWStore(newLoad, newLoc, newVal, atomic);
        }
        newStore.condLevel = condLevel;
        newStore.setHLId(getHLId());
        newStore.setUnfCopy(getUnfCopy());
        return newStore;
    }
}
