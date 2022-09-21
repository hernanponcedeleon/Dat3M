package com.dat3m.dartagnan.wmm.relation.base.stat;

import com.dat3m.dartagnan.program.filter.FilterAbstract;
import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;

public class RelFencerel extends Definition {

    private final FilterAbstract filter;

    public RelFencerel(Relation r0, FilterAbstract s1) {
        super(r0, "fencerel(" + s1 + ")");
        filter = s1;
    }

    public FilterAbstract getFilter() { return filter; }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitFences(definedRelation, filter);
    }
}
