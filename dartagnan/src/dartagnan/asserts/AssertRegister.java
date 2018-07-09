package dartagnan.asserts;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.Register;
import static dartagnan.utils.Utils.lastValueReg;

public class AssertRegister extends AssertInterface{

    private Register register;
    private int value;

    public AssertRegister(Register register, int value){
        this.register = register;
        this.value = value;
    }

    public BoolExpr encode(Context ctx) throws Z3Exception {
        return ctx.mkEq(lastValueReg(register, ctx), ctx.mkInt(value));
    }

    public String toString(){
        return register.getName() + "=" + value;
    }
}
