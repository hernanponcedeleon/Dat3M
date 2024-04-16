package com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.sets.derived;


import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.Derivable;
import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.misc.PredicateVisitor;
import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.sets.Element;
import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.sets.SetPredicate;
import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.sets.MaterializedSet;

import java.util.*;

public class IntersectionSet extends MaterializedSet {

    private final SetPredicate first;
    private final SetPredicate second;

    @Override
    public List<SetPredicate> getDependencies() {
        return Arrays.asList(first, second);
    }

    public SetPredicate getFirst() { return first; }
    public SetPredicate getSecond() { return second; }

    public IntersectionSet(SetPredicate first, SetPredicate second) {
        this.first = first;
        this.second = second;
    }

    private Element derive(Element a, Element b) {
        return a.with(Math.max(a.getTime(), b.getTime()),
                Math.max(a.getDerivationLength(), b.getDerivationLength()) + 1);
    }

    @Override
    public void repopulate() {
        if (first.getEstimatedSize() < second.getEstimatedSize()) {
            for (Element e1 : first.elements()) {
                Element e2 = second.get(e1);
                if (e2 != null) {
                    simpleSet.add(derive(e1, e2));
                }
            }
        } else {
            for (Element e2 : second.elements()) {
                Element e1 = first.get(e2);
                if (e1 != null) {
                    simpleSet.add(derive(e1, e2));
                }
            }
        }
    }

    @Override
    @SuppressWarnings("unchecked")
    public Collection<Element> forwardPropagate(CAATPredicate changedSource, Collection<? extends Derivable> added) {
        if (changedSource == first || changedSource == second) {
            SetPredicate other = (changedSource == first) ? second : first;
            Collection<Element> addedElems = (Collection<Element>)added;
            List<Element> newlyAdded = new ArrayList<>();
            for (Element e1 : addedElems) {
                Element e2 = other.get(e1);
                if (e2 != null) {
                    Element e = derive(e1, e2);
                    simpleSet.add(e);
                    newlyAdded.add(e);
                }
            }
            return newlyAdded;
        } else {
            return Collections.emptyList();
        }
    }

    @Override
    public <TRet, TData, TContext> TRet accept(PredicateVisitor<TRet, TData, TContext> visitor, TData data, TContext context) {
        return visitor.visitSetIntersection(this, data, context);
    }

}