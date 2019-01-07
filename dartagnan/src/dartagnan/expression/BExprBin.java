package dartagnan.expression;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Model;
import dartagnan.expression.op.BOpBin;
import dartagnan.program.Register;
import dartagnan.program.event.Event;

import java.util.HashSet;
import java.util.Set;

public class BExprBin extends BExpr {

    private final ExprInterface b1;
    private final ExprInterface b2;
    private final BOpBin op;

    public BExprBin(ExprInterface b1, BOpBin op, ExprInterface b2) {
        this.b1 = b1;
        this.b2 = b2;
        this.op = op;
    }

    @Override
    public BoolExpr toZ3Bool(Event e, Context ctx) {
        return op.encode(b1.toZ3Bool(e, ctx), b2.toZ3Bool(e, ctx), ctx);
    }

    @Override
    public Set<Register> getRegs() {
        Set<Register> setRegs = new HashSet<>();
        setRegs.addAll(b1.getRegs());
        setRegs.addAll(b2.getRegs());
        return setRegs;
    }

    @Override
    public BExprBin clone() {
        return new BExprBin(b1.clone(), op, b2.clone());
    }

    @Override
    public String toString() {
        return "(" + b1 + " " + op + " " + b2 + ")";
    }

    @Override
    public boolean getBoolValue(Event e, Context ctx, Model model){
        return op.combine(b1.getBoolValue(e, ctx, model), b2.getBoolValue(e, ctx, model));
    }
}
