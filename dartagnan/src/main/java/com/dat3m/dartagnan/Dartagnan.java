package com.dat3m.dartagnan;

import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.parsers.witness.ParserWitness;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.utils.options.DartagnanOptions;
import com.dat3m.dartagnan.verification.RefinementTask;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.witness.WitnessBuilder;
import com.dat3m.dartagnan.witness.WitnessGraph;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;
import org.apache.commons.cli.HelpFormatter;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.ShutdownManager;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.log.BasicLogManager;
import org.sosy_lab.java_smt.SolverContextFactory;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverContext.ProverOptions;

import java.io.File;

import static com.dat3m.dartagnan.GlobalSettings.LogGlobalSettings;
import static com.dat3m.dartagnan.analysis.Analysis.RACES;
import static com.dat3m.dartagnan.analysis.Base.*;
import static com.dat3m.dartagnan.analysis.DataRaces.checkForRaces;
import static com.dat3m.dartagnan.analysis.Refinement.runAnalysisWMMSolver;
import static com.dat3m.dartagnan.utils.GitInfo.CreateGitInfo;
import static com.dat3m.dartagnan.utils.Result.FAIL;

public class Dartagnan {

	private static final Logger logger = LogManager.getLogger(Dartagnan.class);  
	
    public static void main(String[] args) throws Exception {
    	
    	CreateGitInfo();
    	LogGlobalSettings();
    	
        DartagnanOptions options = new DartagnanOptions();
        try {
            options.parse(args);
        }
        catch (Exception e){
            if(e instanceof UnsupportedOperationException){
                System.out.println(e.getMessage());
            }
            new HelpFormatter().printHelp("DARTAGNAN", options);
            System.exit(1);
            return;
        }        
        
        Wmm mcm = new ParserCat().parse(new File(options.getTargetModelFilePath()));
        Program p = new ProgramParser().parse(new File(options.getProgramFilePath()));        	

        Arch target = p.getArch();
        if(target == null){
            target = options.getTarget();
        }

        logger.info("Program path: " + options.getProgramFilePath());
        logger.info("CAT file path: " + options.getTargetModelFilePath());
        logger.info("Bound: " + options.getSettings().getBound());
        logger.info("Target: " + target);

        WitnessGraph witness = new WitnessGraph();
        if(options.getWitnessPath() != null) {
        	logger.info("Witness path: " + options.getWitnessPath());
        	witness = new ParserWitness().parse(new File(options.getWitnessPath()));
        }        

        Settings settings = options.getSettings();
        VerificationTask task = new VerificationTask(p, mcm, witness, target, settings);

        ShutdownManager sdm = ShutdownManager.create();
    	Thread t = new Thread(() -> {
			try {
				if(options.getSettings().getSolverTimeout() > 0) {
					// Converts timeout from secs to millisecs
					Thread.sleep(1000L * options.getSettings().getSolverTimeout());
					sdm.requestShutdown("Shutdown Request");
					logger.warn("Shutdown Request");
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
                    options.getSMTSolver());
                 ProverEnvironment prover = ctx.newProverEnvironment(ProverOptions.GENERATE_MODELS))
            {
                Result result;
                switch (options.getAnalysis()) {
                    case RACES:
                        result = checkForRaces(ctx, task);
                        break;
                    case REACHABILITY:
                        switch (options.getMethod()) {
                            case TWO:
                                try (ProverEnvironment prover2 = ctx.newProverEnvironment(ProverOptions.GENERATE_MODELS)) {
                                    result = runAnalysisTwoSolvers(ctx, prover, prover2, task);
                                }
                                break;
                            case INCREMENTAL:
                                result = runAnalysisIncrementalSolver(ctx, prover, task);
                                break;
                            case ASSUME:
                                result = runAnalysisAssumeSolver(ctx, prover, task);
                                break;
                            case CAAT:
                                result = runAnalysisWMMSolver(ctx, prover,
                                        RefinementTask.fromVerificationTaskWithDefaultBaselineWMM(task));
                                break;
                            default:
                                throw new RuntimeException("Unrecognized method mode: " + options.getMethod());
                        }
                        break;
                    default:
                        throw new RuntimeException("Unrecognized analysis: " + options.getAnalysis());
                }

                // Verification ended, we can interrupt the timeout Thread
                t.interrupt();

                if (options.getProgramFilePath().endsWith(".litmus")) {
                    System.out.println("Settings: " + options.getSettings());
                    if (p.getAssFilter() != null) {
                        System.out.println("Filter " + (p.getAssFilter()));
                    }
                    System.out.println("Condition " + p.getAss().toStringWithType());
                    System.out.println(result == FAIL ? "Ok" : "No");
                } else {
                    System.out.println(result);
                }

                if (options.createWitness() != null && options.getAnalysis() != RACES) {
                    new WitnessBuilder(p, ctx, prover, result).buildGraph(options).write();
                }
            }
        } catch (InterruptedException e){
        	logger.warn("Timeout elapsed. The SMT solver was stopped");
        	System.out.println("TIMEOUT");
        	System.exit(0);
        } catch (Exception e) {
        	logger.error(e.getMessage());
        	System.out.println("ERROR");
        	System.exit(1);
        }
    }
}
