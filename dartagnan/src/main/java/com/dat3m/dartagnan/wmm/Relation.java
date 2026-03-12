package com.dat3m.dartagnan.wmm;

import com.dat3m.dartagnan.utils.dependable.Dependent;
import com.google.common.base.Preconditions;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Optional;

import static com.google.common.base.Preconditions.checkState;

/**
 * Given an execution, describes a set of events or a binary relation between events,
 * constrained by the associated {@link Definition}.
 */
public final class Relation implements Dependent<Relation> {

    private final Wmm wmm;
    private final Arity arity;
    Definition definition = new Definition.Undefined(this);
    private boolean isRecursive;
    final List<String> names = new ArrayList<>();

    public enum Arity { UNARY, BINARY }

    Relation(Wmm wmm, Arity arity) {
        this.wmm = wmm;
        this.arity = arity;
    }

    public Arity getArity() {
        return arity;
    }

    public boolean isSet() {
        return arity == Arity.UNARY;
    }

    public boolean isRelation() {
        return arity == Arity.BINARY;
    }

    public void checkEqualArityRelation(Collection<Relation> others) {
        Preconditions.checkArgument(!isSet() || others.stream().allMatch(Relation::isSet),
                "Non-unary relation in %s", others);
        Preconditions.checkArgument(!isRelation() || others.stream().allMatch(Relation::isRelation),
                "Non-binary relation in %s", others);
    }

    /**
     * @return The current definition for this relation, or a generic proxy, if no such exists.
     */
    public Definition getDefinition() {
        return definition;
    }

    public boolean isRecursive() {
        return isRecursive;
    }

    public void setRecursive() {
        checkState(!names.isEmpty(), "unnamed recursive relation %s", this);
        isRecursive = true;
    }

    @Override
    public List<Relation> getDependencies() {
        List<Relation> relations = getDefinition().getConstrainedRelations();
        // no copying required, as long as getConstrainedRelations() returns a new or unmodifiable list
        return relations.subList(1, relations.size());
    }

    public List<String> getNames() { return names; }

    public Optional<String> getName() {
        return names.isEmpty() ? Optional.empty() : Optional.of(names.get(0));
    }

    public boolean hasName() { return !names.isEmpty(); }

    public boolean hasName(String n) {
        return names.contains(n);
    }

    public String getNameOrTerm() {
        return names.isEmpty() ? getDefinition().getTerm() : names.get(0);
    }

    @Override
    public String toString() {
        return names + " := " + getDefinition().getTerm();
    }

    // ================================================================================================
    // Utility

    public static Relation checkIsSet(Relation relation) {
        Preconditions.checkArgument(relation.isSet(), "Non-unary relation %s.", relation);
        return relation;
    }

    public static Relation checkIsRelation(Relation relation) {
        Preconditions.checkArgument(relation.isRelation(), "Non-binary relation %s.", relation);
        return relation;
    }

}
