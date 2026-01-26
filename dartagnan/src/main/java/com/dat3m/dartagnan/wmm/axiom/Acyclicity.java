package com.dat3m.dartagnan.wmm.axiom;

import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.mutable.MapEventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.mutable.MutableEventGraph;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

public class Acyclicity extends Axiom {

    private static final Logger logger = LoggerFactory.getLogger(Acyclicity.class);

    public Acyclicity(Relation rel, boolean negated, boolean flag) {
        super(Relation.checkIsRelation(rel), negated, flag);
    }

    public Acyclicity(Relation rel) {
        this(rel, false, false);
    }

    // Under-approximates the must-set of (rel+ ; rel).
    // It is the smallest set that contains the binary composition of the must-set with itself with implied intermediates
    // and is closed under that operation with the must-set.
    // Basically, the clause {@code exec(x) and exec(z) implies before(x,z)} is obsolete,
    // if the clauses {@code exec(x) implies before(x,y)} and {@code exec(z) implies before(y,z)} exist.
    // NOTE: Assumes that the must-set of rel+ is acyclic.
    private static EventGraph transitivelyDerivableMustEdges(ExecutionAnalysis exec, RelationAnalysis.Knowledge k) {
        MutableEventGraph result = new MapEventGraph();
        Map<Event, Set<Event>> map = new HashMap<>();
        Map<Event, Set<Event>> mapInverse = new HashMap<>();
        EventGraph current = k.getMustSet();
        while (!current.isEmpty()) {
            MutableEventGraph next = new MapEventGraph();
            current.apply((x, y) -> {
                map.computeIfAbsent(x, e -> new HashSet<>()).add(y);
                mapInverse.computeIfAbsent(y, e -> new HashSet<>()).add(x);
            });
            current.apply((x, y) -> {
                boolean implied = exec.isImplied(y, x);
                boolean implies = exec.isImplied(x, y);
                for (Event z : map.getOrDefault(y, Set.of())) {
                    if (!implies && !exec.isImplied(z, y) || exec.areMutuallyExclusive(x, z)) {
                        continue;
                    }
                    if (result.add(x, z)) {
                        next.add(x, z);
                    }
                }
                for (Event w : mapInverse.getOrDefault(x, Set.of())) {
                    if (!implied && !exec.isImplied(w, x) || exec.areMutuallyExclusive(w, y)) {
                        continue;
                    }
                    if (result.add(w, y)) {
                        next.add(w, y);
                    }
                }
            });
            current = next;
        }
        return result;
    }

    @Override
    public String toString() {
        return (flag ? "flag " : "") + (negated ? "~" : "") + "acyclic " + rel.getNameOrTerm();
    }

    @Override
    protected EventGraph getEncodeGraph(Context analysisContext) {
        ExecutionAnalysis exec = analysisContext.get(ExecutionAnalysis.class);
        RelationAnalysis ra = analysisContext.get(RelationAnalysis.class);
        RelationAnalysis.Knowledge k = ra.getKnowledge(rel);
        return MutableEventGraph.difference(getEncodeGraph(exec, ra), k.getMustSet());
    }

    public int getEncodeGraphSize(Context analysisContext) {
        return getEncodeGraph(analysisContext).size();
    }

    private EventGraph getEncodeGraph(ExecutionAnalysis exec, RelationAnalysis ra) {
        logger.info("Computing encodeGraph for {}", this);
        // ====== Construct [Event -> Successor] mapping ======
        EventGraph maySet = ra.getKnowledge(rel).getMaySet();
        Map<Event, Set<Event>> succMap = maySet.getOutMap();

        // ====== Compute SCCs ======
        DependencyGraph<Event> depGraph = DependencyGraph.from(succMap.keySet(), succMap);
        final MutableEventGraph result = new MapEventGraph();
        for (Set<DependencyGraph<Event>.Node> scc : depGraph.getSCCs()) {
            for (DependencyGraph<Event>.Node node1 : scc) {
                for (DependencyGraph<Event>.Node node2 : scc) {
                    Event e1 = node1.getContent();
                    Event e2 = node2.getContent();
                    if (maySet.contains(e1, e2)) {
                        result.add(e1, e2);
                    }
                }
            }
        }

        logger.info("encodeGraph size: {}", result.size());
        if (getMemoryModel().getConfig().isReduceAcyclicityEncoding()) {
            EventGraph obsolete = transitivelyDerivableMustEdges(exec, ra.getKnowledge(rel));
            result.removeAll(obsolete);
            logger.info("reduced encodeGraph size: {}", result.size());
        }
        return result;
    }


    @Override
    public <T> T accept(Visitor<? extends T> visitor) {
        return visitor.visitAcyclicity(this);
    }
}