package com.dat3m.dartagnan.analysis.saturation.util;

import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.RelationGraph;

public interface GraphVisitor<TRet, TData, TContext> {

    default TRet visit(RelationGraph graph, TData data, TContext context) { return null; }
    default TRet visitUnion(RelationGraph graph, TData data, TContext context) { return visit(graph, data, context); }
    default TRet visitIntersection(RelationGraph graph, TData data, TContext context) { return visit(graph, data, context); }
    default TRet visitComposition(RelationGraph graph, TData data, TContext context) { return visit(graph, data, context); }
    default TRet visitDifference(RelationGraph graph, TData data, TContext context) { return visit(graph, data, context); }
    default TRet visitInverse(RelationGraph graph, TData data, TContext context) { return visit(graph, data, context); }
    default TRet visitRangeIdentity(RelationGraph graph, TData data, TContext context) { return visit(graph, data, context); }
    default TRet visitReflexiveClosure(RelationGraph graph, TData data, TContext context) { return visit(graph, data, context); }
    default TRet visitTransitiveClosure(RelationGraph graph, TData data, TContext context) { return visit(graph, data, context); }
    default TRet visitRecursive(RelationGraph graph, TData data, TContext context) { return visit(graph, data, context); }
    default TRet visitBase(RelationGraph graph, TData data, TContext context) { return visit(graph, data, context); }


}
