package com.dat3m.dartagnan.wmm.graphRefinement.decoration;

import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.graphRefinement.edgeSet.EdgeSet;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.dependable.Dependent;
import com.dat3m.dartagnan.wmm.relation.RecursiveRelation;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.relation.base.stat.StaticRelation;
import com.dat3m.dartagnan.wmm.relation.binary.BinaryRelation;
import com.dat3m.dartagnan.wmm.relation.unary.UnaryRelation;

import java.util.*;

// This class is a combination of a facade and decorator to wrap and enhance
// the functionality of the classes Relation and Axiom
// The name is temporary
// We can replace it by letting Relation and Axiom implement a Dependable/Dependency interface
public class RelationData implements Dependent<RelationData> {
    private final WmmMap map;
    private final Relation relation;
    private final List<RelationData> dependencies;

    // ======================================
    RelationData(Relation rel, WmmMap map) {
        this.map = map;
        this.relation = rel;
        this.dependencies = new ArrayList<>();
    }


    public Relation getWrappedRelation() {
        return relation;
    }

    @Override
    public List<RelationData> getDependencies() {
        return dependencies;
    }


    public boolean isUnaryRelation() { return relation instanceof UnaryRelation; }
    public boolean isBinaryRelation() { return  relation instanceof BinaryRelation; }
    public boolean isRecursiveRelation() { return relation instanceof RecursiveRelation; }
    public boolean isStaticRelation() { return relation instanceof StaticRelation; }

    public RelationData getInner() {
        return getFirst();
    }

    public RelationData getFirst() {
        return dependencies.size() > 0 ? dependencies.get(0) : null;
    }

    public RelationData getSecond() {
        return dependencies.size() > 1 ? dependencies.get(1) : null;
    }

    public void initialize() {
        dependencies.clear();
        if (isUnaryRelation()) {
            dependencies.add(map.get(((UnaryRelation)relation).getInner()));
        } else if (isRecursiveRelation()) {
            dependencies.add(map.get(((RecursiveRelation)relation).getInner()));
        } else if (isBinaryRelation()) {
            dependencies.add(map.get(((BinaryRelation)relation).getFirst()));
            dependencies.add(map.get(((BinaryRelation)relation).getSecond()));
        }
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
        return relation.hashCode();
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null || obj.getClass() != this.getClass())
            return false;

        RelationData other = (RelationData)obj;
        return relation.equals(other.relation);
    }

    @Override
    public String toString() {
        return relation.toString();
    }
}
