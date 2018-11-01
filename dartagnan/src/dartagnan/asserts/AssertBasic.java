package dartagnan.asserts;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import dartagnan.asserts.utils.Op;
import dartagnan.expression.IntExprInterface;
import dartagnan.program.Register;

public class AssertBasic extends AbstractAssert{

    private final IntExprInterface e1;
    private final IntExprInterface e2;
    private final Op op;

    public AssertBasic(IntExprInterface e1, Op op, IntExprInterface e2){
        this.e1 = e1;
        this.e2 = e2;
        this.op = op;
    }

    @Override
    public BoolExpr encode(Context ctx) {
        switch(op){
            case EQ:
                return ctx.mkEq(e1.getLastValueExpr(ctx), e2.getLastValueExpr(ctx));
            case NEQ:
                return ctx.mkNot(ctx.mkEq(e1.getLastValueExpr(ctx), e2.getLastValueExpr(ctx)));
            case GTE:
                return ctx.mkNot(ctx.mkGe(e1.getLastValueExpr(ctx), e2.getLastValueExpr(ctx)));
            case LTE:
                return ctx.mkNot(ctx.mkLe(e1.getLastValueExpr(ctx), e2.getLastValueExpr(ctx)));
            case GT:
                return ctx.mkNot(ctx.mkGt(e1.getLastValueExpr(ctx), e2.getLastValueExpr(ctx)));
            case LT:
                return ctx.mkNot(ctx.mkLt(e1.getLastValueExpr(ctx), e2.getLastValueExpr(ctx)));
        }
        throw new RuntimeException("Unrecognised assertion option " + op + " in " + this);
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
