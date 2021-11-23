package com.dat3m.dartagnan.verification;

import com.dat3m.dartagnan.GlobalSettings;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.witness.WitnessGraph;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Acyclic;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.relation.binary.RelUnion;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.dat3m.dartagnan.wmm.utils.RelationRepository;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.SolverContext;

import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.*;

/*
 A RefinementTask is a VerificationTask with an additional baseline memory model.
 The intention is that such a task is solved by any solving strategy that starts from the
 baseline memory model and refines it iteratively towards the target memory model.
 Currently, we only have a Saturation-based solver to solve such tasks but any CEGAR-like approach could be used.
 */
//TODO: We don't make SaturationDepth etc. an option, because
// this class gets reworked in the Experimental branch!
public class RefinementTask extends VerificationTask {

    private final Wmm baselineModel;

    private RefinementTask(Program program, Wmm targetMemoryModel, Wmm baselineModel, RefinementTaskBuilder builder) {
        super(program,targetMemoryModel,builder);
        this.baselineModel = baselineModel;
    }

    public static class RefinementTaskBuilder extends VerificationTaskBuilder {

        private Wmm baselineModel;

        @Override
        public RefinementTaskBuilder withWitness(WitnessGraph witness) {
            super.withWitness(witness);
            return this;
        }

        @Override
        public RefinementTaskBuilder withTarget(Arch target) {
            super.withTarget(target);
            return this;
        }

        @Override
        public RefinementTaskBuilder withConfig(Configuration config) {
            super.withConfig(config);
            return this;
        }

        public RefinementTaskBuilder withBaselineWMM(Wmm baselineModel) {
            this.baselineModel = baselineModel;
            return this;
        }

        @Override
        public RefinementTask build(Program program, Wmm memoryModel) {
            Wmm baseline = baselineModel == null ? createDefaultWmm() : baselineModel;
            return new RefinementTask(program, memoryModel, baseline, this);
        }
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
        return new RefinementTaskBuilder()
                .withBaselineWMM(createDefaultWmm())
                .withWitness(task.getWitness())
                .withConfig(task.getConfig())
                .build(task.getProgram(),task.getMemoryModel());
    }

    private static Wmm createDefaultWmm() {
        Wmm baseline = new Wmm();
        baseline.setEncodeCo(false);

        GlobalSettings gSet = GlobalSettings.getInstance();

        if (!gSet.shouldRefinementUseLocallyConsistentBaselineWMM()) {
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
        if (gSet.shouldRefinementUseNoOOTABaselineWMM()) {
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
