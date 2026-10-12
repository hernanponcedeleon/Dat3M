package com.dat3m.ui.result;

import com.dat3m.dartagnan.OutputGenerator;
import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.ProgressModel;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.verification.Task;
import com.dat3m.dartagnan.verification.VerificationResult;
import com.dat3m.dartagnan.verification.VerificationStatus;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.VerificationTaskSolver;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.ui.utils.UiOptions;
import com.dat3m.ui.witness.WitnessGraph;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.sosy_lab.common.ShutdownManager;
import org.sosy_lab.common.configuration.Configuration;

import java.util.Optional;

import static com.dat3m.dartagnan.configuration.OptionNames.*;
import static com.dat3m.dartagnan.witness.WitnessType.NONE;

public class ReachabilityResult {

    private static final Logger logger = LoggerFactory.getLogger(ReachabilityResult.class);

    private final Program program;
    private final Wmm wmm;
    private final UiOptions options;
    private final ShutdownManager shutdownManager;

    // The status is only available if the verification ran to completion.
    private VerificationStatus status;
    private String verdict;
    private WitnessGraph witness;
    private boolean isInterrupted;
    private boolean isError;

    public ReachabilityResult(Program program, Wmm wmm, UiOptions options, ShutdownManager shutdownManager) {
        this.program = program;
        this.wmm = wmm;
        this.options = options;
        this.shutdownManager = shutdownManager;
        run();
    }

    public Optional<VerificationStatus> getStatus() {
        return Optional.ofNullable(status);
    }

    public String getVerdict() {
        return verdict;
    }

    public boolean hasWitness() {
        return witness != null;
    }

    public WitnessGraph getWitness() {
        return witness;
    }

    public boolean isInterrupted() {
        return isInterrupted;
    }

    public boolean isError() {
        return isError;
    }

    private void run() {
        final Arch arch = program.getArch() != null ? program.getArch() : options.target();
        if (arch == null) {
            verdict = "Missing target architecture.";
            isError = true;
            return;
        }
        program.setArch(arch);

        try {
            // The UI draws witnesses itself. Graphical witness files are only generated if explicitly configured.
            final Configuration config = Configuration.builder()
                    .setOption(WITNESS_FILENAME, "dat3mUI")
                    .setOption(WITNESS, NONE.asStringOption())
                    .setOptions(options.config())
                    .build();
            final VerificationTask task = Task.builder()
                    .withConfig(config)
                    .withBound(options.bound())
                    .withSolver(options.solver())
                    .withTarget(arch)
                    .withProgressModel(ProgressModel.uniform(options.progress()))
                    .build(program, wmm, options.properties());

            final OutputGenerator outputGenerator = OutputGenerator.create(false, config);
            try (VerificationTaskSolver solver = VerificationTaskSolver.create(task)
                    .withShutdownManager(shutdownManager)) {
                solver.run();

                final VerificationResult result = solver.getResult();
                status = result.getStatus();
                verdict = outputGenerator.getOutputFromSolver(solver).summary();
                if (options.showWitness() && result.hasModel()) {
                    witness = extractWitness(result);
                }
            }
        } catch (InterruptedException e) {
            verdict = "The verification was interrupted.";
            isInterrupted = true;
        } catch (Exception e) {
            verdict = String.valueOf(e);
            isError = true;
        }
    }

    private WitnessGraph extractWitness(VerificationResult result) {
        try {
            return WitnessGraph.from(result);
        } catch (RuntimeException e) {
            logger.warn("Failed to extract the witness execution.", e);
            return null;
        }
    }
}
