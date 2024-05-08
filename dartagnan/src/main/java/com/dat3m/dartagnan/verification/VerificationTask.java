package com.dat3m.dartagnan.verification;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.witness.graphml.WitnessGraph;
import com.dat3m.dartagnan.wmm.Wmm;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.ConfigurationBuilder;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.EnumSet;

import static com.dat3m.dartagnan.configuration.OptionNames.*;
import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Preconditions.checkNotNull;

/*
Represents a verification task.
 */
public class VerificationTask {

    // Data objects
    private final Program program;
    private final Wmm memoryModel;
    private final EnumSet<Property> property;
    private final WitnessGraph witness;
    private final Configuration config;

    protected VerificationTask(Program program, Wmm memoryModel, EnumSet<Property> property, WitnessGraph witness, Configuration config)
    throws InvalidConfigurationException {
        this.program = checkNotNull(program);
        this.memoryModel = checkNotNull(memoryModel);
        this.property = checkNotNull(property);
        this.witness = checkNotNull(witness);
        this.config = checkNotNull(config);
    }

    public static VerificationTaskBuilder builder() {
        return new VerificationTaskBuilder();
    }

    public Program getProgram() { return program; }
    public Wmm getMemoryModel() { return memoryModel; }
    public Configuration getConfig() { return this.config; }
    public WitnessGraph getWitness() { return witness; }
    public EnumSet<Property> getProperty() { return property; }


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

        public VerificationTask build(Program program, Wmm memoryModel, EnumSet<Property> property) throws InvalidConfigurationException {
            return new VerificationTask(program, memoryModel, property, witness, config.build());
        }
    }
}