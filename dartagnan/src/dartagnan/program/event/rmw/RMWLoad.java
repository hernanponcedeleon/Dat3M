package dartagnan.program.event.rmw;

import dartagnan.expression.AExpr;
import dartagnan.program.Register;
import dartagnan.program.event.Load;
import dartagnan.program.event.utils.RegWriter;
import dartagnan.program.utils.EType;

public class RMWLoad extends Load implements RegWriter {

    public RMWLoad(Register reg, AExpr address, String atomic) {
        super(reg, address, atomic);
        addFilters(EType.RMW);
    }

    @Override
    public RMWLoad clone() {
        if(clone == null){
            clone = new RMWLoad(reg.clone(), address.clone(), atomic);
            afterClone();
        }
        return (RMWLoad)clone;
    }
}
