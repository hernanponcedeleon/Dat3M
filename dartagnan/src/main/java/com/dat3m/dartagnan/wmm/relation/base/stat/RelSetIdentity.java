package com.dat3m.dartagnan.wmm.relation.base.stat;

import com.dat3m.dartagnan.program.filter.FilterAbstract;

//TODO: This relation may contain non-visible events. Is this reasonable?
public class RelSetIdentity extends StaticRelation {

    protected FilterAbstract filter;

    public static String makeTerm(FilterAbstract filter){
        return "[" + filter + "]";
    }

    public RelSetIdentity(FilterAbstract filter) {
        this.filter = filter;
        term = makeTerm(filter);
    }

    public RelSetIdentity(FilterAbstract filter, String name) {
        super(name);
        this.filter = filter;
        term = makeTerm(filter);
    }

    public FilterAbstract getFilter() {
        return filter;
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitIdentity(this, filter);
    }
}
