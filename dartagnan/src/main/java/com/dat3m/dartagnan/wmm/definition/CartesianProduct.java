package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.program.filter.FilterAbstract;
import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;

public class CartesianProduct extends Definition {
    private final FilterAbstract filter1;
    private final FilterAbstract filter2;

    public FilterAbstract getFirstFilter() {
    	return filter1;
    }
    
    public FilterAbstract getSecondFilter() {
    	return filter2;
    }

    public CartesianProduct(Relation r0, FilterAbstract s1, FilterAbstract s2) {
        super(r0, s1 + "*" + s2);
        filter1 = s1;
        filter2 = s2;
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitProduct(definedRelation, filter1, filter2);
    }
}
