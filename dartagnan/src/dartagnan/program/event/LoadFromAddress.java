package dartagnan.program.event;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.IntExpr;
import dartagnan.program.Register;
import dartagnan.program.event.utils.RegReaderAddress;
import dartagnan.program.event.utils.RegWriter;
import dartagnan.program.memory.Location;
import dartagnan.utils.MapSSA;
import dartagnan.utils.Pair;

import java.util.Set;

import static dartagnan.utils.Utils.ssaLoc;
import static dartagnan.utils.Utils.ssaReg;

public class LoadFromAddress extends Load implements RegWriter, RegReaderAddress {

    private Register address;
    private IntExpr addressExpr;

    public LoadFromAddress(Register register, Register address, String atomic) {
        super(register, null, atomic);
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
        return nTimesCondLevel() + reg + " <- memory[" + address + "]";
    }

    @Override
    public String label(){
        return "R[" + atomic + "] memory[" + address + "]";
    }

    @Override
    public LoadFromAddress clone() {
        if(clone == null){
            clone = new LoadFromAddress(reg.clone(), address.clone(), atomic);
            afterClone();
        }
        return (LoadFromAddress)clone;
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
    public int getSsaRegIndex() {
        return ssaRegIndex;
    }
}
