package dartagnan.program.rmw;

import dartagnan.expression.AConst;
import dartagnan.program.Load;
import dartagnan.program.Location;
import dartagnan.program.Register;
import dartagnan.program.Store;

public class RMWStore extends Store {

    private Load loadEvent;

    public RMWStore(Load loadEvent, Location loc, Register reg) {
        super(loc, reg);
        this.loadEvent = loadEvent;
    }

    public RMWStore(Load loadEvent, Location loc, AConst val) {
        super(loc, val);
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
            newStore = new RMWStore(newLoad, newLoc, newReg);
        } else {
            AConst newVal = val.clone();
            newStore = new RMWStore(newLoad, newLoc, newVal);
        }
        newStore.condLevel = condLevel;
        newStore.setHLId(getHLId());
        newStore.setUnfCopy(getUnfCopy());
        return newStore;
    }
}
