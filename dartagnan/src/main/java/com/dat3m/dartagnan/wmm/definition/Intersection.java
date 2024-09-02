package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.google.common.base.Preconditions;
import com.google.common.collect.Lists;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class Intersection extends Definition {

    private final Relation[] operands;

    public Intersection(Relation r0, Relation... o) {
        super(r0, Stream.of(o).map(r -> "%s").collect(Collectors.joining(" & ")));
        operands = Stream.of(o).map(Preconditions::checkNotNull).toArray(Relation[]::new);
    }

    public List<Relation> getOperands() { return Arrays.asList(operands); }

    @Override
    public Intersection updateComponents(Wmm wmm, Object oldObj, Object newObj) {
        Relation[] newOperands = Arrays.stream(operands)
                .map(r -> r == oldObj ? (Relation) newObj : r.getDefinition().updateComponents(wmm, oldObj, newObj).getDefinedRelation())
                .toArray(Relation[]::new);
        if (!Arrays.equals(newOperands, operands)) {
            Intersection newIntersection = new Intersection(wmm.newRelation(), newOperands);
            wmm.addDefinition(newIntersection);
            return newIntersection;
        } else {
            return this;
        }
    }

    @Override
    public boolean withoutParametricCall() {
        return Arrays.stream(operands).allMatch(r -> r.getDefinition().withoutParametricCall());
    }

    @Override
    public List<Relation> getConstrainedRelations() {
        return Lists.asList(definedRelation, operands);
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitIntersection(this);
    }
}