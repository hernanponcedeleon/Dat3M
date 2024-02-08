package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;

public class DirectAddressDependency extends Definition {

    public DirectAddressDependency(Relation r0) {
        super(r0);
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitAddressDependency(this);
    }

    @Override
    public EncodingContext.EdgeEncoder getEdgeVariableEncoder(EncodingContext c) {
        return c::dependency;
    }
}
