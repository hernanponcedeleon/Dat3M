package com.dat3m.dartagnan.verification.model;

import com.dat3m.dartagnan.verification.model.event.EventModel;
import com.dat3m.dartagnan.wmm.Relation;

import java.util.Collections;
import java.util.HashSet;
import java.util.Set;


public class RelationModel {
    private final Relation relation;
    private final Set<EdgeModel> edgeModels;

    public RelationModel(Relation relation) {
        this.relation = relation;
        edgeModels = new HashSet<>();
    }

    public Relation getRelation() {
        return relation;
    }

    public Set<EdgeModel> getEdgeModels() {
        return Collections.unmodifiableSet(edgeModels);
    }

    public void addEdgeModel(EdgeModel edge) {
        edgeModels.add(edge);
    }


    public record EdgeModel(EventModel from, EventModel to) {
        @Override
        public String toString() {
            return from.getId() + " -> " + to.getId();
        }
    }
}
