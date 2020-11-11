package com.dat3m.dartagnan.wmm.graphRefinement.decoration;

import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.graphRefinement.GraphContext;
import com.dat3m.dartagnan.wmm.graphRefinement.edgeSet.EdgeSet;
import com.dat3m.dartagnan.wmm.relation.RecursiveRelation;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.relation.base.stat.StaticRelation;
import com.dat3m.dartagnan.wmm.relation.binary.BinaryRelation;
import com.dat3m.dartagnan.wmm.relation.unary.UnaryRelation;

import java.util.*;

// This class is a combination of a facade and decorator to wrap and enhance
// the functionality of the classes Relation and Axiom
// The name is temporary
public class RelationData {
    private RelationMap map;

    private Relation relation;
    private Axiom axiom;

    // This data gets computed only once during the dependency analysis
    private List<RelationData> dependents;
    private List<RelationData> dependencies;
    private Set<RelationData> scc;
    private int topologicalIndex;

    // This set gets recomputed each time graph refinement is performed
    private EdgeSet edgeSet;

    // ======================================

    public RelationData(Relation rel, RelationMap map) {
        this.map = map;
        this.relation = rel;
        dependencies = new ArrayList<>(2);
        dependents = new ArrayList<>(5);
        topologicalIndex = -1;
    }

    public RelationData(Axiom axiom, RelationMap map) {
        this(axiom.getRel(), map);
        this.axiom = axiom;
    }


    public Relation getRelation() {
        return relation;
    }

    public Axiom getAxiom() { return axiom; }

    public boolean isAxiom() { return  axiom != null;}

    public boolean isRelation() { return !isAxiom(); }


    public EdgeSet getEdgeSet() {
        return edgeSet;
    }
    public void setEdgeSet(EdgeSet edgeSet) { this.edgeSet = edgeSet; }

    public List<RelationData> getDependents() {
        return dependents;
    }
    public List<RelationData> getDependencies() {
        return dependencies;
    }

    public Set<RelationData> getSCC() {
        return scc;
    }
    public void setSCC(Set<RelationData> scc) { this.scc = scc; }

    public int getTopologicalIndex() {
        return topologicalIndex;
    }
    public void setTopologicalIndex(int topIndex ) { topologicalIndex = topIndex; }


    public boolean isUnaryRelation() { return isRelation() && relation instanceof UnaryRelation; }
    public boolean isBinaryRelation() { return isRelation() && relation instanceof BinaryRelation; }
    public boolean isRecursiveRelation() { return isRelation() && relation instanceof RecursiveRelation; }
    public boolean isStaticRelation() { return isRelation() && relation instanceof StaticRelation; }

    public RelationData getInner() {
        if (isAxiom()) {
            return map.get(this.relation);
        } else if (isUnaryRelation()) {
            return map.get(((UnaryRelation)relation).getInner());
        } else if (isRecursiveRelation()) {
            return map.get(((RecursiveRelation)relation).getInner());
        }
        return null;
    }

    public RelationData getFirst() {
        if (!isBinaryRelation())
            return null;
        return map.get(((BinaryRelation)relation).getFirst());
    }

    public RelationData getSecond() {
        if (!isBinaryRelation())
            return null;
        return map.get(((BinaryRelation)relation).getSecond());
    }

    public void initialize() {
        RelationData inner = getInner();
        if (inner != null) {
            addDependency(inner);
        } else if (isBinaryRelation()) {
            addDependency(getFirst());
            addDependency(getSecond());
        }
    }

    public void addDependency(RelationData dependency) {
        if (!this.getDependencies().contains(dependency)) {
            dependency.getDependents().add(this);
            this.getDependencies().add(dependency);
        }
    }

    public void removeDependency(RelationData dependency) {
        if (getDependencies().remove(dependency)) {
            dependency.getDependents().remove(this);
        }
    }

    @Override
    public int hashCode() {
        return relation.hashCode() + 31 * Objects.hashCode(axiom);
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null || obj.getClass() != this.getClass())
            return false;

        RelationData other = (RelationData)obj;
        return relation.equals(other.relation) && (Objects.equals(this.axiom, other.axiom));
    }

    @Override
    public String toString() {
        return isAxiom() ? axiom.toString() : relation.toString();
    }
}
