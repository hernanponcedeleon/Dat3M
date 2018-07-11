package dartagnan.asserts;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.Register;

import static dartagnan.utils.Utils.lastValueReg;

public class AssertRegister extends AbstractAssert {

    private String thread;
    private Register register;
    private int value;

    public AssertRegister(String thread, Register register, int value){
        this.thread = thread;
        this.register = register;
        this.value = value;
    }

    public BoolExpr encode(Context ctx) throws Z3Exception {
        return ctx.mkEq(lastValueReg(register, ctx), ctx.mkInt(value));
    }

    public String toString(){
        return thread + ":" + register.getName() + "=" + value;
    }
}
