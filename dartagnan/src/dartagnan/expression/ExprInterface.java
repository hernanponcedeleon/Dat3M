package dartagnan.expression;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import dartagnan.program.Register;
import dartagnan.utils.MapSSA;

import java.util.Set;

public interface ExprInterface {

    Expr toZ3(MapSSA map, Context ctx);

    Set<Register> getRegs();

    ExprInterface clone();

    BoolExpr encodeAssignment(MapSSA map, Context ctx, Expr target, Expr value);
}
