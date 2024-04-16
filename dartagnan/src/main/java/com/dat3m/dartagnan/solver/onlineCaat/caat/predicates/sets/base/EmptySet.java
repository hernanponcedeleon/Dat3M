package com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.sets.base;

import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.Derivable;
import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.sets.Element;

import java.util.Collection;
import java.util.Collections;
import java.util.Iterator;
import java.util.Set;
import java.util.stream.Stream;

public class EmptySet extends AbstractBaseSet {

    @Override
    public void backtrackTo(int time) { }

    @Override
    public Collection<Element> forwardPropagate(CAATPredicate changedSource, Collection<? extends Derivable> added) {
        return Collections.emptyList();
    }

    @Override
    public Element get(Element ele) { return null; }

    @Override
    public Element get(Derivable value) { return null; }

    @Override
    public int size() { return 0; }
    @Override
    public boolean contains(Derivable value) { return false; }

    @Override
    public boolean contains(Element ele) { return false; }

    @Override
    public boolean containsById(int id1) { return false; }

    @Override
    public Element getById(int id1) { return null; }

    @Override
    public Set<Element> setView() { return Collections.emptySet(); }

    @Override
    public Iterator<Element> elementIterator() { return Collections.emptyIterator(); }

    @Override
    public Iterable<Element> elements() { return Collections.emptyList(); }

    @Override
    public Stream<Element> elementStream() { return Stream.empty(); }
}
