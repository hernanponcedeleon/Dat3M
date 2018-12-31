package dartagnan.program.event;

import com.microsoft.z3.Context;
import com.microsoft.z3.IntExpr;
import dartagnan.expression.IExpr;
import dartagnan.program.Register;
import dartagnan.program.event.utils.RegWriter;
import dartagnan.program.utils.EType;

public class Load extends MemEvent implements RegWriter {

    protected Register reg;

    public Load(Register register, IExpr address, String atomic) {
        this.address = address;
        this.atomic = atomic;
        this.condLevel = 0;
        this.reg = register;
        addFilters(EType.ANY, EType.MEMORY, EType.READ);
    }

    @Override
    public void initialise(Context ctx) {
        valueExpr = reg.toZ3IntResult(this, ctx);
        addressExpr = address.toZ3Int(this, ctx);
    }

    @Override
    public Register getModifiedReg(){
        return reg;
    }

    @Override
    public IntExpr getRegResultExpr(){
        return valueExpr;
    }

    @Override
    public String toString() {
        return nTimesCondLevel() + reg + " = load(*" + address + (atomic != null ? ", " + atomic : "") + ")";
    }

    @Override
    public String label(){
        return "R_" + atomic;
    }

    @Override
    public Load clone() {
        if(clone == null){
            clone = new Load(reg.clone(), address.clone(), atomic);
            afterClone();
        }
        return (Load)clone;
    }
}
