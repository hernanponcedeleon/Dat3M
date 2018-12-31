package dartagnan.program.event.rmw.cond;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import dartagnan.expression.ExprInterface;
import dartagnan.expression.IExpr;
import dartagnan.program.Register;
import dartagnan.program.event.utils.RegReaderData;
import dartagnan.program.event.utils.RegWriter;

public class RMWReadCondUnless extends RMWReadCond implements RegWriter, RegReaderData {

    public RMWReadCondUnless(Register reg, ExprInterface cmp, IExpr address, String atomic) {
        super(reg, cmp, address, atomic);
    }

    @Override
    public void initialise(Context ctx) {
        super.initialise(ctx);
        this.z3Cond = ctx.mkNot(z3Cond);
    }

    @Override
    public RMWReadCondUnless clone() {
        if(clone == null){
            clone = new RMWReadCondUnless(reg.clone(), cmp.clone(), address.clone(), atomic);
            afterClone();
        }
        return (RMWReadCondUnless)clone;
    }
}
