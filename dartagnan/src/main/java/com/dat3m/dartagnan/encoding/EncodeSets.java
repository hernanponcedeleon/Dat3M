package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.wmm.Constraint.Visitor;
import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.definition.*;
import com.dat3m.dartagnan.wmm.utils.EventGraph;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

// Propagates relationships in a verification task that need to be constrained in an SMT-based verification.
final class EncodeSets implements Visitor<Map<Relation, EventGraph>> {

    private final RelationAnalysis ra;
    EventGraph news;

    EncodeSets(Context analysisContext) {
        ra = analysisContext.requires(RelationAnalysis.class);
    }

    @Override
    public Map<Relation, EventGraph> visitDefinition(Definition def) {
        return Map.of();
    }

    @Override
    public Map<Relation, EventGraph> visitUnion(Union union) {
        final Map<Relation, EventGraph> m = new HashMap<>();
        for (Relation r : union.getOperands()) {
            m.merge(r, filterUnknowns(news, r), EventGraph::union);
        }
        return m;
    }

    @Override
    public Map<Relation, EventGraph> visitIntersection(Intersection inter) {
        final Map<Relation, EventGraph> m = new HashMap<>();
        for (Relation r : inter.getOperands()) {
            m.merge(r, filterUnknowns(news, r), EventGraph::union);
        }
        return m;
    }

    @Override
    public Map<Relation, EventGraph> visitDifference(Difference diff) {
        final Relation r1 = diff.getMinuend();
        final Relation r2 = diff.getSubtrahend();
        return map(r1, filterUnknowns(news, r1), r2, filterUnknowns(news, r2));
    }

    @Override
    public Map<Relation, EventGraph> visitComposition(Composition comp) {
        if (news.isEmpty()) {
            return Map.of();
        }

        final Relation r1 = comp.getLeftOperand();
        final Relation r2 = comp.getRightOperand();
        final EventGraph set1 = new EventGraph();
        final EventGraph set2 = new EventGraph();
        final RelationAnalysis.Knowledge k1 = ra.getKnowledge(r1);
        final RelationAnalysis.Knowledge k2 = ra.getKnowledge(r2);
        Map<Event, Set<Event>> out = ra.getKnowledge(r1).getMaySet().getOutMap();
        news.apply((e1, e2) -> {
            for (Event e : out.getOrDefault(e1, Set.of())) {
                if (k2.getMaySet().contains(e, e2)) {
                    if (!k1.getMustSet().contains(e1, e)) {
                        set1.add(e1, e);
                    }
                    if (!k2.getMustSet().contains(e, e2)) {
                        set2.add(e, e2);
                    }
                }
            }
        });
        return map(r1, set1, r2, set2);
    }

    @Override
    public Map<Relation, EventGraph> visitDomainIdentity(DomainIdentity domId) {
        final RelationAnalysis.Knowledge k1 = ra.getKnowledge(domId.getOperand());
        Map<Event, Set<Event>> out = k1.getMaySet().getOutMap();
        EventGraph result = new EventGraph();
        news.apply((e1, e2) ->
            out.getOrDefault(e1, Set.of()).forEach(e -> {
                if (!k1.getMustSet().contains(e1, e)) {
                    result.add(e1, e);
                }
            })
        );
        return Map.of(domId.getOperand(), result);
    }

    @Override
    public Map<Relation, EventGraph> visitRangeIdentity(RangeIdentity rangeId) {
        final RelationAnalysis.Knowledge k1 = ra.getKnowledge(rangeId.getOperand());
        Map<Event, Set<Event>> in = k1.getMaySet().getInMap();
        EventGraph result = new EventGraph();
        news.apply((e1, e2) ->
            in.getOrDefault(e2, Set.of()).forEach(e -> {
                if (!k1.getMustSet().contains(e, e2)) {
                    result.add(e, e2);
                }
            })
        );
        return Map.of(rangeId.getOperand(), result);
    }

    @Override
    public Map<Relation, EventGraph> visitInverse(Inverse inv) {
        final RelationAnalysis.Knowledge k1 = ra.getKnowledge(inv.getOperand());
        return Map.of(inv.getOperand(),
                news.inverse().filter((e1, e2) -> k1.getMaySet().contains(e1, e2) && !k1.getMustSet().contains(e1, e2)));
    }

    @Override
    public Map<Relation, EventGraph> visitTransitiveClosure(TransitiveClosure trans) {
        final Relation rel = trans.getDefinedRelation();
        final Relation r1 = trans.getOperand();
        EventGraph factors = new EventGraph();
        final RelationAnalysis.Knowledge k0 = ra.getKnowledge(rel);
        Map<Event, Set<Event>> out = k0.getMaySet().getOutMap();
        news.apply((e1, e2) -> {
            for (Event e : out.getOrDefault(e1, Set.of())) {
                if (k0.getMaySet().contains(e, e2)) {
                    if (!k0.getMustSet().contains(e1, e)) {
                        factors.add(e1, e);
                    }
                    if (!k0.getMustSet().contains(e, e2)) {
                        factors.add(e, e2);
                    }
                }
            }
        });
        return map(rel, factors, r1, filterUnknowns(news, r1));
    }

    @Override
    public Map<Relation, EventGraph> visitLinuxCriticalSections(LinuxCriticalSections rscs) {
        EventGraph queue = new EventGraph();
        final RelationAnalysis.Knowledge k0 = ra.getKnowledge(rscs.getDefinedRelation());
        Map<Event, Set<Event>> in = k0.getMaySet().getInMap();
        Map<Event, Set<Event>> out = k0.getMaySet().getOutMap();
        news.apply((lock, unlock) -> {
            for (Event e : in.getOrDefault(unlock, Set.of())) {
                if (lock.getGlobalId() < e.getGlobalId() && e.getGlobalId() < unlock.getGlobalId()) {
                    queue.add(e, unlock);
                }
            }
            for (Event e : out.getOrDefault(lock, Set.of())) {
                if (lock.getGlobalId() < e.getGlobalId() && e.getGlobalId() < unlock.getGlobalId()) {
                    queue.add(lock, e);
                }
            }
        });
        return Map.of(rscs.getDefinedRelation(), queue);
    }

    private EventGraph filterUnknowns(EventGraph news, Relation relation) {
        RelationAnalysis.Knowledge k = ra.getKnowledge(relation);
        EventGraph may = k.getMaySet();
        EventGraph must = k.getMustSet();
        return news.filter((e1, e2) -> may.contains(e1, e2) && !must.contains(e1, e2));
    }

    private static Map<Relation, EventGraph> map(Relation r1, EventGraph s1, Relation r2, EventGraph s2) {
        return r1.equals(r2) ? Map.of(r1, EventGraph.union(s1, s2)) : Map.of(r1, s1, r2, s2);
    }
}
