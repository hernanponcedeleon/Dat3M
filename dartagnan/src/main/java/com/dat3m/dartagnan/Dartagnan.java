package com.dat3m.dartagnan;

import static com.dat3m.dartagnan.GlobalSettings.LogGlobalSettings;
import static com.dat3m.dartagnan.analysis.Base.runAnalysis;
import static com.dat3m.dartagnan.analysis.Base.runAnalysisIncrementalSolver;
import static com.dat3m.dartagnan.analysis.Base.runAnalysisAssumeSolver;
import static com.dat3m.dartagnan.analysis.DataRaces.checkForRaces;
import static com.dat3m.dartagnan.utils.GitInfo.CreateGitInfo;
import static com.dat3m.dartagnan.utils.Result.FAIL;

import java.io.File;

import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.witness.WitnessBuilder;
import com.dat3m.dartagnan.witness.WitnessGraph;

import org.apache.commons.cli.HelpFormatter;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.ShutdownManager;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.log.BasicLogManager;
import org.sosy_lab.java_smt.SolverContextFactory;
import org.sosy_lab.java_smt.api.SolverContext;

import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.parsers.witness.ParserWitness;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.utils.options.DartagnanOptions;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;

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

        WitnessGraph witness = new WitnessGraph();
        
        logger.info("Program path: " + options.getProgramFilePath());
        logger.info("CAT file path: " + options.getTargetModelFilePath());
        if(options.getWitnessPath() != null) {
        	witness = new ParserWitness().parse(new File(options.getWitnessPath()));
        	logger.info("Witness path: " + options.getWitnessPath());
    		if(witness.hasAttributed("producer")) {
    			logger.info("Witness graph produced by " + witness.getAttributed("producer"));
    		}
    		logger.info("Witness graph stats: #nodes " + witness.getNodes().size());
    		logger.info("Witness graph stats: #edges " + witness.getEdges().size());
        }        
        logger.info("Bound: " + options.getSettings().getBound());
        logger.info("Alias Analysis: " + options.getSettings().getAlias());
        
        Wmm mcm = new ParserCat().parse(new File(options.getTargetModelFilePath()));
        Program p = new ProgramParser().parse(new File(options.getProgramFilePath()));        	
		
        Arch target = p.getArch();
        if(target == null){
            target = options.getTarget();
        }
        if(target == null) {
            System.out.println("Compilation target cannot be inferred");
            System.exit(0);
            return;
        }
        logger.info("Target: " + target);
        
        Settings settings = options.getSettings();
        VerificationTask task = new VerificationTask(p, mcm, witness, target, settings);

        try {
            Configuration config = Configuration.builder()
            		.setOption("solver.z3.usePhantomReferences", "true")
            		.build();
            SolverContext ctx = SolverContextFactory.createSolverContext(
                    config, 
                    BasicLogManager.create(config), 
                    ShutdownManager.create().getNotifier(), 
                    options.getSMTSolver()); 
            logger.info("SMT solver: " + ctx.getVersion());

            Result result = selectAndRunAnalysis(options, task, ctx);
            
            if(result.equals(Result.ERROR)) {
            	System.exit(1);
            }
            
            if(options.getProgramFilePath().endsWith(".litmus")) {
                System.out.println("Settings: " + options.getSettings());
                if(p.getAssFilter() != null){
                    System.out.println("Filter " + (p.getAssFilter()));
                }
                System.out.println("Condition " + p.getAss().toStringWithType());
                System.out.println(result == FAIL ? "Ok" : "No");
            } else {
            	System.out.println(result);
            }

            if(options.createWitness() != null) {
            	new WitnessBuilder(p, ctx, result, options).write();
            }
            
            ctx.close();
        } catch (Exception e) {
        	System.out.println(e.getMessage());
        }
    }

	private static Result selectAndRunAnalysis(DartagnanOptions options, VerificationTask task, SolverContext ctx) {
		switch(options.getAnalysis()) {
			case RACES:
				return checkForRaces(ctx, task);	
			case REACHABILITY:
				switch(options.getSolver()) {
					case TWO:
						return runAnalysis(ctx, task);
					case INCREMENTAL:
						return runAnalysisIncrementalSolver(ctx, task);
					case ASSUME:
						return runAnalysisAssumeSolver(ctx, task);
					default:
						throw new RuntimeException("Unrecognized solver mode: " + options.getSolver());
				}
			default:
				throw new RuntimeException("Unrecognized analysis: " + options.getAnalysis());
		}
	}
}
