package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.RelationNameRepository;

public class DirectDataDependency extends Definition {

    public DirectDataDependency(Relation r0) {
        super(r0, RelationNameRepository.IDD);
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitInternalDataDependency(this);
    }

    @Override
    public EncodingContext.EdgeEncoder getEdgeVariableEncoder(EncodingContext c) {
        return c::dependency;
    }
}
