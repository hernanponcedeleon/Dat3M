package com.dat3m.dartagnan.verification;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.ProgressModel;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.wmm.Wmm;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.ConfigurationBuilder;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.java_smt.SolverContextFactory;

import java.util.EnumSet;

import static com.dat3m.dartagnan.configuration.OptionNames.*;
import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Preconditions.checkNotNull;

/*
    Represents a verification task.
 */
public abstract sealed class Task permits VerificationTask {

    // Data objects
    private final Program program;
    private final Wmm memoryModel;
    private final ProgressModel.Hierarchy progressModel;
    private final Configuration config;

    protected Task(Program program, Wmm memoryModel, ProgressModel.Hierarchy progressModel, Configuration config)
    throws InvalidConfigurationException {
        this.program = checkNotNull(program);
        this.memoryModel = checkNotNull(memoryModel);
        this.progressModel = checkNotNull(progressModel);
        this.config = checkNotNull(config);

        // TODO: Is it a good idea to inject configs into the program here?
        program.injectConfig(config);
    }

    public static TaskBuilder builder() {
        return new TaskBuilder();
    }

    public Program getProgram() { return program; }
    public Wmm getMemoryModel() { return memoryModel; }
    public ProgressModel.Hierarchy getProgressModel() { return progressModel; }
    public Configuration getConfig() { return this.config; }


    // ==================== Builder =====================

    public static class TaskBuilder {
        protected ConfigurationBuilder config = Configuration.builder();
        protected ProgressModel.Hierarchy progressModel = ProgressModel.defaultHierarchy();

        protected TaskBuilder() { }

        public TaskBuilder withTarget(Arch target) {
            checkNotNull(target, "Target may not be null.");
            this.config.setOption(TARGET, target.toString());
            return this;
        }

        public TaskBuilder withBound(int k) {
            checkArgument(k > 0 , "Unrolling bound must be positive.");
            this.config.setOption(BOUND, Integer.toString(k));
            return this;
        }

        public TaskBuilder withProgressModel(ProgressModel.Hierarchy progressModel) {
            this.progressModel = progressModel;
            return this;
        }

        public TaskBuilder withSolverTimeout(int t) {
            this.config.setOption(TIMEOUT, Integer.toString(t));
            return this;
        }

        public TaskBuilder withSolver(SolverContextFactory.Solvers solver) {
            this.config.setOption(SOLVER, solver.toString());
            return this;
        }

        public TaskBuilder withConfig(Configuration config) {
            this.config.copyFrom(config);
            return this;
        }

        public TaskBuilder withOption(String option, String value) {
            this.config.setOption(option, value);
            return this;
        }

        public VerificationTask build(Program program, Wmm memoryModel, EnumSet<Property> property) throws InvalidConfigurationException {
            return new VerificationTask(program, memoryModel, progressModel, config.build(), property);
        }
    }
}