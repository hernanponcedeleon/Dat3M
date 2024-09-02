package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;

import static com.dat3m.dartagnan.wmm.RelationNameRepository.PARAMETRIC;
import static com.google.common.base.Preconditions.checkNotNull;

public class Parametric extends Definition {
    private final Object parameterDummy;
    private final String alias;
    private final boolean parameterIsRelation;

    public Parametric(Relation relation, String alias, Object parameterObject) {
        super(relation, PARAMETRIC);
        this.alias = checkNotNull(alias);
        this.parameterDummy = checkNotNull(parameterObject);
        this.parameterIsRelation = parameterObject instanceof Relation;
    }

    public Object getParameterDummy() {
        return parameterDummy;
    }

    public String getAlias() {
        return alias;
    }

    public boolean isParameterRelation() {
        return parameterIsRelation;
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitParametric(this);
    }
}
