package com.dat3m.dartagnan.solver.caat.predicates.misc;

import com.dat3m.dartagnan.solver.caat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.RelationGraph;
import com.dat3m.dartagnan.solver.caat.predicates.sets.SetPredicate;

public interface PredicateVisitor<TRet, TData, TContext> {

    default TRet visit(CAATPredicate predicate, TData data, TContext context) { return null; }

    // ============================================== RelationGraph ==============================================
    default TRet visitGraph(RelationGraph graph, TData data, TContext context) { return visit(graph, data, context); }
    default TRet visitGraphUnion(RelationGraph graph, TData data, TContext context) { return visitGraph(graph, data, context); }
    default TRet visitGraphIntersection(RelationGraph graph, TData data, TContext context) { return visitGraph(graph, data, context); }
    default TRet visitGraphComposition(RelationGraph graph, TData data, TContext context) { return visitGraph(graph, data, context); }
    default TRet visitGraphDifference(RelationGraph graph, TData data, TContext context) { return visitGraph(graph, data, context); }
    default TRet visitCartesian(RelationGraph graph, TData data, TContext context) { return visitGraph(graph, data, context); }
    default TRet visitInverse(RelationGraph graph, TData data, TContext context) { return visitGraph(graph, data, context); }
    default TRet visitSetIdentity(RelationGraph graph, TData data, TContext context) { return visitGraph(graph, data, context); }
    default TRet visitProjectionIdentity(RelationGraph graph, TData data, TContext context) { return visitGraph(graph, data, context); }
    default TRet visitReflexiveClosure(RelationGraph graph, TData data, TContext context) { return visitGraph(graph, data, context); }
    default TRet visitTransitiveClosure(RelationGraph graph, TData data, TContext context) { return visitGraph(graph, data, context); }
    default TRet visitRecursiveGraph(RelationGraph graph, TData data, TContext context) { return visitGraph(graph, data, context); }
    default TRet visitBaseGraph(RelationGraph graph, TData data, TContext context) { return visitGraph(graph, data, context); }

    // ============================================== SetPredicates ==============================================

    default TRet visitSet(SetPredicate set, TData data, TContext context) { return visit(set, data, context); }
    default TRet visitSetUnion(SetPredicate set, TData data, TContext context) { return visitSet(set, data, context); }
    default TRet visitSetIntersection(SetPredicate set, TData data, TContext context) { return visitSet(set, data, context); }
    default TRet visitSetDifference(SetPredicate set, TData data, TContext context) { return visitSet(set, data, context); }
    default TRet visitBaseSet(SetPredicate set, TData data, TContext context) { return visitSet(set, data, context); }

}
