package com.dat3m.dartagnan.solver.caat4wmm.basePredicates;

import com.dat3m.dartagnan.solver.caat.domain.Domain;
import com.dat3m.dartagnan.solver.caat.predicates.sets.Element;
import com.dat3m.dartagnan.solver.caat.predicates.sets.base.SimpleSet;

import java.util.Iterator;
import java.util.stream.Stream;

public abstract class MaterializedWMMSet extends AbstractWMMSet {

    protected final SimpleSet simpleSet;

    protected MaterializedWMMSet() {
        this.simpleSet = new SimpleSet();
    }

    @Override
    public Element get(Element element) { return simpleSet.get(element); }

    @Override
    public boolean containsById(int a) { return simpleSet.containsById(a); }

    @Override
    public boolean contains(Element element) { return simpleSet.contains(element); }

    @Override
    public void backtrackTo(int time) { simpleSet.backtrackTo(time); }

    @Override
    public void initializeToDomain(Domain<?> domain) {
        super.initializeToDomain(domain);
        simpleSet.initializeToDomain(domain);
    }

    @Override
    public int getEstimatedSize() { return simpleSet.getEstimatedSize(); }

    @Override
    public int getMinSize() { return simpleSet.getMinSize(); }

    @Override
    public int getMaxSize() { return simpleSet.getMaxSize(); }

    @Override
    public Stream<Element> elementStream() { return simpleSet.elementStream(); }

    @Override
    public Iterator<Element> elementIterator() { return simpleSet.elementIterator(); }

    @Override
    public int size() { return simpleSet.size(); }

    @Override
    public boolean isEmpty() { return simpleSet.isEmpty(); }
}
