package com.dat3m.dartagnan.asserts;

import java.util.Collections;
import java.util.List;

import com.dat3m.dartagnan.encoding.EncodingContext;
import org.sosy_lab.java_smt.api.BooleanFormula;

import com.dat3m.dartagnan.program.Register;

public class AssertTrue extends AbstractAssert {

    @Override
    public BooleanFormula encode(EncodingContext ctx) {
    	// We want the verification to succeed so it should be UNSAT
        return ctx.getBooleanFormulaManager().makeFalse();
    }

    @Override
    public String toString(){
        return "true";
    }

    @Override
	public List<Register> getRegs() {
		return Collections.emptyList();
	}
}
