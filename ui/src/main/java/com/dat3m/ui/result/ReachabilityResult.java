package com.dat3m.ui.result;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.verification.RefinementTask;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.dat3m.ui.utils.UiOptions;
import com.dat3m.ui.utils.Utils;
import org.sosy_lab.common.ShutdownManager;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.log.BasicLogManager;
import org.sosy_lab.java_smt.SolverContextFactory;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverContext.ProverOptions;

import static com.dat3m.dartagnan.analysis.Base.*;
import static com.dat3m.dartagnan.analysis.Refinement.runAnalysisWMMSolver;

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
            Arch arch = program.getArch() != null ? program.getArch() : options.getTarget();
            VerificationTask task = new VerificationTask(program, wmm, arch, options.getSettings());
            Result result = Result.UNKNOWN;

            ShutdownManager sdm = ShutdownManager.create();
        	Thread t = new Thread(() -> {
    			try {
    				if(options.getSettings().getSolverTimeout() > 0) {
    					// Converts timeout from secs to millisecs
    					Thread.sleep(1000L * options.getSettings().getSolverTimeout());
    					sdm.requestShutdown("Shutdown Request");
    				}
    			} catch (InterruptedException e) {
    				// Verification ended, nothing to be done.
    			}});

            try {
            	t.start();
                Configuration config = Configuration.builder()
                		.setOption("solver.z3.usePhantomReferences", "true")
                		.build();
				try (SolverContext ctx = SolverContextFactory.createSolverContext(
                        config,
                        BasicLogManager.create(config),
                        sdm.getNotifier(),
                        options.getSolver());
                     ProverEnvironment prover = ctx.newProverEnvironment(ProverOptions.GENERATE_MODELS)) {


                    switch (options.getMethod()) {
                        case INCREMENTAL:
                            result = runAnalysisIncrementalSolver(ctx, prover, task);
                            break;
                        case ASSUME:
                            result = runAnalysisAssumeSolver(ctx, prover, task);
                            break;
                        case TWO:
                            try (ProverEnvironment prover2 = ctx.newProverEnvironment(ProverOptions.GENERATE_MODELS)) {
                                result = runAnalysisTwoSolvers(ctx, prover, prover2, task);
                            }
                            break;
                        case CAAT:
                            result = runAnalysisWMMSolver(ctx, prover,
                                    RefinementTask.fromVerificationTaskWithDefaultBaselineWMM(task));
                            break;
                    }
                    // Verification ended, we can interrupt the timeout Thread
                    t.interrupt();
                    buildVerdict(result);
                }
            } catch (InterruptedException e){
            	verdict = "TIMEOUT";
            } catch (Exception e) {
            	verdict = "ERROR: " + e.getMessage();
            }
        }
    }

    private void buildVerdict(Result result){
        StringBuilder sb = new StringBuilder();
        sb.append("Condition ").append(program.getAss().toStringWithType()).append("\n");
        sb.append(result).append("\n");
        verdict = sb.toString();
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
