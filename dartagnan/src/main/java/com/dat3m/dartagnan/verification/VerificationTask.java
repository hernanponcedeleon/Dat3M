package com.dat3m.dartagnan.verification;

import com.dat3m.dartagnan.encoding.MemoryEncoder;
import com.dat3m.dartagnan.encoding.ProgramEncoder;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.analysis.AliasAnalysis;
import com.dat3m.dartagnan.program.analysis.BranchEquivalence;
import com.dat3m.dartagnan.program.analysis.ThreadSymmetry;
import com.dat3m.dartagnan.program.processing.ProcessingManager;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.utils.symmetry.SymmetryBreaking;
import com.dat3m.dartagnan.witness.WitnessGraph;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Arch;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.ConfigurationBuilder;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.List;
import java.util.Set;

import static com.dat3m.dartagnan.configuration.OptionNames.*;
import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Preconditions.checkNotNull;

/*
Represents a verification task.
 */
@Options
public class VerificationTask {

    private static final Logger logger = LogManager.getLogger(VerificationTask.class);

    private final Program program;
    private final Wmm memoryModel;
    private final WitnessGraph witness;
    private final Configuration config;
    private BranchEquivalence branchEquivalence;
	private AliasAnalysis aliasAnalysis;
    private ThreadSymmetry threadSymmetry;

    private final ProgramEncoder progEncoder;
    private final MemoryEncoder memoryEncoder;

    protected VerificationTask(Program program, Wmm memoryModel, WitnessGraph witness, Configuration config)
    throws InvalidConfigurationException {
        this.program = checkNotNull(program);
        this.memoryModel = checkNotNull(memoryModel);
        this.witness = checkNotNull(witness);
        this.config = checkNotNull(config);

        config.recursiveInject(this);
        progEncoder = ProgramEncoder.fromConfig(config);
        memoryEncoder = MemoryEncoder.fromConfig(config);
    }

    public static VerificationTaskBuilder builder() {
        return new VerificationTaskBuilder();
    }

    public Configuration getConfig() {
        return this.config;
    }

    public Program getProgram() {
    	return program;
    }
    
    public Wmm getMemoryModel() {
    	return memoryModel;
    }
    
    public WitnessGraph getWitness() {
    	return witness;
    }

    public Set<Relation> getRelations() {
    	return memoryModel.getRelationRepository().getRelations();
    }

    public List<Axiom> getAxioms() {
    	return memoryModel.getAxioms();
    }

    public BranchEquivalence getBranchEquivalence() {
        return branchEquivalence;
    }

	public AliasAnalysis getAliasAnalysis() {
		return aliasAnalysis;
	}

    public ThreadSymmetry getThreadSymmetry() { return threadSymmetry; }

    public DependencyGraph<Relation> getRelationDependencyGraph() {
        return memoryModel.getRelationDependencyGraph();
    }

    public ProgramEncoder getProgramEncoder() {
        return progEncoder;
    }

    public MemoryEncoder getMemoryEncoder() {
    	return memoryEncoder;
    }


    // ===================== Utility Methods ====================

    public void preprocessProgram() throws InvalidConfigurationException {
        ProcessingManager.fromConfig(config).run(program);
    }

    public void performStaticProgramAnalyses() throws InvalidConfigurationException {
        branchEquivalence = BranchEquivalence.fromConfig(program, config);
        aliasAnalysis = AliasAnalysis.fromConfig(program, config);
        threadSymmetry = ThreadSymmetry.fromConfig(program, config);
    }

    public void initialiseEncoding(SolverContext ctx) {
        progEncoder.initialise(this, ctx);
        memoryEncoder.initialise(this, ctx);
        memoryModel.initialise(this, ctx);
    }

    public BooleanFormula encodeProgram(SolverContext ctx) {
        BooleanFormula memEncoding = memoryEncoder.encodeMemory(ctx);
    	BooleanFormula cfEncoding = progEncoder.encodeControlFlow(ctx);
    	BooleanFormula finalRegValueEncoding = progEncoder.encodeFinalRegisterValues(ctx);
        return ctx.getFormulaManager().getBooleanFormulaManager().and(memEncoding, cfEncoding, finalRegValueEncoding);
    }

    public BooleanFormula encodeWmmRelations(SolverContext ctx) {
        return memoryModel.encodeRelations( ctx);
    }

    public BooleanFormula encodeWmmConsistency(SolverContext ctx) {
        return memoryModel.encodeConsistency(ctx);
    }

	public BooleanFormula encodeSymmetryBreaking(SolverContext ctx) {
		return new SymmetryBreaking(this).encode(ctx);
	}

    public BooleanFormula encodeAssertions(SolverContext ctx) {
        return progEncoder.encodeAssertions(ctx);
    }

    public BooleanFormula encodeWitness(SolverContext ctx) {
    	return witness.encode(program, ctx);
    }


    // ==================== Builder =====================

    public static class VerificationTaskBuilder {
        protected WitnessGraph witness = new WitnessGraph();
        protected ConfigurationBuilder config = Configuration.builder();

        protected VerificationTaskBuilder() { }

        public VerificationTaskBuilder withWitness(WitnessGraph witness) {
            this.witness = checkNotNull(witness, "Witness may not be null.");
            return this;
        }

        public VerificationTaskBuilder withTarget(Arch target) {
            checkNotNull(target, "Target may not be null.");
            this.config.setOption(TARGET, target.toString());
            return this;
        }

        public VerificationTaskBuilder withBound(int k) {
            checkArgument(k > 0 , "Unrolling bound must be positive.");
            this.config.setOption(BOUND, Integer.toString(k));
            return this;
        }

        public VerificationTaskBuilder withSolverTimeout(int t) {
            this.config.setOption(TIMEOUT, Integer.toString(t));
            return this;
        }

        public VerificationTaskBuilder withConfig(Configuration config) {
            this.config.copyFrom(config);
            return this;
        }

        public VerificationTask build(Program program, Wmm memoryModel) throws InvalidConfigurationException {
            return new VerificationTask(program, memoryModel, witness, config.build());
        }
    }
}