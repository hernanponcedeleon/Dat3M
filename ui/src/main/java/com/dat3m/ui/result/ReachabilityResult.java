package com.dat3m.ui.result;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.verification.RefinementTask;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.solving.AssumeSolver;
import com.dat3m.dartagnan.verification.solving.IncrementalSolver;
import com.dat3m.dartagnan.verification.solving.RefinementSolver;
import com.dat3m.dartagnan.verification.solving.TwoSolvers;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.ui.utils.UiOptions;
import com.dat3m.ui.utils.Utils;
import org.sosy_lab.common.ShutdownManager;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.log.BasicLogManager;
import org.sosy_lab.java_smt.SolverContextFactory;
import org.sosy_lab.java_smt.api.Model;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverContext.ProverOptions;
import org.sosy_lab.java_smt.api.SolverException;

import static com.dat3m.dartagnan.configuration.OptionNames.PHANTOM_REFERENCES;
import static com.dat3m.dartagnan.configuration.Property.CAT;
import static com.dat3m.dartagnan.configuration.Property.REACHABILITY;
import static com.dat3m.dartagnan.program.Program.SourceLanguage.LITMUS;
import static com.dat3m.dartagnan.utils.Result.FAIL;
import static java.lang.Boolean.TRUE;

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
                Result result = Result.UNKNOWN;
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
                        case INCREMENTAL:
                            result = IncrementalSolver.run(ctx, prover, task);
                            break;
                        case ASSUME:
                            result = AssumeSolver.run(ctx, prover, task);
                            break;
                        case TWO:
                            try (ProverEnvironment prover2 = ctx.newProverEnvironment(ProverOptions.GENERATE_MODELS)) {
                                result = TwoSolvers.run(ctx, prover, prover2, task);
                            }
                            break;
                        case CAAT:
                            result = RefinementSolver.run(ctx, prover,
                                    RefinementTask.fromVerificationTaskWithDefaultBaselineWMM(task));
                            break;
                    }
                    // Verification ended, we can interrupt the timeout Thread
                    t.interrupt();
                    buildVerdict(result, prover, ctx);
                }
            } catch (InterruptedException e){
            	verdict = "TIMEOUT";
            } catch (Exception e) {
            	verdict = "ERROR: " + e.getMessage();
            }
        }
    }

    private void buildVerdict(Result result, ProverEnvironment prover, SolverContext ctx) throws SolverException {
        StringBuilder sb = new StringBuilder();
        Model model = result.equals(FAIL) ? prover.getModel() : null;
    	for(Axiom ax : wmm.getAxioms()) {
        	if(ax.isFlagged() && model != null && TRUE.equals(model.evaluate(CAT.getSMTVariable(ax, ctx)))) {
        		sb.append("Flag " + (ax.getName() != null ? ax.getName() : ax.getRelation().getName())).append("\n");
        	}
    	}
		// TODO We might want to output different messages once we allow to check LIVENESS from the UI
		sb.append("Condition ").append(program.getAss().toStringWithType()).append("\n");
		sb.append(program.getFormat().equals(LITMUS) ? (model != null && TRUE.equals(model.evaluate(REACHABILITY.getSMTVariable(ctx)))) ? "Ok" : "No" : result).append("\n");
		if(model != null) {
			model.close();			
		}
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
