package com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.sets;

import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.Derivable;
import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.sets.Element;
import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.misc.AbstractPredicateSetView;
import com.dat3m.dartagnan.utils.collections.OneTimeIterable;

import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.stream.Stream;

public interface SetPredicate extends CAATPredicate {

    @Override
    Collection<Element> forwardPropagate(CAATPredicate changedSource, Collection<? extends Derivable> added);

    @Override
    List<SetPredicate> getDependencies(); // SetPredicates only depend on other SetPredicates
    // In case we add something like projections, we would also have sets dependent on graphs

    Element get(Element e); // Gets the metadata associated with <e>

    // We only require a stream implementation, because it is the easiest
    // For performance, it might be better to overwrite the associated default methods.
    Stream<Element> elementStream();


    // ===================== Default methods =======================

    default Element getById(int id) { return get(new Element(id)); }
    default boolean contains(Element e) { return get(e) != null; }
    default boolean containsById(int id) { return getById(id) != null; }

    default Iterator<Element> elementIterator() { return elementStream().iterator(); }
    default Iterable<Element> elements() { return OneTimeIterable.create(elementIterator()); }

    @Override
    default Set<Element> setView() { return new SetView(this); }

    @Override
    default Element get(Derivable value) {
        return (value instanceof Element elem) ? get(elem) : null;
    }
    @Override
    default Stream<Element> valueStream() { return elementStream(); }
    @Override
    default Iterator<Element> valueIterator() { return elementIterator(); }
    @Override
    default Iterable<Element> values() { return elements(); }


    class SetView extends AbstractPredicateSetView<Element> {

        private final SetPredicate pred;
        private SetView(SetPredicate pred) {
            this.pred = pred;
        }

        @Override
        public SetPredicate getPredicate() { return pred; }

        @Override
        public Stream<Element> stream() { return pred.elementStream(); }

        @Override
        public Iterator<Element> iterator() { return pred.elementIterator(); }
    }

}
