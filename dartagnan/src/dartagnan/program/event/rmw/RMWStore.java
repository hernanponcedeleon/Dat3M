package dartagnan.program.event.rmw;

import dartagnan.expression.ExprInterface;
import dartagnan.expression.IExpr;
import dartagnan.program.event.Store;
import dartagnan.program.event.utils.RegReaderData;
import dartagnan.program.utils.EType;

public class RMWStore extends Store implements RegReaderData {

    protected RMWLoad loadEvent;

    public RMWStore(RMWLoad loadEvent, IExpr address, ExprInterface value, String atomic) {
        super(address, value, atomic);
        this.loadEvent = loadEvent;
        addFilters(EType.RMW);
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
