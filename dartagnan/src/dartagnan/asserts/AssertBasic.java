package dartagnan.asserts;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.expression.IntExprInterface;
import dartagnan.program.Register;

public class AssertBasic extends AbstractAssert{

    private IntExprInterface e1;
    private String op;
    private IntExprInterface e2;

    public AssertBasic(IntExprInterface e1, String op, IntExprInterface e2){
        this.e1 = e1;
        this.op = op;
        this.e2 = e2;
    }

    public BoolExpr encode(Context ctx) throws Z3Exception {
        switch(op){
            case "==":
                return ctx.mkEq(e1.getLastValueExpr(ctx), e2.getLastValueExpr(ctx));
            case "!=":
                return ctx.mkNot(ctx.mkEq(e1.getLastValueExpr(ctx), e2.getLastValueExpr(ctx)));
        }
        throw new RuntimeException("Unrecognised assertion option");
    }

    public String toString(){
        return valueToString(e1) + op + valueToString(e2);
    }

    private String valueToString(IntExprInterface value){
        if(value instanceof Register){
            return ((Register)value).getPrintMainThread() + ":" + value;
        }
        return value.toString();
    }
}
