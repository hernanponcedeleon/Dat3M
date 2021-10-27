package com.dat3m.dartagnan.verification;

import com.dat3m.dartagnan.GlobalSettings;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.encoding.MemoryEncoder;
import com.dat3m.dartagnan.program.encoding.ProgramEncoder;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Label;
import com.dat3m.dartagnan.program.processing.ProcessingManager;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.utils.equivalence.BranchEquivalence;
import com.dat3m.dartagnan.utils.symmetry.SymmetryBreaking;
import com.dat3m.dartagnan.utils.symmetry.ThreadSymmetry;
import com.dat3m.dartagnan.witness.WitnessGraph;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.dat3m.dartagnan.wmm.utils.alias.Alias;
import com.google.common.base.Preconditions;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.List;
import java.util.Set;

/*
Represents a verification task.
 */

public class VerificationTask {

    private static final Logger logger = LogManager.getLogger(VerificationTask.class);

    private final Program program;
    private final Wmm memoryModel;
    private final WitnessGraph witness;
    private final Arch target;
    private final Settings settings;
    private final Configuration config;
    private BranchEquivalence branchEquivalence;
    private ThreadSymmetry threadSymmetry;

    private final ProgramEncoder progEncoder;
    private final MemoryEncoder memoryEncoder;

    protected VerificationTask(Program program, Wmm memoryModel, WitnessGraph witness,
                            Arch target, Settings settings, Configuration config) {
        this.program = program;
        this.memoryModel = memoryModel;
        this.witness = witness;
        this.target = target;
        this.settings = settings;

        try {
            //TODO: This should be a parameter and <target> as well as <settings> should directly be integrated
            // But for now we will use the VerificationTask as the point where different settings are merged into
            // a config. From here on, all algorithms should be able to purely rely on configs.
            this.config = Configuration.builder()
                    .copyFrom(settings.applyToConfig(config))
                    .setOption("program.processing.compilationTarget", target.toString())
                    .build();
            progEncoder = ProgramEncoder.fromConfig(config);
            memoryEncoder = MemoryEncoder.fromConfig(config);
        } catch (InvalidConfigurationException ex) {
            throw new RuntimeException(ex);
        }
    }

    public static VerificationTaskBuilder builder() {
        return new VerificationTaskBuilder();
    }

    public static class VerificationTaskBuilder {
        protected WitnessGraph witness = new WitnessGraph();
        protected Arch target = Arch.NONE;
        protected Settings settings = new Settings(Alias.CFIS, 1, 0);
        protected Configuration config = Configuration.defaultConfiguration();

        protected VerificationTaskBuilder() { }

        public VerificationTaskBuilder withWitness(WitnessGraph witness) {
            Preconditions.checkNotNull(witness, "Witness may not be null.");
            this.witness = witness;
            return this;
        }

        public VerificationTaskBuilder withTarget(Arch target) {
            Preconditions.checkNotNull(target, "Target architecture may not be null");
            this.target = target;
            return this;
        }

        public VerificationTaskBuilder withSettings(Settings settings) {
            Preconditions.checkNotNull(settings, "Settings may not be null");
            this.settings = settings;
            return this;
        }

        public VerificationTaskBuilder withConfig(Configuration config) {
            Preconditions.checkNotNull(config, "Config may not be null");
            this.config = config;
            return this;
        }

        public VerificationTask build(Program program, Wmm memoryModel) {
            return new VerificationTask(program, memoryModel, witness, target, settings, config);
        }
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
    
    public Arch getTarget() {
    	return target;
    }
    
    public Settings getSettings() {
    	return settings;
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

    public DependencyGraph<Relation> getRelationDependencyGraph() {
        return memoryModel.getRelationDependencyGraph();
    }

    public ThreadSymmetry getThreadSymmetry() {
        if (threadSymmetry == null) {
            Preconditions.checkState(program.isCompiled(), "Thread symmetry can only be computed after compilation.");
            threadSymmetry = new ThreadSymmetry(program);
        }
        return threadSymmetry;
    }

    public ProgramEncoder getProgramEncoder() {
        return progEncoder;
    }

    public MemoryEncoder getMemoryEncoder() { return memoryEncoder; }


    // ===================== Utility Methods ====================

    public void unrollAndCompile() {
        logger.info("#Events: " + program.getEvents().size());
        try {
            ProcessingManager.fromConfig(config).run(program);
            branchEquivalence = new BranchEquivalence(program, config);
        } catch (InvalidConfigurationException ex) {
            logger.warn("Configuration error when preprocessing program. Some preprocessing steps may have been skipped.");
        }

        program.setFId(0); // This is used for symmetry breaking

        if (GlobalSettings.getInstance().shouldDebugPrintProgram()) {
            for (Thread t : program.getThreads()) {
                System.out.println("========== Thread " + t.getId() + " ==============");
                for (Event e : t.getEntry().getSuccessors()) {
                    String indent = ((e instanceof Label) ? "" : "   ");
                    System.out.printf("%4d: %s%s%n", e.getCId(), indent, e);
                }
            }
        }
        // AssertionInline depends on compiled events (copies)
        // Thus we need to update the assertion after compilation
        program.updateAssertion();
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
}
