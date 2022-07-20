package com.dat3m.dartagnan.wmm.relation.base;

import com.dat3m.dartagnan.wmm.relation.base.stat.StaticRelation;

import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.RMW;

/*
    NOTE: Changes to the semantics of this class may need to be reflected
    in RMWGraph for Refinement!
 */
public class RelRMW extends StaticRelation {

    public RelRMW(){
        term = RMW;
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitReadModifyWrites(this);
    }
}