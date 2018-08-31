package dartagnan.expression;

import com.microsoft.z3.Context;
import com.microsoft.z3.IntExpr;

public interface IntExprInterface {

    IntExpr getLastValueExpr(Context ctx);
}
