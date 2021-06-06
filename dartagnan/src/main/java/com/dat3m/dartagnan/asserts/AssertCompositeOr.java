package com.dat3m.dartagnan.asserts;

import com.dat3m.dartagnan.program.memory.Location;
import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

public class AssertCompositeOr extends AbstractAssert {

    private final AbstractAssert a1;
    private final AbstractAssert a2;

    public AssertCompositeOr(AbstractAssert a1, AbstractAssert a2){
        this.a1 = a1;
        this.a2 = a2;
    }

    @Override
    public ImmutableSet<Location> getLocs() {
        return new ImmutableSet.Builder<Location>().addAll(a1.getLocs()).addAll(a2.getLocs()).build();
    }

    @Override
    public AbstractAssert removeLocAssertions(boolean replaceByTrue) {
        return new AssertCompositeOr(a1.removeLocAssertions(replaceByTrue), a2.removeLocAssertions(replaceByTrue));
    }

    @Override
    public BoolExpr encode(Context ctx) {
        return ctx.mkOr(a1.encode(ctx), a2.encode(ctx));
    }

    @Override
    public String toString() {
        return "(" + a1 + " || " + a2 + ")";
    }
}
