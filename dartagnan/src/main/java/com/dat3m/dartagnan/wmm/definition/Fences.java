package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.program.filter.Filter;
import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;

public class Fences extends Definition {

    private final Filter filter;

    public Fences(Relation r0, Filter s1) {
        super(r0, "fencerel(" + s1 + ")");
        filter = s1;
    }

    public Filter getFilter() { return filter; }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitFences(this);
    }

}
