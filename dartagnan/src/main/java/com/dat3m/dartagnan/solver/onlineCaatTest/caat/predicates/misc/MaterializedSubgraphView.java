package com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.misc;

import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.relationGraphs.MaterializedGraph;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.relationGraphs.RelationGraph;

import java.util.Collection;
import java.util.Collections;
import java.util.List;

/*
IMPORTANT NOTE: As opposed to all other graphs, a Subgraph is only a snapshot of an already existing graph that
gets populated on construction and won't perform any updates. In particular, it should not be used
in a PredicateHierarchy as it cannot perform propagation.

Note: This seems to perform better than a virtualized Subgraph.
*/
public class MaterializedSubgraphView extends MaterializedGraph {

    private final RelationGraph sourceGraph;

    @Override
    public List<RelationGraph> getDependencies() {
        return Collections.singletonList(sourceGraph);
    }

    public MaterializedSubgraphView(RelationGraph source, Collection<Integer> elements) {
        sourceGraph = source;
        simpleGraph.initializeToDomain(source.getDomain());

        for (Integer e : elements) {
            sourceGraph.outEdgeStream(e)
                    .filter(edge -> elements.contains(edge.getSecond()))
                    .forEach(simpleGraph::add);
        }
    }


    // The following operations should never be called because the Subgraph is intended to
    // be created only temporarily

    @Override
    public void backtrackTo(int time) {
        throw new UnsupportedOperationException();
    }

    @Override
    public void repopulate() {
        throw new UnsupportedOperationException();
    }

    @Override
    public <TRet, TData, TContext> TRet accept(PredicateVisitor<TRet, TData, TContext> visitor, TData tData, TContext context) {
        throw new UnsupportedOperationException();
    }
}
