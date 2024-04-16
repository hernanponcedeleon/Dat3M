package com.dat3m.dartagnan.solver.onlineCaat.caat4wmm.basePredicates;

import com.dat3m.dartagnan.program.filter.Filter;
import com.dat3m.dartagnan.solver.caat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.caat.predicates.Derivable;
import com.dat3m.dartagnan.solver.caat.predicates.misc.PredicateVisitor;
import com.dat3m.dartagnan.solver.caat.predicates.sets.Element;
import com.dat3m.dartagnan.solver.caat.predicates.sets.SetPredicate;

import java.util.Collection;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class StaticWMMSet extends AbstractWMMPredicate implements SetPredicate {

    private final Filter filter;
    private List<Element> events;

    public StaticWMMSet(Filter filter) {
        this.filter = filter;
    }

    @Override
    public <TRet, TData, TContext> TRet accept(PredicateVisitor<TRet, TData, TContext> visitor, TData tData, TContext context) {
        return visitor.visitBaseSet(this, tData, context);
    }

    @Override
    public void repopulate() {
        events = model.getEventList().stream()
                .filter(e -> filter.apply(e.getEvent()))
                .map(e -> new Element(e.getId())).collect(Collectors.toList());
    }

    @Override
    public void backtrackTo(int time) {
    }

    @Override
    public Collection<Element> forwardPropagate(CAATPredicate changedSource, Collection<? extends Derivable> added) {
        return Collections.emptyList();
    }

    @Override
    public List<SetPredicate> getDependencies() {
        return Collections.emptyList();
    }

    @Override
    public int size() {
        return events.size();
    }

    @Override
    public boolean containsById(int id) {
        return filter.apply(getEvent(id).getEvent());
    }

    @Override
    public Element get(Element e) {
        return getById(e.getId());
    }

    @Override
    public Element getById(int id) {
        return containsById(id) ? new Element(id) : null;
    }

    @Override
    public Stream<Element> elementStream() {
        return events.stream();
    }

    @Override
    public Iterator<Element> elementIterator() {
        return events.iterator();
    }

    @Override
    public Iterable<Element> elements() {
        return events;
    }
}
