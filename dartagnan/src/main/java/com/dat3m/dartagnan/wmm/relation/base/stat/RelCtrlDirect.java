package com.dat3m.dartagnan.wmm.relation.base.stat;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;

import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.CTRLDIRECT;

//TODO: We can restrict the codomain to visible events as the only usage of this Relation is in
// ctrl := idd^+;ctrlDirect & (R*V)
public class RelCtrlDirect extends Definition {

    public RelCtrlDirect(Relation r0) {
        super(r0, CTRLDIRECT);
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitControl(definedRelation);
    }
}
