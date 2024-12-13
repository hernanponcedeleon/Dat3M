package com.dat3m.dartagnan.verification.model;

import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.verification.model.event.EventModel;

import java.util.Collections;
import java.util.Set;
import java.util.HashSet;


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


    public static class EdgeModel {
        private final EventModel from;
        private final EventModel to;

        public EdgeModel(EventModel from, EventModel to) {
            this.from = from;
            this.to = to;
        }

        public EventModel getFrom() {
            return from;
        }

        public EventModel getTo() {
            return to;
        }

        @Override
        public String toString() { return from.getId() + " -> " + to.getId(); }

        @Override
        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return from.getId() == ((EdgeModel) other).getFrom().getId()
                   && to.getId() == ((EdgeModel) other).getTo().getId();
        }

        @Override
        public int hashCode() {
            int a = from.getId();
            return  a ^ (31 * to.getId() + 0x9e3779b9 + (a << 6) + (a >> 2));
        }
    }
}
