package com.dat3m.dartagnan.wmm.relation.base.memory;

import com.dat3m.dartagnan.wmm.Definition;

import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.RF;

public class RelRf extends Definition {

    public RelRf(){
        term = RF;
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitReadFrom(this);
    }
}