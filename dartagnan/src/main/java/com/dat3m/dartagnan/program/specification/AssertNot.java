package com.dat3m.dartagnan.program.specification;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.Register;
import com.google.common.base.Preconditions;
import org.sosy_lab.java_smt.api.BooleanFormula;

import java.util.List;

public class AssertNot extends AbstractAssert {

    private final AbstractAssert child;

    public AssertNot(AbstractAssert child) {
        Preconditions.checkNotNull(child, "Empty assertion clause in " + this.getClass().getName());
        this.child = child;
    }

    AbstractAssert getChild() {
        return child;
    }

    @Override
    public BooleanFormula encode(EncodingContext ctx) {
        return ctx.getBooleanFormulaManager().not(child.encode(ctx));
    }

    @Override
    public String toString() {
        return "!" + child.toString();
    }

    @Override
    public List<Register> getRegs() {
        return child.getRegs();
    }
}