package dartagnan.program.event.rmw.cond;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import dartagnan.expression.ExprInterface;
import dartagnan.expression.IExpr;
import dartagnan.program.Register;
import dartagnan.program.event.rmw.RMWLoad;
import dartagnan.program.event.utils.RegReaderData;
import dartagnan.program.event.utils.RegWriter;

import java.util.Set;

public abstract class RMWReadCond extends RMWLoad implements RegWriter, RegReaderData {

    protected ExprInterface cmp;
    BoolExpr z3Cond;

    RMWReadCond(Register reg, ExprInterface cmp, IExpr address, String atomic) {
        super(reg, address, atomic);
        this.cmp = cmp;
    }

    @Override
    public void initialise(Context ctx) {
        memValueExpr = reg.toZ3IntResult(this, ctx);
        z3Cond = ctx.mkEq(memValueExpr, cmp.toZ3Int(this, ctx));
        memAddressExpr = address.toZ3Int(this, ctx);
    }

    public BoolExpr getCond(){
        if(z3Cond != null){
            return z3Cond;
        }
        throw new RuntimeException("z3Cond is requested before it has been initialised in " + this.getClass().getName());
    }

    @Override
    public Set<Register> getDataRegs(){
        return cmp.getRegs();
    }

    @Override
    public abstract RMWReadCond clone();

    public abstract String condToString();
}
