package com.dat3m.ui.result;

import com.dat3m.dartagnan.Dartagnan;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.solving.*;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.ui.utils.UiOptions;
import com.dat3m.ui.utils.Utils;
import org.sosy_lab.common.ShutdownManager;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.log.BasicLogManager;
import org.sosy_lab.java_smt.SolverContextFactory;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverContext.ProverOptions;
import static com.dat3m.dartagnan.configuration.OptionNames.PHANTOM_REFERENCES;

public class ReachabilityResult {

    private final Program program;
    private final Wmm wmm;
    private final UiOptions options;

    private String verdict;

    public ReachabilityResult(Program program, Wmm wmm, UiOptions options){
        this.program = program;
        this.wmm = wmm;
        this.options = options;
        run();
    }

    public String getVerdict(){
        return verdict;
    }

    private void run(){
        if(validate()){

            ShutdownManager sdm = ShutdownManager.create();
        	Thread t = new Thread(() -> {
    			try {
    				if(options.getTimeout() > 0) {
    					// Converts timeout from secs to millisecs
    					Thread.sleep(1000L * options.getTimeout());
    					sdm.requestShutdown("Shutdown Request");
    				}
    			} catch (InterruptedException e) {
    				// Verification ended, nothing to be done.
    			}});

            try {
                ModelChecker modelChecker;
                Arch arch = program.getArch() != null ? program.getArch() : options.getTarget();
                VerificationTask task = VerificationTask.builder()
                        .withBound(options.getBound())
                        .withSolverTimeout(options.getTimeout())
                        .withTarget(arch)
                        .build(program, wmm, Property.getDefault());

            	t.start();
                Configuration config = Configuration.builder()
                		.setOption(PHANTOM_REFERENCES, "true")
                		.build();
				try (SolverContext ctx = SolverContextFactory.createSolverContext(
                        config,
                        BasicLogManager.create(config),
                        sdm.getNotifier(),
                        options.getSolver());
                     ProverEnvironment prover = ctx.newProverEnvironment(ProverOptions.GENERATE_MODELS)) {

                    switch (options.getMethod()) {
                        case EAGER:
                            modelChecker = AssumeSolver.run(ctx, prover, task);
                            break;
                        case LAZY:
                            modelChecker = RefinementSolver.run(ctx, prover, task);
                            break;
                        default:
                            throw new IllegalArgumentException("method " + options.getMethod());
                    }
                    // Verification ended, we can interrupt the timeout Thread
                    t.interrupt();
                    verdict = Dartagnan.generateResultSummary(task, prover, modelChecker);
                }
            } catch (InterruptedException e){
            	verdict = "TIMEOUT";
            } catch (Exception e) {
            	verdict = "ERROR: " + e.getMessage();
            }
        }
    }

    private boolean validate(){
        Arch target = program.getArch() == null ? options.getTarget() : program.getArch();
        if(target == null) {
            Utils.showError("Missing target architecture.");
            return false;
        }
        program.setArch(target);
        return true;
    }
}
