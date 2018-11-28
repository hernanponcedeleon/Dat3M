package dartagnan.program.event;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.IntExpr;
import dartagnan.expression.AExpr;
import dartagnan.expression.ExprInterface;
import dartagnan.program.Register;
import dartagnan.program.memory.Location;
import dartagnan.program.event.utils.RegReaderAddress;
import dartagnan.program.event.utils.RegReaderData;
import dartagnan.program.utils.EType;
import dartagnan.utils.MapSSA;
import dartagnan.utils.Pair;

import java.util.HashSet;
import java.util.Set;

import static dartagnan.utils.Utils.ssaLoc;

public class Store extends MemEvent implements RegReaderData, RegReaderAddress {

    protected ExprInterface value;
    protected IntExpr addressExpr;

    public Store(AExpr address, ExprInterface value, String atomic){
        this.value = value;
        this.address = address;
        this.atomic = atomic;
        this.condLevel = 0;
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
    public IntExpr getAddressExpr(Context ctx){
        return addressExpr;
    }

    @Override
    public String toString() {
        return nTimesCondLevel() + "memory[" + address + "] := " + value;
    }

    @Override
    public String label(){
        return "W[" + atomic + "] memory[" + address + "]";
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

        Expr z3Expr = value.toZ3(map, ctx);
        addressExpr = (IntExpr) address.toZ3(map, ctx);
        BoolExpr enc = ctx.mkTrue();

        for(Location loc : locations){
            Expr z3Loc = ssaLoc(loc, mainThread.getTId(), map.getFresh(loc), ctx);
            this.ssaLocMap.put(loc, z3Loc);
            enc = ctx.mkAnd(enc, ctx.mkImplies(
                    ctx.mkAnd(executes(ctx), ctx.mkEq(addressExpr, loc.getAddress().toZ3(ctx))),
                    value.encodeAssignment(map, ctx, z3Loc, z3Expr)
            ));
        }
        return new Pair<>(enc, map);
    }
}
