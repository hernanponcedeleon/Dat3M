package dartagnan.expression;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.IntExpr;
import dartagnan.expression.op.IOpBin;
import dartagnan.program.Register;
import dartagnan.utils.MapSSA;

import java.util.HashSet;
import java.util.Set;

public class IExprBin extends IExpr implements ExprInterface {

    private ExprInterface lhs;
    private ExprInterface rhs;
    private IOpBin op;

    public IExprBin(ExprInterface lhs, IOpBin op, ExprInterface rhs) {
        this.lhs = lhs;
        this.rhs = rhs;
        this.op = op;
    }

    @Override
    public IntExpr toZ3Int(MapSSA map, Context ctx) {
        return op.encode(lhs.toZ3Int(map, ctx), rhs.toZ3Int(map, ctx), ctx);
    }

    @Override
    public BoolExpr toZ3Bool(MapSSA map, Context ctx) {
        return ctx.mkGt(toZ3Int(map, ctx), ctx.mkInt(0));
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
}
