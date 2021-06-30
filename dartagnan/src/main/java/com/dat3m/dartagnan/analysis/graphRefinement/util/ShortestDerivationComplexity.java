package com.dat3m.dartagnan.analysis.graphRefinement.util;

import com.dat3m.dartagnan.analysis.graphRefinement.graphs.GraphHierarchy;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

/*
This class computes the "shortest derivation complexity" C on a hierarchy of graphs as follows:
    - Each base graph G (= non-derived) has complexity C(G) = 0
    - Each unary graph G = f(A) has complexity C(G) = C(A) + 1
    - Composition and intersection graphs G = f(A, B) have complexity C(G) = max(C(A), C(B)) + 1
    - Union graphs G = f(A, B) have complexity C(G) = min(C(A), C(B)) + 1
    - In case of non-welldefined shortest derivation length, C(G) = Integer.MAXVALUE (symbolizes infinity)
        - This can happen in recursive definitions like A = A & B, where each derivation infinitely cycles through A
        - Conjecture: C(G) = infinity => G is empty
        - Proof: If C(G) = infinity, each derivation has at least infinite length. Due to least fixed point semantics,
          edges can only be in a graph if they have some finite derivation.
          The i-th Kleene iteration adds edges of derivation complexity at most i, so no finite number of Kleene iterations
          will add new edges.
 */
public class ShortestDerivationComplexity {

    private final Map<EventGraph, Integer> complexityMap = new HashMap<>();
    private final GraphHierarchy hierarchy;
    private final Visitor visitor = new Visitor();

    public Map<EventGraph, Integer> getComplexityMap() {
        return complexityMap;
    }

    public ShortestDerivationComplexity(GraphHierarchy hierarchy) {
        this.hierarchy = hierarchy;
        computeComplexityMap();
    }

    private void computeComplexityMap() {
        hierarchy.getGraphs().forEach(g -> complexityMap.put(g, Integer.MAX_VALUE));

        for (Set<DependencyGraph<EventGraph>.Node> scc : hierarchy.getDependencyGraph().getSCCs()) {
            if (scc.size() == 1) {
                EventGraph g = scc.stream().findAny().get().getContent();
                complexityMap.put(g, g.accept(visitor, null, null));
            } else {
                handleComplexityDistance(scc);
            }
        }
    }

    private void handleComplexityDistance(Set<DependencyGraph<EventGraph>.Node> scc) {
        List<EventGraph> graphs = scc.stream().map(DependencyGraph.Node::getContent).collect(Collectors.toList());;
        boolean progress;
        do {
            progress = false;
            for (EventGraph g : graphs) {
                int comp = g.accept(visitor, null, null);
                int oldComp = complexityMap.put(g, comp);
                if (comp < oldComp) {
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
            int comp = g.getDependencies().stream().mapToInt(complexityMap::get).max().getAsInt();
            return comp == Integer.MAX_VALUE ? comp : comp + 1;
        }

        private Integer computeOrComplexity(EventGraph g) {
            if (g.isStatic()) {
                return 0;
            }
            int comp = g.getDependencies().stream().mapToInt(complexityMap::get).min().getAsInt();
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
