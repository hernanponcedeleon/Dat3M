package com.dat3m.dartagnan;

import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.parsers.witness.ParserWitness;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.options.BaseOptions;
import com.dat3m.dartagnan.verification.RefinementTask;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.witness.WitnessBuilder;
import com.dat3m.dartagnan.witness.WitnessGraph;
import com.dat3m.dartagnan.wmm.Wmm;
import com.google.common.collect.ImmutableSet;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.ShutdownManager;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.common.log.BasicLogManager;
import org.sosy_lab.java_smt.SolverContextFactory;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverContext.ProverOptions;

import static java.lang.String.valueOf;

import java.io.File;
import java.util.Arrays;
import java.util.Set;

import static com.dat3m.dartagnan.analysis.Analysis.RACES;
import static com.dat3m.dartagnan.analysis.Base.*;
import static com.dat3m.dartagnan.analysis.DataRaces.checkForRaces;
import static com.dat3m.dartagnan.analysis.Refinement.runAnalysisWMMSolver;
import static com.dat3m.dartagnan.configuration.OptionNames.PHANTOM_REFERENCES;
import static com.dat3m.dartagnan.utils.GitInfo.CreateGitInfo;
import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.UNKNOWN;

@Options
public class Dartagnan extends BaseOptions {

	private static final Logger logger = LogManager.getLogger(Dartagnan.class);

	private static final Set<String> supportedFormats = 
    		ImmutableSet.copyOf(Arrays.asList(".litmus", ".bpl", ".c", ".i"));

	public static void main(String[] args) throws Exception {
    	
    	CreateGitInfo();
		
    	String[] argKeyword = Arrays.stream(args)
				.filter(s->s.startsWith("-"))
				.toArray(String[]::new);
		Configuration config = Configuration.fromCmdLineArguments(argKeyword); // TODO: We don't parse configs yet
		Dartagnan o = new Dartagnan();
		config.recursiveInject(o);

		//TODO add help

		if(Arrays.stream(args).noneMatch(a -> supportedFormats.stream().anyMatch(f -> a.endsWith(f)))) {
			throw new IllegalArgumentException("Input program not given or format not recognized");
		}
		// get() is guaranteed to success
		File fileProgram = new File(Arrays.stream(args).filter(a -> supportedFormats.stream().anyMatch(f -> a.endsWith(f))).findFirst().get());
		logger.info("Program path: " + fileProgram);

		if(Arrays.stream(args).noneMatch(a -> a.endsWith(".cat"))) {
			throw new IllegalArgumentException("CAT model not given or format not recognized");
		}
		// get() is guaranteed to success		
		File fileModel = new File(Arrays.stream(args).filter(a -> a.endsWith(".cat")).findFirst().get());		
		logger.info("CAT file path: " + fileModel);	
        
		Wmm mcm = new ParserCat().parse(fileModel);
		config.inject(mcm);
        Program p = new ProgramParser().parse(fileProgram);
        
        WitnessGraph witness = new WitnessGraph();
        if(o.runValidator()) {
        	logger.info("Witness path: " + o.getWitnessPath());
        	witness = new ParserWitness().parse(new File(o.getWitnessPath()));
        }

        VerificationTask task = VerificationTask.builder()
                .withConfig(config)
                .withWitness(witness)
                .build(p, mcm);

        ShutdownManager sdm = ShutdownManager.create();
    	Thread t = new Thread(() -> {
			try {
				if(o.hasTimeout()) {
					// Converts timeout from secs to millisecs
					Thread.sleep(1000L * o.getTimeout());
					sdm.requestShutdown("Shutdown Request");
					logger.warn("Shutdown Request");
				}
			} catch (InterruptedException e) {
				// Verification ended, nothing to be done.
			}});

    	try {
            t.start();
            Configuration solverConfig = Configuration.builder()
                    .setOption(PHANTOM_REFERENCES, valueOf(o.usePhantomReferences()))
                    .build();
            try (SolverContext ctx = SolverContextFactory.createSolverContext(
                    config,
                    BasicLogManager.create(solverConfig),
                    sdm.getNotifier(),
                    o.getSolver());
                 ProverEnvironment prover = ctx.newProverEnvironment(ProverOptions.GENERATE_MODELS))
            {
                Result result = UNKNOWN;
                switch (o.getAnalysis()) {
                	case RACES:
                    	result = checkForRaces(ctx, task);
                        break;
                    case REACHABILITY:
                    	switch (o.getMethod()) {
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
                        }
                        break;
                }

                // Verification ended, we can interrupt the timeout Thread
                t.interrupt();

                if (fileProgram.getName().endsWith(".litmus")) {
                    if (p.getAssFilter() != null) {
                        System.out.println("Filter " + (p.getAssFilter()));
                    }
                    System.out.println("Condition " + p.getAss().toStringWithType());
                    System.out.println(result == FAIL ? "Ok" : "No");
                } else {
                    System.out.println(result);
                }

				try {
					WitnessBuilder w = new WitnessBuilder(task, ctx, prover, result);
					config.inject(w);
	                // We only write witnesses for REACHABILITY (if the path to the original C file was given) 
					// and if we are not doing witness validation
	                if (!o.getAnalysis().equals(RACES) && w.canBeBuilt() && !o.runValidator()) {
						w.build().write();
	                }
				} catch(InvalidConfigurationException e) {
					logger.warn(e.getMessage());
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
