package com.dat3m.dartagnan.wmm.utils;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.utils.equivalence.BranchEquivalence;
import com.google.common.collect.Iterables;

import java.util.*;
import java.util.function.BiPredicate;
import java.util.function.Function;


//TODO: This class should probably be replaced
// The utility functions are nice, but it is not extensible/interchangeable with custom
// implementations
// The solutions are as follows:
// (1) Make TupleSet an interface and this class its default implementation (easy)
// (2) Use Set<Tuple> instead, and move the utility of this class into a separate class
//     Right now, the only value it has is the byFirst/bySecond functionality
//     which could be computed on demand instead.
//     Advantage over (1): We can reuse all code that generates arbitrary sets (e.g. the functionality provided by guava)
public class TupleSet implements Set<Tuple>{

    private final Set<Tuple> tuples;
    private final Map<Event, Set<Tuple>> byFirst = new HashMap<>();
    private final Map<Event, Set<Tuple>> bySecond = new HashMap<>();
    private boolean isUpdated = false;

    public TupleSet() {
        tuples = new HashSet<>();
    }

    public TupleSet(Collection<? extends Tuple> c) {
        tuples = new HashSet<>(c);
        isUpdated = !tuples.isEmpty();
    }

    @Override
    public boolean add(Tuple e){
        boolean result = tuples.add(e);
        isUpdated |= result;
        return result;
    }

    @Override
    public boolean addAll(Collection<? extends Tuple> c){
        boolean result = c instanceof TupleSet ? tuples.addAll(((TupleSet)c).tuples) : tuples.addAll(c);
        isUpdated |= result;
        return result;
    }

    @Override
    public void clear(){
        tuples.clear();
        isUpdated = true;
    }

    @Override
    public boolean contains(Object e){
        return tuples.contains(e);
    }

    @Override
    public boolean containsAll(Collection<?> c){
        return c instanceof TupleSet ? tuples.containsAll(((TupleSet)c).tuples) : tuples.containsAll(c);
    }

    @Override
    public boolean equals(Object obj){
        if (this == obj) {
            return true;
        } else if (obj == null || getClass() != obj.getClass()) {
            return false;
        }

        return tuples.equals(((TupleSet)obj).tuples);
    }

    @Override
    public int hashCode(){
        return tuples.hashCode();
    }

    @Override
    public boolean isEmpty(){
        return tuples.isEmpty();
    }

    @Override
    public Iterator<Tuple> iterator(){
        return tuples.iterator();
    }

    @Override
    public boolean remove(Object e){
        boolean result = tuples.remove(e);
        isUpdated |= result;
        return result;
    }

    @Override
    public boolean removeAll(Collection<?> c){
        boolean result = c instanceof TupleSet ? tuples.removeAll(((TupleSet)c).tuples) : tuples.removeAll(c);
        isUpdated |= result;
        return result;
    }

    @Override
    public boolean retainAll(Collection<?> c){
        boolean result = c instanceof TupleSet ? tuples.retainAll(((TupleSet)c).tuples) : tuples.retainAll(c);
        isUpdated |= result;
        return result;
    }

    @Override
    public int size(){
        return tuples.size();
    }

    @Override
    public Object[] toArray(){
        return tuples.toArray();
    }

    @Override
    public <T> T[] toArray(T[] a){
        return tuples.toArray(a);
    }

    @Override
    public String toString(){
        return tuples.toString();
    }

    public Set<Tuple> getByFirst(Event e){
        if(isUpdated){
            updateAuxiliary();
        }
        return byFirst.computeIfAbsent(e, key -> new HashSet<>());
    }

    public Set<Tuple> getBySecond(Event e){
        if(isUpdated){
            updateAuxiliary();
        }
        return bySecond.computeIfAbsent(e, key -> new HashSet<>());
    }

    //TODO: Reimplement transMap using tarjan and SCCs
    public Map<Event, Set<Event>> transMap(){
        Map<Event, Set<Event>> map = new HashMap<>();

        final Function<Event, Set<Event>> newSet = key -> new HashSet<>();
        for(Tuple tuple : tuples){
            map.computeIfAbsent(tuple.getFirst(), newSet).add(tuple.getSecond());
            map.computeIfAbsent(tuple.getSecond(), newSet);
        }

        boolean changed = true;

        while (changed){
            changed = false;
            for(Event e1 : map.keySet()){
                Set<Event> newEls = new HashSet<>();
                for(Event e2 : map.get(e1)){
                    if(e1.getCId() != e2.getCId()){
                        newEls.addAll(map.get(e2));
                    }
                }
                if(map.get(e1).addAll(newEls)) {
                    changed = true;
                }
            }
        }

        return map;
    }

    private void updateAuxiliary(){
        byFirst.clear();
        bySecond.clear();
        final Function<Event, Set<Tuple>> newSet = key -> new HashSet<>();
        for(Tuple e : tuples){
            byFirst.computeIfAbsent(e.getFirst(), newSet).add(e);
            bySecond.computeIfAbsent(e.getSecond(), newSet).add(e);
        }
        isUpdated = false;
    }

    // ================ Utility functions ==============
    public TupleSet inverse() {
        return this.mapped(Tuple::getInverse);
    }

    //TODO: Make clear through which tuple set is iterated first/second
    // This can make a big difference because getByFirst/Second needs to be recomputed
    // if the corresponding tuple set is changed (e.g. by repeated composition)
    public TupleSet preComposition(TupleSet tuples) {
        TupleSet result = new TupleSet();
        for (Tuple t1 : tuples) {
            Event e1 = t1.getFirst();
            Event e2 = t1.getSecond();
            for (Tuple t2 : this.getByFirst(e2)) {
                Event e3 = t2.getSecond();
                result.add(new Tuple(e1 , e3));
            }
        }
        return result;
    }

    public TupleSet preComposition(TupleSet tuples, BiPredicate<Tuple, Tuple> condition) {
        TupleSet result = new TupleSet();
        for (Tuple t1 : tuples) {
            Event e1 = t1.getFirst();
            Event e2 = t1.getSecond();
            for (Tuple t2 : this.getByFirst(e2)) {
                if (condition.test(t1, t2)) {
                    Event e3 = t2.getSecond();
                    result.add(new Tuple(e1, e3));
                }
            }
        }
        return result;
    }

    public TupleSet postComposition(TupleSet tuples) {
        return tuples.preComposition(this);
    }

    public TupleSet postComposition(TupleSet tuples, BiPredicate<Tuple, Tuple> condition) {
        return tuples.preComposition(this, condition);
    }

    public TupleSet mapped(Function<Tuple, Tuple> mapping) {
        TupleSet result = new TupleSet();
        tuples.stream().map(mapping).forEach(result::add);
        return result;
    }

    // =============== Static utility functions =================

    public static TupleSet approximateTransitiveMustReduction(BranchEquivalence eq, TupleSet minSet) {
        // Approximative must-transitive reduction of minSet:
        TupleSet reduct = new TupleSet();
        Iterable<Event> codomain = Iterables.transform(minSet, Tuple::getSecond);
        DependencyGraph<Event> depGraph = DependencyGraph.from(codomain, e -> Iterables.transform(minSet.getBySecond(e), Tuple::getFirst));
        for (DependencyGraph<Event>.Node start : depGraph.getNodes()) {
            Event e1 = start.getContent();
            List<DependencyGraph<Event>.Node> deps = start.getDependents();
            for (int i = deps.size() - 1; i >= 0; i--) {
                DependencyGraph<Event>.Node end = deps.get(i);
                Event e3 = end.getContent();
                boolean redundant = false;
                for (DependencyGraph<Event>.Node mid : deps.subList(0, i)) {
                    Event e2 = mid.getContent();
                    if (e2.cfImpliesExec() && (eq.isImplied(e1, e2) || eq.isImplied(e3, e2))) {
                        if (minSet.contains(new Tuple(e2, e3))) {
                            redundant = true;
                            break;
                        }
                    }
                }
                if (!redundant) {
                    reduct.add(new Tuple(e1, e3));
                }
            }
        }
        return reduct;
    }
}
