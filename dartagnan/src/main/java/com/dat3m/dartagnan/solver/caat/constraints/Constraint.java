package com.dat3m.dartagnan.solver.caat.constraints;

import com.dat3m.dartagnan.solver.caat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.caat.predicates.Derivable;
import com.dat3m.dartagnan.solver.caat.predicates.misc.PredicateListener;
import com.dat3m.dartagnan.utils.dependable.Dependent;

import java.util.Collection;
import java.util.Collections;

public interface Constraint extends PredicateListener, Dependent<CAATPredicate> {
    CAATPredicate getConstrainedPredicate();

    boolean checkForViolations();

    Collection<? extends Collection<? extends Derivable>> getViolations();

    @Override
    default Collection<CAATPredicate> getDependencies() { return Collections.singletonList(getConstrainedPredicate()); }
}
