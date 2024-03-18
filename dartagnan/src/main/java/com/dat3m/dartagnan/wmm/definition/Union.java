package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.google.common.base.Preconditions;
import com.google.common.collect.Lists;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class Union extends Definition {

    private final Relation[] operands;

    public Union(Relation r0, Relation... o) {
        super(r0, Stream.of(o).map(r -> "%s").collect(Collectors.joining(" | ")));
        operands = Stream.of(o).map(Preconditions::checkNotNull).toArray(Relation[]::new);
    }

    public List<Relation> getOperands() { return Arrays.asList(operands); }

    @Override
    public List<Relation> getConstrainedRelations() {
        return Lists.asList(definedRelation, operands);
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitUnion(this);
    }
}