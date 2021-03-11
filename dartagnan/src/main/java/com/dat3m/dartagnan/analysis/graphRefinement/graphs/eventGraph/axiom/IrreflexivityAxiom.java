package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.axiom;

import com.dat3m.dartagnan.verification.model.ExecutionModel;
import com.dat3m.dartagnan.analysis.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.logic.Conjunction;
import com.dat3m.dartagnan.analysis.graphRefinement.logic.DNF;
import com.dat3m.dartagnan.analysis.graphRefinement.logic.SortedClauseSet;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.utils.timeable.Timeable;

import java.util.*;

//TODO: Track actual violating edges
// To support further search after finding some violations
// we might want to store violations only until
// they are processed and remove them again (even if they still exist in the underlying graph)
// Alternatively, we should store both: past violations (processed but still present)
// and new violations (unprocessed)
public class IrreflexivityAxiom extends GraphAxiom {

    private final List<Edge> violatingEdges = new ArrayList<>();

    public IrreflexivityAxiom(EventGraph inner) {
        super(inner);
    }

    @Override
    public void clearViolations() {
        violatingEdges.clear();
    }

    @Override
    public boolean checkForViolations() {
        return !violatingEdges.isEmpty();
    }

    @Override
    public DNF<CoreLiteral> computeReasons() {
        if (!checkForViolations())
            return DNF.FALSE;
        SortedClauseSet<CoreLiteral> clauseSet = new SortedClauseSet<>();
        for (Edge e : violatingEdges) {
            clauseSet.add(inner.computeReason(e));
        }
        clauseSet.simplify();
        return new DNF<>(clauseSet.getClauses());
    }

    @Override
    public Conjunction<CoreLiteral> computeSomeReason() {
        return checkForViolations() ? inner.computeReason(violatingEdges.get(0)) : Conjunction.FALSE;
    }

    @Override
    public void initialize(ExecutionModel context) {
        super.initialize(context);
        violatingEdges.clear();

        inner.stream().filter(Edge::isLoop).forEach(violatingEdges::add);
        /*for (Edge e : inner.edges()) {
            if (e.isLoop()) {
                violatingEdges.add(e);
            }
        }*/
    }

    @Override
    public void onGraphChanged(EventGraph changedGraph, Collection<Edge> addedEdges) {
        if (changedGraph == inner) {

            addedEdges.stream().filter(Edge::isLoop).forEach(violatingEdges::add);
            /*for (Edge e : addedEdges) {
                if (e.isLoop())
                    violatingEdges.add(e);
            }*/
        }

    }

    @Override
    public void backtrack() {
        violatingEdges.removeIf(Timeable::isInvalid);
    }

}