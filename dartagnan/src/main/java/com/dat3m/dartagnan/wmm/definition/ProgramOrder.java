package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.program.filter.Filter;
import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;

public class ProgramOrder extends Definition {

    private final Filter filter;

    public ProgramOrder(Relation r0, Filter s1) {
        super(r0, "po(" + s1 + ")");
        filter = s1;
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitProgramOrder(definedRelation, filter);
    }

}
