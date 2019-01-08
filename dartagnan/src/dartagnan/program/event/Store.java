package dartagnan.program.event;

import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.Context;
import dartagnan.expression.ExprInterface;
import dartagnan.expression.IExpr;
import dartagnan.program.Register;
import dartagnan.program.event.utils.RegReaderData;
import dartagnan.program.utils.EType;

public class Store extends MemEvent implements RegReaderData {

    protected ExprInterface value;
    private ImmutableSet<Register> dataRegs;

    public Store(IExpr address, ExprInterface value, String atomic){
        this.address = address;
        this.atomic = atomic;
        this.condLevel = 0;
        this.value = value;
        dataRegs = value.getRegs();
        addFilters(EType.ANY, EType.MEMORY, EType.WRITE);
    }

    @Override
    public void initialise(Context ctx) {
        memValueExpr = value.toZ3Int(this, ctx);
        memAddressExpr = address.toZ3Int(this, ctx);
    }

    @Override
    public ImmutableSet<Register> getDataRegs(){
        return dataRegs;
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
}
