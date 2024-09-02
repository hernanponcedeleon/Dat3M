package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;

import java.util.List;

import static com.google.common.base.Preconditions.checkNotNull;

public class Composition extends Definition {

    private final Relation left;
    private final Relation right;

    public Composition(Relation r0, Relation r1, Relation r2) {
        super(r0, "%s ; %s");
        left = checkNotNull(r1);
        right = checkNotNull(r2);
    }

    public Relation getLeftOperand() { return left; }
    public Relation getRightOperand() { return right; }

    @Override
    public List<Relation> getConstrainedRelations() {
        return List.of(definedRelation, left, right);
    }

    @Override
    public Composition updateComponents(Wmm wmm, Object oldObj, Object newObj) {
        Relation newLeft = oldObj == left ? (Relation) newObj :
                left.getDefinition().updateComponents(wmm, oldObj, newObj).getDefinedRelation();
        Relation newRight = oldObj == right ? (Relation) newObj :
                right.getDefinition().updateComponents(wmm, oldObj, newObj).getDefinedRelation();
        if (newLeft != left || newRight != right) {
            Composition newComposition = new Composition(wmm.newRelation(), newLeft, newRight);
            wmm.addDefinition(newComposition);
            return newComposition;
        } else {
            return this;
        }
    }

    @Override
    public boolean withoutParametricCall() {
        return left.getDefinition().withoutParametricCall() && right.getDefinition().withoutParametricCall();
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitComposition(this);
    }
}