package dartagnan.program.event.rmw;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.Z3Exception;
import dartagnan.expression.AExpr;
import dartagnan.program.Location;
import dartagnan.program.Register;
import dartagnan.program.event.Load;
import dartagnan.utils.MapSSA;
import dartagnan.utils.Pair;

import java.util.Collections;

import static dartagnan.utils.Utils.ssaLoc;

// TODO: Support for conversion from BExpr
public class RMWStoreUnless extends RMWStore {

    private AExpr cmp;
    private Register cmpReg;

    public RMWStoreUnless(Load loadEvent, Location loc, AExpr cmp, AExpr val, String atomic) {
        super(loadEvent, loc, val, atomic);
        this.cmp = cmp;
        this.cmpReg = (cmp instanceof Register) ? (Register) cmp : null;
    }

    public RMWStore clone() {
        Location newLoc = loc.clone();
        Load newLoad = loadEvent.clone();
        AExpr newCmp = cmp.clone();
        AExpr newVal = (AExpr) val.clone();
        RMWStoreUnless newStore = new RMWStoreUnless(newLoad, newLoc, newCmp, newVal, atomic);
        newStore.condLevel = condLevel;
        newStore.setHLId(getHLId());
        newStore.setUnfCopy(getUnfCopy());
        return newStore;
    }

    public String toString() {
        return String.format("%s%s == %s ? %s := %s", String.join("", Collections.nCopies(condLevel, "  ")), loc, cmp, loc, val);
    }

    public Pair<BoolExpr, MapSSA> encodeDF(MapSSA map, Context ctx) throws Z3Exception {
        if(mainThread == null){
            throw new RuntimeException("Main thread is not set in " + this);
        }

        Expr z3LocOld = ssaLoc(loc, mainThread, map.get(loc), ctx);
        Expr z3LocNew = ssaLoc(loc, mainThread, map.getFresh(loc), ctx);
        this.ssaLoc = z3LocNew;

        Expr z3Val = encodeValue(map, ctx, reg, (AExpr) val);
        Expr z3Cmp = encodeValue(map, ctx, cmpReg, cmp);

        return new Pair<BoolExpr, MapSSA>(ctx.mkImplies(executes(ctx),
                ctx.mkOr(
                        ctx.mkAnd(ctx.mkNot(ctx.mkEq(z3LocOld, z3Cmp)), ctx.mkEq(z3LocNew, z3Val)),
                        ctx.mkAnd(ctx.mkEq(z3LocOld, z3Cmp), ctx.mkEq(z3LocNew, z3LocOld))
                )
        ), map);
    }
}
