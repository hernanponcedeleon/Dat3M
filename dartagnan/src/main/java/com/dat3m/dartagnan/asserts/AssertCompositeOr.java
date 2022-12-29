package com.dat3m.dartagnan.asserts;

import java.util.ArrayList;
import java.util.List;

import com.dat3m.dartagnan.encoding.EncodingContext;
import org.sosy_lab.java_smt.api.BooleanFormula;

import com.dat3m.dartagnan.program.Register;

public class AssertCompositeOr extends AbstractAssert {

    private final AbstractAssert a1;
    private final AbstractAssert a2;

    public AssertCompositeOr(AbstractAssert a1, AbstractAssert a2){
        this.a1 = a1;
        this.a2 = a2;
    }

    @Override
    public BooleanFormula encode(EncodingContext ctx) {
        return ctx.getBooleanFormulaManager().or(a1.encode(ctx), a2.encode(ctx));
    }

    @Override
    public String toString() {
        return "(" + a1 + " || " + a2 + ")";
    }

    @Override
	public List<Register> getRegs() {
		List<Register> regs = new ArrayList<>();
		regs.addAll(a1.getRegs());
		regs.addAll(a2.getRegs());
		return regs;
	}
}
