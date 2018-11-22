package dartagnan.program.event.address;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.IntExpr;
import dartagnan.expression.ExprInterface;
import dartagnan.program.memory.Location;
import dartagnan.program.Register;
import dartagnan.program.event.utils.RegReaderAddress;
import dartagnan.program.event.utils.RegReaderData;
import dartagnan.program.utils.EType;
import dartagnan.utils.MapSSA;
import dartagnan.utils.Pair;

import java.util.HashSet;
import java.util.Set;

import static dartagnan.utils.Utils.ssaLoc;

public class StoreToAddress extends MemEventAddress implements RegReaderData, RegReaderAddress {

    protected ExprInterface value;

    public StoreToAddress(Register address, ExprInterface value, String atomic){
        this.address = address;
        this.value = value;
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
    public String toString() {
        // TODO: Figure out better representation
        return nTimesCondLevel() + address + " := " + value;
    }

    @Override
    public String label(){
        // TODO: Figure out better representation
        return "W[" + atomic + "] " + address;
    }

    @Override
    public StoreToAddress clone() {
        StoreToAddress newStore = new StoreToAddress(address.clone(), value.clone(), atomic);
        newStore.condLevel = condLevel;
        newStore.setHLId(getHLId());
        newStore.setUnfCopy(getUnfCopy());
        return newStore;
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
                    ctx.mkAnd(executes(ctx), ctx.mkEq(addressExpr, ctx.mkInt(loc.getAddress()))),
                    value.encodeAssignment(map, ctx, z3Loc, z3Expr)
            ));
        }
        return new Pair<>(enc, map);
    }
}
