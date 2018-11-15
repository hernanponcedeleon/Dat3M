package dartagnan.expression;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import dartagnan.expression.op.BOpUn;
import dartagnan.program.Register;
import dartagnan.utils.MapSSA;

import java.util.HashSet;
import java.util.Set;

public class BExprUn extends BExpr {

    private ExprInterface b;
    private BOpUn op;


    public BExprUn(BOpUn op, ExprInterface b) {
        this.b = b;
        this.op = op;
    }

    public String toString() {
        return "(" + op + " " + b + ")";
    }

    public BExprUn clone() {
        return new BExprUn(op, b.clone());
    }

    @Override
    public BoolExpr toZ3(MapSSA map, Context ctx) {
        return op.encode(b.toZ3Boolean(map, ctx), ctx);
    }

    @Override
    public BoolExpr toZ3Boolean(MapSSA map, Context ctx){
        return toZ3(map, ctx);
    }

    @Override
    public Set<Register> getRegs() {
        return new HashSet<>(b.getRegs());
    }

    @Override
    public BoolExpr encodeAssignment(MapSSA map, Context ctx, Expr target, Expr value){
        return ctx.mkOr(
                ctx.mkAnd((BoolExpr) value, ctx.mkEq(target, ctx.mkInt(1))),
                ctx.mkAnd(ctx.mkNot((BoolExpr) value), ctx.mkEq(target, ctx.mkInt(0)))
        );
    }
}
