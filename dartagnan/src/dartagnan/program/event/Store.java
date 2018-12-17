package dartagnan.program.event;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.IntExpr;
import dartagnan.expression.ExprInterface;
import dartagnan.expression.IExpr;
import dartagnan.program.Register;
import dartagnan.program.event.utils.RegReaderData;
import dartagnan.program.memory.Location;
import dartagnan.program.utils.EType;
import dartagnan.utils.MapSSA;
import dartagnan.utils.Pair;

import java.util.HashSet;
import java.util.Set;

import static dartagnan.utils.Utils.ssaLoc;

public class Store extends MemEvent implements RegReaderData {

    protected ExprInterface value;

    public Store(IExpr address, ExprInterface value, String atomic){
        this.address = address;
        this.atomic = atomic;
        this.condLevel = 0;
        this.value = value;
        addFilters(EType.ANY, EType.MEMORY, EType.WRITE);
    }

    @Override
    public Set<Register> getDataRegs(){
        Set<Register> regs = new HashSet<>();
        if(value instanceof Register){
            regs.add((Register) value);
        }
        return regs;
    }

    @Override
    public String toString() {
        return nTimesCondLevel() + "memory[" + address + "] := " + value;
    }

    @Override
    public String label(){
        return "W_" + atomic;
    }

    @Override
    public Store clone() {
        if(clone == null){
            clone = new Store(address.clone(), value.clone(), atomic);
            afterClone();
        }
        return (Store)clone;
    }

    @Override
    public Pair<BoolExpr, MapSSA> encodeDF(MapSSA map, Context ctx) {
        if(mainThread == null){
            throw new RuntimeException("Main thread is not set for " + toString());
        }
        if(locations == null){
            throw new RuntimeException("Location set is not specified for " + toString());
        }

        IntExpr z3Expr = value.toZ3Int(map, ctx);
        addressExpr = address.toZ3Int(map, ctx);
        BoolExpr enc = ctx.mkTrue();

        for(Location loc : locations){
            IntExpr z3Loc = ssaLoc(loc, mainThread.getTId(), map.getFresh(loc), ctx);
            this.ssaLocMap.put(loc, z3Loc);
            enc = ctx.mkAnd(enc, ctx.mkImplies(
                    ctx.mkAnd(executes(ctx), ctx.mkEq(addressExpr, loc.getAddress().toZ3Int(ctx))),
                    ctx.mkEq(z3Loc, z3Expr)
            ));
        }
        return new Pair<>(enc, map);
    }
}
