package dartagnan.expression.op;

import com.microsoft.z3.ArithExpr;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

public enum COpBin {
    EQ, NEQ, GTE, LTE, GT, LT;

    @Override
    public String toString() {
        switch(this){
            case EQ:
                return "==";
            case NEQ:
                return "!=";
            case GTE:
                return ">=";
            case LTE:
                return "<=";
            case GT:
                return ">";
            case LT:
                return "<";
        }
        return super.toString();
    }

    public BoolExpr encode(ArithExpr e1, ArithExpr e2, Context ctx) {
        switch(this) {
            case EQ:
                return ctx.mkEq(e1, e2);
            case NEQ:
                return ctx.mkNot(ctx.mkEq(e1, e2));
            case LT:
                return ctx.mkLt(e1, e2);
            case LTE:
                return ctx.mkLe(e1, e2);
            case GT:
                return ctx.mkGt(e1, e2);
            case GTE:
                return ctx.mkGe(e1, e2);
        }
        throw new UnsupportedOperationException("Encoding of not supported for COpBin " + this);
    }
}
