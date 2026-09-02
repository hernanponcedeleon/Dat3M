package com.dat3m.ui.result;

import com.dat3m.dartagnan.OutputGenerator;
import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.ProgressModel;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.verification.TaskSolver;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.witness.WitnessType;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.ui.utils.UiOptions;
import com.dat3m.ui.utils.Utils;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.ShutdownManager;

import java.nio.file.Path;

import static com.dat3m.dartagnan.configuration.OptionNames.*;
import static com.dat3m.dartagnan.witness.WitnessType.NONE;
import static com.dat3m.dartagnan.witness.WitnessType.PNG;

public class ReachabilityResult {

    private final Program program;
    private final Wmm wmm;
    private final UiOptions options;
    private final ShutdownManager shutdownManager;

    private String verdict;
    private Path witnessFile;


    public ReachabilityResult(Program program, Wmm wmm, UiOptions options) {
        this(program, wmm, options, null);
    }

    public ReachabilityResult(Program program, Wmm wmm, UiOptions options, ShutdownManager shutdownManager) {
        this.program = program;
        this.wmm = wmm;
        this.options = options;
        this.shutdownManager = shutdownManager;
        run();
    }

    public String getVerdict() {
        return verdict;
    }

    public boolean hasWitness() {
        return witnessFile != null;
    }

    public Path getWitnessFile() {
        return witnessFile;
    }

    private void run() {
        if (!validate()) {
            return;
        }

        try {
            final Arch arch = program.getArch() != null ? program.getArch() : options.target();
            final Configuration config = Configuration.builder()
                    .setOption(WITNESS_FILENAME, "dat3mUI")
                    .setOptions(options.config())
                    .setOption(WITNESS, options.showWitness() ? PNG.asStringOption() : NONE.asStringOption())
                    .build();
            final VerificationTask task = VerificationTask.builder()
                    .withConfig(config)
                    .withBound(options.bound())
                    .withSolverTimeout(options.timeout())
                    .withSolver(options.solver())
                    .withTarget(arch)
                    .withProgressModel(ProgressModel.uniform(options.progress()))
                    .build(program, wmm, options.properties());

            final OutputGenerator outputGenerator = OutputGenerator.create(false, config);
            try (TaskSolver solver = TaskSolver.create(task).withShutdownManager(shutdownManager)) {
                solver.run();

                verdict = outputGenerator.getOutputFromSolver(solver, "dat3mUI").summary();
                witnessFile = outputGenerator.getWitnessFile().orElse(null);
            }
        } catch (InterruptedException e) {
            verdict = "TIMEOUT";
        } catch (Exception e) {
            verdict = "ERROR: " + e;
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
