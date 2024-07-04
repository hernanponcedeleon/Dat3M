package com.dat3m.dartagnan.program.specification;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.Assert;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;

import java.util.Set;

public class AssertInline extends AbstractAssert {

    private final Assert assertion;

    public AssertInline(Assert assertion) {
        this.assertion = assertion;
    }

    public Assert getAssertion() {
        return assertion;
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
    public Set<Register> getRegisters() {
        return assertion.getExpression().getRegs();
    }

    @Override
    public Set<MemoryObject> getMemoryObjects() {
        return assertion.getExpression().getMemoryObjects();
    }
}
