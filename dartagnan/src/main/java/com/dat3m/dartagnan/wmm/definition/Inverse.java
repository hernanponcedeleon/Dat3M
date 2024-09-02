package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;

import java.util.List;

import static com.google.common.base.Preconditions.checkNotNull;

public class Inverse extends Definition {
    //TODO/Note: We can forward getSMTVar calls
    // to avoid encoding this completely!

    private final Relation r1;

    public Inverse(Relation r0, Relation r1) {
        super(r0, "%s^-1");
        this.r1 = checkNotNull(r1);
    }

    public Relation getOperand() { return r1; }

    @Override
    public Inverse updateComponents(Wmm wmm, Object oldObj, Object newObj) {
        Relation newR1 = oldObj == r1 ? (Relation) newObj : r1.getDefinition().updateComponents(wmm, oldObj, newObj).getDefinedRelation();
        if (newR1 != r1) {
            Inverse newInverse = new Inverse(wmm.newRelation(), newR1);
            wmm.addDefinition(newInverse);
            return newInverse;
        } else {
            return this;
        }
    }

    @Override
    public boolean withoutParametricCall() {
        return r1.getDefinition().withoutParametricCall();
    }

    @Override
    public List<Relation> getConstrainedRelations() {
        return List.of(definedRelation, r1);
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitInverse(this);
    }

}