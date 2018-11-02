package dartagnan.expression.op;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

public enum BOpBin {
    AND, OR;

    @Override
    public String toString() {
        switch(this){
            case AND:
                return "&&";
            case OR:
                return "||";
        }
        return super.toString();
    }

    public BoolExpr encode(BoolExpr e1, BoolExpr e2, Context ctx) {
        switch(this) {
            case AND:
                return ctx.mkAnd(e1, e2);
            case OR:
                return ctx.mkOr(e1, e2);
        }
        throw new UnsupportedOperationException("Encoding of not supported for BOpBin " + this);
    }
}
