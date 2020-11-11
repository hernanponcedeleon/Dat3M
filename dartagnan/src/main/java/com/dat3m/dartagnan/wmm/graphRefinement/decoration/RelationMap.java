package com.dat3m.dartagnan.wmm.graphRefinement.decoration;

import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.graphRefinement.GraphContext;
import com.dat3m.dartagnan.wmm.relation.RecursiveRelation;
import com.dat3m.dartagnan.wmm.relation.Relation;

import java.util.*;


public class RelationMap {
    private Map<Relation, RelationData> relMap;
    private Map<Axiom, RelationData> axiomMap;

    public RelationMap() {
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

    public RelationData remove(Axiom axiom) {
        return axiomMap.remove(axiom);
    }

    public RelationData get(Relation rel) {
        RelationData data = relMap.get(rel);
        if (data == null) {
            data = new RelationData(rel, this);
            relMap.put(rel, data);
        }
        return data;
    }

    public RelationData get(Axiom axiom) {
        RelationData data = axiomMap.get(axiom);
        if (data == null) {
            data = new RelationData(axiom, this);
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

    public Collection<RelationData> getAxiomValues() {
        return axiomMap.values();
    }



    public static RelationMap fromMemoryModel(Wmm memoryModel) {
        RelationMap mapping = new RelationMap();
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
            RelationData inner = relData.getInner();
            if (inner != null) {
                relData.addDependency(inner);
            } else if (relData.isBinaryRelation()) {
                relData.addDependency(relData.getFirst());
                relData.addDependency(relData.getSecond());
            }
        }
        for (RelationData relData : mapping.getAxiomValues())
            relData.addDependency(relData.getInner());

        return mapping;
    }

}
