package com.dat3m.dartagnan.wmm.analysis;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.analysis.AliasAnalysis;
import com.dat3m.dartagnan.program.analysis.BranchEquivalence;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.RecursiveGroup;
import com.google.common.base.Preconditions;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

public class RelationAnalysis {

    private final Wmm memoryModel;
    private final VerificationTask task;

    private RelationAnalysis(Program program, Wmm memoryModel, VerificationTask task) {
        this.memoryModel = Preconditions.checkNotNull(memoryModel);
        this.task = Preconditions.checkNotNull(task);
        task.getAnalysisContext().requires(AliasAnalysis.class);
        task.getAnalysisContext().requires(BranchEquivalence.class);
        task.getAnalysisContext().requires(WmmAnalysis.class);
        run();
    }

    public static RelationAnalysis fromConfig(Program program, Wmm memoryModel, VerificationTask task, Configuration config) throws InvalidConfigurationException {
        return new RelationAnalysis(program, memoryModel, task);
    }

    private void run() {
        // Init data context so that each relation is able to compute its may/must sets.
        for (Axiom ax : memoryModel.getAxioms()) {
            ax.getRelation().updateRecursiveGroupId(ax.getRelation().getRecursiveGroupId());
        }
        for(RecursiveGroup recursiveGroup : memoryModel.getRecursiveGroups()){
            recursiveGroup.setDoRecurse();
        }

        // ------------------------------------------------
        for(String relName : Wmm.BASE_RELATIONS){
            memoryModel.getRelationRepository().getRelation(relName).initializeRelationAnalysis(task);
        }
        for (Relation rel : memoryModel.getRelationRepository().getRelations()) {
            rel.initializeRelationAnalysis(task);
        }
        for (Axiom ax : memoryModel.getAxioms()) {
            ax.initializeRelationAnalysis(task);
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
