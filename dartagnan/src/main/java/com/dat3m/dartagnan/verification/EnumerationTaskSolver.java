package com.dat3m.dartagnan.verification;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.metadata.SourceLocation;
import com.dat3m.dartagnan.verification.solving.EnumerationSolver;
import com.dat3m.dartagnan.verification.solving.ModelChecker;
import com.google.common.base.Preconditions;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.java_smt.api.SolverException;

import static com.dat3m.dartagnan.program.Program.SourceLanguage.LITMUS;

@Options
public final class EnumerationTaskSolver extends TaskSolverBase<EnumerationTaskSolver, EnumerationTask, EnumerationResult> implements AutoCloseable {

    // =================================== Construction ===================================

    private EnumerationTaskSolver(EnumerationTask task) throws InvalidConfigurationException {
        super(task);
        checkSupport(task);
    }

    public static EnumerationTaskSolver create(EnumerationTask task) throws InvalidConfigurationException {
        return new EnumerationTaskSolver(task);
    }

    private void checkSupport(EnumerationTask task) {
        if (task.getProgram().getFormat() != LITMUS) {
            throw new UnsupportedOperationException("Enumeration task is only supported for Litmus programs.");
        }
    }

    // ===================================== Solving =====================================

    @Override
    public void run() throws SolverException, InterruptedException, InvalidConfigurationException {
        try (EnumerationSolver enumerator = EnumerationSolver.create(task)) {
            enumerator.setShutdownManager(shutdownManager);
            startRun();
            enumerator.run();

            result = new EnumerationResult(task, enumerator.getResult(),
                    enumerator.getVars(), enumerator.getEnumeratedStates()
            );
        } finally {
            endRun();
        }
    }

    // ===================================== Misc =====================================

    @Override
    protected EnumerationTaskSolver getThis() {
        return this;
    }

    @Override
    public void close() {
        result = null;
    }

}
