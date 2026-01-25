package com.dat3m.dartagnan.verification.solving;

import com.dat3m.dartagnan.GlobalSettings;
import com.dat3m.dartagnan.configuration.Method;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.encoding.IREvaluator;
import com.dat3m.dartagnan.exception.UnsatisfiedRequirementException;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.*;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.processing.ProcessingManager;
import com.dat3m.dartagnan.smt.ProverWithTracker;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.model.ExecutionModelManager;
import com.dat3m.dartagnan.verification.model.ExecutionModelNext;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.analysis.WmmAnalysis;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.processing.WmmProcessingManager;
import com.google.common.base.Preconditions;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.ShutdownManager;
import org.sosy_lab.common.ShutdownNotifier;
import org.sosy_lab.common.configuration.*;
import org.sosy_lab.common.log.BasicLogManager;
import org.sosy_lab.java_smt.SolverContextFactory;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverException;

import java.util.Optional;

import static com.dat3m.dartagnan.configuration.OptionNames.*;
import static com.dat3m.dartagnan.configuration.Property.CAT_SPEC;
import static com.dat3m.dartagnan.configuration.Property.DATARACEFREEDOM;
import static com.dat3m.dartagnan.program.analysis.SyntacticContextAnalysis.*;
import static com.dat3m.dartagnan.utils.Result.*;

@Options
public abstract class ModelChecker implements AutoCloseable {

    @Options
    protected static class SMTConfig {
        @Option(
                name = SOLVER,
                description = "Uses the specified SMT solver as a backend.",
                toUppercase = true)
        private SolverContextFactory.Solvers solver = SolverContextFactory.Solvers.Z3;

        public SolverContextFactory.Solvers getSolver() {
            return solver;
        }

        @Option(
                name = SMTLIB2,
                description = "Dump encoding to an SMTLIB2 file.")
        private boolean smtlib = false;

        public boolean getDumpSmtLib() {
            return smtlib;
        }

        @Option(
                name = TIMEOUT,
                description = "Timeout (in secs) before interrupting the SMT solver.")
        @IntegerOption(min = 0)
        private int timeout = 0;

        public boolean hasTimeout() {
            return timeout > 0;
        }

        public int getTimeout() {
            return timeout;
        }
    }

    private static final Logger logger = LogManager.getLogger(ModelChecker.class);


    protected final VerificationTask task;
    protected final SMTConfig smtConfig;
    private ShutdownManager shutdownManager = ShutdownManager.create();

    protected SolverContext solverContext;
    protected EncodingContext context;
    protected ProverWithTracker prover;

    protected Result res = Result.UNKNOWN;

    protected ModelChecker(VerificationTask task) throws InvalidConfigurationException {
        this.task = Preconditions.checkNotNull(task);
        this.smtConfig = new SMTConfig();
        task.getConfig().inject(smtConfig);
    }

    public static ModelChecker create(VerificationTask task, Method method) throws InvalidConfigurationException {
        if (task.getProperty().contains(DATARACEFREEDOM)) {
            // For DATARACEFREEDOM, we always use EAGER
            // Shall we just throw an exception here?
            method = Method.EAGER;
        }
        return switch (method) {
            case EAGER -> AssumeSolver.create(task);
            case LAZY -> RefinementSolver.create(task);
        };
    }

    public final Result getResult() {
        Preconditions.checkState(prover != null, "No result: the model checker has not run yet.");
        return res;
    }

    public long getTimeout() {
        return smtConfig.getTimeout();
    }

    public void setShutdownManager(ShutdownManager shutdownManager) {
        this.shutdownManager = shutdownManager;
    }

    public boolean hasModel() {
        final Property.Type propType = Property.getCombinedType(context.getTask().getProperty(), context.getTask());
        final boolean hasViolationWitnesses = res == FAIL && propType == Property.Type.SAFETY;
        final boolean hasPositiveWitnesses = res == PASS && propType == Property.Type.REACHABILITY;
        final boolean hasReachedBounds = res == UNKNOWN && propType == Property.Type.SAFETY;
        return (hasViolationWitnesses || hasPositiveWitnesses || hasReachedBounds);
    }

    public IREvaluator getModel() throws SolverException {
        Preconditions.checkState(hasModel(), "No model available");
        return context.newEvaluator(prover);
    }

    public ExecutionModelNext getExecutionGraph() throws SolverException {
        Preconditions.checkState(hasModel(), "No model available");
        try (IREvaluator evaluator = getModel()) {
            return new ExecutionModelManager().buildExecutionModel(evaluator);
        }
    }

    public void run() throws SolverException, InterruptedException, InvalidConfigurationException {
        Preconditions.checkState(prover == null, "Model checker already ran.");
        if (!smtConfig.hasTimeout()) {
            runInternal();
            return;
        }

        java.lang.Thread t = new java.lang.Thread(() -> {
            try {
                final long timeoutInMillis = smtConfig.getTimeout() * 1000L;
                java.lang.Thread.sleep(timeoutInMillis);
                shutdownManager.requestShutdown("Timeout of " + smtConfig.getTimeout() + "s exceeded.");
            } catch (InterruptedException e) {
                // Verification ended, nothing to be done.
            }
        });

        t.start();
        runInternal();
        t.interrupt();
    }

    protected abstract void runInternal() throws InterruptedException, SolverException, InvalidConfigurationException;

    @Override
    public void close() {
        if (prover != null) {
            prover.close();
            prover = null;
        }
        if (solverContext != null) {
            solverContext.close();
            solverContext = null;
        }
    }

    public String getFlaggedPairsOutput() throws SolverException {
        if (!context.getTask().getProperty().contains(CAT_SPEC)) {
            return "";
        }

        final Wmm wmm = context.getTask().getMemoryModel();
        final Program program = context.getTask().getProgram();
        final StringBuilder output = new StringBuilder();
        try (IREvaluator evaluator = getModel()) {
            final SyntacticContextAnalysis synContext = newInstance(program);
            for (Axiom ax : wmm.getAxioms()) {
                if (ax.isFlagged() && evaluator.isFlaggedAxiomViolated(ax)) {
                    StringBuilder violatingPairs = new StringBuilder("\tFlag " + Optional.ofNullable(ax.getName()).orElse(ax.getRelation().getNameOrTerm())).append("\n");
                    evaluator.eventGraph(ax.getRelation()).apply((e1, e2) -> {
                        final String callSeparator = " -> ";
                        final String callStackFirst = makeContextString(
                                synContext.getContextInfo(e1).getContextOfType(CallContext.class),
                                callSeparator);
                        final String callStackSecond = makeContextString(
                                synContext.getContextInfo(e2).getContextOfType(CallContext.class),
                                callSeparator);

                        violatingPairs
                                .append("\tE").append(e1.getGlobalId())
                                .append(" / E").append(e2.getGlobalId())
                                .append("\t").append(callStackFirst).append(callStackFirst.isEmpty() ? "" : callSeparator)
                                .append(getSourceLocationString(e1))
                                .append(" / ").append(callStackSecond).append(callStackSecond.isEmpty() ? "" : callSeparator)
                                .append(getSourceLocationString(e2))
                                .append("\n");
                    });
                    output.append(violatingPairs);
                }
            }
        }

        return output.toString();
    }

    // ====================================== Encoding utility ==================================================

    protected SolverContext createSolverContext(VerificationTask task) throws InvalidConfigurationException {
        if (solverContext != null) {
            solverContext.close();
        }
        final ShutdownNotifier notifier = shutdownManager.getNotifier();
        solverContext = createSolverContext(task.getConfig(), notifier, smtConfig.getSolver());
        return solverContext;
    }

    protected ProverWithTracker createProver() {
        Preconditions.checkState(solverContext != null, "SolverContext not initialized");
        if (prover != null) {
            prover.close();
        }

        final String dumpPath = smtConfig.getDumpSmtLib()
                ? GlobalSettings.getOutputDirectory() + String.format("/%s.smt2", task.getProgram().getName())
                : "";
        prover = new ProverWithTracker(solverContext, dumpPath, SolverContext.ProverOptions.GENERATE_MODELS);
        return prover;
    }

    private static SolverContext createSolverContext(Configuration config, ShutdownNotifier notifier,
                                                     SolverContextFactory.Solvers solver)
            throws InvalidConfigurationException {
        // Try using NativeLibraries::loadLibrary. Fallback to System::loadLibrary
        // if NativeLibraries failed, for example, because the operating system is
        // not supported,
        try {
            return SolverContextFactory.createSolverContext(
                    config,
                    BasicLogManager.create(config),
                    notifier,
                    solver);
        } catch (Exception e) {
            return SolverContextFactory.createSolverContext(
                    config,
                    BasicLogManager.create(config),
                    notifier,
                    solver,
                    System::loadLibrary);
        }
    }

    // ====================================== Processing utility ==================================================


    /**
     * Performs all modifications to a parsed program.
     * @param task Program, target memory model and property to be checked.
     * @param config User-defined options to further specify the behavior.
     * @exception InvalidConfigurationException Some user-defined option does not match the format.
     */
    public static void preprocessProgram(VerificationTask task, Configuration config) throws InvalidConfigurationException {
        Program program = task.getProgram();
        ProcessingManager.fromConfig(config).run(program);
    }
    public static void preprocessMemoryModel(VerificationTask task, Configuration config) throws InvalidConfigurationException{
        final Wmm memoryModel = task.getMemoryModel();
        WmmProcessingManager.fromConfig(config).run(memoryModel);
    }

    /**
     * Performs all static program analyses.
     * @param task Program, target memory model and property to be checked.
     * @param analysisContext Collection of static analyses already performed for this task.
     *                        Also receives the results.
     * @param config User-defined options to further specify the behavior.
     * @exception InvalidConfigurationException Some user-defined option does not match the format.
     * @exception UnsatisfiedRequirementException Some static analysis is missing.
     */
    public static void performStaticProgramAnalyses(VerificationTask task, Context analysisContext, Configuration config) throws InvalidConfigurationException {
        final Program program = task.getProgram();
        analysisContext.register(BranchEquivalence.class, BranchEquivalence.fromConfig(program, config));
        analysisContext.register(ExecutionAnalysis.class, ExecutionAnalysis.fromConfig(program, task.getProgressModel(),
                analysisContext, config));
        analysisContext.register(ReachingDefinitionsAnalysis.class, ReachingDefinitionsAnalysis.fromConfig(program,
                analysisContext, config));
        final AliasAnalysis alias = AliasAnalysis.fromConfig(program, analysisContext, config, logger.isWarnEnabled());
        analysisContext.register(AliasAnalysis.class, alias);
        analysisContext.register(ThreadSymmetry.class, ThreadSymmetry.fromConfig(program, config));
        for(Thread thread : program.getThreads()) {
            for(Event e : thread.getEvents()) {
                // Some events perform static analyses by themselves (e.g. Svcomp's EndAtomic)
                // which may rely on previous "global" analyses
                e.runLocalAnalysis(program, analysisContext);
            }
        }
    }

    /**
     * Performs all memory-model-based static analyses.
     * @param task Program, target memory model and property to be checked.
     * @param analysisContext Collection of static analyses already performed for this task.
     *                        Also receives the results.
     * @param config User-defined options to further specify the behavior.
     * @exception InvalidConfigurationException Some user-defined option does not match the format.
     * @exception UnsatisfiedRequirementException Some static analysis is missing.
     */
    public static void performStaticWmmAnalyses(VerificationTask task, Context analysisContext, Configuration config) throws InvalidConfigurationException {
        analysisContext.register(WmmAnalysis.class, WmmAnalysis.fromConfig(task.getMemoryModel(), task.getProgram().getArch(), config));
        analysisContext.register(RelationAnalysis.class, RelationAnalysis.fromConfig(task, analysisContext, config));
    }
}
