package com.dat3m.dartagnan;

import com.dat3m.dartagnan.configuration.OptionNames;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.parsers.witness.ParserWitness;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Program.SourceLanguage;
import com.dat3m.dartagnan.program.analysis.CallStackComputation;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.options.BaseOptions;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.model.ExecutionModel;
import com.dat3m.dartagnan.verification.solving.*;
import com.dat3m.dartagnan.witness.WitnessBuilder;
import com.dat3m.dartagnan.witness.WitnessGraph;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.google.common.collect.ImmutableSet;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.ShutdownManager;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.common.log.BasicLogManager;
import org.sosy_lab.java_smt.SolverContextFactory;
import org.sosy_lab.java_smt.api.Model;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverException;
import org.sosy_lab.java_smt.api.SolverContext.ProverOptions;

import java.io.File;
import java.math.BigInteger;
import java.util.*;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.GlobalSettings.LogGlobalSettings;
import static com.dat3m.dartagnan.configuration.OptionInfo.collectOptions;
import static com.dat3m.dartagnan.configuration.OptionNames.PHANTOM_REFERENCES;
import static com.dat3m.dartagnan.configuration.Property.*;
import static com.dat3m.dartagnan.utils.GitInfo.CreateGitInfo;
import static com.dat3m.dartagnan.utils.Result.*;
import static com.dat3m.dartagnan.utils.visualization.ExecutionGraphVisualizer.generateGraphvizFile;
import static java.lang.Boolean.FALSE;
import static java.lang.Boolean.TRUE;
import static java.lang.String.valueOf;

@Options
public class Dartagnan extends BaseOptions {

	private static final Logger logger = LogManager.getLogger(Dartagnan.class);

	private static final Set<String> supportedFormats = 
    		ImmutableSet.copyOf(Arrays.asList(".litmus", ".bpl", ".c", ".i", "ll"));

	private Dartagnan(Configuration config) throws InvalidConfigurationException {
		config.recursiveInject(this);
	}

	public static void main(String[] args) throws Exception {
    	
        if(Arrays.asList(args).contains("--help")) {
            collectOptions();
            return;
        }

    	CreateGitInfo();
    	LogGlobalSettings();

    	String[] argKeyword = Arrays.stream(args)
				.filter(s->s.startsWith("-"))
				.toArray(String[]::new);
		Configuration config = Configuration.fromCmdLineArguments(argKeyword);
		Dartagnan o = new Dartagnan(config);

		if(Arrays.stream(args).noneMatch(a -> supportedFormats.stream().anyMatch(a::endsWith))) {
			throw new IllegalArgumentException("Input program not given or format not recognized");
		}
		// get() is guaranteed to succeed
		File fileProgram = new File(Arrays.stream(args).filter(a -> supportedFormats.stream().anyMatch(a::endsWith)).findFirst().get());
		logger.info("Program path: " + fileProgram);

		if(Arrays.stream(args).noneMatch(a -> a.endsWith(".cat"))) {
			throw new IllegalArgumentException("CAT model not given or format not recognized");
		}
		// get() is guaranteed to succeed
		File fileModel = new File(Arrays.stream(args).filter(a -> a.endsWith(".cat")).findFirst().get());		
		logger.info("CAT file path: " + fileModel);	
        
		Wmm mcm = new ParserCat().parse(fileModel);
        Program p = new ProgramParser().parse(fileProgram);
        EnumSet<Property> properties = o.getProperty();
        
        WitnessGraph witness = new WitnessGraph();
        if(o.runValidator()) {
        	logger.info("Witness path: " + o.getWitnessPath());
        	witness = new ParserWitness().parse(new File(o.getWitnessPath()));
        }

		VerificationTask task = VerificationTask.builder()
                .withConfig(config)
                .withWitness(witness)
                .build(p, mcm, properties);

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
			long startTime = System.currentTimeMillis();
            t.start();
            Configuration solverConfig = Configuration.builder()
                    .setOption(PHANTOM_REFERENCES, valueOf(o.usePhantomReferences()))
                    .build();
            try (SolverContext ctx = SolverContextFactory.createSolverContext(
            		solverConfig,
                    BasicLogManager.create(solverConfig),
                    sdm.getNotifier(),
                    o.getSolver());
                 ProverEnvironment prover = ctx.newProverEnvironment(ProverOptions.GENERATE_MODELS))
            {
                ModelChecker modelChecker;
                if(properties.contains(DATARACEFREEDOM)) {
                	if(properties.size() > 1) {
                    	System.out.println("Data race detection cannot be combined with other properties");
                    	System.exit(1);
                	}
                	modelChecker = DataRaceSolver.run(ctx, prover, task);
                } else {
                	// Property is either PROGRAM_SPEC, LIVENESS, or CAT_SPEC
                	switch (o.getMethod()) {
                		case TWO:
                			try (ProverEnvironment prover2 = ctx.newProverEnvironment(ProverOptions.GENERATE_MODELS)) {
                				modelChecker = TwoSolvers.run(ctx, prover, prover2, task);
                			}
                			break;
                		case INCREMENTAL:
							modelChecker = IncrementalSolver.run(ctx, prover, task);
                			break;
                		case ASSUME:
							modelChecker = AssumeSolver.run(ctx, prover, task);
                			break;
                		case CAAT:
							modelChecker = RefinementSolver.run(ctx, prover, task);
                			break;
						default:
							throw new InvalidConfigurationException("unsupported method " + o.getMethod());
                	}
                }

                // Verification ended, we can interrupt the timeout Thread
                t.interrupt();

				Result result = modelChecker.getResult();
            	if(result.equals(FAIL) && o.generateGraphviz()) {
                	ExecutionModel m = ExecutionModel.withContext(modelChecker.getEncodingContext());
                	m.initialize(prover.getModel());
					CallStackComputation csc = CallStackComputation.fromConfig(config);
					csc.run(p);
    				String name = task.getProgram().getName().substring(0, task.getProgram().getName().lastIndexOf('.'));
    				generateGraphvizFile(m, 1, (x, y) -> true, System.getenv("DAT3M_OUTPUT") + "/", name, csc.getCallStackMapping());        		
            	}

				long endTime = System.currentTimeMillis();
				System.out.print(generateResultSummary(task, prover, modelChecker));
				System.out.println("Total verification time(ms): " +  (endTime - startTime));

				if (!o.runValidator()) {
					// We only generate witnesses if we are not validating one.
					generateWitnessIfAble(task, prover, modelChecker);
				}
			}
        } catch (InterruptedException e){
        	logger.warn("Timeout elapsed. The SMT solver was stopped");
        	System.out.println("TIMEOUT");
        	System.exit(0);
        } catch (Exception e) {
        	logger.error(e.getMessage(), e);
        	System.out.println("ERROR");
        	System.exit(1);
        }
    }

	private static void generateWitnessIfAble(VerificationTask task, ProverEnvironment prover, ModelChecker modelChecker) {
		// ------------------ Generate Witness, if possible ------------------
		final Program p = task.getProgram();
		final EnumSet<Property> properties = task.getProperty();
		final Result result = modelChecker.getResult();
		final boolean hasViolations = result == FAIL && p.getSpecification().isSafetySpec();
		final boolean hasPositiveWitnesses = result == PASS && !p.getSpecification().isSafetySpec();
		if ((hasViolations || hasPositiveWitnesses) && properties.contains(PROGRAM_SPEC)) {
			try {
				WitnessBuilder w = WitnessBuilder.of(modelChecker.getEncodingContext(), prover, result);
				if (w.canBeBuilt()) {
					//  We can only write witnesses if the path to the original C file was given.
					w.build().write();
				}
			} catch (InvalidConfigurationException e) {
				logger.warn(e.getMessage());
			}
		}
	}

	public static String generateResultSummary(VerificationTask task, ProverEnvironment prover, ModelChecker modelChecker) throws SolverException {
		// ----------------- Generate output of verification result -----------------
		final Program p = task.getProgram();
		final Result result = modelChecker.getResult();
		final EncodingContext encCtx = modelChecker.getEncodingContext();
		final boolean hasViolations = result == FAIL && p.getSpecification().isSafetySpec();
		final boolean hasPositiveWitnesses = result == PASS && !p.getSpecification().isSafetySpec();
		final Model model = (hasViolations || hasPositiveWitnesses) ? prover.getModel() : null;

		StringBuilder summary = new StringBuilder();

		if (p.getFormat().equals(SourceLanguage.BOOGIE)) {
			if (hasViolations) {
				printWarningIfThreadStartFailed(p, encCtx, prover);
				if(FALSE.equals(model.evaluate(PROGRAM_SPEC.getSMTVariable(encCtx)))) {
					summary.append("Program specification violation found").append("\n");
					summary.append("Spec: ").append(p.getSpecification().toStringWithType()).append("\n");
				}
				if(FALSE.equals(model.evaluate(LIVENESS.getSMTVariable(encCtx)))) {
					summary.append("Liveness violation found").append("\n");
				}
				final List<Axiom> violatedCATSpecs = task.getMemoryModel().getAxioms().stream()
						.filter(Axiom::isFlagged)
						.filter(ax -> FALSE.equals(model.evaluate(CAT_SPEC.getSMTVariable(ax, encCtx))))
						.collect(Collectors.toList());
				if (!violatedCATSpecs.isEmpty()) {
					summary.append("CAT specification violation found").append("\n");
					for (Axiom violatedAx : violatedCATSpecs) {
						summary.append("flag ")
								.append(Optional.ofNullable(violatedAx.getName()).orElse(violatedAx.getNameOrTerm()))
								.append("\n");
					}
				}
			} else if (hasPositiveWitnesses) {
				if(TRUE.equals(model.evaluate(PROGRAM_SPEC.getSMTVariable(encCtx)))) {
					// The check above is just a sanity check: the program spec has to be true
					// because it is the only property that got encoded.
					summary.append("Program specification witness found.").append("\n");
				}
			}
			summary.append(result).append("\n");
		} else {
			// Litmus-specific output format that matches with Herd7 (as good as it can)
			if (p.getFilterSpecification() != null) {
				summary.append("Filter ").append(p.getFilterSpecification().toStringWithType()).append("\n");
			}

			// NOTE: We cannot produce an output that matches herd7 when checking for both program spec and cat properties.
			// This requires two SMT-queries because a single model is unlikely to witness/falsify both properties
			// simultaneously.
			// Instead, if we check for multiple safety properties, we find the first one and
			// generate output based on its type (Program spec OR CAT property)

			if (hasPositiveWitnesses || !hasViolations) {
				// We have a positive witness or no violations, then the program must be ok.
				// NOTE: We also treat the UNKNOWN case as positive, assuming that
				// looping litmus tests are unusual.
				summary.append("Condition ").append(p.getSpecification().toStringWithType()).append("\n");
				summary.append("Ok").append("\n");
			} else {
				if (FALSE.equals(model.evaluate(PROGRAM_SPEC.getSMTVariable(encCtx)))) {
					// Program spec violated
					summary.append("Condition ").append(p.getSpecification().toStringWithType()).append("\n");
					summary.append("No").append("\n");
				} else {
					final List<Axiom> violatedCATSpecs = task.getMemoryModel().getAxioms().stream()
							.filter(Axiom::isFlagged)
							.filter(ax -> FALSE.equals(model.evaluate(CAT_SPEC.getSMTVariable(ax, encCtx))))
							.collect(Collectors.toList());
					for (Axiom violatedAx : violatedCATSpecs) {
						summary.append("flag ")
								.append(Optional.ofNullable(violatedAx.getName()).orElse(violatedAx.getNameOrTerm()))
								.append("\n");
					}
				}
			}
		}
		return summary.toString();
	}

	private static void printWarningIfThreadStartFailed(Program p, EncodingContext encoder, ProverEnvironment prover) throws SolverException {
		for(Event e : p.getCache().getEvents(FilterBasic.get(Tag.STARTLOAD))) {
			if(BigInteger.ZERO.equals(prover.getModel().evaluate(encoder.value((Load) e)))) {
				// This msg should be displayed even if the logging is off
				System.out.printf(
						"[WARNING] The call to pthread_create of thread %s failed. To force thread creation to succeed use --%s=true%n",
						e.getThread().getId(), OptionNames.THREAD_CREATE_ALWAYS_SUCCEEDS);
				break;
			}
		}
	}
}
