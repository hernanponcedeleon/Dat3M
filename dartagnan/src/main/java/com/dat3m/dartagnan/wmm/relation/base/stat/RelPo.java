package com.dat3m.dartagnan.wmm.relation.base.stat;

import com.dat3m.dartagnan.program.filter.FilterAbstract;
import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;

public class RelPo extends Definition {

    private final FilterAbstract filter;

    public RelPo(Relation r0, FilterAbstract s1) {
        super(r0, "po(" + s1 + ")");
        filter = s1;
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitProgramOrder(definedRelation, filter);
    }
}
