package dartagnan.program.event;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.IntExpr;
import dartagnan.expression.ExprInterface;
import dartagnan.program.memory.Location;
import dartagnan.program.Register;
import dartagnan.program.event.utils.RegReaderAddress;
import dartagnan.program.event.utils.RegReaderData;
import dartagnan.utils.MapSSA;
import dartagnan.utils.Pair;

import java.util.Set;

import static dartagnan.utils.Utils.ssaLoc;

public class StoreToAddress extends Store implements RegReaderData, RegReaderAddress {

    private Register address;
    private IntExpr addressExpr;

    public StoreToAddress(Register address, ExprInterface value, String atomic){
        super(null, value, atomic);
        this.address = address;
    }

    @Override
    public void setMaxLocationSet(Set<Location> locations){
        this.locations = locations;
    }

    @Override
    public Register getAddressReg(){
        return address;
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
    public StoreToAddress clone() {
        if(clone == null){
            clone = new StoreToAddress(address.clone(), value.clone(), atomic);
            afterClone();
        }
        return (StoreToAddress)clone;
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
