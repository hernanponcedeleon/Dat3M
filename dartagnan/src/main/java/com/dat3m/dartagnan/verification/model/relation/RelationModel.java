package com.dat3m.dartagnan.verification.model.relation;

import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.verification.model.EventData;

import java.util.Set;
import java.util.HashSet;


public class RelationModel {
    private String name;
    private final Relation relation;
    private final Set<EdgeModel> edges;

    RelationModel(Relation r) {
        relation = r;
        edges = new HashSet<>();
    }

    public Relation getRelation() {
        return relation;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public boolean isDefined() {
        return name != null;
    }

    public Set<EdgeModel> getEdges() {
        return Set.copyOf(edges);
    }

    public void addEdge(EdgeModel edge) {
        edges.add(edge);
    }

    public void addEdges(Set<EdgeModel> edgeModels) {
        edges.addAll(edgeModels);
    }

    public EdgeModel newEdge(EventData p, EventData s) {
        EdgeModel edge = new EdgeModel(p, s);
        addEdge(edge);
        return edge;
    }

    
    public static class EdgeModel {
        private final EventData predecessor;
        private final EventData successor;
        private final String identifier;

        EdgeModel(EventData p, EventData s) {
            predecessor = p;
            successor = s;
            identifier = p.getId() + " -> " + s.getId();
        }

        public EventData getPredecessor() {
            return predecessor;
        }

        public EventData getSuccessor() {
            return successor;
        }

        public String getIdentifier() {
            return identifier;
        }
    }
}
