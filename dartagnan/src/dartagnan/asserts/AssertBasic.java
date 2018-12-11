package dartagnan.asserts;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import dartagnan.expression.IntExprInterface;
import dartagnan.expression.op.COpBin;
import dartagnan.program.Register;

public class AssertBasic extends AbstractAssert{

    private final IntExprInterface e1;
    private final IntExprInterface e2;
    private final COpBin op;

    public AssertBasic(IntExprInterface e1, COpBin op, IntExprInterface e2){
        this.e1 = e1;
        this.e2 = e2;
        this.op = op;
    }

    @Override
    public BoolExpr encode(Context ctx) {
        return op.encode(e1.getLastValueExpr(ctx), e2.getLastValueExpr(ctx), ctx);
    }

    @Override
    public String toString(){
        return valueToString(e1) + op + valueToString(e2);
    }

    @Override
    public AbstractAssert clone(){
        return new AssertBasic(e1.clone(), op, e2.clone());
    }

    private String valueToString(IntExprInterface value){
        if(value instanceof Register){
            return ((Register)value).getPrintMainThreadId() + ":" + value;
        }
        return value.toString();
    }
}
