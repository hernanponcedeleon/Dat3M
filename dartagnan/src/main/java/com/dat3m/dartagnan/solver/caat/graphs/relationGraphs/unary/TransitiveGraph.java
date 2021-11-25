package com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.unary;

import com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.RelationGraph;
import com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.utils.MaterializedGraph;
import com.dat3m.dartagnan.solver.caat.util.GraphVisitor;
import com.dat3m.dartagnan.utils.collections.SetUtil;
import com.dat3m.dartagnan.verification.model.ExecutionModel;

import java.util.*;

public class TransitiveGraph extends MaterializedGraph {

    private final RelationGraph inner;

    @Override
    public List<? extends RelationGraph> getDependencies() {
        return Collections.singletonList(inner);
    }

    public TransitiveGraph(RelationGraph inner) {
        this.inner = inner;
    }

    @Override
    public void constructFromModel(ExecutionModel model) {
        super.constructFromModel(model);
        initialPopulation();
    }

    @Override
    public <TRet, TData, TContext> TRet accept(GraphVisitor<TRet, TData, TContext> visitor, TData data, TContext context) {
        return visitor.visitTransitiveClosure(this, data, context);
    }

    private Edge derive(Edge e) {
        return e.withDerivLength(e.getDerivationLength() + 1);
    }

    private Edge combine(Edge a, Edge b, int time) {
        return new Edge(a.getFirst(), b.getSecond(), time,
                Math.max(a.getDerivationLength(), b.getDerivationLength()) + 1);
    }

    private void initialPopulation() {
        //TODO: This is inefficient for many edges (the likely default case!)
        // Initially, we can probably use some non-incremental approach
        Set<Edge> fakeSet = SetUtil.fakeSet();
        for (Edge e : inner.edges()) {
            updateEdge(derive(e), fakeSet);
        }
    }

    // Every (transitive) edge that gets added by adding <edge> is collected into <addedEdged>
    private void updateEdge(Edge edge, Collection<Edge> addedEdges) {
        if (!simpleGraph.add(edge)) {
            return;
        }
        addedEdges.add(edge);
        final int time = edge.getTime();

        for (Edge inEdge : inEdges(edge.getFirst())) {
            Edge newEdge = combine(inEdge, edge, time);
            if (simpleGraph.add(newEdge)) {
                addedEdges.add(newEdge);
                for (Edge outEdge : outEdges(edge.getSecond())) {
                    Edge combined = combine(newEdge, outEdge, time);
                    if (simpleGraph.add(combined)) {
                        addedEdges.add(combined);
                    }
                }
            }
        }

        for (Edge outEdge : outEdges(edge.getSecond())) {
            Edge newEdge = combine(edge, outEdge, time);
            if (simpleGraph.add(newEdge)) {
                addedEdges.add(newEdge);
            }
        }
    }


    @Override
    public Collection<Edge> forwardPropagate(RelationGraph changedGraph, Collection<Edge> addedEdges) {
        if (changedGraph == inner) {
            List<Edge> newEdges = new ArrayList<>();
            for (Edge e : addedEdges) {
                updateEdge(derive(e), newEdges);
            }
            return newEdges;
        } else {
            return Collections.emptyList();
        }
    }

}
