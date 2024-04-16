package com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.sets.base;

import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.Derivable;
import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.sets.Element;

import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class SimpleSet extends AbstractBaseSet {

    private final Map<Element, Element> elements = new HashMap<>();
    private final Set<Element> keySet = elements.keySet();

    @Override
    public int size() {
        return elements.size();
    }

    @Override
    public boolean contains(Derivable value) {
        return keySet.contains(value);
    }

    @Override
    public Element get(Derivable value) {
        return elements.get(value);
    }

    @Override
    public Element get(Element e) {
        return elements.get(e);
    }

    @Override
    public boolean contains(Element e) {
        return keySet.contains(e);
    }

    @Override
    public Iterator<Element> elementIterator() {
        return keySet.iterator();
    }

    @Override
    public Iterable<Element> elements() {
        return keySet;
    }

    @Override
    public Set<Element> setView() {
        return keySet;
    }

    @Override
    public void backtrackTo(int time) {
        keySet.removeIf(e -> e.getTime() > time);
    }

    @Override
    public Collection<Element> forwardPropagate(CAATPredicate changedSource, Collection<? extends Derivable> added) {
        Collection<Element> addedEles = (Collection<Element>) added;
        return addedEles.stream().filter(this::add).collect(Collectors.toList());
    }

    @Override
    public Stream<Element> elementStream() {
        return keySet.stream();
    }

    public boolean add(Element ele) {
        return elements.putIfAbsent(ele, ele) == null;
    }

    public boolean addAll(Collection<? extends Element> elems) {
        boolean changed = false;
        for (Element e : elems) {
            changed |= add(e);
        }
        return changed;
    }
}
