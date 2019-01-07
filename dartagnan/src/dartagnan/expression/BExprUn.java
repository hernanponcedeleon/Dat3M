package dartagnan.expression;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Model;
import dartagnan.expression.op.BOpUn;
import dartagnan.program.Register;
import dartagnan.program.event.Event;

import java.util.HashSet;
import java.util.Set;

public class BExprUn extends BExpr {

    private final ExprInterface b;
    private final BOpUn op;

    public BExprUn(BOpUn op, ExprInterface b) {
        this.b = b;
        this.op = op;
    }

    @Override
    public BoolExpr toZ3Bool(Event e, Context ctx) {
        return op.encode(b.toZ3Bool(e, ctx), ctx);
    }

    @Override
    public Set<Register> getRegs() {
        return new HashSet<>(b.getRegs());
    }

    @Override
    public BExprUn clone() {
        return new BExprUn(op, b.clone());
    }

    @Override
    public String toString() {
        return "(" + op + " " + b + ")";
    }

    @Override
    public boolean getBoolValue(Event e, Context ctx, Model model){
        return op.combine(b.getBoolValue(e, ctx, model));
    }
}
