package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.axiom;

import com.dat3m.dartagnan.analysis.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.analysis.graphRefinement.coreReason.ReasoningEngine;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.GraphListener;
import com.dat3m.dartagnan.analysis.graphRefinement.logic.Conjunction;
import com.dat3m.dartagnan.analysis.graphRefinement.logic.DNF;
import com.dat3m.dartagnan.utils.dependable.Dependent;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.ExecutionModel;

import java.util.Collection;
import java.util.Collections;
import java.util.List;

public abstract class GraphAxiom implements GraphListener, Dependent<EventGraph> {
    protected ExecutionModel context;
    protected final EventGraph inner;

    public List<EventGraph> getDependencies() {
        return Collections.singletonList(inner);
    }

    public GraphAxiom(EventGraph inner) {
        this.inner = inner;
    }

    public abstract void clearViolations();
    public abstract boolean checkForViolations();
    public abstract DNF<CoreLiteral> computeReasons(ReasoningEngine reasEng);
    public abstract Conjunction<CoreLiteral> computeSomeReason(ReasoningEngine reasEng);

    public void initialize(ExecutionModel context) {
        this.context = context;
    }

    @Override
    public abstract void onGraphChanged(EventGraph graph, Collection<Edge> addedEdges);

    @Override
    public void backtrack() {

    }
}
