package com.dat3m.dartagnan;

import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.parsers.witness.ParserWitness;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Program.SourceLanguage;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.options.BaseOptions;
import com.dat3m.dartagnan.verification.RefinementTask;
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
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverContext.ProverOptions;

import java.io.File;
import java.util.Arrays;
import java.util.EnumSet;
import java.util.Set;

import static com.dat3m.dartagnan.configuration.OptionInfo.collectOptions;
import static com.dat3m.dartagnan.configuration.OptionNames.PHANTOM_REFERENCES;
import static com.dat3m.dartagnan.configuration.Property.*;
import static com.dat3m.dartagnan.utils.GitInfo.CreateGitInfo;
import static com.dat3m.dartagnan.utils.Result.*;
import static com.dat3m.dartagnan.utils.visualization.ExecutionGraphVisualizer.generateGraphvizFile;
import static java.lang.Boolean.TRUE;
import static java.lang.String.valueOf;

@Options
public class Dartagnan extends BaseOptions {

	private static final Logger logger = LogManager.getLogger(Dartagnan.class);

	private static final Set<String> supportedFormats = 
    		ImmutableSet.copyOf(Arrays.asList(".litmus", ".bpl", ".c", ".i"));

	private Dartagnan(Configuration config) throws InvalidConfigurationException {
		config.recursiveInject(this);
	}

	public static void main(String[] args) throws Exception {
    	
        if(Arrays.asList(args).contains("--help")) {
            collectOptions();
            return;
        }

    	CreateGitInfo();

    	String[] argKeyword = Arrays.stream(args)
				.filter(s->s.startsWith("-"))
				.toArray(String[]::new);
		Configuration config = Configuration.fromCmdLineArguments(argKeyword); // TODO: We don't parse configs yet
		Dartagnan o = new Dartagnan(config);

		if(Arrays.stream(args).noneMatch(a -> supportedFormats.stream().anyMatch(a::endsWith))) {
			throw new IllegalArgumentException("Input program not given or format not recognized");
		}
		// get() is guaranteed to success
		File fileProgram = new File(Arrays.stream(args).filter(a -> supportedFormats.stream().anyMatch(a::endsWith)).findFirst().get());
		logger.info("Program path: " + fileProgram);

		if(Arrays.stream(args).noneMatch(a -> a.endsWith(".cat"))) {
			throw new IllegalArgumentException("CAT model not given or format not recognized");
		}
		// get() is guaranteed to success		
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
                Result result = UNKNOWN;
                if(properties.contains(RACES)) {
                	if(properties.size() > 1) {
                    	System.out.println("Data race detection cannot be combined with other properties");
                    	System.exit(1);
                	}
                	result = DataRaceSolver.run(ctx, prover, task);
                } else {
                	// Property is either LIVENESS and/or REACHABILITY
                	switch (o.getMethod()) {
                		case TWO:
                			try (ProverEnvironment prover2 = ctx.newProverEnvironment(ProverOptions.GENERATE_MODELS)) {
                				result = TwoSolvers.run(ctx, prover, prover2, task);
                			}
                			break;
                		case INCREMENTAL:
                			result = IncrementalSolver.run(ctx, prover, task);
                			break;
                		case ASSUME:
                			result = AssumeSolver.run(ctx, prover, task);
                			break;
                		case CAAT:
                			result = RefinementSolver.run(ctx, prover,
                					RefinementTask.fromVerificationTaskWithDefaultBaselineWMM(task));
                			break;
                	}
                }

                // Verification ended, we can interrupt the timeout Thread
                t.interrupt();

            	if(result.equals(FAIL) && o.generateGraphviz()) {
                	ExecutionModel m = new ExecutionModel(task);
                	m.initialize(prover.getModel(), ctx);
    				String name = task.getProgram().getName().substring(0, task.getProgram().getName().lastIndexOf('.'));
    				generateGraphvizFile(m, 1, (x, y) -> true, System.getenv("DAT3M_OUTPUT") + "/", name);        		
            	}

            	boolean safetyViolationFound = false;
            	if((result == FAIL && !p.getAss().getInvert()) || 
            			(result == PASS && p.getAss().getInvert())) {
            		if(TRUE.equals(prover.getModel().evaluate(REACHABILITY.getSMTVariable(ctx)))) {
            			safetyViolationFound = true;
            			System.out.println("Safety violation found");
            		}
            		if(TRUE.equals(prover.getModel().evaluate(LIVENESS.getSMTVariable(ctx)))) {
            			System.out.println("Liveness violation found");
            		}
            		for(Axiom ax : task.getMemoryModel().getAxioms()) {
                		if(ax.isFlagged() && TRUE.equals(prover.getModel().evaluate(CAT.getSMTVariable(ax, ctx)))) {
                			System.out.println("Flag " + (ax.getName() != null ? ax.getName() : ax.getRelation().getName()));
                		}                			
            		}
                }
                if (p.getFormat().equals(SourceLanguage.LITMUS)) {
                    if (p.getAssFilter() != null) {
                        System.out.println("Filter " + (p.getAssFilter()));
                    }
                    System.out.println("Condition " + p.getAss().toStringWithType());
                    System.out.println(safetyViolationFound ? "Ok" : "No");
                } else {
                    System.out.println(result);                	
                }

				try {
					WitnessBuilder w = new WitnessBuilder(task, ctx, prover, result);
	                // We only write witnesses for REACHABILITY (if the path to the original C file was given) 
					// and if we are not doing witness validation
	                if (properties.contains(REACHABILITY) && w.canBeBuilt() && !o.runValidator()) {
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
