package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Definition.Visitor;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.utils.Tuple;

import java.util.*;
import java.util.stream.Stream;

// Collections of relationships in a verification task that need to be constrained in an SMT-based verification.
final class EncodeSets implements Visitor<Map<Relation, Stream<Tuple>>> {

    private final RelationAnalysis ra;
    List<Tuple> news;
    Map<Relation, Map<Event, List<Tuple>>> outSetMap = new HashMap<>();

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
            m.merge(r, filterUnknowns(news, r), Stream::concat);
        }
        return m;
    }

    @Override
    public Map<Relation, Stream<Tuple>> visitIntersection(Relation rel, Relation... operands) {
        Map<Relation, Stream<Tuple>> m = new HashMap<>();
        for (Relation r : operands) {
            m.merge(r, filterUnknowns(news, r), Stream::concat);
        }
        return m;
    }

    @Override
    public Map<Relation, Stream<Tuple>> visitDifference(Relation rel, Relation r1, Relation r2) {
        return map(r1, filterUnknowns(news, r1), r2, filterUnknowns(news, r2));
    }

    @Override
    public Map<Relation, Stream<Tuple>> visitComposition(Relation rel, Relation r1, Relation r2) {
        if (news.isEmpty()) {
            return Map.of();
        }
        final Set<Tuple> set1 = new HashSet<>();
        final Set<Tuple> set2 = new HashSet<>();
        final RelationAnalysis.Knowledge k1 = ra.getKnowledge(r1);
        final RelationAnalysis.Knowledge k2 = ra.getKnowledge(r2);
        if(!outSetMap.containsKey(r1)) {
            Map<Event, List<Tuple>> outSet = new HashMap<>();
            for (Tuple t : k1.getMaySet()) { 
                outSet.computeIfAbsent(t.getFirst(), key -> new ArrayList<>()).add(t);
            }
            outSetMap.put(r1, outSet);    
        }

        for (Tuple t : news) {
            Event e = t.getSecond();
            for (Tuple t1 : outSetMap.get(r1).get(t.getFirst())) {
                Tuple t2 = new Tuple(t1.getSecond(), e);
                if (k2.containsMay(t2)) {
                    if (!k1.containsMust(t1)) {
                        set1.add(t1);
                    }
                    if (!k2.containsMust(t2)) {
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
        return Map.of(r1, news.stream().flatMap(t -> k1.getMayOut(t.getFirst()).stream().filter(t1 -> !k1.containsMust(t1))));
    }

    @Override
    public Map<Relation, Stream<Tuple>> visitRangeIdentity(Relation rel, Relation r1) {
        final RelationAnalysis.Knowledge k1 = ra.getKnowledge(r1);
        return Map.of(r1, news.stream().flatMap(t -> k1.getMayIn(t.getSecond()).stream().filter(t1 -> !k1.containsMust(t1))));
    }

    @Override
    public Map<Relation, Stream<Tuple>> visitInverse(Relation rel, Relation r1) {
        final RelationAnalysis.Knowledge k1 = ra.getKnowledge(r1);
        return Map.of(r1, news.stream().map(Tuple::getInverse).filter(t -> k1.containsMay(t) && !k1.containsMust(t)));
    }

    @Override
    public Map<Relation, Stream<Tuple>> visitTransitiveClosure(Relation rel, Relation r1) {
        HashSet<Tuple> factors = new HashSet<>();
        final RelationAnalysis.Knowledge k0 = ra.getKnowledge(rel);
        if(!outSetMap.containsKey(rel)) {
            Map<Event, List<Tuple>> outSet = new HashMap<>();
            for (Tuple t : k0.getMaySet()) { 
                outSet.computeIfAbsent(t.getFirst(), key -> new ArrayList<>()).add(t);
            }
            outSetMap.put(rel, outSet);    
        }

        for (Tuple t : news) {
            Event e = t.getSecond();
            for (Tuple t1 : outSetMap.get(rel).get(t.getFirst())) {
                Tuple t2 = new Tuple(t1.getSecond(), e);
                if (k0.containsMay(t2)) {
                    if (!k0.containsMust(t1)) {
                        factors.add(t1);
                    }
                    if (!k0.containsMust(t2)) {
                        factors.add(t2);
                    }
                }
            }
        }
        return map(rel, factors.stream(), r1, filterUnknowns(news, r1));
    }

    @Override
    public Map<Relation, Stream<Tuple>> visitCriticalSections(Relation rscs) {
        List<Tuple> queue = new ArrayList<>();
        final RelationAnalysis.Knowledge k0 = ra.getKnowledge(rscs);
        for (Tuple tuple : news) {
            Event lock = tuple.getFirst();
            Event unlock = tuple.getSecond();
            for (Tuple t : k0.getMayIn(unlock)) {
                Event e = t.getFirst();
                if (lock.getGlobalId() < e.getGlobalId() && e.getGlobalId() < unlock.getGlobalId()) {
                    queue.add(t);
                }
            }
            for (Tuple t : k0.getMayOut(lock)) {
                Event e = t.getSecond();
                if (lock.getGlobalId() < e.getGlobalId() && e.getGlobalId() < unlock.getGlobalId()) {
                    queue.add(t);
                }
            }
        }
        return Map.of(rscs, queue.stream());
    }

    private Stream<Tuple> filterUnknowns(Collection<Tuple> news, Relation relation) {
        final RelationAnalysis.Knowledge k = ra.getKnowledge(relation);
        return news.stream().filter(t -> k.containsMay(t) && !k.containsMust(t));
    }

    private static Map<Relation, Stream<Tuple>> map(Relation r1, Stream<Tuple> s1, Relation r2, Stream<Tuple> s2) {
        return r1.equals(r2) ? Map.of(r1, Stream.concat(s1, s2)) : Map.of(r1, s1, r2, s2);
    }
}
