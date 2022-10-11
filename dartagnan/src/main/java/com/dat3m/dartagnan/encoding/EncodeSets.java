package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.wmm.relation.Relation;
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
final class EncodeSets implements Relation.Visitor<Map<Relation, Stream<Tuple>>> {

    List<Tuple> news;

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
        TupleSet may1 = r1.getMaxTupleSet();
        TupleSet may2 = r2.getMaxTupleSet();
        TupleSet must1 = r1.getMinTupleSet();
        TupleSet must2 = r2.getMinTupleSet();
        for (Tuple t : news) {
            Event e = t.getSecond();
            for (Tuple t1 : may1.getByFirst(t.getFirst())) {
                Tuple t2 = new Tuple(t1.getSecond(), e);
                if (may2.contains(t2)) {
                    if (!must1.contains(t1)) {
                        set1.add(t1);
                    }
                    if (!must2.contains(t2)) {
                        set2.add(t2);
                    }
                }
            }
        }
        return map(r1, set1.stream(), r2, set2.stream());
    }

    @Override
    public Map<Relation, Stream<Tuple>> visitDomainIdentity(Relation rel, Relation r1) {
        TupleSet may1 = r1.getMaxTupleSet();
        TupleSet must1 = r1.getMinTupleSet();
        return Map.of(r1, news.stream().flatMap(t -> may1.getByFirst(t.getFirst()).stream().filter(t1 -> !must1.contains(t1))));
    }

    @Override
    public Map<Relation, Stream<Tuple>> visitRangeIdentity(Relation rel, Relation r1) {
        TupleSet may1 = r1.getMaxTupleSet();
        TupleSet must1 = r1.getMinTupleSet();
        return Map.of(r1, news.stream().flatMap(t -> may1.getBySecond(t.getSecond()).stream().filter(t1 -> !must1.contains(t1))));
    }

    @Override
    public Map<Relation, Stream<Tuple>> visitInverse(Relation rel, Relation r1) {
        Collection<Tuple> may1 = r1.getMaxTupleSet();
        Collection<Tuple> must1 = r1.getMinTupleSet();
        return Map.of(r1, news.stream().map(Tuple::getInverse).filter(t -> may1.contains(t) && !must1.contains(t)));
    }

    @Override
    public Map<Relation, Stream<Tuple>> visitRecursive(Relation rel, Relation other) {
        return Map.of(other, news.stream());
    }

    @Override
    public Map<Relation, Stream<Tuple>> visitTransitiveClosure(Relation rel, Relation r1) {
        HashSet<Tuple> factors = new HashSet<>();
        TupleSet may = rel.getMaxTupleSet();
        TupleSet must = rel.getMinTupleSet();
        for (Tuple t : news) {
            Event e = t.getSecond();
            for (Tuple t1 : may.getByFirst(t.getFirst())) {
                Tuple t2 = new Tuple(t1.getSecond(), e);
                if (may.contains(t2)) {
                    if (!must.contains(t1)) {
                        factors.add(t1);
                    }
                    if (!must.contains(t2)) {
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
        TupleSet may = rscs.getMaxTupleSet();
        for (Tuple tuple : news) {
            Event lock = tuple.getFirst();
            Event unlock = tuple.getSecond();
            for (Tuple t : may.getBySecond(unlock)) {
                Event e = t.getFirst();
                if (lock.getCId() < e.getCId() && e.getCId() < unlock.getCId()) {
                    queue.add(t);
                }
            }
            for (Tuple t : may.getByFirst(lock)) {
                Event e = t.getSecond();
                if (lock.getCId() < e.getCId() && e.getCId() < unlock.getCId()) {
                    queue.add(t);
                }
            }
        }
        return Map.of(rscs, queue.stream());
    }

    private Stream<Tuple> lower(Collection<Tuple> news, Relation relation) {
        Collection<Tuple> may = relation.getMaxTupleSet();
        Collection<Tuple> must = relation.getMinTupleSet();
        return news.stream().filter(t -> may.contains(t) && !must.contains(t));
    }

    private static Map<Relation, Stream<Tuple>> map(Relation r1, Stream<Tuple> s1, Relation r2, Stream<Tuple> s2) {
        return r1.equals(r2) ? Map.of(r1, Stream.concat(s1, s2)) : Map.of(r1, s1, r2, s2);
    }
}
