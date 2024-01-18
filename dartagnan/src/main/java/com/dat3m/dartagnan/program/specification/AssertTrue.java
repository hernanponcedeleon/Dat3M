package com.dat3m.dartagnan.program.specification;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.Register;
import org.sosy_lab.java_smt.api.BooleanFormula;

import java.util.Collections;
import java.util.List;

public class AssertTrue extends AbstractAssert {

    @Override
    public BooleanFormula encode(EncodingContext ctx) {
        return ctx.getBooleanFormulaManager().makeTrue();
    }

    @Override
    public String toString() {
        return "true";
    }

    @Override
    public List<Register> getRegs() {
        return Collections.emptyList();
    }
}
