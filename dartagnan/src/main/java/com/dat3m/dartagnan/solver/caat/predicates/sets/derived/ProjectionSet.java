package com.dat3m.dartagnan.solver.caat.predicates.sets.derived;

import com.dat3m.dartagnan.solver.caat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.caat.predicates.Derivable;
import com.dat3m.dartagnan.solver.caat.predicates.misc.PredicateVisitor;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.RelationGraph;
import com.dat3m.dartagnan.solver.caat.predicates.sets.Element;
import com.dat3m.dartagnan.solver.caat.predicates.sets.MaterializedSet;

import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

public class ProjectionSet extends MaterializedSet {

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

    public ProjectionSet(RelationGraph inner, Dimension dimension) {
        this.inner = inner;
        this.dimension = dimension;
    }

    private Element derive(Edge e) {
        int id = switch (this.dimension) {
            case RANGE -> e.getSecond();
            case DOMAIN -> e.getFirst();
        };
        return new Element(id, e.getTime(), e.getDerivationLength() + 1);
    }

    @Override
    public void repopulate() {
        inner.edgeStream().forEach(e -> simpleSet.add(derive(e)));
    }

    @Override
    @SuppressWarnings("unchecked")
    public Collection<Element> forwardPropagate(CAATPredicate changedSource, Collection<? extends Derivable> added) {
        if (changedSource == inner) {
            Collection<Edge> addedEdges = (Collection<Edge>) added;
            return addedEdges.stream()
                    .map(this::derive)
                    .filter(simpleSet::add)
                    .collect(Collectors.toList());
        } else {
            return Collections.emptyList();
        }
    }

    @Override
    public <TRet, TData, TContext> TRet accept(PredicateVisitor<TRet, TData, TContext> visitor, TData data, TContext context) {
        return visitor.visitProjection(this, data, context);
    }

}
