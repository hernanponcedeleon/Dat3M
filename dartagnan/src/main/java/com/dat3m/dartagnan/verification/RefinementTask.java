package com.dat3m.dartagnan.verification;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Baseline;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.encoding.ProgramEncoder;
import com.dat3m.dartagnan.encoding.PropertyEncoder;
import com.dat3m.dartagnan.encoding.SymmetryEncoder;
import com.dat3m.dartagnan.encoding.WmmEncoder;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.witness.WitnessGraph;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.analysis.WmmAnalysis;
import com.dat3m.dartagnan.wmm.axiom.Acyclic;
import com.dat3m.dartagnan.wmm.axiom.Empty;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.relation.binary.RelComposition;
import com.dat3m.dartagnan.wmm.relation.binary.RelIntersection;
import com.dat3m.dartagnan.wmm.relation.binary.RelUnion;
import com.dat3m.dartagnan.wmm.utils.RelationRepository;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.EnumSet;

import static com.dat3m.dartagnan.configuration.Baseline.*;
import static com.dat3m.dartagnan.configuration.OptionNames.BASELINE;
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
    private Context baselineContext;
    private WmmEncoder baselineWmmEncoder;

    //FIXME: This is only used to fix issue #280 (https://github.com/hernanponcedeleon/Dat3M/issues/280)
    private VerificationTask baselineTask;


    // =========================== Configurables ===========================

	@Option(name=BASELINE,
			description="Refinement starts from this baseline WMM.",
			secure=true,
			toUppercase=true)
		private EnumSet<Baseline> baselines = EnumSet.noneOf(Baseline.class);

    // ======================================================================

    private RefinementTask(Program program, Wmm targetMemoryModel, Wmm baselineModel, 
    		EnumSet<Property> property, WitnessGraph witness, Configuration config)
    throws InvalidConfigurationException {
        super(program, targetMemoryModel, property, witness, config);
        config.inject(this);
        this.baselineModel = baselineModel != null ? baselineModel : createDefaultWmm();
    }

    public Wmm getBaselineModel() {
        return baselineModel;
    }

    public WmmEncoder getBaselineWmmEncoder() { return baselineWmmEncoder; }

    @Override
    public void performStaticWmmAnalyses() throws InvalidConfigurationException {
        super.performStaticWmmAnalyses();
        baselineTask = new VerificationTask(getProgram(), baselineModel, getProperty(), getWitness(), getConfig());
        baselineContext = Context.createCopyFrom(getAnalysisContext());
        baselineContext.invalidate(WmmAnalysis.class);
        baselineContext.register(WmmAnalysis.class, WmmAnalysis.fromConfig(baselineModel, getConfig()));
        baselineContext.register(RelationAnalysis.class, RelationAnalysis.fromConfig(baselineTask, baselineContext, getConfig()));
    }

    @Override
    public void initializeEncoders(SolverContext ctx) throws InvalidConfigurationException {
        progEncoder = ProgramEncoder.fromConfig(getProgram(), getAnalysisContext(), getConfig());
        propertyEncoder = PropertyEncoder.fromConfig(getProgram(), baselineModel, getAnalysisContext(), getConfig());
        //wmmEncoder = WmmEncoder.fromConfig(getMemoryModel(), getAnalysisContext(), getConfig());
        symmetryEncoder = SymmetryEncoder.fromConfig(baselineModel, getAnalysisContext(), getConfig());
        baselineWmmEncoder = WmmEncoder.fromConfig(baselineModel, baselineContext, getConfig());

        // FIXME: Here we share some encoders with the baselineTask, to fix issue #280 for now.
        baselineTask.progEncoder = this.progEncoder;
        baselineTask.propertyEncoder = this.propertyEncoder;

        progEncoder.initializeEncoding(ctx);
        propertyEncoder.initializeEncoding(ctx);
        //wmmEncoder.initializeEncoding(ctx);
        symmetryEncoder.initializeEncoding(ctx);
        baselineWmmEncoder.initializeEncoding(ctx);
		logger.info("{}: {}", BASELINE, baselines);
    }

    public static RefinementTask fromVerificationTaskWithDefaultBaselineWMM(VerificationTask task)
            throws InvalidConfigurationException {
        return new RefinementTaskBuilder()
                .withWitness(task.getWitness())
                .withConfig(task.getConfig())
                .build(task.getProgram(), task.getMemoryModel(), task.getProperty());
    }

    private Wmm createDefaultWmm() {
        Wmm baseline = new Wmm();
        RelationRepository repo = baseline.getRelationRepository();
        Relation rf = repo.getRelation(RF);

        if(baselines.contains(UNIPROC)) {
	        // ---- acyclic(po-loc | rf) ----
	        Relation poloc = repo.getRelation(POLOC);
	        Relation co = repo.getRelation(CO);
	        Relation fr = repo.getRelation(FR);
	        Relation porf = new RelUnion(poloc, rf);
	        repo.addRelation(porf);
	        Relation porfco = new RelUnion(porf, co);
	        repo.addRelation(porfco);
	        Relation porfcofr = new RelUnion(porfco, fr);
	        repo.addRelation(porfcofr);
	        baseline.addAxiom(new Acyclic(porfcofr));
        }
        if(baselines.contains(NO_OOTA)) {
            // ---- acyclic (dep | rf) ----
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
        if(baselines.contains(ATOMIC_RMW)) {
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
        public RefinementTask build(Program program, Wmm memoryModel, EnumSet<Property> property) throws InvalidConfigurationException {
            return new RefinementTask(program, memoryModel, baselineModel, property, witness, config.build());
        }
    }
}