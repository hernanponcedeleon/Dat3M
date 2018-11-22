package dartagnan.program.event.address;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.IntExpr;
import dartagnan.program.Register;
import dartagnan.program.event.utils.RegReaderAddress;
import dartagnan.program.event.utils.RegWriter;
import dartagnan.program.memory.Location;
import dartagnan.program.utils.EType;
import dartagnan.utils.MapSSA;
import dartagnan.utils.Pair;

import static dartagnan.utils.Utils.ssaLoc;
import static dartagnan.utils.Utils.ssaReg;

public class LoadFromAddress extends MemEventAddress implements RegWriter, RegReaderAddress {

    private Register register;
    private int ssaRegIndex;

    public LoadFromAddress(Register register, Register address, String atomic) {
        this.register = register;
        this.address = address;
        this.condLevel = 0;
        this.atomic = atomic;
        addFilters(EType.ANY, EType.MEMORY, EType.READ);
    }

    @Override
    public Register getModifiedReg(){
        return register;
    }

    @Override
    public String toString() {
        // TODO: Figure out better representation
        return nTimesCondLevel() + register + " <- " + address;
    }

    @Override
    public String label(){
        // TODO: Figure out better representation
        return "R[" + atomic + "] " + address;
    }

    @Override
    public LoadFromAddress clone() {
        LoadFromAddress newLoad = new LoadFromAddress(register.clone(), address.clone(), atomic);
        newLoad.condLevel = condLevel;
        newLoad.setHLId(getHLId());
        newLoad.setUnfCopy(getUnfCopy());
        return newLoad;
    }

    @Override
    public Pair<BoolExpr, MapSSA> encodeDF(MapSSA map, Context ctx) {
        if(mainThread == null){
            throw new RuntimeException("Main thread is not set for " + toString());
        }
        if(locations == null){
            throw new RuntimeException("Location set is not specified for " + toString());
        }

        Expr z3Reg = ssaReg(register, map.getFresh(register), ctx);
        this.ssaRegIndex = map.get(register);
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
