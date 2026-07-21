package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.RelationNameRepository;

public class ProgramOrder extends Definition {

    public ProgramOrder(Relation r0) {
        super(Relation.checkIsRelation(r0), RelationNameRepository.PO);
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitProgramOrder(this);
    }

}
