package dartagnan.program.event.rmw;

import dartagnan.expression.AExpr;
import dartagnan.expression.ExprInterface;
import dartagnan.program.event.Store;
import dartagnan.program.event.utils.RegReaderAddress;
import dartagnan.program.event.utils.RegReaderData;
import dartagnan.program.utils.EType;

public class RMWStore extends Store implements RegReaderData, RegReaderAddress {

    protected RMWLoad loadEvent;

    public RMWStore(RMWLoad loadEvent, AExpr address, ExprInterface value, String atomic) {
        super(address, value, atomic);
        addFilters(EType.RMW);
        this.loadEvent = loadEvent;
    }

    public RMWLoad getLoadEvent(){
        return loadEvent;
    }

    @Override
    public RMWStore clone() {
        if(clone == null){
            clone = new RMWStore(loadEvent.clone(), address.clone(), value.clone(), atomic);
            afterClone();
        }
        return (RMWStore)clone;
    }
}
