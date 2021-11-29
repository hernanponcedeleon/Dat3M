package com.dat3m.dartagnan.solver.newcaat.predicates;

import com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.utils.OneTimeIterable;
import com.dat3m.dartagnan.solver.newcaat.domain.Domain;
import com.dat3m.dartagnan.solver.newcaat.predicates.misc.PredicateVisitor;
import com.dat3m.dartagnan.utils.dependable.Dependent;

import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.stream.Stream;

public interface CAATPredicate extends Dependent<CAATPredicate> {

    @Override
    List<? extends CAATPredicate> getDependencies();

    String getName();
    void setName(String name);

    Domain<?> getDomain();
    void initializeToDomain(Domain<?> domain);

    Stream<? extends Derivable> valueStream();
    Derivable get(Derivable value);

    <TRet, TData, TContext> TRet accept(PredicateVisitor<TRet, TData, TContext> visitor, TData data, TContext context);

    /*
        This method should be called sometime after <initializeToDomain>.
        It is used to
            - Perform initial population of derived predicates
            - Perform initialization work for base predicates (e.g. set up data structures for virtual predicates)
     */
    void repopulate();
    Collection<? extends Derivable> forwardPropagate(CAATPredicate changedSource, Collection<? extends Derivable> added);
    void backtrackTo(int time);

    Set<? extends Derivable> setView();


    // ======================================== Defaults ==============================================

    default int size() { return (int)valueStream().count(); }; // Returns the exact(!) size of this predicate
    default boolean contains(Derivable value) { return get(value) != null; }
    default boolean isEmpty() { return size() == 0; }

    default int getMinSize() { return size(); }
    default int getMaxSize() { return size(); }
    default int getEstimatedSize() { return (getMinSize() + getMaxSize()) / 2;}

    default Iterator<? extends Derivable> valueIterator() { return valueStream().iterator(); }
    default Iterable<? extends Derivable> values() { return OneTimeIterable.create(valueIterator()); }

}
