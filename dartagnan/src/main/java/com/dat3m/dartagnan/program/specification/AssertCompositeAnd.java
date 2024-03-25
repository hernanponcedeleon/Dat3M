package com.dat3m.dartagnan.program.specification;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.Register;
import org.sosy_lab.java_smt.api.BooleanFormula;

import java.util.ArrayList;
import java.util.List;

public class AssertCompositeAnd extends AbstractAssert {

    private final AbstractAssert a1;
    private final AbstractAssert a2;

    public AbstractAssert getLeft() {
        return a1;
    }

    public AbstractAssert getRight() {
        return a2;
    }

    public AssertCompositeAnd(AbstractAssert a1, AbstractAssert a2) {
        this.a1 = a1;
        this.a2 = a2;
    }

    @Override
    public BooleanFormula encode(EncodingContext ctx) {
        return ctx.getBooleanFormulaManager().and(a1.encode(ctx), a2.encode(ctx));
    }

    @Override
    public String toString() {
        return a1 + " && " + a2;
    }

    @Override
    public List<Register> getRegs() {
        List<Register> regs = new ArrayList<>();
        regs.addAll(a1.getRegs());
        regs.addAll(a2.getRegs());
        return regs;
    }
}
