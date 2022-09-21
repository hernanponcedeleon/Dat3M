package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Definition.Visitor;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.stream.Stream;

// Collections of relationships in a verification task that need to be constrained in an SMT-based verification.
final class EncodeSets implements Visitor<Map<Relation, Stream<Tuple>>> {

    private final RelationAnalysis ra;
    List<Tuple> news;

    EncodeSets(Context analysisContext) {
        ra = analysisContext.requires(RelationAnalysis.class);
    }

    @Override
    public Map<Relation, Stream<Tuple>> visitDefinition(Relation r, List<? extends Relation> d) {
        return Map.of();
    }

    @Override
    public Map<Relation, Stream<Tuple>> visitUnion(Relation rel, Relation... operands) {
        Map<Relation, Stream<Tuple>> m = new HashMap<>();
        for (Relation r : operands) {
            m.merge(r, lower(news, r), Stream::concat);
        }
        return m;
    }

    @Override
    public Map<Relation, Stream<Tuple>> visitIntersection(Relation rel, Relation... operands) {
        Map<Relation, Stream<Tuple>> m = new HashMap<>();
        for (Relation r : operands) {
            m.merge(r, lower(news, r), Stream::concat);
        }
        return m;
    }

    @Override
    public Map<Relation, Stream<Tuple>> visitDifference(Relation rel, Relation r1, Relation r2) {
        return map(r1, lower(news, r1), r2, lower(news, r2));
    }

    @Override
    public Map<Relation, Stream<Tuple>> visitComposition(Relation rel, Relation r1, Relation r2) {
        if (news.isEmpty()) {
            return Map.of();
        }
        TupleSet set1 = new TupleSet();
        TupleSet set2 = new TupleSet();
        final RelationAnalysis.Knowledge k1 = ra.getKnowledge(r1);
        final RelationAnalysis.Knowledge k2 = ra.getKnowledge(r2);
        for (Tuple t : news) {
            Event e = t.getSecond();
            for (Tuple t1 : k1.getMaySet().getByFirst(t.getFirst())) {
                Tuple t2 = new Tuple(t1.getSecond(), e);
                if (k2.getMaySet().contains(t2)) {
                    if (!k1.getMustSet().contains(t1)) {
                        set1.add(t1);
                    }
                    if (!k2.getMustSet().contains(t2)) {
                        set2.add(t2);
                    }
                }
            }
        }
        return map(r1, set1.stream(), r2, set2.stream());
    }

    @Override
    public Map<Relation, Stream<Tuple>> visitDomainIdentity(Relation rel, Relation r1) {
        final RelationAnalysis.Knowledge k1 = ra.getKnowledge(r1);
        return Map.of(r1, news.stream().flatMap(t -> k1.getMaySet().getByFirst(t.getFirst()).stream().filter(t1 -> !k1.getMustSet().contains(t1))));
    }

    @Override
    public Map<Relation, Stream<Tuple>> visitRangeIdentity(Relation rel, Relation r1) {
        final RelationAnalysis.Knowledge k1 = ra.getKnowledge(r1);
        return Map.of(r1, news.stream().flatMap(t -> k1.getMaySet().getBySecond(t.getSecond()).stream().filter(t1 -> !k1.getMustSet().contains(t1))));
    }

    @Override
    public Map<Relation, Stream<Tuple>> visitInverse(Relation rel, Relation r1) {
        final RelationAnalysis.Knowledge k1 = ra.getKnowledge(r1);
        return Map.of(r1, news.stream().map(Tuple::getInverse).filter(t -> k1.getMaySet().contains(t) && !k1.getMustSet().contains(t)));
    }

    @Override
    public Map<Relation, Stream<Tuple>> visitTransitiveClosure(Relation rel, Relation r1) {
        HashSet<Tuple> factors = new HashSet<>();
        final RelationAnalysis.Knowledge k0 = ra.getKnowledge(rel);
        for (Tuple t : news) {
            Event e = t.getSecond();
            for (Tuple t1 : k0.getMaySet().getByFirst(t.getFirst())) {
                Tuple t2 = new Tuple(t1.getSecond(), e);
                if (k0.getMaySet().contains(t2)) {
                    if (!k0.getMustSet().contains(t1)) {
                        factors.add(t1);
                    }
                    if (!k0.getMustSet().contains(t2)) {
                        factors.add(t2);
                    }
                }
            }
        }
        return map(rel, factors.stream(), r1, lower(news, r1));
    }

    @Override
    public Map<Relation, Stream<Tuple>> visitCriticalSections(Relation rscs) {
        List<Tuple> queue = new ArrayList<>();
        final RelationAnalysis.Knowledge k0 = ra.getKnowledge(rscs);
        for (Tuple tuple : news) {
            Event lock = tuple.getFirst();
            Event unlock = tuple.getSecond();
            for (Tuple t : k0.getMaySet().getBySecond(unlock)) {
                Event e = t.getFirst();
                if (lock.getCId() < e.getCId() && e.getCId() < unlock.getCId()) {
                    queue.add(t);
                }
            }
            for (Tuple t : k0.getMaySet().getByFirst(lock)) {
                Event e = t.getSecond();
                if (lock.getCId() < e.getCId() && e.getCId() < unlock.getCId()) {
                    queue.add(t);
                }
            }
        }
        return Map.of(rscs, queue.stream());
    }

    private Stream<Tuple> lower(Collection<Tuple> news, Relation relation) {
        final RelationAnalysis.Knowledge k = ra.getKnowledge(relation);
        return news.stream().filter(t -> k.getMaySet().contains(t) && !k.getMustSet().contains(t));
    }

    private static Map<Relation, Stream<Tuple>> map(Relation r1, Stream<Tuple> s1, Relation r2, Stream<Tuple> s2) {
        return r1.equals(r2) ? Map.of(r1, Stream.concat(s1, s2)) : Map.of(r1, s1, r2, s2);
    }
}
