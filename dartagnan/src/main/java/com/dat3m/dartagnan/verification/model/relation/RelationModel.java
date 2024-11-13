package com.dat3m.dartagnan.verification.model.relation;

import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.verification.model.event.EventModel;

import java.util.Set;
import java.util.HashSet;
import java.util.Collections;


public class RelationModel {
    private final Relation relation;
    private final String name;
    private final Set<EdgeModel> edgeModels;

    RelationModel(Relation relation, String name) {
        this.relation = relation;
        this.name = name;
        edgeModels = new HashSet<>();
    }

    public Relation getRelation() {
        return relation;
    }

    public String getName() {
        return name;
    }

    public Set<EdgeModel> getEdgeModels() {
        return Collections.unmodifiableSet(edgeModels);
    }

    public void addEdgeModel(EdgeModel edge) {
        edgeModels.add(edge);
    }

    
    public static class EdgeModel {
        private final EventModel from;
        private final EventModel to;
        private final String identifier;

        EdgeModel(EventModel from, EventModel to) {
            this.from = from;
            this.to = to;
            identifier = from.getId() + " -> " + to.getId();
        }

        public EventModel getFrom() {
            return from;
        }

        public EventModel getTo() {
            return to;
        }

        public String getIdentifier() {
            return identifier;
        }

        @Override
        public String toString() { return identifier; }

        @Override
        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return identifier.equals(((EdgeModel) other).getIdentifier());
        }

        @Override
        public int hashCode() {
            int a = from.getId();
            return  a ^ (31 * to.getId() + 0x9e3779b9 + (a << 6) + (a >> 2));
        }
    }
}
