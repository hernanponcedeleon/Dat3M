package com.dat3m.dartagnan.wmm;

import com.dat3m.dartagnan.utils.dependable.Dependent;
import com.dat3m.dartagnan.wmm.definition.Composition;
import com.dat3m.dartagnan.wmm.definition.Union;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static com.dat3m.dartagnan.wmm.RelationNameRepository.*;
import static com.google.common.base.Preconditions.checkState;

public final class Relation implements Dependent<Relation> {

    private final Wmm wmm;
    Definition definition = new Definition.Undefined(this);
    private boolean isRecursive;
    final List<String> names = new ArrayList<>();

    Relation(Wmm wmm) {
        this.wmm = wmm;
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

    public void configure(Configuration config) throws InvalidConfigurationException { }

    public Wmm getMemoryModel() { return this.wmm; }

    public Optional<String> getName() {
        return names.isEmpty() ? Optional.empty() : Optional.of(names.get(0));
    }

    public String getNameOrTerm() {
        return names.isEmpty() ? getDefinition().getTerm() : names.get(0);
    }

    public boolean isInternal() {
        return hasName(ADDRDIRECT) || hasName(CTRLDIRECT) || hasName(IDD) || hasName(IDDTRANS) ||
                definition instanceof Composition && getDependencies().get(0).hasName(IDDTRANS) ||
                definition instanceof Union && getDependencies().get(0).hasName(ADDRDIRECT);
    }

    @Override
    public String toString() {
        return names + " := " + getDefinition().getTerm();
    }

    boolean hasName(String n) {
        return names.contains(n);
    }
}
