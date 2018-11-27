package dartagnan.program.event.rmw;

import dartagnan.expression.ExprInterface;
import dartagnan.program.Register;
import dartagnan.program.event.StoreToAddress;
import dartagnan.program.event.utils.RegReaderAddress;
import dartagnan.program.event.utils.RegReaderData;
import dartagnan.program.utils.EType;

public class RMWStoreToAddress extends StoreToAddress implements RegReaderData, RegReaderAddress {

    protected RMWLoadFromAddress loadEvent;

    public RMWStoreToAddress(RMWLoadFromAddress loadEvent, Register address, ExprInterface value, String atomic) {
        super(address, value, atomic);
        addFilters(EType.RMW);
        this.loadEvent = loadEvent;
    }

    public RMWLoadFromAddress getLoadEvent(){
        return loadEvent;
    }

    @Override
    public RMWStoreToAddress clone() {
        if(clone == null){
            clone = new RMWStoreToAddress(loadEvent.clone(), address.clone(), value.clone(), atomic);
            afterClone();
        }
        return (RMWStoreToAddress)clone;
    }
}
