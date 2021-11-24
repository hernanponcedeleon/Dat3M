package com.dat3m.dartagnan;

import com.dat3m.dartagnan.analysis.Analysis;
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
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.ShutdownManager;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.common.log.BasicLogManager;
import org.sosy_lab.java_smt.SolverContextFactory;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverContext.ProverOptions;

import java.io.File;
import java.util.Arrays;

import static com.dat3m.dartagnan.analysis.Analysis.RACES;
import static com.dat3m.dartagnan.analysis.Base.*;
import static com.dat3m.dartagnan.analysis.DataRaces.checkForRaces;
import static com.dat3m.dartagnan.analysis.Refinement.runAnalysisSaturationSolver;
import static com.dat3m.dartagnan.utils.GitInfo.createGitInfo;
import static com.dat3m.dartagnan.utils.Result.FAIL;
import static org.sosy_lab.common.configuration.OptionCollector.collectOptions;

@Options
public class Dartagnan extends BaseOptions {

	public static final String ANALYSIS = "analysis";
	public static final String WITNESS = "verifyWitness";

	@Option(
		description="Analysis to be performed.",
		secure=true,
		toUppercase=true)
	private Analysis analysis = Analysis.getDefault();

	@Option(
		description="Path to read witness from.",
		secure=true)
	private File verifyWitness;

	private static final Logger logger = LogManager.getLogger(Dartagnan.class);

	public static void main(String[] args) throws Exception {

		if(Arrays.asList(args).contains("--help")) {
			collectOptions(false,false,System.out);
			return;
		}

		createGitInfo();
		String[] argKeyword = Arrays.stream(args)
		.filter(s->s.startsWith("-"))
		.toArray(String[]::new);
		Configuration config = Configuration.fromCmdLineArguments(argKeyword); // TODO: We don't parse configs yet
    	GlobalSettings.initializeFromConfig(config);
    	GlobalSettings.log();
		Dartagnan o = new Dartagnan();
		config.recursiveInject(o);

		String[] argPositional = Arrays.stream(args)
		.filter(s->!s.startsWith("-"))
		.toArray(String[]::new);
		File fileModel = new File(argPositional[0]);
		File fileProgram = new File(argPositional[1]);
		logger.info("Program path: " + fileProgram);
		logger.info("CAT file path: " + fileModel);

        Wmm mcm = new ParserCat().parse(fileModel);
		config.inject(mcm);
        Program p = new ProgramParser().parse(fileProgram);

        WitnessGraph witness = new WitnessGraph();
        if(o.verifyWitness != null) {
        	logger.info("Witness path: " + o.verifyWitness);
        	witness = new ParserWitness().parse(o.verifyWitness);
        }        

        VerificationTask task = VerificationTask.builder()
                .withConfig(config)
                .withWitness(witness)
                .build(p, mcm);

        ShutdownManager sdm = ShutdownManager.create();
    	Thread t = new Thread(() -> {
			try {
				if(o.timeout > 0) {
					// Converts timeout from secs to millisecs
					Thread.sleep(1000L * o.timeout);
					sdm.requestShutdown("Shutdown Request");
					logger.warn("Shutdown Request");
				}
			} catch (InterruptedException e) {
				// Verification ended, nothing to be done.
			}});

    	try {
            t.start();
            Configuration solverConfig = Configuration.builder()
                    .setOption("solver.z3.usePhantomReferences", "true")
                    .build();
            try (SolverContext ctx = SolverContextFactory.createSolverContext(
                    solverConfig,
                    BasicLogManager.create(solverConfig),
                    sdm.getNotifier(),
                    o.solver);
                 ProverEnvironment prover = ctx.newProverEnvironment(ProverOptions.GENERATE_MODELS))
            {
                Result result;
                switch (o.analysis) {
                    case RACES:
                        result = checkForRaces(ctx, task);
                        break;
                    case REACHABILITY:
                        switch (o.method) {
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
                            case REFINEMENT:
                                result = runAnalysisSaturationSolver(ctx, prover,
                                        RefinementTask.fromVerificationTaskWithDefaultBaselineWMM(task));
                                break;
                            default:
                                throw new RuntimeException("Unrecognized method mode: " + o.method);
                        }
                        break;
                    default:
                        throw new RuntimeException("Unrecognized analysis: " + o.analysis);
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

                if (o.analysis != RACES) {
					try {
						WitnessBuilder w = new WitnessBuilder(p, ctx, prover, result);
						config.inject(w);
						w.write();
					} catch(InvalidConfigurationException ignore) {
					}
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
