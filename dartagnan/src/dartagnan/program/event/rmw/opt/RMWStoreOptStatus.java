package dartagnan.program.event.rmw.opt;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import dartagnan.expression.AConst;
import dartagnan.program.Register;
import dartagnan.program.event.Event;
import dartagnan.program.event.utils.RegWriter;
import dartagnan.utils.MapSSA;
import dartagnan.utils.Pair;

import static dartagnan.utils.Utils.ssaReg;

public class RMWStoreOptStatus extends Event implements RegWriter {

    private Register register;
    private RMWStoreOpt storeEvent;
    private int ssaRegIndex;

    public RMWStoreOptStatus(Register register, RMWStoreOpt storeEvent){
        this.register = register;
        this.storeEvent = storeEvent;
    }

    @Override
    public Register getModifiedReg(){
        return register;
    }

    @Override
    public int getSsaRegIndex(){
        return ssaRegIndex;
    }

    @Override
    public String toString() {
        return nTimesCondLevel() + register + " <- exec(" + storeEvent + ")";
    }

    @Override
    public RMWStoreOptStatus clone() {
        if(clone == null){
            clone = new RMWStoreOptStatus(register.clone(), storeEvent.clone());
            afterClone();
        }
        return (RMWStoreOptStatus)clone;
    }

    @Override
    public Pair<BoolExpr, MapSSA> encodeDF(MapSSA map, Context ctx) {
        if(mainThread != null){
            Expr z3Reg = ssaReg(register, map.getFresh(register), ctx);
            this.ssaRegIndex = map.get(register);
            BoolExpr enc = ctx.mkAnd(
                    ctx.mkImplies(storeEvent.executes(ctx), ctx.mkEq(z3Reg, new AConst(0).toZ3Int(map, ctx))),
                    ctx.mkImplies(ctx.mkNot(storeEvent.executes(ctx)), ctx.mkEq(z3Reg, new AConst(1).toZ3Int(map, ctx)))
            );
            return new Pair<>(ctx.mkImplies(executes(ctx), enc), map);
        }
        throw new RuntimeException("Main thread is not set for " + toString());
    }
}
