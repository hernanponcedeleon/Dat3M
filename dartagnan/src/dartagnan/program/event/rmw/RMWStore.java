package dartagnan.program.event.rmw;

import dartagnan.expression.AExpr;
import dartagnan.program.event.Load;
import dartagnan.program.Location;
import dartagnan.program.event.Store;

public class RMWStore extends Store {

    protected Load loadEvent;

    public RMWStore(Load loadEvent, Location loc, AExpr val, String atomic) {
        super(loc, val, atomic);
        this.loadEvent = loadEvent;
    }

    public Load getLoadEvent(){
        return loadEvent;
    }

    public RMWStore clone() {
        Location newLoc = loc.clone();
        Load newLoad = loadEvent.clone();
        AExpr newVal = val.clone();
        RMWStore newStore = new RMWStore(newLoad, newLoc, newVal, atomic);
        newStore.condLevel = condLevel;
        newStore.setHLId(getHLId());
        newStore.setUnfCopy(getUnfCopy());
        return newStore;
    }
}
