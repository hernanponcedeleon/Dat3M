package com.dat3m.dartagnan.wmm.relation.base.stat;

import com.dat3m.dartagnan.program.filter.FilterAbstract;

public class RelCartesian extends StaticRelation {
    private final FilterAbstract filter1;
    private final FilterAbstract filter2;

    public FilterAbstract getFirstFilter() {
    	return filter1;
    }
    
    public FilterAbstract getSecondFilter() {
    	return filter2;
    }

    public static String makeTerm(FilterAbstract filter1, FilterAbstract filter2){
        return "(" + filter1 + "*" + filter2 + ")";
    }

    public RelCartesian(FilterAbstract filter1, FilterAbstract filter2) {
        this.filter1 = filter1;
        this.filter2 = filter2;
        this.term = makeTerm(filter1, filter2);
    }

    public RelCartesian(FilterAbstract filter1, FilterAbstract filter2, String name) {
        super(name);
        this.filter1 = filter1;
        this.filter2 = filter2;
        this.term = makeTerm(filter1, filter2);
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitProduct(this, filter1, filter2);
    }
}
