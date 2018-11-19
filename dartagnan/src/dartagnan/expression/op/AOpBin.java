package dartagnan.expression.op;

import com.microsoft.z3.ArithExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.IntExpr;

public enum AOpBin {
    PLUS, MINUS, MULT, DIV, AND, OR, XOR, L_SHIFT, R_SHIFT, AR_SHIFT;

    @Override
    public String toString() {
        switch(this){
            case PLUS:
                return "+";
            case MINUS:
                return "-";
            case MULT:
                return "*";
            case DIV:
                return "/";
            case AND:
                return "&";
            case OR:
                return "|";
            case XOR:
                return "^";
            case L_SHIFT:
                return "<<";
            case R_SHIFT:
                return ">>";
            case AR_SHIFT:
                return ">>";
        }
        return super.toString();
    }

    public String toLinuxName(){
        switch(this){
            case PLUS:
                return "add";
            case MINUS:
                return "sub";
        }
        throw new UnsupportedOperationException("Linux op name is not defined for " + this);
    }

    public ArithExpr encode(ArithExpr e1, ArithExpr e2, Context ctx){
        switch(this){
            case PLUS:
                return ctx.mkAdd(e1, e2);
            case MINUS:
                return ctx.mkSub(e1, e2);
            case MULT:
                return ctx.mkMul(e1, e2);
            case DIV:
                return ctx.mkDiv(e1, e2);
            case AND:
                return ctx.mkBV2Int(ctx.mkBVAND(ctx.mkInt2BV(32, (IntExpr) e1), ctx.mkInt2BV(32, (IntExpr)e2)), false);
            case OR:
                return ctx.mkBV2Int(ctx.mkBVOR(ctx.mkInt2BV(32, (IntExpr) e1), ctx.mkInt2BV(32, (IntExpr) e2)), false);
            case XOR:
                return ctx.mkBV2Int(ctx.mkBVXOR(ctx.mkInt2BV(32, (IntExpr) e1), ctx.mkInt2BV(32, (IntExpr) e2)), false);
        }
        throw new UnsupportedOperationException("Encoding of not supported for AOpBin " + this);
    }
}
