package com.dat3m.dartagnan.wmm.analysis;

import com.dat3m.dartagnan.program.analysis.AliasAnalysis;
import com.dat3m.dartagnan.program.analysis.BranchEquivalence;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.relation.binary.RelMinus;
import com.dat3m.dartagnan.wmm.utils.RecursiveGroup;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import static com.google.common.base.Preconditions.checkArgument;

public class RelationAnalysis {

    private RelationAnalysis(VerificationTask task, Context context, Configuration config) {
        context.requires(AliasAnalysis.class);
        context.requires(BranchEquivalence.class);
        context.requires(WmmAnalysis.class);
        run(task, context);
    }

    public static RelationAnalysis fromConfig(VerificationTask task, Context context, Configuration config) throws InvalidConfigurationException {
        return new RelationAnalysis(task, context, config);
    }

    /**
     * Fetches results of this analysis.
     * @param relation Some element in the associated task's memory model.
     * @return Event pairs that could participate in {@code relation} in some execution.
     */
    public TupleSet may(Relation relation) {
        return relation.getMaxTupleSet();
    }

    /**
     * Fetches results of this analysis.
     * @param relation Some element in the associated task's memory model.
     * @return Event pairs that cannot be missing in {@code relation} in any execution that executes both events.
     */
    public TupleSet must(Relation relation) {
        return relation.getMinTupleSet();
    }

    private void run(VerificationTask task, Context context) {
        // Init data context so that each relation is able to compute its may/must sets.
        Wmm memoryModel = task.getMemoryModel();
        for (Axiom ax : memoryModel.getAxioms()) {
            ax.getRelation().updateRecursiveGroupId(ax.getRelation().getRecursiveGroupId());
        }

        DependencyGraph<Relation> dep = memoryModel.getRelationDependencyGraph();
        checkArgument(memoryModel.getRelationRepository().getRelations().stream()
                        .filter(RelMinus.class::isInstance)
                        .noneMatch(r -> dep.get(r.getSecond()).getDependencies().contains(dep.get(r))),
                "Unstratified model.");

        // ------------------------------------------------
        //ensure that the repository contains all base relations
        for(String relName : Wmm.BASE_RELATIONS){
            memoryModel.getRelationRepository().getRelation(relName);
        }
        for (Relation rel : memoryModel.getRelationRepository().getRelations()) {
            rel.initializeRelationAnalysis(task, context);
        }
        for (Axiom ax : memoryModel.getAxioms()) {
            ax.initializeRelationAnalysis(task, context);
        }

        // ------------------------------------------------
        for(String relName : Wmm.BASE_RELATIONS){
            Relation baseRel = memoryModel.getRelationRepository().getRelation(relName);
            baseRel.getMaxTupleSet();
            baseRel.getMinTupleSet();
        }
        for (RecursiveGroup recursiveGroup : memoryModel.getRecursiveGroups()) {
            recursiveGroup.initMaxTupleSets();
            recursiveGroup.initMinTupleSets();
        }
        for (Axiom ax : memoryModel.getAxioms()) {
            ax.getRelation().getMaxTupleSet();
            ax.getRelation().getMinTupleSet();
        }


    }
}
