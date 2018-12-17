package dartagnan.expression;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.IntExpr;
import dartagnan.program.Register;
import dartagnan.utils.MapSSA;

import java.util.Set;

public interface ExprInterface {

    IntExpr toZ3Int(MapSSA map, Context ctx);

    BoolExpr toZ3Bool(MapSSA map, Context ctx);

    Set<Register> getRegs();

    ExprInterface clone();
}
