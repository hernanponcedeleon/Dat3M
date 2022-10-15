package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.google.common.base.Preconditions;

import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class Intersection extends Definition {

    private final Relation[] operands;

    public Intersection(Relation r0, Relation... o) {
        super(r0, Stream.of(o).map(r -> "%s").collect(Collectors.joining(" & ")));
        operands = Stream.of(o).map(Preconditions::checkNotNull).toArray(Relation[]::new);
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitIntersection(definedRelation, operands);
    }

    @Override
    public Intersection substitute(Relation p, Relation r) {
        boolean match = definedRelation.equals(p);
        Relation r0 = match ? r : definedRelation;
        return match || List.of(operands).contains(p) ?
                new Intersection(r0, Stream.of(operands).map(x -> x.equals(p) ? r : x).toArray(Relation[]::new)) :
                this;
    }
}