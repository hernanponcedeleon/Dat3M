package com.dat3m.dartagnan.task.exploration;

import com.dat3m.dartagnan.task.TaskSolverBase;
import com.dat3m.dartagnan.task.verification.VerificationStatus;

import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.processing.ProcessingManager;
import com.dat3m.dartagnan.task.SMTModelChecker;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.IntegerOption;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.util.EnumSet;

import static com.dat3m.dartagnan.configuration.OptionNames.EXPLORATION_MAX_EVENTS;
import static com.dat3m.dartagnan.configuration.OptionNames.EXPLORATION_ORDER;
import static com.dat3m.dartagnan.configuration.OptionNames.MIXED_SIZE;
import static com.dat3m.dartagnan.configuration.OptionNames.EXPLORATION_THREAD_CREATION_BOUND;
import static com.dat3m.dartagnan.configuration.OptionNames.EXPLORATION_PRINT_EXECUTIONS;
import static com.dat3m.dartagnan.task.verification.VerificationStatus.*;

/*
    Solves exploration tasks via stateless model checking (TruSt).
    The program is NOT unrolled: if it has infinite executions, the exploration runs forever,
    unless a bound on the number of events per thread is given (or a timeout is reached).
 */
@Options
public final class ExplorationTaskSolver extends TaskSolverBase<ExplorationTaskSolver, ExplorationTask, ExplorationResult> {

    private static final Logger logger = LoggerFactory.getLogger(ExplorationTaskSolver.class);

    // ================================== Configurables ==================================

    @Option(name = EXPLORATION_MAX_EVENTS,
            description = "Maximal number of events per thread. Executions exceeding the bound are cut off " +
                    "and make the result inconclusive. 0 (default) means unbounded: the exploration does not " +
                    "terminate on programs with infinite executions.")
    @IntegerOption(min = 0)
    private int maxEventsPerThread = 0;

    @Option(name = EXPLORATION_ORDER,
            description = "Order along which events are explored: po (default, the original TruSt algorithm; " +
                    "requires (po U rf) to be acyclic) or dependencies (replaces po by dependencies, po-loc, rmw, " +
                    "and fence/acquire/release ordering; allows exploring e.g. load buffering).",
            toUppercase = true)
    private ExplorationOrder order = ExplorationOrder.PO;

    @Option(name = EXPLORATION_THREAD_CREATION_BOUND,
            description = "Unrolling bound for loops that create threads (the only loops that are unrolled during " +
                    "exploration). Executions that reach the bound make the result inconclusive. Default: 8.")
    @IntegerOption(min = 1)
    private int threadCreationBound = 8;

    @Option(name = EXPLORATION_PRINT_EXECUTIONS,
            description = "Prints every complete execution found during exploration (disables early termination).")
    private boolean printExecutions = false;

    // ====================================== State ======================================

    private TruStExplorer explorer;

    // =================================== Construction ===================================

    private ExplorationTaskSolver(ExplorationTask task) throws InvalidConfigurationException {
        super(task);
        task.getConfig().inject(this);
    }

    public static ExplorationTaskSolver create(ExplorationTask task) throws InvalidConfigurationException {
        return new ExplorationTaskSolver(task);
    }

    public ExplorationTaskSolver withMaxEventsPerThread(int bound) {
        this.maxEventsPerThread = bound;
        return this;
    }

    // ===================================== Solving =====================================

    @Override
    public void run() throws InterruptedException, InvalidConfigurationException {
        if ("true".equals(task.getConfig().getProperty(MIXED_SIZE))) {
            throw new UnsupportedOperationException("Exploration does not support mixed-size accesses (" + MIXED_SIZE + ").");
        }
        startRun();
        try {
            final Program program = task.getProgram();
            ProcessingManager.forExploration(task.getConfig(), threadCreationBound).run(program);
            SMTModelChecker.preprocessMemoryModel(task);

            final EnumSet<Property> properties = task.getProperties();
            explorer = new TruStExplorer(program, task.getMemoryModel(), properties, order, maxEventsPerThread,
                    printExecutions, shutdownManager.getNotifier());
            explorer.run();
        } finally {
            endRun();
        }
        result = new ExplorationResult(task, computeStatus(), explorer.getStatistics(),
                explorer.getViolation().orElse(null), explorer.getReachabilityWitness(), explorer.isExhaustive(),
                explorer.getOutcomes());
        logger.info("Exploration finished with result {}", result.getStatus());
    }

    private VerificationStatus computeStatus() {
        if (explorer.getViolation().isPresent()) {
            return FAIL;
        }
        final boolean isReachability = task.getProperties().contains(Property.PROGRAM_SPEC)
                && task.getProgram().hasReachabilitySpecification();
        if (isReachability) {
            if (explorer.isSpecificationReached()) {
                return PASS;
            }
            return explorer.isExhaustive() ? FAIL : UNKNOWN;
        }
        return explorer.isExhaustive() ? PASS : UNKNOWN;
    }

    // ===================================== Misc =====================================

    @Override
    protected ExplorationTaskSolver getThis() {
        return this;
    }
}
