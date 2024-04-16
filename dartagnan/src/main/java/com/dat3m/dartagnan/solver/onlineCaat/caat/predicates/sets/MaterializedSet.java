package com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.sets;

import com.dat3m.dartagnan.solver.onlineCaat.caat.domain.Domain;
import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.AbstractPredicate;
import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.Derivable;
import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.sets.base.SimpleSet;

import java.util.Collection;
import java.util.Iterator;
import java.util.Set;
import java.util.stream.Stream;

public abstract class MaterializedSet extends AbstractPredicate implements SetPredicate {

    protected final SimpleSet simpleSet;

    protected MaterializedSet() {
        this.simpleSet = new SimpleSet();
    }

    @Override
    public void initializeToDomain(Domain<?> domain) {
        super.initializeToDomain(domain);
        simpleSet.initializeToDomain(domain);
    }

    @Override
    public int size() {
        return simpleSet.size();
    }

    @Override
    public boolean contains(Derivable value) {
        return simpleSet.contains(value);
    }

    @Override
    public boolean isEmpty() {
        return simpleSet.isEmpty();
    }

    @Override
    public int getMinSize() {
        return simpleSet.getMinSize();
    }

    @Override
    public int getMaxSize() {
        return simpleSet.getMaxSize();
    }

    @Override
    public int getEstimatedSize() {
        return simpleSet.getEstimatedSize();
    }

    @Override
    public Element get(Element e) {
        return simpleSet.get(e);
    }

    @Override
    public Stream<Element> elementStream() {
        return simpleSet.elementStream();
    }

    @Override
    public Element getById(int id) {
        return simpleSet.getById(id);
    }

    @Override
    public boolean contains(Element e) {
        return simpleSet.contains(e);
    }

    @Override
    public boolean containsById(int id) {
        return simpleSet.containsById(id);
    }

    @Override
    public Iterator<Element> elementIterator() {
        return simpleSet.elementIterator();
    }

    @Override
    public Iterable<Element> elements() {
        return simpleSet.elements();
    }

    @Override
    public Set<Element> setView() {
        return simpleSet.setView();
    }

    @Override
    public Element get(Derivable value) {
        return simpleSet.get(value);
    }

    @Override
    public Collection<Element> forwardPropagate(CAATPredicate changedSource, Collection<? extends Derivable> added) {
        return simpleSet.forwardPropagate(changedSource, added);
    }

    @Override
    public void backtrackTo(int time) {
        simpleSet.backtrackTo(time);
    }
}
