package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;

import java.util.List;

import static com.google.common.base.Preconditions.checkNotNull;

public class Difference extends Definition {

    private final Relation minuend;
    private final Relation subtrahend;

    public Difference(Relation r0, Relation r1, Relation r2) {
        super(r0, "%s \\ %s");
        minuend = checkNotNull(r1);
        subtrahend = checkNotNull(r2);
    }

    public Relation getMinuend() { return minuend; }
    public Relation getSubtrahend() { return subtrahend; }

    @Override
    public Difference updateComponents(Wmm wmm, Object oldObj, Object newObj) {
        Relation newMinuend = oldObj == minuend ? (Relation) newObj :
                minuend.getDefinition().updateComponents(wmm, oldObj, newObj).getDefinedRelation();
        Relation newSubtrahend = oldObj == subtrahend ? (Relation) newObj :
                subtrahend.getDefinition().updateComponents(wmm, oldObj, newObj).getDefinedRelation();
        if (newMinuend != minuend || newSubtrahend != subtrahend) {
            Difference newDifference = new Difference(wmm.newRelation(), newMinuend, newSubtrahend);
            wmm.addDefinition(newDifference);
            return newDifference;
        } else {
            return this;
        }
    }

    @Override
    public boolean withoutParametricCall() {
        return minuend.getDefinition().withoutParametricCall() && subtrahend.getDefinition().withoutParametricCall();
    }

    @Override
    public List<Relation> getConstrainedRelations() {
        return List.of(definedRelation, minuend, subtrahend);
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitDifference(this);
    }
}
