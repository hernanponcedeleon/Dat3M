package dartagnan.program.event.rmw;

import dartagnan.expression.AExpr;
import dartagnan.program.Register;
import dartagnan.program.event.LoadFromAddress;
import dartagnan.program.event.utils.RegReaderAddress;
import dartagnan.program.event.utils.RegWriter;
import dartagnan.program.utils.EType;

public class RMWLoadFromAddress extends LoadFromAddress implements RegWriter, RegReaderAddress {

    public RMWLoadFromAddress(Register reg, AExpr address, String atomic) {
        super(reg, address, atomic);
        addFilters(EType.RMW);
    }

    @Override
    public RMWLoadFromAddress clone() {
        if(clone == null){
            clone = new RMWLoadFromAddress(reg.clone(), address.clone(), atomic);
            afterClone();
        }
        return (RMWLoadFromAddress)clone;
    }
}
