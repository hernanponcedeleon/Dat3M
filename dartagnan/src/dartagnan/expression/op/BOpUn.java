package dartagnan.expression.op;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

public enum BOpUn {
    NOT;

    @Override
    public String toString() {
        switch(this){
            case NOT:
                return "!";
        }
        return super.toString();
    }

    public BoolExpr encode(BoolExpr e, Context ctx) {
        switch(this) {
            case NOT:
                return ctx.mkNot(e);
        }
        throw new UnsupportedOperationException("Encoding of not supported for BOpUn " + this);
    }
}
