package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.program.filter.FilterAbstract;
import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;

//TODO: This relation may contain non-visible events. Is this reasonable?
public class Identity extends Definition {

    private final FilterAbstract filter;

    public Identity(Relation r0, FilterAbstract s1) {
        super(r0, "[" + s1 + "]");
        filter = s1;
    }

    public FilterAbstract getFilter() {
        return filter;
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitIdentity(definedRelation, filter);
    }
}
