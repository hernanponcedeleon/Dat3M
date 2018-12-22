package dartagnan.program.event;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import dartagnan.expression.ExprInterface;
import dartagnan.expression.IExpr;
import dartagnan.program.Register;
import dartagnan.program.event.utils.RegReaderData;
import dartagnan.program.utils.EType;
import dartagnan.utils.MapSSA;
import dartagnan.utils.Pair;

import java.util.HashSet;
import java.util.Set;

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
        return nTimesCondLevel() + "store(*" + address + ", " + value + (atomic != null ? ", " + atomic : "") + ")";
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
        valueExpr = value.toZ3Int(map, ctx);
        addressExpr = address.toZ3Int(map, ctx);
        return new Pair<>(ctx.mkImplies(executes(ctx), ctx.mkTrue()), map);
    }
}
