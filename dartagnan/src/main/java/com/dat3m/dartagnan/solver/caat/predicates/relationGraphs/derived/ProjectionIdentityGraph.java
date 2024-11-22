package com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.derived;

import com.dat3m.dartagnan.solver.caat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.caat.predicates.Derivable;
import com.dat3m.dartagnan.solver.caat.predicates.misc.PredicateVisitor;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.MaterializedGraph;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.RelationGraph;

import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

public class ProjectionIdentityGraph extends MaterializedGraph {

    public enum Dimension {
        DOMAIN,
        RANGE
    }

    private final RelationGraph inner;
    private final Dimension dimension;

    @Override
    public List<RelationGraph> getDependencies() {
        return List.of(inner);
    }

    public Dimension getProjectionDimension() { return dimension; }

    public ProjectionIdentityGraph(RelationGraph inner, Dimension dimension) {
        this.inner = inner;
        this.dimension = dimension;
    }

    private Edge derive(Edge e) {
        int id = switch (this.dimension) {
            case RANGE -> e.getSecond();
            case DOMAIN -> e.getFirst();
        };
        return new Edge(id, id, e.getTime(), e.getDerivationLength() + 1);
    }

    @Override
    public void repopulate() {
        inner.edgeStream().forEach(e -> simpleGraph.add(derive(e)));
    }

    @Override
    @SuppressWarnings("unchecked")
    public Collection<Edge> forwardPropagate(CAATPredicate changedSource, Collection<? extends Derivable> added) {
        if (changedSource == inner) {
            Collection<Edge> addedEdges = (Collection<Edge>) added;
            return addedEdges.stream()
                    .map(this::derive)
                    .filter(simpleGraph::add)
                    .collect(Collectors.toList());
        } else {
            return Collections.emptyList();
        }
    }

    @Override
    public <TRet, TData, TContext> TRet accept(PredicateVisitor<TRet, TData, TContext> visitor, TData data, TContext context) {
        return visitor.visitProjectionIdentity(this, data, context);
    }

}
