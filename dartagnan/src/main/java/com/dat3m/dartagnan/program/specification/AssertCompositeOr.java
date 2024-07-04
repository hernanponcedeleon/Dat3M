package com.dat3m.dartagnan.program.specification;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.google.common.collect.Sets;
import org.sosy_lab.java_smt.api.BooleanFormula;

import java.util.Set;

public class AssertCompositeOr extends AbstractAssert {

    private final AbstractAssert a1;
    private final AbstractAssert a2;

    public AssertCompositeOr(AbstractAssert a1, AbstractAssert a2) {
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
    public Set<Register> getRegisters() {
        return Sets.union(a1.getRegisters(), a2.getRegisters());
    }

    @Override
    public Set<MemoryObject> getMemoryObjects() {
        return Sets.union(a1.getMemoryObjects(), a2.getMemoryObjects());
    }
}
