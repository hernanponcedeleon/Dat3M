package com.dat3m.dartagnan.program.specification;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.Assert;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;

import java.util.ArrayList;
import java.util.List;

public class AssertInline extends AbstractAssert {

    private final Assert assertion;

    public AssertInline(Assert assertion) {
        this.assertion = assertion;
    }

    @Override
    public BooleanFormula encode(EncodingContext ctx) {
        final BooleanFormulaManager bmgr = ctx.getBooleanFormulaManager();
        return bmgr.implication(ctx.execution(assertion),
                ctx.encodeExpressionAsBooleanAt(assertion.getExpression(), assertion));
    }

    @Override
    public String toString() {
        return String.format("%s@%d", assertion.getExpression(), assertion.getGlobalId());
    }

    @Override
    public List<Register> getRegs() {
        return new ArrayList<>(assertion.getExpression().getRegs());
    }
}
