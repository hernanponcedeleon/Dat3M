package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.RecursiveGroup;
import com.dat3m.dartagnan.wmm.utils.RelationRepository;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableSet;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.Collections;
import java.util.List;

import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.*;

public class WmmEncoder implements Encoder {

    private final static ImmutableSet<String> baseRelations = ImmutableSet.of(CO, RF, IDD, ADDRDIRECT);

    private static final Logger logger = LogManager.getLogger(WmmEncoder.class);

    // =========================== Configurables ===========================



    // =====================================================================

    private WmmEncoder(Configuration config) throws InvalidConfigurationException {
        config.inject(this);
    }

    public static WmmEncoder fromConfig(Configuration config) throws InvalidConfigurationException {
        return new WmmEncoder(config);
    }

    private VerificationTask task;
    private Wmm memoryModel;
    private RelationRepository relationRepository;

    private boolean relationsAreEncoded = false;
    private boolean encodeCo = true;

    public void setEncodeCo(boolean value) {
        this.encodeCo = value;
    }

    public void initialise(VerificationTask task, SolverContext ctx) {
        this.task = task;
        this.memoryModel = task.getMemoryModel();
        this.relationRepository = memoryModel.getRelationRepository();

        for(String relName : baseRelations){
            relationRepository.getRelation(relName);
        }

        for (Axiom ax : memoryModel.getAxioms()) {
            ax.getRelation().updateRecursiveGroupId(ax.getRelation().getRecursiveGroupId());
        }

        for(RecursiveGroup recursiveGroup : memoryModel.getRecursiveGroups()){
            recursiveGroup.setDoRecurse();
        }

        for(Relation relation : relationRepository.getRelations()){
            relation.initialise(task, ctx);
        }

        for (Axiom axiom : memoryModel.getAxioms()) {
            axiom.initialise(task, ctx);
        }
    }

    // This methods initializes all relations and encodes all base relations
    // and recursive groups (why recursive groups?)
    // It also triggers the computation of may and active sets!
    // It does NOT encode the axioms nor any non-base relation yet!
    private BooleanFormula encodeBase(SolverContext ctx) {
        Preconditions.checkState(task != null, "The WMM needs to get initialised before encoding.");

        List<RecursiveGroup> recursiveGroups = memoryModel.getRecursiveGroups();
        List<Axiom> axioms = memoryModel.getAxioms();

        for (RecursiveGroup recursiveGroup : recursiveGroups) {
            recursiveGroup.initMaxTupleSets();
            recursiveGroup.initMinTupleSets();
        }

        for (Axiom ax : axioms) {
            ax.getRelation().getMaxTupleSet();
        }

        for(String relName : baseRelations){
            relationRepository.getRelation(relName).getMaxTupleSet();
        }

        for (Axiom ax : axioms) {
            ax.getRelation().addEncodeTupleSet(ax.getEncodeTupleSet());
        }

        Collections.reverse(recursiveGroups);
        for(RecursiveGroup recursiveGroup : recursiveGroups){
            recursiveGroup.updateEncodeTupleSets();
        }

        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        BooleanFormula enc = bmgr.makeTrue();
        for(String relName : baseRelations){
            if (!encodeCo && relName.equals(CO)) {
                continue;
            }
            enc = bmgr.and(enc, relationRepository.getRelation(relName).encode(ctx));
        }

        return enc;
    }

    // Initalizes everything just like encodeBase but also encodes all
    // relations that are needed for the axioms (but does NOT encode the axioms themselves yet)
    // NOTE: It avoids encoding relations that do NOT affect the axioms, i.e. unused relations
    public BooleanFormula encodeRelations(SolverContext ctx) {
        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        BooleanFormula enc = encodeBase(ctx);
        for (Axiom ax : memoryModel.getAxioms()) {
            enc = bmgr.and(enc, ax.getRelation().encode(ctx));
        }
        relationsAreEncoded = true;
        return enc;
    }

    // Encodes all axioms. This should be called after <encodeRelations>
    public BooleanFormula encodeConsistency(SolverContext ctx) {
        Preconditions.checkState(relationsAreEncoded, "Wmm relations must be encoded before the consistency predicate.");

        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        BooleanFormula expr = bmgr.makeTrue();
        for (Axiom ax : memoryModel.getAxioms()) {
            expr = bmgr.and(expr, ax.consistent(ctx));
        }
        return expr;
    }
}
