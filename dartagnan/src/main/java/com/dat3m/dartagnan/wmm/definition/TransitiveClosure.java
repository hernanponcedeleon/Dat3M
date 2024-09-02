package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;

import java.util.List;

import static com.google.common.base.Preconditions.checkNotNull;

public class TransitiveClosure extends Definition {

    private final Relation r1;

    public TransitiveClosure(Relation r0, Relation r1) {
        super(r0, "%s^+");
        this.r1 = checkNotNull(r1);
    }

    public Relation getOperand() { return r1; }

    @Override
    public TransitiveClosure updateComponents(Wmm wmm, Object oldObj, Object newObj) {
        Relation newR1 = oldObj == r1 ? (Relation) newObj :
                r1.getDefinition().updateComponents(wmm, oldObj, newObj).getDefinedRelation();
        if (newR1 != r1) {
            TransitiveClosure newTransitiveClosure = new TransitiveClosure(wmm.newRelation(), newR1);
            wmm.addDefinition(newTransitiveClosure);
            return newTransitiveClosure;
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
        return v.visitTransitiveClosure(this);
    }

}