package com.dat3m.dartagnan.wmm.analysis;

import com.dat3m.dartagnan.program.analysis.Dependency;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
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
        context.requires(ExecutionAnalysis.class);
        context.requires(AliasAnalysis.class);
        context.requires(Dependency.class);
        context.requires(WmmAnalysis.class);
    }

    /**
     * Performs a static analysis on the relationships that may occur in an execution.
     * @param memoryModel Collection of relations and axioms to perform this analysis on.
     * @param task Program, target memory model and property to check.
     *             The target memory model does not have to coincide with {@code memoryModel}.
     * @param context Collection of static analyses already performed on {@code task} with respect to {@code memoryModel}.
     *                Should at least include the following elements:
     *                <ul>
     *                    <li>{@link ExecutionAnalysis}
     *                    <li>{@link Dependency}
     *                    <li>{@link AliasAnalysis}
     *                    <li>{@link WmmAnalysis}
     *                </ul>
     * @param config User-defined options to further specify the behavior.
     */
    public static RelationAnalysis fromConfig(Wmm memoryModel, VerificationTask task, Context context, Configuration config) throws InvalidConfigurationException {
        RelationAnalysis a = new RelationAnalysis(task, context, config);
        a.run(memoryModel, task, context);
        return a;
    }

    private void run(Wmm memoryModel, VerificationTask task, Context context) {
        // Init data context so that each relation is able to compute its may/must sets.
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
