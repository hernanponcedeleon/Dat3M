package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.program.filter.Filter;
import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;

public class CartesianProduct extends Definition {
    private final Filter filter1;
    private final Filter filter2;

    public Filter getFirstFilter() {
    	return filter1;
    }
    
    public Filter getSecondFilter() {
    	return filter2;
    }

    @Override
    public CartesianProduct updateComponents(Wmm wmm, Object oldObj, Object newObj) {
        Filter newFilter1 = oldObj == filter1 ? (Filter) newObj : filter1;
        Filter newFilter2 = oldObj == filter2 ? (Filter) newObj : filter2;
        if (newFilter1 != filter1 || newFilter2 != filter2) {
            CartesianProduct newCartesianProduct = new CartesianProduct(wmm.newRelation(), newFilter1, newFilter2);
            wmm.addDefinition(newCartesianProduct);
            return newCartesianProduct;
        }
        return this;
    }

    public CartesianProduct(Relation r0, Filter s1, Filter s2) {
        super(r0, s1 + "*" + s2);
        filter1 = s1;
        filter2 = s2;
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitProduct(this);
    }
}
