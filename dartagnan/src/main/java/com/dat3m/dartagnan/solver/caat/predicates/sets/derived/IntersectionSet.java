package com.dat3m.dartagnan.solver.caat.predicates.sets.derived;


import com.dat3m.dartagnan.solver.caat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.caat.predicates.Derivable;
import com.dat3m.dartagnan.solver.caat.predicates.misc.PredicateVisitor;
import com.dat3m.dartagnan.solver.caat.predicates.sets.Element;
import com.dat3m.dartagnan.solver.caat.predicates.sets.MaterializedSet;
import com.dat3m.dartagnan.solver.caat.predicates.sets.SetPredicate;

import java.util.*;
import java.util.stream.Stream;

public class IntersectionSet extends MaterializedSet {

    private final SetPredicate[] operands;

    @Override
    public List<SetPredicate> getDependencies() {
        return Arrays.asList(operands);
    }

    public IntersectionSet(SetPredicate... o) {
        operands = o;
    }

    private Element derive(Element... elements) {
        final int time = Stream.of(elements).mapToInt(Element::getTime).max().orElseThrow();
        final int length = Stream.of(elements).mapToInt(Element::getDerivationLength).max().orElseThrow();
        return elements[0].with(time, length + 1);
    }

    @Override
    public void repopulate() {
        final SetPredicate smallest = Stream.of(operands).min(Comparator.comparingInt(CAATPredicate::getEstimatedSize)).orElseThrow();
        for (Element e1 : smallest.elements()) {
            final Element[] elements = new Element[operands.length];
            for (int i = 0; i < operands.length; i++) {
                elements[i] = operands[i] == smallest ? e1 : operands[i].get(e1);
            }
            if (Stream.of(elements).allMatch(Objects::nonNull)) {
                simpleSet.add(derive(elements));
            }
        }
    }

    @Override
    @SuppressWarnings("unchecked")
    public Collection<Element> forwardPropagate(CAATPredicate changedSource, Collection<? extends Derivable> added) {
        if (Stream.of(operands).anyMatch(o -> changedSource == o)) {
            Collection<Element> addedElems = (Collection<Element>)added;
            List<Element> newlyAdded = new ArrayList<>();
            for (Element e1 : addedElems) {
                final Element[] elements = new Element[operands.length];
                for (int i = 0; i < operands.length; i++) {
                    elements[i] = operands[i] == changedSource ? e1 : operands[i].get(e1);
                }
                if (Stream.of(elements).allMatch(Objects::nonNull)) {
                    final Element e = derive(elements);
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