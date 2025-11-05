package com.dat3m.dartagnan.solver.caat.predicates.sets.derived;


import com.dat3m.dartagnan.solver.caat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.caat.predicates.Derivable;
import com.dat3m.dartagnan.solver.caat.predicates.misc.PredicateVisitor;
import com.dat3m.dartagnan.solver.caat.predicates.sets.Element;
import com.dat3m.dartagnan.solver.caat.predicates.sets.MaterializedSet;
import com.dat3m.dartagnan.solver.caat.predicates.sets.SetPredicate;

import java.util.*;
import java.util.stream.Stream;

// A materialized Union Graph.
// This seems to be more efficient than the virtualized UnionGraph we used before.
public class UnionSet extends MaterializedSet {

    private final SetPredicate[] operands;

    @Override
    public List<SetPredicate> getDependencies() {
        return Arrays.asList(operands);
    }

    public UnionSet(SetPredicate... o) {
        operands = o;
    }

    private Element derive(Element e) {
        return e.withDerivationLength(e.getDerivationLength() + 1);
    }

    @Override
    public void repopulate() {
        //TODO: Maybe try to minimize the derivation length initially
        for (SetPredicate o : operands) {
            for (Element e : o.elements()) {
                simpleSet.add(derive(e));
            }
        }
    }

    @Override
    @SuppressWarnings("unchecked")
    public Collection<Element> forwardPropagate(CAATPredicate changedSource, Collection<? extends Derivable> added) {
        if (Stream.of(operands).anyMatch(o -> changedSource == o)) {
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