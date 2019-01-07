package dartagnan.expression;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.IntExpr;
import com.microsoft.z3.Model;
import dartagnan.program.Register;
import dartagnan.program.event.Event;

import java.util.Set;

public interface ExprInterface {

    IntExpr toZ3Int(Event e, Context ctx);

    BoolExpr toZ3Bool(Event e, Context ctx);

    int getIntValue(Event e, Context ctx, Model model);

    boolean getBoolValue(Event e, Context ctx, Model model);

    Set<Register> getRegs();

    ExprInterface clone();
}
