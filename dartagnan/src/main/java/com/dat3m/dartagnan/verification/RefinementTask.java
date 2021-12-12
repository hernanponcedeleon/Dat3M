package com.dat3m.dartagnan.verification;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.BitFlags;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.witness.WitnessGraph;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Acyclic;
import com.dat3m.dartagnan.wmm.axiom.Empty;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.relation.binary.RelComposition;
import com.dat3m.dartagnan.wmm.relation.binary.RelIntersection;
import com.dat3m.dartagnan.wmm.relation.binary.RelUnion;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.dat3m.dartagnan.wmm.utils.RelationRepository;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.SolverContext;

import static com.dat3m.dartagnan.GlobalSettings.REFINEMENT_BASELINE_WMM;
import static com.dat3m.dartagnan.verification.RefinementTask.BaselineWMM.*;
import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.*;

/*
 A RefinementTask is a VerificationTask with an additional baseline memory model.
 The intention is that such a task is solved by any solving strategy that starts from the
 baseline memory model and refines it iteratively towards the target memory model.
 Currently, we only have a Saturation-based solver to solve such tasks but any CEGAR-like approach could be used.
 */
public class RefinementTask extends VerificationTask {

    //TODO: The usage of plain integers is not so nice.
    // Maybe we can use EnumSets or something similar to model this more nicely.
    public static class BaselineWMM {
        private BaselineWMM() {}

        public static final int EMPTY = 0;
        public static final int ACYCLIC_DEP_RF = 1; // no OOTA
        public static final int ACYCLIC_POLOC_RF = 2;
        public static final int ACYCLIC_POLOC_RF_CO_FR = 6; // SC-per-location
        public static final int ATOMIC_RMW = 8; // empty(RMW & fre;coe)
    }

    private final Wmm baselineModel;

    public RefinementTask(Program program, Wmm targetMemoryModel, Wmm baselineModel, WitnessGraph witness, Arch target,
                          Settings settings) {
        super(program, targetMemoryModel, witness, target, settings);
        this.baselineModel = baselineModel;
    }

    public Wmm getBaselineModel() {
        return baselineModel;
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

        RelationRepository repo = baseline.getRelationRepository();
        if (BitFlags.isSet(REFINEMENT_BASELINE_WMM, ACYCLIC_POLOC_RF)) {
            // ---- acyclic(po-loc | rf (| co | fr)) ----
            Relation poloc = repo.getRelation(POLOC);
            Relation rf = repo.getRelation(RF);
            Relation porf = new RelUnion(poloc, rf);
            repo.addRelation(porf);
            Relation localConsistency = porf;
            if (BitFlags.isSet(REFINEMENT_BASELINE_WMM, ACYCLIC_POLOC_RF_CO_FR)) {
                Relation co = repo.getRelation(CO);
                Relation fr = repo.getRelation(FR);
                Relation porfco = new RelUnion(porf, co);
                repo.addRelation(porfco);
                Relation porfcofr = new RelUnion(porfco, fr);
                repo.addRelation(porfcofr);
                localConsistency = porfcofr;
            }
            baseline.addAxiom(new Acyclic(localConsistency));
        }

        if (BitFlags.isSet(REFINEMENT_BASELINE_WMM, ACYCLIC_DEP_RF)) {
            // ---- acyclic (dep | rf) ----
            Relation rf = repo.getRelation(RF);
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

        if (BitFlags.isSet(REFINEMENT_BASELINE_WMM, ATOMIC_RMW)) {
            // ---- empty (rmw & fre;coe) ----
            Relation rmw = repo.getRelation(RMW);
            Relation coe = repo.getRelation(COE);
            Relation fre = repo.getRelation(FRE);

            Relation frecoe = new RelComposition(fre, coe);
            repo.addRelation(frecoe);
            Relation rmwANDfrecoe = new RelIntersection(rmw, frecoe);
            repo.addRelation(rmwANDfrecoe);

            baseline.addAxiom(new Empty(rmwANDfrecoe));
        }

        return baseline;
    }
}
