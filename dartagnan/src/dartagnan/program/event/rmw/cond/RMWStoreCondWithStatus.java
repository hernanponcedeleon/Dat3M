package dartagnan.program.event.rmw.cond;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import dartagnan.expression.AConst;
import dartagnan.expression.ExprInterface;
import dartagnan.program.memory.Location;
import dartagnan.program.Register;
import dartagnan.program.event.rmw.RMWLoad;
import dartagnan.program.event.rmw.RMWStore;
import dartagnan.program.event.utils.RegReaderData;
import dartagnan.program.event.utils.RegWriter;
import dartagnan.utils.MapSSA;
import dartagnan.utils.Pair;

import static dartagnan.utils.Utils.ssaLoc;
import static dartagnan.utils.Utils.ssaReg;

public class RMWStoreCondWithStatus extends RMWStore implements RegWriter, RegReaderData {

    private Register statusReg;
    private int ssaRegIndex;
    private RMWStoreCondWithStatus clone;

    public RMWStoreCondWithStatus(Register statusReg, RMWLoad loadEvent, Location location, ExprInterface value, String atomic){
        super(loadEvent, location, value, atomic);
        this.statusReg = statusReg;
        this.condLevel = 0;
    }

    @Override
    public Register getModifiedReg(){
        return statusReg;
    }

    @Override
    public int getSsaRegIndex() {
        return ssaRegIndex;
    }

    @Override
    public String toString() {
        return nTimesCondLevel() + statusReg + " = (" + loc + " := " + value + ")";
    }

    @Override
    public BoolExpr encodeCF(Context ctx) {
        return ctx.mkImplies(ctx.mkNot(ctx.mkBoolConst(cfVar())), ctx.mkNot(executes(ctx)));
    }

    @Override
    public void beforeClone(){
        clone = null;
    }

    @Override
    public RMWStoreCondWithStatus clone() {
        if(clone == null){
            clone = new RMWStoreCondWithStatus(statusReg.clone(), loadEvent.clone(), loc.clone(), value.clone(), atomic);
            clone.condLevel = condLevel;
            clone.setHLId(getHLId());
            clone.setUnfCopy(getUnfCopy());
        }
        return clone;
    }

    @Override
    public Pair<BoolExpr, MapSSA> encodeDF(MapSSA map, Context ctx) {
        if(mainThread != null){
            Expr z3Expr = value.toZ3(map, ctx);
            Expr z3Loc = ssaLoc(loc, mainThread.getTId(), map.getFresh(loc), ctx);
            this.ssaLocMap.put(loc, z3Loc);
            Expr z3Reg = ssaReg(statusReg, map.getFresh(statusReg), ctx);
            this.ssaRegIndex = map.get(statusReg);
            BoolExpr enc = ctx.mkAnd(
                    ctx.mkImplies(executes(ctx), ctx.mkAnd(
                            ctx.mkEq(z3Reg, new AConst(0).toZ3(map, ctx)),
                            value.encodeAssignment(map, ctx, z3Loc, z3Expr))
                    ),
                    ctx.mkImplies(ctx.mkNot(executes(ctx)), ctx.mkEq(z3Reg, new AConst(1).toZ3(map, ctx)))
            );
            return new Pair<>(enc, map);
        }
        throw new RuntimeException("Main thread is not set for " + toString());
    }
}
