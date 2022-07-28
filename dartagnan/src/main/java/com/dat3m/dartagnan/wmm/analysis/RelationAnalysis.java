package com.dat3m.dartagnan.wmm.analysis;

import com.dat3m.dartagnan.program.analysis.BranchEquivalence;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.RecursiveGroup;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

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

    private void run(VerificationTask task, Context context) {
        // Init data context so that each relation is able to compute its may/must sets.
        Wmm memoryModel = task.getMemoryModel();
        for (Axiom ax : memoryModel.getAxioms()) {
            ax.getRelation().updateRecursiveGroupId(ax.getRelation().getRecursiveGroupId());
        }
        for(RecursiveGroup recursiveGroup : memoryModel.getRecursiveGroups()){
            recursiveGroup.setDoRecurse();
        }

        // ------------------------------------------------
        for(String relName : Wmm.BASE_RELATIONS){
            memoryModel.getRelationRepository().getRelation(relName).initializeRelationAnalysis(task, context);
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
