package com.dat3m.dartagnan.wmm.relation.base.stat;

import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;

public class RelEmpty extends StaticRelation {

    public RelEmpty(String name) {
        super(name);
        term = name;
    }

    public void initializeRelationAnalysis(RelationAnalysis.Buffer a) {
    }
}
