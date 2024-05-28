package com.dat3m.ui.result;

import com.dat3m.dartagnan.Dartagnan;
import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.solving.AssumeSolver;
import com.dat3m.dartagnan.verification.solving.ModelChecker;
import com.dat3m.dartagnan.verification.solving.RefinementSolver;
import com.dat3m.dartagnan.witness.WitnessType;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.ui.utils.UiOptions;
import com.dat3m.ui.utils.Utils;
import org.sosy_lab.common.ShutdownManager;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.log.BasicLogManager;
import org.sosy_lab.java_smt.SolverContextFactory;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverContext.ProverOptions;

import java.io.File;

import static com.dat3m.dartagnan.configuration.OptionNames.PHANTOM_REFERENCES;

public class ReachabilityResult {

    private final Program program;
    private final Wmm wmm;
    private final UiOptions options;

    private String verdict;
    private File violationModel;


    public ReachabilityResult(Program program, Wmm wmm, UiOptions options) {
        this.program = program;
        this.wmm = wmm;
        this.options = options;
        run();
    }

    public String getVerdict() {
        return verdict;
    }

    public boolean hasViolationModel() {
        return violationModel != null;
    }

    public File getViolationModelFile() {
        return violationModel;
    }

    private void run() {
        if (validate()) {

            ShutdownManager sdm = ShutdownManager.create();
            Thread t = new Thread(() -> {
                try {
                    if (options.timeout() > 0) {
                        // Converts timeout from secs to millisecs
                        Thread.sleep(1000L * options.timeout());
                        sdm.requestShutdown("Shutdown Request");
                    }
                } catch (InterruptedException e) {
                    // Verification ended, nothing to be done.
                }
            });

            try {
                ModelChecker modelChecker;
                Arch arch = program.getArch() != null ? program.getArch() : options.target();
                VerificationTask task = VerificationTask.builder()
                        .withBound(options.bound())
                        .withSolverTimeout(options.timeout())
                        .withTarget(arch)
                        .build(program, wmm, options.properties());

                t.start();
                Configuration config = Configuration.builder()
                        .setOption(PHANTOM_REFERENCES, "true")
                        .build();
                try (SolverContext ctx = SolverContextFactory.createSolverContext(
                        config,
                        BasicLogManager.create(config),
                        sdm.getNotifier(),
                        options.solver());
                     ProverEnvironment prover = ctx.newProverEnvironment(ProverOptions.GENERATE_MODELS)) {

                    modelChecker = switch (options.method()) {
                        case EAGER -> AssumeSolver.run(ctx, prover, task);
                        case LAZY -> RefinementSolver.run(ctx, prover, task);
                    };
                    // Verification ended, we can interrupt the timeout Thread
                    t.interrupt();
                    verdict = Dartagnan.generateResultSummary(task, prover, modelChecker);

                    if (modelChecker.hasModel()) {
                        violationModel = Dartagnan.generateExecutionGraphFile(task, prover, modelChecker, WitnessType.PNG);
                    }
                }
            } catch (InterruptedException e) {
                verdict = "TIMEOUT";
            } catch (Exception e) {
                verdict = "ERROR: " + e.getMessage();
            }
        }
    }

    private boolean validate() {
        Arch target = program.getArch() == null ? options.target() : program.getArch();
        if (target == null) {
            Utils.showError("Missing target architecture.");
            return false;
        }
        program.setArch(target);
        return true;
    }
}
