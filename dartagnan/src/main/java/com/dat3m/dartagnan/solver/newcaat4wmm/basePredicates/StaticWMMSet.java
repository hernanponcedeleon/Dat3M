package com.dat3m.dartagnan.solver.newcaat4wmm.basePredicates;

import com.dat3m.dartagnan.solver.newcaat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.newcaat.predicates.Derivable;
import com.dat3m.dartagnan.solver.newcaat.predicates.misc.PredicateVisitor;
import com.dat3m.dartagnan.solver.newcaat.predicates.sets.Element;
import com.dat3m.dartagnan.solver.newcaat.predicates.sets.SetPredicate;
import com.dat3m.dartagnan.wmm.filter.FilterAbstract;

import java.util.Collection;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class StaticWMMSet extends AbstractWMMPredicate implements SetPredicate {

    private final FilterAbstract filter;
    private List<Element> events;

    public StaticWMMSet(FilterAbstract filter) {
        this.filter = filter;
    }

    @Override
    public <TRet, TData, TContext> TRet accept(PredicateVisitor<TRet, TData, TContext> visitor, TData tData, TContext context) {
        return visitor.visitBaseSet(this, tData, context);
    }

    @Override
    public void repopulate() {
        events = model.getEventList().stream()
                .filter(e -> filter.filter(e.getEvent()))
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
        return filter.filter(getEvent(id).getEvent());
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
