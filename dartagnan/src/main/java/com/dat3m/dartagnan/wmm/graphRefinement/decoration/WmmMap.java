package com.dat3m.dartagnan.wmm.graphRefinement.decoration;

import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.dependable.DependencyGraph;
import com.dat3m.dartagnan.wmm.relation.RecursiveRelation;
import com.dat3m.dartagnan.wmm.relation.Relation;

import java.util.*;


public class WmmMap {
    private final Map<Relation, RelationData> relMap;
    private final Map<Axiom, AxiomData> axiomMap;

    public WmmMap() {
        relMap = new HashMap<>();
        axiomMap = new HashMap<>();
    }

    public boolean contains(Relation rel) {
        return relMap.containsKey(rel);
    }

    public boolean contains(Axiom axiom) {
        return axiomMap.containsKey(axiom);
    }

    public RelationData remove(Relation rel) {
        return relMap.remove(rel);
    }
    public RelationData remove(RelationData rel) {
        return remove(rel.getWrappedRelation());
    }

    public AxiomData remove(Axiom axiom) {
        return axiomMap.remove(axiom);
    }
    public AxiomData remove(AxiomData axiom) {
        return remove(axiom.getWrappedAxiom());
    }

    public RelationData get(Relation rel) {
        RelationData data = relMap.get(rel);
        if (data == null) {
            data = new RelationData(rel, this);
            relMap.put(rel, data);
        }
        return data;
    }

    public AxiomData get(Axiom axiom) {
        AxiomData data = axiomMap.get(axiom);
        if (data == null) {
            data = new AxiomData(axiom, this);
            axiomMap.put(axiom, data);
        }
        return data;
    }

    public Set<Relation> getRelationKeys() {
        return relMap.keySet();
    }

    public Set<Axiom> getAxiomKeys() {
        return axiomMap.keySet();
    }

    public Collection<RelationData> getRelationValues() {
        return relMap.values();
    }

    public Collection<AxiomData> getAxiomValues() {
        return axiomMap.values();
    }

    public DependencyGraph<RelationData> computeRelationDependencyGraph() {
        return new DependencyGraph<>(getRelationValues());
    }

    public static WmmMap fromMemoryModel(Wmm memoryModel) {
        WmmMap mapping = new WmmMap();
        for (Relation rel : memoryModel.getRelationRepository().getRelations()) {
            mapping.get(rel);
            // Recursive relations are not found otherwise
            if (rel instanceof RecursiveRelation) {
                mapping.get(((RecursiveRelation)rel).getInner());
            }
        }

        for (Axiom ax : memoryModel.getAxioms()) {
            mapping.get(ax);
        }

        for (RelationData relData : mapping.getRelationValues()) {
            relData.initialize();
        }
        for (AxiomData axiomData : mapping.getAxiomValues()) {
            axiomData.initialize();
        }

        return mapping;
    }

}
