package porthosc.languages.syntax.zformula;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import porthosc.utils.patterns.Builder;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;


public class ZFormulaBuilder implements Builder<BoolExpr> {

    private final Context ctx;
    private List<BoolExpr> assertions;

    public ZFormulaBuilder(Context ctx) {
        this.ctx = ctx;
        this.assertions = new ArrayList<>();
    }

    @Override
    public BoolExpr build() {
        return ctx.mkAnd(assertions.toArray(new BoolExpr[0]));
    }

    public void addAssert(BoolExpr assertion) {
        if (assertion != null) {
            assertions.add(assertion);
        }
    }

    public void addAsserts(Collection<BoolExpr> assertions) {
        for (BoolExpr assertion : assertions) {
            addAssert(assertion);
        }
    }
}
