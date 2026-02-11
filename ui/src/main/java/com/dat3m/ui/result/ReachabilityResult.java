package com.dat3m.ui.result;

import com.dat3m.dartagnan.Dartagnan;
import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.ProgressModel;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.solving.ModelChecker;
import com.dat3m.dartagnan.witness.WitnessType;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.ui.utils.UiOptions;
import com.dat3m.ui.utils.Utils;
import org.sosy_lab.common.configuration.Configuration;

import java.io.File;

public class ReachabilityResult {

    private final Program program;
    private final Wmm wmm;
    private final UiOptions options;

    private String verdict;
    private File witnessFile;


    public ReachabilityResult(Program program, Wmm wmm, UiOptions options) {
        this.program = program;
        this.wmm = wmm;
        this.options = options;
        run();
    }

    public String getVerdict() {
        return verdict;
    }

    public boolean hasWitness() {
        return witnessFile != null;
    }

    public File getWitnessFile() {
        return witnessFile;
    }

    private void run() {
        if (!validate()) {
            return;
        }

        try {
            final Arch arch = program.getArch() != null ? program.getArch() : options.target();
            final Configuration config = Configuration.builder().setOptions(options.config()).build();
            final VerificationTask task = VerificationTask.builder()
                    .withConfig(config)
                    .withBound(options.bound())
                    .withSolverTimeout(options.timeout())
                    .withSolver(options.solver())
                    .withTarget(arch)
                    .withProgressModel(ProgressModel.uniform(options.progress()))
                    .build(program, wmm, options.properties());
            try (ModelChecker modelChecker = ModelChecker.create(task, options.method())) {
                long startTime = System.currentTimeMillis();
                modelChecker.run();
                long endTime = System.currentTimeMillis();
                verdict = Dartagnan.summaryFromResult(task, modelChecker, "", (endTime - startTime)).toUIString();

                if (modelChecker.hasModel() && modelChecker.getResult() != Result.UNKNOWN) {
                    witnessFile = Dartagnan.generateExecutionGraphFile(task, modelChecker, WitnessType.PNG);
                }
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
