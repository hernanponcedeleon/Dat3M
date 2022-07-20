package com.dat3m.dartagnan.wmm.relation.base.stat;

import com.dat3m.dartagnan.program.filter.FilterAbstract;
import com.dat3m.dartagnan.program.filter.FilterBasic;

public class RelFencerel extends StaticRelation {

    protected FilterAbstract filter;

    public static String makeTerm(FilterAbstract filter){
        return "fencerel(" + filter + ")";
    }

    public RelFencerel(FilterAbstract filter) {
        this.filter = filter;
        term = makeTerm(filter);
    }

    public RelFencerel(FilterAbstract filter, String name) {
        super(name);
        this.filter = filter;
        term = makeTerm(filter);
    }

    public String getFenceName() { return name != null ? name : filter.getName(); }
    public FilterAbstract getFilter() { return filter; }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitFences(this, filter);
    }
}
