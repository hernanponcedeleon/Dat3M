package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.RecursiveGroup;
import com.google.common.base.Preconditions;
import com.google.common.collect.Lists;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;


public class WmmEncoder implements Encoder {

    private static final Logger logger = LogManager.getLogger(WmmEncoder.class);

    private final Wmm memoryModel;
    private boolean isInitialized = false;

    // =====================================================================

    private WmmEncoder(Wmm memoryModel, Context context) {
        this.memoryModel = Preconditions.checkNotNull(memoryModel);
        context.requires(RelationAnalysis.class);
    }

    public static WmmEncoder fromConfig(Wmm memoryModel, Context context, Configuration config) throws InvalidConfigurationException {
        return new WmmEncoder(memoryModel, context);
    }

    @Override
    public void initializeEncoding(SolverContext ctx) {
        for(String relName : Wmm.BASE_RELATIONS) {
            memoryModel.getRelationRepository().getRelation(relName);
        }

        for(RecursiveGroup recursiveGroup : memoryModel.getRecursiveGroups()){
            recursiveGroup.setDoRecurse();
        }

        for(Relation relation : memoryModel.getRelationRepository().getRelations()){
            relation.initializeEncoding(ctx);
        }

        for (Axiom axiom : memoryModel.getAxioms()) {
            axiom.initializeEncoding(ctx);
        }

        // ====================== Compute encoding information =================
        for (Axiom ax : memoryModel.getAxioms()) {
            ax.getRelation().addEncodeTupleSet(ax.getEncodeTupleSet());
        }

        for (RecursiveGroup recursiveGroup : Lists.reverse(memoryModel.getRecursiveGroups())) {
            recursiveGroup.updateEncodeTupleSets();
        }

        isInitialized = true;
    }

    private void checkInitialized() {
        Preconditions.checkState(isInitialized, "initializeEncoding must get called before encoding.");
    }

    public BooleanFormula encodeFullMemoryModel(SolverContext ctx) {
        return ctx.getFormulaManager().getBooleanFormulaManager().and(
                encodeRelations(ctx), encodeConsistency(ctx)
        );
    }

    // This methods initializes all relations and encodes all base relations
    // It does NOT encode the axioms nor any non-base relation yet!
    public BooleanFormula encodeAnarchicSemantics(SolverContext ctx) {
        checkInitialized();
        logger.info("Encoding anarchic semantics");
        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        BooleanFormula enc = bmgr.makeTrue();
        for(String relName : Wmm.BASE_RELATIONS){
            enc = bmgr.and(enc, memoryModel.getRelationRepository().getRelation(relName).encode(ctx));
        }

        return enc;
    }

    // Initializes everything just like encodeAnarchicSemantics but also encodes all
    // relations that are needed for the axioms (but does NOT encode the axioms themselves yet)
    // NOTE: It avoids encoding relations that do NOT affect the axioms, i.e. unused relations
    public BooleanFormula encodeRelations(SolverContext ctx) {
        checkInitialized();
        logger.info("Encoding relations");
        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        BooleanFormula enc = encodeAnarchicSemantics(ctx);
        for (Axiom ax : memoryModel.getAxioms()) {
            enc = bmgr.and(enc, ax.getRelation().encode(ctx));
        }
        return enc;
    }

    // Encodes all axioms. This should be called after <encodeRelations>
    public BooleanFormula encodeConsistency(SolverContext ctx) {
        checkInitialized();
        logger.info("Encoding consistency");
        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        BooleanFormula expr = bmgr.makeTrue();
        for (Axiom ax : memoryModel.getAxioms()) {
        	// Flagged axioms do not act as consistency filter
        	if(ax.isFlagged()) {
        		continue;
        	}
            expr = bmgr.and(expr, ax.consistent(ctx));
        }
        return expr;
    }
}
