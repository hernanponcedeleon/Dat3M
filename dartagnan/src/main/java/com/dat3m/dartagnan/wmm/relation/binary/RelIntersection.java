package com.dat3m.dartagnan.wmm.relation.binary;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;

import java.util.stream.Collectors;
import java.util.stream.Stream;

public class RelIntersection extends Definition {

    private final Relation[] operands;

    public RelIntersection(Relation r0, Relation... o) {
        super(r0, Stream.of(o).map(Relation::getName).collect(Collectors.joining(" & ")));
        operands = o;
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitIntersection(definedRelation, operands);
    }
}