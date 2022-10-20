package com.dat3m.dartagnan.wmm;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.utils.dependable.Dependent;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.java_smt.api.BooleanFormula;

import java.util.ArrayList;
import java.util.List;

import static com.google.common.base.Preconditions.checkState;

public final class Relation implements Dependent<Relation> {

    Definition definition;
    private boolean isRecursive;
    final List<String> names = new ArrayList<>();

    Relation() {
    }

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

    public <T> T accept(Definition.Visitor<? extends T> visitor) {
        return definition == null ?
                visitor.visitDefinition(this, List.of()) :
                definition.accept(visitor);
    }

    public BooleanFormula getSMTVar(Tuple tuple, EncodingContext context) {
        return definition == null ?
                context.edgeVariable(getNameOrTerm(), tuple.getFirst(), tuple.getSecond()) :
                definition.getSMTVar(tuple, context);
    }

    @Override
    public List<Relation> getDependencies() {
        if (definition == null) {
            return List.of();
        }
        List<Relation> relations = definition.getConstrainedRelations();
        // no copying required, as long as getConstrainedRelations() returns a new or unmodifiable list
        return relations.subList(1, relations.size());
    }

    public void configure(Configuration config) throws InvalidConfigurationException { }

    public String getName() {
        return names.isEmpty() ? null : names.get(0);
    }

    public String getNameOrTerm() {
        return names.isEmpty() ? getTerm() : names.get(0);
    }

    @Override
    public String toString() {
        return names + " := " + getTerm();
    }

    boolean hasName(String n) {
        return names.contains(n);
    }

    private String getTerm() {
        return definition == null ? "undefined" : definition.getTerm();
    }
}
