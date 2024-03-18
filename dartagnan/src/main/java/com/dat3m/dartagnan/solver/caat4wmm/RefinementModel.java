package com.dat3m.dartagnan.solver.caat4wmm;


import com.dat3m.dartagnan.wmm.Assumption;
import com.dat3m.dartagnan.wmm.Constraint;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.axiom.ForceEncodeAxiom;
import com.dat3m.dartagnan.wmm.utils.ConstraintCopier;
import com.dat3m.dartagnan.wmm.utils.Cut;
import com.google.common.collect.BiMap;
import com.google.common.collect.HashBiMap;

import java.util.HashSet;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

public class RefinementModel {

    private final Wmm baseModel;
    private final Wmm originalModel;
    private final BiMap<Constraint, Constraint> orig2BaseConstraints;
    private final BiMap<Relation, Relation> orig2BaseRelations;

    public Wmm getBaseModel() { return baseModel; }

    public Wmm getOriginalModel() { return originalModel; }

    public Relation translateToBase(Relation rel) {
        return orig2BaseRelations.get(rel);
    }

    @SuppressWarnings("unchecked")
    public <T extends Constraint> T translateToBase(T constraint) {
        return (T)orig2BaseConstraints.get(constraint);
    }

    public Relation translateToOriginal(Relation rel) {
        return orig2BaseRelations.inverse().get(rel);
    }

    @SuppressWarnings("unchecked")
    public <T extends Constraint> T translateToOriginal(T constraint) {
        return (T)orig2BaseConstraints.inverse().get(constraint);
    }

    public Set<Relation> computeBoundaryRelations() {
        final Set<Relation> boundary = new HashSet<>();
        for (Constraint c : originalModel.getConstraints()) {
            if (orig2BaseConstraints.containsKey(c)) {
                continue;
            }
            c.getConstrainedRelations()
                    .stream().map(orig2BaseRelations::get)
                    .filter(Objects::nonNull)
                    .forEach(boundary::add);
        }

        return boundary;
    }

    public void transferKnowledgeFromOriginal(RelationAnalysis ra) {
        for (Relation origRel : orig2BaseRelations.keySet()) {
            final RelationAnalysis.Knowledge knowledge = ra.getKnowledge(origRel);
            final Relation targetRel = orig2BaseRelations.get(origRel);
            final Assumption assume = new Assumption(targetRel, knowledge.getMaySet(), knowledge.getMustSet());
            baseModel.addConstraint(assume);
        }
    }

    public void forceEncodeBoundary() {
        for (Relation rel : computeBoundaryRelations()) {
            baseModel.addConstraint(new ForceEncodeAxiom(rel));
        }
    }

    public Set<Relation> getUpperRelations() {
        return originalModel.getRelations().stream().filter(r -> !orig2BaseRelations.containsKey(r))
                .collect(Collectors.toSet());
    }

    // =============================================================================================

    private RefinementModel(Wmm originalModel, Wmm baseModel,
                            BiMap<Constraint, Constraint> orig2BaseConstraints,
                            BiMap<Relation, Relation> orig2BaseRelations) {
        this.originalModel = originalModel;
        this.baseModel = baseModel;
        this.orig2BaseRelations = orig2BaseRelations;
        this.orig2BaseConstraints = orig2BaseConstraints;
    }

    public static RefinementModel fromCut(Cut cut) {
        final Wmm base = new Wmm();
        final BiMap<Constraint, Constraint> orig2BaseConstraints = HashBiMap.create();
        final BiMap<Relation, Relation> orig2BaseRelations = HashBiMap.create();

        for (String coreRelName : Wmm.ANARCHIC_CORE_RELATIONS) {
            // Special handle core relations because we need them in every memory model
            // (even if they were not explicitly cut)
            final Relation origRel = cut.getMemoryModel().getRelation(coreRelName);
            final Relation baseRel = base.getRelation(coreRelName);
            orig2BaseRelations.put(origRel, baseRel);
            orig2BaseConstraints.put(origRel.getDefinition(), baseRel.getDefinition());
        }

        final Set<Relation> lower = cut.getLowerRelations();
        for (Relation rel : lower) {
            if (orig2BaseRelations.containsKey(rel)) {
                // Skip the anarchic relations we already copied above
                continue;
            }
            final Relation copy = base.newRelation();
            rel.getNames().forEach(n -> base.addAlias(n, copy));
            orig2BaseRelations.put(rel, copy);
        }

        final ConstraintCopier copier = new ConstraintCopier(orig2BaseRelations);
        for (Constraint c : cut.getLower()) {
            if (orig2BaseConstraints.containsKey(c)) {
                // Skip the anarchic constraints we already copied above
                continue;
            }
            final Constraint copy = c.accept(copier);
            base.addConstraint(copy);
            orig2BaseConstraints.put(c, copy);

        }

        return new RefinementModel(cut.getMemoryModel(), base, orig2BaseConstraints, orig2BaseRelations);
    }




}
