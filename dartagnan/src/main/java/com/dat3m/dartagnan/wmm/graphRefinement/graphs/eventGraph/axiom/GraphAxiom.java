package com.dat3m.dartagnan.wmm.graphRefinement.graphs.eventGraph.axiom;

import com.dat3m.dartagnan.wmm.graphRefinement.ModelContext;
import com.dat3m.dartagnan.wmm.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.Edge;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.dependable.Dependent;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.eventGraph.GraphListener;
import com.dat3m.dartagnan.wmm.graphRefinement.logic.Conjunction;
import com.dat3m.dartagnan.wmm.graphRefinement.logic.DNF;

import java.util.Collection;
import java.util.Collections;
import java.util.List;

public abstract class GraphAxiom implements GraphListener, Dependent<EventGraph> {
    protected ModelContext context;
    protected final EventGraph inner;

    public List<EventGraph> getDependencies() {
        return Collections.singletonList(inner);
    }

    public GraphAxiom(EventGraph inner) {
        this.inner = inner;
    }

    public abstract void clearViolations();
    public abstract boolean checkForViolations();
    public abstract DNF<CoreLiteral> computeReasons();
    public abstract Conjunction<CoreLiteral> computeSomeReason();

    public void initialize(ModelContext context) {
        this.context = context;
    }

    @Override
    public abstract void onGraphChanged(EventGraph graph, Collection<Edge> addedEdges);

    @Override
    public void backtrack() {

    }
}
