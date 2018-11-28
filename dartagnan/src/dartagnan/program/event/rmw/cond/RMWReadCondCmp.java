package dartagnan.program.event.rmw.cond;

import dartagnan.expression.AExpr;
import dartagnan.expression.ExprInterface;
import dartagnan.program.Register;
import dartagnan.program.event.utils.RegReaderAddress;
import dartagnan.program.event.utils.RegReaderData;
import dartagnan.program.event.utils.RegWriter;

public class RMWReadCondCmp extends RMWReadCond implements RegWriter, RegReaderData, RegReaderAddress {

    public RMWReadCondCmp(Register reg, ExprInterface cmp, AExpr address, String atomic) {
        super(reg, cmp, address, atomic);
    }

    @Override
    public RMWReadCondCmp clone() {
        if(clone == null){
            clone = new RMWReadCondCmp(reg.clone(), cmp.clone(), address.clone(), atomic);
            afterClone();
        }
        return (RMWReadCondCmp)clone;
    }
}
