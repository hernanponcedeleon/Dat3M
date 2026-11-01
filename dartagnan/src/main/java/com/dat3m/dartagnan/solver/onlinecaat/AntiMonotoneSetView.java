package com.dat3m.dartagnan.solver.onlinecaat;

import com.dat3m.dartagnan.solver.caat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.caat.predicates.Derivable;
import com.dat3m.dartagnan.solver.caat.predicates.sets.Element;
import com.dat3m.dartagnan.solver.caat.predicates.sets.base.AbstractBaseSet;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.stream.Stream;

// The set analogue of AntiMonotoneGraphView.
public final class AntiMonotoneSetView extends AbstractBaseSet {

    final OnlineBaseSet base;
    private final OnlineCAATPropagator theory;

    AntiMonotoneSetView(OnlineCAATPropagator theory, OnlineBaseSet base) {
        this.theory = theory;
        this.base = base;
    }

    void collectOnAtomFalse(int e, int time, List<Element> out) {
        out.add(new Element(e, time, 0));
    }

    @Override
    public Element get(Element e) {
        final int id = e.getId();
        final int a = base.atom[id];
        if (a == OnlineBaseSet.NOT_MEMBER) {
            return null;
        }
        return (a == OnlineBaseSet.STATIC || theory.atomValue(a) >= 0) ? new Element(id) : null;
    }

    @Override
    @SuppressWarnings("unchecked")
    public Collection<Element> forwardPropagate(CAATPredicate changedSource, Collection<? extends Derivable> added) {
        return new ArrayList<>((Collection<Element>) added);
    }

    @Override
    public void backtrackTo(int time) { }

    @Override
    public int size() { return 0; }

    @Override
    public Stream<Element> elementStream() {
        throw new UnsupportedOperationException("Cannot enumerate the elements of " + getName());
    }

    @Override
    public String toString() { return getName(); }
}
