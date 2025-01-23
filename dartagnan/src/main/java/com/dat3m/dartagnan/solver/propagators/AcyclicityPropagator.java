package com.dat3m.dartagnan.solver.propagators;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.solver.caat.domain.Domain;
import com.dat3m.dartagnan.solver.caat.domain.GenericDomain;
import com.dat3m.dartagnan.solver.caat.misc.PathAlgorithm;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.base.SimpleGraph;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.axiom.Acyclicity;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import com.google.common.collect.BiMap;
import com.google.common.collect.HashBiMap;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.PropagatorBackend;
import org.sosy_lab.java_smt.basicimpl.AbstractUserPropagator;

import java.util.*;

public class AcyclicityPropagator extends AbstractUserPropagator {

    private RelationAnalysis relationAnalysis;
    private Acyclicity axiom;
    private EncodingContext context;

    private Domain<Event> domain;
    private SimpleGraph relationGraph = new SimpleGraph();
    private BiMap<BooleanFormula, Edge> lit2Edge = HashBiMap.create();
    private BiMap<Edge, BooleanFormula> edge2Lit = lit2Edge.inverse();

    private int curLevel = 0;

    public AcyclicityPropagator(Acyclicity axiom, EncodingContext ctx) {
        this.context = ctx;
        this.axiom = axiom;
        this.relationAnalysis = ctx.getAnalysisContext().requires(RelationAnalysis.class);

        // Setup CAAT graph
        final List<Event> events = context.getTask().getProgram().getThreadEvents();
        this.domain = new GenericDomain<>(events);
        relationGraph.initializeToDomain(domain);
        PathAlgorithm.ensureCapacity(events.size());
    }

    @Override
    public void initializeWithBackend(PropagatorBackend backend) {
        super.initializeWithBackend(backend);

        backend.notifyOnKnownValue();
        backend.notifyOnFinalCheck();

        final Relation rel = axiom.getRelation();
        final RelationAnalysis.Knowledge k = relationAnalysis.getKnowledge(rel);
        final EventGraph must = k.getMustSet();

        final EventGraph encodeGraph = axiom.getEncodeGraph(context.getTask(), context.getAnalysisContext()).get(rel);
        System.out.println("encode/may: " + encodeGraph.size() + "/" + k.getMaySet().size());
        System.out.println("must/may: " + must.size() + "/" + k.getMaySet().size());
        k.getMaySet().apply((x, y) -> {
            final int idx = domain.getId(x);
            final int idy = domain.getId(y);
            if (must.contains(x, y)) {
                relationGraph.add(new Edge(idx, idy, 0, 0));
            } else if (encodeGraph.contains(x, y)) {
                final BooleanFormula edgeLit = context.edge(rel, x, y);
                lit2Edge.put(edgeLit, new Edge(idx, idy, 0, 0 ));
                backend.registerExpression(edgeLit);
            }
        });
    }

    @Override
    public void onKnownValue(BooleanFormula expr, boolean value) {
        if (value) {
            final Edge edge = lit2Edge.get(expr);
            propagate(edge.withTime(curLevel));
        }
    }

    private boolean raisedConflict = false;

    private void propagate(Edge edge) {
        if (raisedConflict) {
            return;
        }
        relationGraph.add(edge);

        final List<Edge> cycle = PathAlgorithm.findShortestPath(relationGraph, edge.getSecond(), edge.getFirst());

        if (!cycle.isEmpty()) {
            List<BooleanFormula> reason = new ArrayList<>();
            for (Edge e : cycle) {
                final BooleanFormula lit = edge2Lit.get(e);
                if (lit != null) {
                    reason.add(lit);
                }
            }
            reason.add(edge2Lit.get(edge));
            trackReason(reason);
            getBackend().propagateConflict(reason.toArray(new BooleanFormula[0]));
            raisedConflict = true;
        }
    }

    private Map<Set<BooleanFormula>, Integer> observedReasons = new HashMap<>();
    private void trackReason(List<BooleanFormula> reason) {
        // observedReasons.compute(new HashSet<>(reason), (k, v) -> v == null ? 1 : v + 1);
    }

    @Override
    public void onFinalCheck() {
        int uniqueReasons = observedReasons.size();
        int totalReasons = observedReasons.values().stream().mapToInt(v -> v).sum();
        int maxDuplicate = observedReasons.values().stream().mapToInt(v -> v).max().getAsInt();
        // System.out.println("total: " + totalReasons + " ### unique: " + uniqueReasons + " ### maxDup: " + maxDuplicate);
    }

    @Override
    public void onPush() {
        curLevel++;
    }

    @Override
    public void onPop(int numPoppedLevels) {
        raisedConflict = false;
        curLevel -= numPoppedLevels;
        relationGraph.backtrackTo(curLevel);
    }
}
