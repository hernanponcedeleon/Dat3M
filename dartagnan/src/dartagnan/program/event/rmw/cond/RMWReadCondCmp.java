package dartagnan.program.event.rmw.cond;

import dartagnan.expression.ExprInterface;
import dartagnan.expression.IExpr;
import dartagnan.program.Register;
import dartagnan.program.event.utils.RegReaderData;
import dartagnan.program.event.utils.RegWriter;

public class RMWReadCondCmp extends RMWReadCond implements RegWriter, RegReaderData {

    public RMWReadCondCmp(Register reg, ExprInterface cmp, IExpr address, String atomic) {
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

    @Override
    public String condToString(){
        return "# if " + reg + " = " + cmp;
    }
}
