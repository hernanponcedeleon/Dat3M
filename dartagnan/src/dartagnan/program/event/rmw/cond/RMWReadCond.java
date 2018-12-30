package dartagnan.program.event.rmw.cond;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import dartagnan.expression.ExprInterface;
import dartagnan.expression.IExpr;
import dartagnan.program.Register;
import dartagnan.program.event.rmw.RMWLoad;
import dartagnan.program.event.utils.RegReaderData;
import dartagnan.program.event.utils.RegWriter;
import dartagnan.utils.MapSSA;
import dartagnan.utils.Pair;

import java.util.HashSet;
import java.util.Set;

import static dartagnan.utils.Utils.ssaReg;

public abstract class RMWReadCond extends RMWLoad implements RegWriter, RegReaderData {

    protected ExprInterface cmp;
    protected BoolExpr z3Cond;

    RMWReadCond(Register reg, ExprInterface cmp, IExpr address, String atomic) {
        super(reg, address, atomic);
        this.cmp = cmp;
    }

    public BoolExpr getCond(){
        if(z3Cond == null){
            // encodeDF must be called before encodeCF, otherwise this exception will be thrown
            throw new RuntimeException("z3Cond is requested before it has been initialised in " + this.getClass().getName());
        }
        return z3Cond;
    }

    @Override
    public Set<Register> getDataRegs(){
        return cmp.getRegs();
    }

    @Override
    public Pair<BoolExpr, MapSSA> encodeDF(MapSSA map, Context ctx) {
        valueExpr = ssaReg(reg, map.getFresh(reg), ctx);
        ssaRegIndex = map.get(reg);
        z3Cond = ctx.mkEq(valueExpr, encodeValue(map, ctx, cmp));
        addressExpr = address.toZ3Int(map, ctx);
        return new Pair<>(ctx.mkTrue(), map);
    }

    @Override
    public abstract RMWReadCond clone();

    private Expr encodeValue(MapSSA map, Context ctx, ExprInterface v){
        if(v instanceof Register){
            return ssaReg((Register)v, map.get((Register)v), ctx);
        }
        return ctx.mkInt(v.toString());
    }
}
