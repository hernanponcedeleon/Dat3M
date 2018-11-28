package dartagnan.program.event;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.IntExpr;
import dartagnan.expression.AExpr;
import dartagnan.program.Register;
import dartagnan.program.event.utils.RegReaderAddress;
import dartagnan.program.event.utils.RegWriter;
import dartagnan.program.memory.Location;
import dartagnan.program.utils.EType;
import dartagnan.utils.MapSSA;
import dartagnan.utils.Pair;

import static dartagnan.utils.Utils.ssaLoc;
import static dartagnan.utils.Utils.ssaReg;

public class Load extends MemEvent implements RegWriter, RegReaderAddress {

    protected IntExpr addressExpr;
    protected Register reg;
    protected int ssaRegIndex;

    public Load(Register register, AExpr address, String atomic) {
        this.reg = register;
        this.address = address;
        this.condLevel = 0;
        this.atomic = atomic;
        addFilters(EType.ANY, EType.MEMORY, EType.READ);
    }

    @Override
    public Register getModifiedReg(){
        return reg;
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
    public Load clone() {
        if(clone == null){
            clone = new Load(reg.clone(), address.clone(), atomic);
            afterClone();
        }
        return (Load)clone;
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
