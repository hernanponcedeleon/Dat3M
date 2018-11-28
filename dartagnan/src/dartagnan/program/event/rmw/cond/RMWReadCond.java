package dartagnan.program.event.rmw.cond;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.IntExpr;
import dartagnan.expression.AExpr;
import dartagnan.expression.ExprInterface;
import dartagnan.program.event.rmw.RMWLoad;
import dartagnan.program.Register;
import dartagnan.program.event.utils.RegReaderAddress;
import dartagnan.program.event.utils.RegReaderData;
import dartagnan.program.event.utils.RegWriter;
import dartagnan.program.memory.Location;
import dartagnan.utils.MapSSA;
import dartagnan.utils.Pair;

import java.util.HashSet;
import java.util.Set;

import static dartagnan.utils.Utils.ssaLoc;
import static dartagnan.utils.Utils.ssaReg;

public abstract class RMWReadCond extends RMWLoad implements RegWriter, RegReaderData, RegReaderAddress {

    protected ExprInterface cmp;
    protected BoolExpr z3Cond;

    public RMWReadCond(Register reg, ExprInterface cmp, AExpr address, String atomic) {
        super(reg, address, atomic);
        this.cmp = cmp;
    }

    public BoolExpr getCond(){
        if(z3Cond != null){
            return z3Cond;
        }
        // encodeDF must be called before encodeCF, otherwise this exception will be thrown
        throw new RuntimeException("z3Cond is requested before it has been initialised in " + this.getClass().getName());
    }

    @Override
    public Set<Register> getDataRegs(){
        Set<Register> regs = new HashSet<>();
        if(cmp instanceof Register){
            regs.add((Register) cmp);
        }
        return regs;
    }

    @Override
    public Pair<BoolExpr, MapSSA> encodeDF(MapSSA map, Context ctx) {
        if(mainThread == null){
            throw new RuntimeException("Main thread is not set for " + toString());
        }
        if(locations == null){
            throw new RuntimeException("Location set is not specified for " + toString());
        }

        Expr z3Reg = ssaReg(reg, map.getFresh(reg), ctx);
        this.ssaRegIndex = map.get(reg);
        this.z3Cond = ctx.mkEq(z3Reg, encodeValue(map, ctx, cmp));
        addressExpr = (IntExpr) address.toZ3(map, ctx);
        BoolExpr enc = ctx.mkTrue();

        for(Location loc : locations){
            Expr z3Loc = ssaLoc(loc, mainThread.getTId(), map.getFresh(loc), ctx);
            this.ssaLocMap.put(loc, z3Loc);
            enc = ctx.mkAnd(enc, ctx.mkImplies(
                    ctx.mkAnd(executes(ctx), ctx.mkEq(addressExpr, loc.getAddress().toZ3(ctx))),
                    ctx.mkEq(z3Reg, z3Loc)
            ));
        }
        return new Pair<>(enc, map);
    }

    @Override
    public abstract RMWReadCond clone();

    private Expr encodeValue(MapSSA map, Context ctx, ExprInterface v){
        if(v instanceof Register){
            return ssaReg((Register) v, map.get(v), ctx);
        }
        return ctx.mkInt(v.toString());
    }
}
