package com.dat3m.dartagnan.wmm.graphRefinement.edgeSet.unary;

import com.dat3m.dartagnan.wmm.graphRefinement.ReasonGraph;
import com.dat3m.dartagnan.wmm.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.Edge;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.EventData;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.RelationData;
import com.dat3m.dartagnan.wmm.graphRefinement.edgeSet.EdgeSet;
import com.dat3m.dartagnan.wmm.graphRefinement.edgeSet.EdgeSetAbstract;
import com.dat3m.dartagnan.wmm.graphRefinement.logic.Conjunction;
import com.dat3m.dartagnan.wmm.utils.Tuple;

import java.util.*;

public class EdgeSetTransitive extends EdgeSetAbstract {
    protected EdgeSet inner;

    public EdgeSetTransitive(RelationData rel, EdgeSet inner) {
        super(rel);
        this.inner = inner;
    }

    @Override
    public Set<Edge> update(EdgeSet changedSet, Set<Edge> addedEdges, int time) {
        if (changedSet != inner)
            return Collections.EMPTY_SET;

        Set<Edge> updatedEdges = new HashSet<>();
        for (Edge edge : addedEdges) {
            /*Set<Tuple> added = updateFromSingleEdge(edge, time);
            addAll(added, time);
            updatedEdges.addAll(added);*/
            updateBaseEdge(edge, time, updatedEdges);
        }
        return updatedEdges;
    }

    private void updateBaseEdge(Edge edge, int time, Set<Edge> updatedEdges) {
        /*ReasonGraph.Node edgeNode = reasonGraph.addNode(this, edge, time);
        edgeNode.addReason(reasonGraph.getNode(inner, edge));*/
        if (add(edge, time)) {
            updatedEdges.add(edge);
            updateEdgeRecursive(edge, time, updatedEdges);
        }
    }

    // Computes the update R;R+, assuming "edge" was newly added to R+
    private void updateEdgeRecursive(Edge edge, int time, Set<Edge> updatedEdges) {
        Iterator<Edge> inEdges = inner.inEdgeIterator(edge.getFirst());
        //ReasonGraph.Node edgeNode = reasonGraph.getNode(this, edge);
        while (inEdges.hasNext()) {
            Edge inEdge = inEdges.next();
            //ReasonGraph.Node inEdgeNode = reasonGraph.getNode(inner, inEdge);
            Edge newEdge = new Edge(inEdge.getFirst(), edge.getSecond());
            //reasonGraph.addNode(this, newEdge, time).addReason(inEdgeNode, edgeNode);
            if (this.add(newEdge, time)) {
                updatedEdges.add(newEdge);
                updateEdgeRecursive(newEdge, time, updatedEdges);
            }
        }
    }

    @Override
    public Conjunction<CoreLiteral> computeShortestReason(Edge edge) {
        if (!this.contains(edge))
            return Conjunction.FALSE;

        Conjunction<CoreLiteral> result = Conjunction.TRUE;
        for (Edge innerEdge : findShortestPath(edge.getFirst(), edge.getSecond())) {
            result = result.and(inner.computeShortestReason(innerEdge));
        }
        return result;
    }

    Queue<EventData> queue = new ArrayDeque<>();
    HashSet<EventData> visited = new HashSet<>();
    Map<EventData, Edge> parentMap = new HashMap<>();
    private List<Edge> findShortestPath(EventData start, EventData end) {
        queue.clear();
        visited.clear();
        parentMap.clear();

        queue.add(start);
        boolean found = false;

        while (!queue.isEmpty() && !found) {
            EventData cur = queue.poll();
            Iterator<Edge> it = inner.outEdgeIterator(cur);
            while (it.hasNext()) {
                Edge next = it.next();
                EventData e = next.getSecond();

                if(!visited.contains(e)) {
                    parentMap.put(e, next);
                    if (e.equals(end)) {
                        found = true;
                        break;
                    }
                    visited.add(e);
                    queue.add(e);
                }
            }
        }
        if (!found)
            throw new RuntimeException("This should never happen");

        ArrayList<Edge> path = new ArrayList();
        do {
            Edge backEdge = parentMap.get(end);
            path.add(backEdge);
            end = backEdge.getFirst();
        } while (!end.equals(start));

        return path;
    }
/*
    // Note: we flatten the reason sets of edges in A+ to only contain edges in A.
    // This removes cyclic dependencies but also has the disadvantage of potentially getting
    // prohibitively large reason sets if A has many cycles.
    private Set<Tuple> updateFromSingleEdge(Tuple edge, int time) {
        Set<Tuple> updatedEdges = new HashSet<>();

        // Add "edge"
        updatedEdges.add(edge);
        ReasonGraph.Node edgeNode = reasonGraph.addNode(this, edge, time);
        edgeNode.addReason(reasonGraph.getNode(inner, edge));

        // Adds "this+;edge;(this*)"
        Iterator<Tuple> inEdges = this.inEdgeIterator(edge.getFirst());
        while (inEdges.hasNext()) {
            // Adds "this+;edge"
            Tuple inEdge = inEdges.next();
            Tuple newEdge = new Tuple(inEdge.getFirst(), edge.getSecond());
            ReasonGraph.Node inNode = reasonGraph.addNode(this, newEdge, time);
            // We could potentially short-circuit to the inner edge here
            inNode.reasons = inNode.reasons.or(reasonGraph.getNode(this, inEdge).reasons.and(edgeNode.reasons));
            //inNode.addReason(reasonGraph.getNode(this, inEdge), edgeNode);
            //if (contains(newEdge))
             //   continue; // No new edge added, so we can skip
            if (!contains(newEdge))
                updatedEdges.add(newEdge);

            // Adds "(this+;edge);this+"
            Iterator<Tuple> outEdges = this.outEdgeIterator(edge.getSecond());
            while (outEdges.hasNext()) {
                Tuple outEdge = outEdges.next();
                newEdge = new Tuple(inEdge.getFirst(), outEdge.getSecond());
                if (!this.contains(newEdge))
                    updatedEdges.add(newEdge);
                ReasonGraph.Node node = reasonGraph.addNode(this, newEdge, time);
                node.reasons = node.reasons.or(reasonGraph.getNode(this, outEdge).reasons.and(inNode.reasons));
                //node.addReason(reasonGraph.getNode(this, outEdge), inNode);
            }
        }

        // Adds "edge;this+"
        Iterator<Tuple> outEdges = this.outEdgeIterator(edge.getSecond());
        while (outEdges.hasNext()) {
            Tuple outEdge = outEdges.next();
            Tuple newEdge = new Tuple(edge.getFirst(), outEdge.getSecond());
            if (!this.contains(newEdge))
                updatedEdges.add(newEdge);
            ReasonGraph.Node node = reasonGraph.addNode(this, newEdge, time);
            node.reasons = node.reasons.or(reasonGraph.getNode(this, outEdge).reasons.and(edgeNode.reasons));
            //node.addReason(reasonGraph.getNode(this, outEdge), edgeNode);
        }

        return updatedEdges;
    }
    */
}
