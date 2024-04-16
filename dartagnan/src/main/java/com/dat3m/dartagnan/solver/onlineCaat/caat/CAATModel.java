package com.dat3m.dartagnan.solver.onlineCaat.caat;

import com.dat3m.dartagnan.solver.onlineCaat.caat.constraints.Constraint;
import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.PredicateHierarchy;
import com.dat3m.dartagnan.solver.onlineCaat.caat.domain.Domain;
import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.CAATPredicate;
import com.google.common.base.Preconditions;
import com.google.common.collect.Maps;

import java.util.*;
import java.util.stream.Collectors;

public class CAATModel {

    // ======================================== Fields ==============================================

    private final Map<String, CAATPredicate> predicateMap;
    private final Set<Constraint> constraints;
    private final PredicateHierarchy hierarchy;

    // ======================================== Construction ==============================================

    private CAATModel(PredicateHierarchy hierarchy, Set<Constraint> constraints) {
        Preconditions.checkNotNull(hierarchy);
        Preconditions.checkNotNull(constraints);

        this.constraints = constraints;
        this.hierarchy = hierarchy;
        this.predicateMap = Maps.uniqueIndex(hierarchy.getPredicateList(), CAATPredicate::getName);

        for (Constraint c : this.constraints) {
            hierarchy.addListener(c.getConstrainedPredicate(), c);
        }
    }

    public static CAATModel from(Collection<? extends CAATPredicate> predicates, Collection< ? extends Constraint> constraints) {
        Set<Constraint> consts = new HashSet<>(constraints);
        Set<CAATPredicate> preds = new HashSet<>(predicates);
        consts.forEach(c -> preds.add(c.getConstrainedPredicate()));
        PredicateHierarchy hierarchy = new PredicateHierarchy(preds);

        return new CAATModel(hierarchy, consts);
    }

    public static CAATModel fromConstraints(Collection<? extends Constraint> constraints) {
        return from(Collections.emptyList(), constraints);
    }

    // ======================================== Accessors ==============================================

    public PredicateHierarchy getHierarchy() { return hierarchy; }
    public List<CAATPredicate> getPredicates() { return hierarchy.getPredicateList(); }
    public Set<Constraint> getConstraints() { return constraints; }
    public Domain<?> getDomain() { return hierarchy.getDomain(); }
    public Set<CAATPredicate> getBasePredicates() { return hierarchy.getBasePredicates(); }

    public CAATPredicate getPredicateByName(String name) {
        return predicateMap.get(name);
    }

    // ======================================== Initialization ==============================================

    public void initializeToDomain(Domain<?> domain) {
        this.hierarchy.initializeToDomain(domain);
    }

    public void populate() {
        this.hierarchy.populate();
    }

    // ======================================== Consistency ==============================================

    public List<Constraint> getViolatedConstraints() {
        return constraints.stream().filter(Constraint::checkForViolations).collect(Collectors.toList());
    }

    public boolean checkInconsistency() {
        return constraints.stream().anyMatch(Constraint::checkForViolations);
    }

}
