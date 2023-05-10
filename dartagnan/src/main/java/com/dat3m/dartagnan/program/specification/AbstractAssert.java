package com.dat3m.dartagnan.program.specification;

import java.util.List;

import com.dat3m.dartagnan.encoding.EncodingContext;
import org.sosy_lab.java_smt.api.BooleanFormula;

import com.dat3m.dartagnan.program.Register;

public abstract class AbstractAssert {

    public abstract BooleanFormula encode(EncodingContext context);

    public abstract List<Register> getRegs();
}