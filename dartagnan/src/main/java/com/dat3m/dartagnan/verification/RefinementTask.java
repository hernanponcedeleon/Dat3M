package com.dat3m.dartagnan.verification;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.witness.WitnessGraph;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Acyclic;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.relation.binary.RelUnion;
import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.wmm.utils.RelationRepository;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.SolverContext;

import static com.dat3m.dartagnan.configuration.OptionNames.ASSUME_LOCALLY_CONSISTENT_WMM;
import static com.dat3m.dartagnan.configuration.OptionNames.ASSUME_NO_OOTA;
import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.*;

/*
 A RefinementTask is a VerificationTask with an additional baseline memory model.
 The intention is that such a task is solved by any solving strategy that starts from the
 baseline memory model and refines it iteratively towards the target memory model.
 Currently, we only have a custom theory solver (CAAT) to solve such tasks but any CEGAR-like approach could be used.
 */
@Options
public class RefinementTask extends VerificationTask {

	private static final Logger logger = LogManager.getLogger(RefinementTask.class);

    private final Wmm baselineModel;

    // =========================== Configurables ===========================

	@Option(name=ASSUME_LOCALLY_CONSISTENT_WMM,
		description="Refinement will start from a locally consistent baseline WMM instead of the empty one.",
		secure=true)
	private boolean useLocallyConsistentBaselineWmm = false;

	@Option(name=ASSUME_NO_OOTA,
		description="Refinement will start from a baseline WMM that does not allow Out-Of-Thin-Air behaviour.",
		secure=true)
	private boolean useNoOOTABaselineWMM = false;

    // ======================================================================

    private RefinementTask(Program program, Wmm targetMemoryModel, Wmm baselineModel, WitnessGraph witness, Configuration config)
    throws InvalidConfigurationException {
        super(program, targetMemoryModel, witness, config);
        this.baselineModel = baselineModel != null ? baselineModel : createDefaultWmm();
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
        baselineModel.initializeEncoding(this, ctx);
		logger.info("{}: {}", ASSUME_LOCALLY_CONSISTENT_WMM, useLocallyConsistentBaselineWmm);
		logger.info("{}: {}", ASSUME_NO_OOTA, useNoOOTABaselineWMM);
    }

    public static RefinementTask fromVerificationTaskWithDefaultBaselineWMM(VerificationTask task)
            throws InvalidConfigurationException {
        return new RefinementTaskBuilder()
                .withWitness(task.getWitness())
                .withConfig(task.getConfig())
                .build(task.getProgram(), task.getMemoryModel());
    }

    //TODO: This code is outdated and was replaced in the CAAT branch.
    // The merging introduced the old code again.
    private Wmm createDefaultWmm() {
        Wmm baseline = new Wmm();
        baseline.setEncodeCo(true);

        if (!useLocallyConsistentBaselineWmm) {
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
        if (useNoOOTABaselineWMM) {
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

    // ==================== Builder =====================

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
        public RefinementTask build(Program program, Wmm memoryModel) throws InvalidConfigurationException {
            return new RefinementTask(program, memoryModel, baselineModel, witness, config.build());
        }
    }
}