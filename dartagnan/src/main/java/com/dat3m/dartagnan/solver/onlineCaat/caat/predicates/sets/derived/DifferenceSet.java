package com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.sets.derived;


import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.misc.PredicateVisitor;
import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.sets.SetPredicate;
import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.AbstractPredicate;
import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.Derivable;
import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.sets.Element;

import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class DifferenceSet extends AbstractPredicate implements SetPredicate {

    private final SetPredicate first;
    private final SetPredicate second;

    @Override
    public List<SetPredicate> getDependencies() {
        return Arrays.asList(first, second);
    }

    public SetPredicate getFirst() { return first; }
    public SetPredicate getSecond() { return second; }

    public DifferenceSet(SetPredicate first, SetPredicate second) {
        this.first = first;
        this.second = second;
    }

    @Override
    public int getMinSize() {
        return first.getMinSize() - second.getMaxSize();
    }

    @Override
    public int getMaxSize() {
        return first.getMaxSize();
    }

    @Override
    public Element get(Element e) {
        return second.contains(e) ? null : first.get(e);
    }

    @Override
    public Stream<Element> elementStream() {
        return first.elementStream().filter(e -> !second.contains(e));
    }

    @Override
    public Element getById(int id) {
        return second.containsById(id) ? null : first.getById(id);
    }

    @Override
    public boolean contains(Element e) {
        return !second.contains(e) && first.contains(e);
    }

    @Override
    public boolean containsById(int id) {
        return !second.containsById(id) && first.containsById(id);
    }

    @Override
    @SuppressWarnings("unchecked")
    public Collection<Element> forwardPropagate(CAATPredicate changedSource, Collection<? extends Derivable> added) {
        Collection<Element> addedElems = (Collection<Element>) added;
        if (changedSource == first) {
            return addedElems.stream().filter(e -> !second.contains(e)).collect(Collectors.toList());
        } else if (changedSource == second) {
            throw new IllegalStateException("Non-static predicates on the right hand side of differences are invalid.");
        } else {
            return Collections.emptyList();
        }
    }

    @Override
    public void backtrackTo(int time) { }
    @Override
    public void repopulate() { }

    @Override
    public <TRet, TData, TContext> TRet accept(PredicateVisitor<TRet, TData, TContext> visitor, TData data, TContext context) {
        return visitor.visitSetDifference(this, data, context);
    }


}
