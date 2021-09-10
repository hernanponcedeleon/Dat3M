package com.dat3m.dartagnan.verification;

import com.dat3m.dartagnan.GlobalSettings;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.witness.WitnessGraph;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Acyclic;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.relation.binary.RelUnion;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.dat3m.dartagnan.wmm.utils.RelationRepository;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.SolverContext;

import static com.dat3m.dartagnan.GlobalSettings.REFINEMENT_ADD_ACYCLIC_DEP_RF;
import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.*;

// NOTE: A RefinementTask can be treated as a VerificationTask in which case
// the baseline model is mostly ignored.
public class RefinementTask extends VerificationTask {

    private final Wmm baselineModel;

    public RefinementTask(Program program, Wmm targetMemoryModel, Wmm baselineModel, WitnessGraph witness, Arch target,
                          Settings settings) {
        super(program, targetMemoryModel, witness, target, settings);
        this.baselineModel = baselineModel;
    }

    public Wmm getBaselineModel() {
        return baselineModel;
    }

    // For now, we return a constant. But we can add options for this later on.
    //TODO: This is a Saturation-specific information and should not be part of this class
    public int getMaxSaturationDepth() {
        return GlobalSettings.SATURATION_MAX_DEPTH;
    }

    public BooleanFormula encodeBaselineWmmRelations(SolverContext ctx) {
        return baselineModel.encodeRelations(ctx);
    }

    public BooleanFormula encodeBaselineWmmConsistency(SolverContext ctx) {
        return baselineModel.encodeConsistency(ctx);
    }

    @Override
    public void initialiseEncoding(SolverContext ctx) {
        super.initialiseEncoding(ctx);
        baselineModel.initialise(this, ctx);
    }

    public static RefinementTask fromVerificationTaskWithDefaultBaselineWMM(VerificationTask task) {
        return new RefinementTask(
                task.getProgram(),
                task.getMemoryModel(),
                createDefaultWmm(),
                task.getWitness(),
                task.getTarget(),
                task.getSettings()
        );
    }

    private static Wmm createDefaultWmm() {
        Wmm baseline = new Wmm();
        baseline.setEncodeCo(false);

        if (!GlobalSettings.REFINEMENT_USE_LOCALLY_CONSISTENT_BASELINE_WMM) {
            return baseline;
        }

        RelationRepository repo = baseline.getRelationRepository();

        // ====== Locally consistent baseline WMM ======
        // ---- acyclic(po-loc | rf) ----
        Relation poloc = repo.getRelation(POLOC);
        Relation rf = repo.getRelation(RF);
        Relation porf = new RelUnion(poloc, rf);
        repo.addRelation(porf);
        baseline.addAxiom(new Acyclic(porf));

        // ---- acyclic (dep | rf) ----
        if (REFINEMENT_ADD_ACYCLIC_DEP_RF) {
            Relation data = repo.getRelation(DATA);
            Relation ctrl = repo.getRelation(CTRL);
            Relation addr = repo.getRelation(ADDR);
            Relation dep = new RelUnion(data, addr);
            repo.addRelation(dep);
            dep = new RelUnion(ctrl, dep);
            repo.addRelation(dep);
            Relation hb = new RelUnion(dep, rf);
            repo.addRelation(hb);
            baseline.addAxiom(new Acyclic(hb));
        }

        return baseline;
    }
}
