package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;

import static com.dat3m.dartagnan.wmm.RelationNameRepository.PARAMETRIC_CALL;
import static com.google.common.base.Preconditions.checkNotNull;

public class ParametricCall extends Definition {
    private final Parametric parametric;
    private final Object parameter;

    public ParametricCall(Relation relation, Parametric parametric, Object parameter) {
        super(relation, PARAMETRIC_CALL);
        this.parametric = checkNotNull(parametric);
        this.parameter = checkNotNull(parameter);
    }

    public Parametric getParametric() {
        return parametric;
    }

    public Object getParameter() {
        return parameter;
    }

    @Override
    public boolean withoutParametricCall() {
        return false;
    }

    @Override
    public ParametricCall updateComponents(Wmm wmm, Object oldObj, Object newObj) {
        Object newParameter = parameter;
        if (oldObj == parameter) {
            newParameter = newObj;
        } else if (parameter instanceof Relation) {
            newParameter = ((Relation) parameter).getDefinition().updateComponents(wmm, oldObj, newObj).getDefinedRelation();
        }
        if (newParameter != parameter) {
            ParametricCall newParametricCall = new ParametricCall(wmm.newRelation(), parametric, newParameter);
            wmm.addDefinition(newParametricCall);
            return newParametricCall;
        }
        return this;
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitParametricCall(this);
    }
}
