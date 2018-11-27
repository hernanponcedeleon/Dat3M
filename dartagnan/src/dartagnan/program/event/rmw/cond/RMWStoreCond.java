package dartagnan.program.event.rmw.cond;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import dartagnan.expression.ExprInterface;
import dartagnan.program.Register;
import dartagnan.program.event.rmw.RMWStoreToAddress;
import dartagnan.program.event.utils.RegReaderAddress;
import dartagnan.program.event.utils.RegReaderData;

public class RMWStoreCond extends RMWStoreToAddress implements RegReaderData, RegReaderAddress {

    public RMWStoreCond(RMWReadCond loadEvent, Register address, ExprInterface value, String atomic) {
        super(loadEvent, address, value, atomic);
    }

    @Override
    public BoolExpr encodeCF(Context ctx) {
        return ctx.mkEq(ctx.mkAnd(ctx.mkBoolConst(cfVar()), ((RMWReadCond)loadEvent).getCond()), executes(ctx));
    }
}
