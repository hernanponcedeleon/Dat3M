package com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.sets.derived;


import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.Derivable;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.misc.PredicateVisitor;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.sets.Element;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.sets.MaterializedSet;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.sets.SetPredicate;

import java.util.*;

// A materialized Union Graph.
// This seems to be more efficient than the virtualized UnionGraph we used before.
public class UnionSet extends MaterializedSet {

    private final SetPredicate first;
    private final SetPredicate second;

    @Override
    public List<SetPredicate> getDependencies() {
        return Arrays.asList(first, second);
    }

    public SetPredicate getFirst() { return first; }
    public SetPredicate getSecond() { return second; }

    public UnionSet(SetPredicate first, SetPredicate second) {
        this.first = first;
        this.second = second;
    }

    private Element derive(Element e) {
        return e.withDerivationLength(e.getDerivationLength() + 1);
    }

    @Override
    public void repopulate() {
        //TODO: Maybe try to minimize the derivation length initially
        for (Element e : first.elements()) {
            simpleSet.add(derive(e));
        }
        for (Element e : second.elements()) {
            simpleSet.add(derive(e));
        }
    }

    @Override
    @SuppressWarnings("unchecked")
    public Collection<Element> forwardPropagate(CAATPredicate changedSource, Collection<? extends Derivable> added) {
        if (changedSource == first || changedSource == second) {
            ArrayList<Element> newlyAdded = new ArrayList<>();
            Collection<Element> addedElems = (Collection<Element>)added;
            for (Element e : addedElems) {
                Element elem = derive(e);
                if (simpleSet.add(elem)) {
                    newlyAdded.add(elem);
                }
            }
            return newlyAdded;
        } else {
            return Collections.emptyList();
        }
    }

    @Override
    public <TRet, TData, TContext> TRet accept(PredicateVisitor<TRet, TData, TContext> visitor, TData data, TContext context) {
        return visitor.visitSetUnion(this, data, context);
    }


}