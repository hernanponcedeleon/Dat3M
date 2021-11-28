package com.dat3m.dartagnan.solver.newcaat.predicates.relationGraphs;

import com.dat3m.dartagnan.solver.newcaat.misc.DomainSet;

import java.util.Collection;
import java.util.Collections;
import java.util.List;

/*
IMPORTANT NOTE: As opposed to all other graphs, a Subgraph is only a snapshot of an already existing graph that
gets populated on construction and won't perform any updates. In particular, it should not be used
in a GraphHierarchy as it cannot perform propagation.

Note: This seems to perform better than a virtualized Subgraph.
*/
public class MaterializedSubgraph extends MaterializedGraph {

    private final RelationGraph sourceGraph;

    @Override
    public List<RelationGraph> getDependencies() {
        return Collections.singletonList(sourceGraph);
    }

    public MaterializedSubgraph(RelationGraph source, Collection<Integer> elements) {
        sourceGraph = source;
        simpleGraph.initializeToDomain(domain);

        for (Integer e : elements) {
            sourceGraph.outEdgeStream(e)
                    .filter(edge -> elements.contains(edge.getSecond()))
                    .forEach(simpleGraph::add);
        }
    }

    public MaterializedSubgraph(RelationGraph source, DomainSet events) {
        sourceGraph = source;
        simpleGraph.initializeToDomain(domain);

        events.intStream().forEach(e ->
                sourceGraph.outEdgeStream(e)
                        .filter(edge -> events.contains(edge.getSecond()))
                        .forEach(simpleGraph::add)
        );
    }

    @Override
    public void backtrackTo(int time) { }

}
