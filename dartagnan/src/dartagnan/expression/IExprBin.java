package dartagnan.expression;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.IntExpr;
import com.microsoft.z3.Model;
import dartagnan.expression.op.IOpBin;
import dartagnan.program.Register;
import dartagnan.program.event.Event;

import java.util.HashSet;
import java.util.Set;

public class IExprBin extends IExpr implements ExprInterface {

    private final ExprInterface lhs;
    private final ExprInterface rhs;
    private final IOpBin op;

    public IExprBin(ExprInterface lhs, IOpBin op, ExprInterface rhs) {
        this.lhs = lhs;
        this.rhs = rhs;
        this.op = op;
    }

    @Override
    public IntExpr toZ3Int(Event e, Context ctx) {
        return op.encode(lhs.toZ3Int(e, ctx), rhs.toZ3Int(e, ctx), ctx);
    }

    @Override
    public BoolExpr toZ3Bool(Event e, Context ctx) {
        return ctx.mkGt(toZ3Int(e, ctx), ctx.mkInt(0));
    }

    @Override
    public Set<Register> getRegs() {
        Set<Register> setRegs = new HashSet<>();
        setRegs.addAll(lhs.getRegs());
        setRegs.addAll(rhs.getRegs());
        return setRegs;
    }

    @Override
    public IExprBin clone() {
        return new IExprBin(lhs.clone(), op, rhs.clone());
    }

    @Override
    public String toString() {
        return "(" + lhs + " " + op + " " + rhs + ")";
    }

    @Override
    public int getIntValue(Event e, Context ctx, Model model){
        return op.combine(lhs.getIntValue(e, ctx, model), rhs.getIntValue(e, ctx, model));
    }
}
