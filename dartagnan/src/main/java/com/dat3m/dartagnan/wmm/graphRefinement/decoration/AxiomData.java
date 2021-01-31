package com.dat3m.dartagnan.wmm.graphRefinement.decoration;

import com.dat3m.dartagnan.wmm.axiom.Acyclic;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.axiom.Empty;
import com.dat3m.dartagnan.wmm.axiom.Irreflexive;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.dependable.Dependent;
import com.dat3m.dartagnan.wmm.relation.Relation;

import java.util.ArrayList;
import java.util.List;

public class AxiomData implements Dependent<RelationData> {
    private final WmmMap map;
    private final Axiom axiom;
    private final List<RelationData> dependencies;

    // ======================================
    AxiomData(Axiom axiom, WmmMap map) {
        this.map = map;
        this.axiom = axiom;
        this.dependencies = new ArrayList<>();
    }


    public Relation getWrappedRelation() {
        return axiom.getRel();
    }

    public RelationData getRelation() { return map.get(axiom.getRel()); }

    @Override
    public List<RelationData> getDependencies() {
        return dependencies;
    }

    public Axiom getWrappedAxiom() { return axiom; }

    public boolean isAcyclicity() { return axiom instanceof Acyclic; }
    public boolean isIrreflexivity() { return axiom instanceof Irreflexive; }
    public boolean isEmptiness() { return axiom instanceof Empty; }


    public void initialize() {
        dependencies.clear();
        dependencies.add(getRelation());
    }

    // This method should only be used with caution
    public void addDependency(RelationData dependency) {
        if (!dependencies.contains(dependency)) {
            dependencies.add(dependency);
        }
    }

    public void removeDependency(RelationData dependency) {
        dependencies.remove(dependency);
    }

    @Override
    public int hashCode() {
        return axiom.hashCode();
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null || obj.getClass() != this.getClass())
            return false;

        AxiomData other = (AxiomData)obj;
        return axiom.equals(other.axiom);
    }

    @Override
    public String toString() {
        return axiom.toString();
    }
}
