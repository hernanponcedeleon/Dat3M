package com.dat3m.dartagnan.analysis.graphRefinement.util;

import com.dat3m.dartagnan.analysis.graphRefinement.graphs.GraphHierarchy;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

public class GraphComplexityMeasure {

    private final Map<EventGraph, Integer> complexityMap = new HashMap<>();
    private final GraphHierarchy hierarchy;
    private final Visitor visitor = new Visitor();

    public Map<EventGraph, Integer> getComplexityMap() {
        return complexityMap;
    }

    public GraphComplexityMeasure(GraphHierarchy hierarchy) {
        this.hierarchy = hierarchy;
        computeComplexityMap();
    }

    private void computeComplexityMap() {
        for (Set<DependencyGraph<EventGraph>.Node> scc : hierarchy.getDependencyGraph().getSCCs()) {
            if (scc.size() == 1) {
                EventGraph g = scc.stream().findAny().get().getContent();
                complexityMap.put(g, g.accept(visitor, null, null));
            } else {
                handleRecursiveDistance(scc);
            }
        }
    }

    private void handleRecursiveDistance(Set<DependencyGraph<EventGraph>.Node> scc) {
        List<EventGraph> graphs = scc.stream().map(DependencyGraph.Node::getContent).collect(Collectors.toList());;
        boolean progress;
        do {
            progress = false;
            for (EventGraph g : graphs) {
                int curComp = complexityMap.getOrDefault(g, Integer.MAX_VALUE);
                int comp = g.accept(visitor, null, null);
                complexityMap.put(g, comp);
                if (comp < curComp) {
                    progress = true;
                }
            }
        } while (progress);
    }



    // Computes the current complexity of a graph based on the state of <complexityMap
    private class Visitor implements GraphVisitor<Integer, Void, Void> {

        private Integer computeAndComplexity(EventGraph g) {
            if (g.isStatic()) {
                return 0;
            }
            int comp = g.getDependencies().stream()
                    .mapToInt(x -> complexityMap.getOrDefault(x, Integer.MAX_VALUE)).max().getAsInt();
            return comp == Integer.MAX_VALUE ? comp : comp + 1;
        }

        private Integer computeOrComplexity(EventGraph g) {
            if (g.isStatic()) {
                return 0;
            }
            int comp = g.getDependencies().stream()
                    .mapToInt(x -> complexityMap.getOrDefault(x, Integer.MAX_VALUE)).min().getAsInt();
            return comp == Integer.MAX_VALUE ? comp : comp + 1;
        }

        @Override
        public Integer visit(EventGraph graph, Void unused, Void unused2) {
            throw new UnsupportedOperationException("No complexity measure is defined for this graph");
        }

        @Override
        public Integer visitUnion(EventGraph graph, Void unused, Void unused2) {
            return computeOrComplexity(graph);
        }

        @Override
        public Integer visitIntersection(EventGraph graph, Void unused, Void unused2) {
            return computeAndComplexity(graph);
        }

        @Override
        public Integer visitComposition(EventGraph graph, Void unused, Void unused2) {
            return computeAndComplexity(graph);
        }

        @Override
        public Integer visitDifference(EventGraph graph, Void unused, Void unused2) {
            return computeAndComplexity(graph);
        }

        @Override
        public Integer visitInverse(EventGraph graph, Void unused, Void unused2) {
            return computeAndComplexity(graph);
        }

        @Override
        public Integer visitRangeIdentity(EventGraph graph, Void unused, Void unused2) {
            return computeAndComplexity(graph);
        }

        @Override
        public Integer visitReflexiveClosure(EventGraph graph, Void unused, Void unused2) {
            return computeAndComplexity(graph);
        }

        @Override
        public Integer visitTransitiveClosure(EventGraph graph, Void unused, Void unused2) {
            return computeAndComplexity(graph);
        }

        @Override
        public Integer visitRecursive(EventGraph graph, Void unused, Void unused2) {
            return computeAndComplexity(graph);
        }

        @Override
        public Integer visitBase(EventGraph graph, Void unused, Void unused2) {
            return 0;
        }
    }
}
