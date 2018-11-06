package dartagnan.program.event.rmw.cond;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import dartagnan.expression.AConst;
import dartagnan.program.Register;
import dartagnan.program.event.Local;
import dartagnan.utils.MapSSA;
import dartagnan.utils.Pair;

import static dartagnan.utils.Utils.ssaReg;

public class LocalCondStatus extends Local {

    private RMWStoreCondWithStatus storeEvent;

    public LocalCondStatus(Register register, RMWStoreCondWithStatus storeEvent){
        super(register, new AConst(0));
        this.storeEvent = storeEvent;
    }

    @Override
    public String toString() {
        return nTimesCondLevel() + reg + " <- status";
    }

    @Override
    public LocalCondStatus clone() {
        LocalCondStatus newLocalStatus = new LocalCondStatus(reg.clone(), storeEvent.clone());
        newLocalStatus.condLevel = condLevel;
        newLocalStatus.setHLId(hashCode());
        newLocalStatus.setUnfCopy(getUnfCopy());
        return newLocalStatus;
    }

    @Override
    public Pair<BoolExpr, MapSSA> encodeDF(MapSSA map, Context ctx) {
        if(mainThread != null){
            Expr z3Reg = ssaReg(reg, map.getFresh(reg), ctx);
            this.ssaRegIndex = map.get(reg);
            return new Pair<>(ctx.mkAnd(
                    ctx.mkImplies(storeEvent.executes(ctx), ctx.mkEq(z3Reg, expr.toZ3(map, ctx))),
                    ctx.mkImplies(ctx.mkNot(storeEvent.executes(ctx)), ctx.mkEq(z3Reg, new AConst(1).toZ3(map, ctx)))
            ), map);
        }
        throw new RuntimeException("Main thread is not set for " + toString());
    }
}
