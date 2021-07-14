package com.dat3m.dartagnan.asserts;

import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.SolverContext;

import com.dat3m.dartagnan.program.memory.Location;
import com.google.common.collect.ImmutableSet;

public class AssertNot extends AbstractAssert {

    private final AbstractAssert child;

    public AssertNot(AbstractAssert child){
        this.child = child;
    }

    AbstractAssert getChild(){
        return child;
    }

    @Override
    public ImmutableSet<Location> getLocs() {
        return child.getLocs();
    }

    @Override
    public BooleanFormula encode(SolverContext ctx) {
        if(child != null){
            return ctx.getFormulaManager().getBooleanFormulaManager().not(child.encode(ctx));
        }
        throw new RuntimeException("Empty assertion clause in " + this.getClass().getName());
    }

    @Override
    public String toString() {
        return "!" + child.toString();
    }
}
