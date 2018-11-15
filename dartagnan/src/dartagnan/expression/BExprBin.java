package dartagnan.expression;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import dartagnan.expression.op.BOpBin;
import dartagnan.program.Register;
import dartagnan.utils.MapSSA;

import java.util.HashSet;
import java.util.Set;

public class BExprBin extends BExpr {

    private ExprInterface b1;
    private ExprInterface b2;
    private BOpBin op;

    public BExprBin(ExprInterface b1, BOpBin op, ExprInterface b2) {
        this.b1 = b1;
        this.b2 = b2;
        this.op = op;
    }

    public String toString() {
        return "(" + b1 + " " + op + " " + b2 + ")";
    }

    public BExprBin clone() {
        return new BExprBin(b1.clone(), op, b2.clone());
    }

    @Override
    public BoolExpr toZ3(MapSSA map, Context ctx) {
        return op.encode(b1.toZ3Boolean(map, ctx), b2.toZ3Boolean(map, ctx), ctx);
    }

    @Override
    public BoolExpr toZ3Boolean(MapSSA map, Context ctx){
        return toZ3(map, ctx);
    }

    @Override
    public Set<Register> getRegs() {
        Set<Register> setRegs = new HashSet<>();
        setRegs.addAll(b1.getRegs());
        setRegs.addAll(b2.getRegs());
        return setRegs;
    }

    @Override
    public BoolExpr encodeAssignment(MapSSA map, Context ctx, Expr target, Expr value){
        return ctx.mkOr(
                ctx.mkAnd((BoolExpr) value, ctx.mkEq(target, ctx.mkInt(1))),
                ctx.mkAnd(ctx.mkNot((BoolExpr) value), ctx.mkEq(target, ctx.mkInt(0)))
        );
    }
}
