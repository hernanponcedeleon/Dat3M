package com.dat3m.dartagnan.analysis.graphRefinement.util;

import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.EventGraph;

public interface GraphVisitor<TRet, TData, TContext> {

    default TRet visit(EventGraph graph, TData data, TContext context) { return null; }
    default TRet visitUnion(EventGraph graph, TData data, TContext context) { return visit(graph, data, context); }
    default TRet visitIntersection(EventGraph graph, TData data, TContext context) { return visit(graph, data, context); }
    default TRet visitComposition(EventGraph graph, TData data, TContext context) { return visit(graph, data, context); }
    default TRet visitDifference(EventGraph graph, TData data, TContext context) { return visit(graph, data, context); }
    default TRet visitInverse(EventGraph graph, TData data, TContext context) { return visit(graph, data, context); }
    default TRet visitRangeIdentity(EventGraph graph, TData data, TContext context) { return visit(graph, data, context); }
    default TRet visitReflexiveClosure(EventGraph graph, TData data, TContext context) { return visit(graph, data, context); }
    default TRet visitTransitiveClosure(EventGraph graph, TData data, TContext context) { return visit(graph, data, context); }
    default TRet visitRecursive(EventGraph graph, TData data, TContext context) { return visit(graph, data, context); }
    default TRet visitBase(EventGraph graph, TData data, TContext context) { return visit(graph, data, context); }


}
