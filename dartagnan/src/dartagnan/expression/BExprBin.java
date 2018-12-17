package dartagnan.expression;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
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

    @Override
    public BoolExpr toZ3Bool(MapSSA map, Context ctx) {
        return op.encode(b1.toZ3Bool(map, ctx), b2.toZ3Bool(map, ctx), ctx);
    }

    @Override
    public Set<Register> getRegs() {
        Set<Register> setRegs = new HashSet<>();
        setRegs.addAll(b1.getRegs());
        setRegs.addAll(b2.getRegs());
        return setRegs;
    }

    public BExprBin clone() {
        return new BExprBin(b1.clone(), op, b2.clone());
    }

    public String toString() {
        return "(" + b1 + " " + op + " " + b2 + ")";
    }
}
