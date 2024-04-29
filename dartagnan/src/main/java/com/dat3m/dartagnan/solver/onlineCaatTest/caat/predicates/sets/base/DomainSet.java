package com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.sets.base;

import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.Derivable;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.sets.Element;

import java.util.Collection;
import java.util.Collections;
import java.util.stream.IntStream;
import java.util.stream.Stream;

public class DomainSet extends AbstractBaseSet {

    @Override
    public void backtrackTo(int time) { }

    @Override
    public Collection<Element> forwardPropagate(CAATPredicate changedSource, Collection<? extends Derivable> added) {
        return Collections.emptyList();
    }

    @Override
    public Element get(Element ele) { return ele.with(0, 0); }

    @Override
    public int size() { return domain.size(); }

    @Override
    public boolean contains(Derivable value) { return value instanceof Element; }

    @Override
    public boolean contains(Element ele) { return containsById(ele.getId()); }

    @Override
    public boolean containsById(int id) { return 0 <= id && id < domain.size(); }

    @Override
    public Element getById(int id) { return containsById(id) ? new Element(id) : null; }

    @Override
    public Stream<Element> elementStream() {
        return IntStream.range(0, domain.size()).mapToObj(Element::new);
    }
}
