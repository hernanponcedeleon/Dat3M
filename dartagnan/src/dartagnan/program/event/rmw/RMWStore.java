package dartagnan.program.event.rmw;

import dartagnan.expression.ExprInterface;
import dartagnan.program.Location;
import dartagnan.program.event.Store;
import dartagnan.program.utils.EType;

public class RMWStore extends Store {

    protected RMWLoad loadEvent;

    public RMWStore(RMWLoad loadEvent, Location loc, ExprInterface val, String atomic) {
        super(loc, val, atomic);
        addFilters(EType.RMW);
        this.loadEvent = loadEvent;
    }

    public RMWLoad getLoadEvent(){
        return loadEvent;
    }

    @Override
    public RMWStore clone() {
        Location newLoc = loc.clone();
        RMWLoad newLoad = loadEvent.clone();
        ExprInterface newVal = val.clone();
        RMWStore newStore = new RMWStore(newLoad, newLoc, newVal, atomic);
        newStore.condLevel = condLevel;
        newStore.setHLId(getHLId());
        newStore.setUnfCopy(getUnfCopy());
        return newStore;
    }
}
