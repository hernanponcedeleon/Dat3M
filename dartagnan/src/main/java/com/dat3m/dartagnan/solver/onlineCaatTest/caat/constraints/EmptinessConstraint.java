package com.dat3m.dartagnan.solver.onlineCaatTest.caat.constraints;


import com.dat3m.dartagnan.solver.onlineCaatTest.caat.domain.Domain;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.Derivable;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

public class EmptinessConstraint extends AbstractConstraint {

    private final CAATPredicate constrainedPred;
    private final List<Derivable> violations = new ArrayList<>();

    public EmptinessConstraint(CAATPredicate constrainedPred) {
        this.constrainedPred = constrainedPred;
    }

    @Override
    public CAATPredicate getConstrainedPredicate() {
        return constrainedPred;
    }

    @Override
    public void onDomainInit(CAATPredicate predicate, Domain<?> domain) {
        super.onDomainInit(predicate, domain);
        violations.clear();
    }

    @Override
    public void onPopulation(CAATPredicate predicate) {
        onChanged(predicate, predicate.setView());
    }

    @Override
    public void onChanged(CAATPredicate predicate, Collection<? extends Derivable> added) {
        violations.addAll(added);
    }

    @Override
    public void onBacktrack(CAATPredicate predicate, int time) {
        violations.removeIf(e -> e.getTime() > time);
    }

    @Override
    public boolean checkForViolations() {
        return !violations.isEmpty();
    }

    @Override
    public List<List<Derivable>> getViolations() {
        return violations.stream().map(Collections::singletonList).collect(Collectors.toList());
    }

}