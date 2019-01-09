package dartagnan.program.event;

import com.microsoft.z3.Context;
import com.microsoft.z3.IntExpr;
import dartagnan.expression.ExprInterface;
import dartagnan.expression.IExpr;
import dartagnan.program.Register;
import dartagnan.program.event.utils.RegWriter;
import dartagnan.program.utils.EType;

public class Load extends MemEvent implements RegWriter {

    protected Register resultRegister;

    public Load(Register register, IExpr address, String atomic) {
        this.address = address;
        this.atomic = atomic;
        this.condLevel = 0;
        this.resultRegister = register;
        addFilters(EType.ANY, EType.MEMORY, EType.READ);
    }

    @Override
    public void initialise(Context ctx) {
        memValueExpr = resultRegister.toZ3IntResult(this, ctx);
        memAddressExpr = address.toZ3Int(this, ctx);
    }

    @Override
    public Register getResultRegister(){
        return resultRegister;
    }

    @Override
    public IntExpr getResultRegisterExpr(){
        return memValueExpr;
    }

    @Override
    public String toString() {
        return nTimesCondLevel() + resultRegister + " = load(*" + address + (atomic != null ? ", " + atomic : "") + ")";
    }

    @Override
    public String label(){
        return "R_" + atomic;
    }

    @Override
    public Load clone() {
        if(clone == null){
            clone = new Load(resultRegister.clone(), address.clone(), atomic);
            afterClone();
        }
        return (Load)clone;
    }

    @Override
    public ExprInterface getMemValue(){
        return resultRegister;
    }
}
