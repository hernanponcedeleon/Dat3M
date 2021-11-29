package com.dat3m.dartagnan.solver.newcaat.constraints;

import com.dat3m.dartagnan.solver.newcaat.domain.Domain;
import com.dat3m.dartagnan.solver.newcaat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.newcaat.predicates.Derivable;
import com.dat3m.dartagnan.solver.newcaat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.newcaat.predicates.relationGraphs.RelationGraph;
import com.google.common.base.Preconditions;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

@SuppressWarnings("unchecked")
public class IrreflexivityConstraint extends AbstractConstraint {

    private final RelationGraph constrainedGraph;
    private final List<Edge> violatingEdges = new ArrayList<>();

    public IrreflexivityConstraint(RelationGraph constrainedGraph) {
       this.constrainedGraph = constrainedGraph;
    }

    @Override
    public RelationGraph getConstrainedPredicate() {
        return constrainedGraph;
    }

    @Override
    public boolean checkForViolations() {
        return !violatingEdges.isEmpty();
    }

    @Override
    public List<List<Edge>> getViolations() {
        return violatingEdges.stream().map(Collections::singletonList).collect(Collectors.toList());
    }

    @Override
    public void onDomainInit(CAATPredicate predicate, Domain<?> domain) {
        super.onDomainInit(predicate, domain);
        violatingEdges.clear();
    }

    @Override
    public void onPopulation(CAATPredicate predicate) {
        Preconditions.checkArgument(predicate instanceof RelationGraph, "Relation graph expected");
        constrainedGraph.edgeStream().filter(Edge::isLoop).forEach(violatingEdges::add);
    }

    @Override
    public void onChanged(CAATPredicate predicate, Collection<? extends Derivable> added) {
        ((Collection<Edge>)added).stream().filter(Edge::isLoop).forEach(violatingEdges::add);
    }

    @Override
    public void onBacktrack(CAATPredicate predicate, int time) {
        violatingEdges.removeIf(e -> e.getTime() > time);
    }

}