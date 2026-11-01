package com.dat3m.dartagnan.solver.caat.predicates.sets.base;

import com.dat3m.dartagnan.solver.caat.domain.Domain;
import com.dat3m.dartagnan.solver.caat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.caat.predicates.Derivable;
import com.dat3m.dartagnan.solver.caat.predicates.sets.Element;

import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class SimpleSet extends AbstractBaseSet {

    private final Map<Element, Element> elements = new HashMap<>();
    private final Set<Element> keySet = elements.keySet();
    // See SimpleGraph: allows cheap backtracking if elements are inserted with monotone timestamps.
    private final ArrayList<Element> trail = new ArrayList<>();
    private boolean monotone = true;
    private int maxTime = 0;

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
    public void initializeToDomain(Domain<?> domain) {
        super.initializeToDomain(domain);
        elements.clear();
        trail.clear();
        monotone = true;
        maxTime = 0;
    }

    @Override
    public void backtrackTo(int time) {
        if (maxTime <= time) {
            return;
        }
        if (monotone) {
            int i = trail.size();
            while (--i >= 0 && trail.get(i).getTime() > time) {
                elements.remove(trail.get(i));
            }
            trail.subList(i + 1, trail.size()).clear();
        } else {
            keySet.removeIf(e -> e.getTime() > time);
            trail.removeIf(e -> e.getTime() > time);
        }
        maxTime = trail.isEmpty() ? 0
                : monotone ? trail.get(trail.size() - 1).getTime()
                : trail.stream().mapToInt(Element::getTime).max().getAsInt();
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
        if (elements.putIfAbsent(ele, ele) != null) {
            return false;
        }
        if (ele.getTime() < maxTime) {
            monotone = false;
        }
        maxTime = Math.max(maxTime, ele.getTime());
        trail.add(ele);
        return true;
    }

    public boolean addAll(Collection<? extends Element> elems) {
        boolean changed = false;
        for (Element e : elems) {
            changed |= add(e);
        }
        return changed;
    }
}
