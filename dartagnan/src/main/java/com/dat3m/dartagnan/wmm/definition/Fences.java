package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.program.filter.FilterAbstract;
import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;

public class Fences extends Definition {

    private final FilterAbstract filter;

    public Fences(Relation r0, FilterAbstract s1) {
        super(r0, "fencerel(" + s1 + ")");
        filter = s1;
    }

    public FilterAbstract getFilter() { return filter; }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitFences(definedRelation, filter);
    }

}
