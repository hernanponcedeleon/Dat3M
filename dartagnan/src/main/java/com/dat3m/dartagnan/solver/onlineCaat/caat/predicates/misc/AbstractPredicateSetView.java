package com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.misc;

import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.Derivable;
import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.CAATPredicate;

import java.util.Collection;
import java.util.Iterator;
import java.util.Set;
import java.util.function.Consumer;
import java.util.function.Predicate;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public abstract class AbstractPredicateSetView<T extends Derivable> implements Set<T> {

    public abstract CAATPredicate getPredicate();

    @Override
    public abstract Stream<T> stream();

    @Override
    public abstract Iterator<T> iterator();

    @Override
    public int size() { return getPredicate().size(); }

    @Override
    public boolean isEmpty() { return getPredicate().isEmpty(); }

    @Override
    public boolean contains(Object o) {
        CAATPredicate pred = getPredicate();
        if (o instanceof Derivable der) {
            return pred.contains(der);
        }
        return false;
    }

    @Override
    public void forEach(Consumer<? super T> action) {
        stream().forEach(action);
    }

    @Override
    public Object[] toArray() {
        return stream().toArray();
    }

    @Override
    public <T1> T1[] toArray(T1[] a) {
        return stream().collect(Collectors.toList()).toArray(a);
    }

    @Override
    public boolean containsAll(Collection<?> c) {
        for (Object o : c) {
            if (!contains(o)) {
                return false;
            }
        }
        return true;
    }

    @Override
    public boolean removeIf(Predicate<? super T> filter) { return false; }

    @Override
    public boolean add(T t) { return false; }

    @Override
    public boolean remove(Object o) { return false; }

    @Override
    public boolean addAll(Collection<? extends T> c) { return false; }

    @Override
    public boolean retainAll(Collection<?> c) { return false; }

    @Override
    public boolean removeAll(Collection<?> c) { return false; }

    @Override
    public void clear() { }
}
