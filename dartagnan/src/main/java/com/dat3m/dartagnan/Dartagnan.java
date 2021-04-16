package com.dat3m.dartagnan;

import static com.dat3m.dartagnan.analysis.Base.runAnalysis;
import static com.dat3m.dartagnan.analysis.Base.runAnalysisIncrementalSolver;
import static com.dat3m.dartagnan.analysis.Base.runAnalysisAssumeSolver;
import static com.dat3m.dartagnan.analysis.DataRaces.checkForRaces;
import static com.dat3m.dartagnan.utils.GitInfo.CreateGitInfo;
import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.microsoft.z3.enumerations.Z3_ast_print_mode.Z3_PRINT_SMTLIB_FULL;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.witness.WitnessBuilder;
import com.dat3m.dartagnan.witness.WitnessGraph;

import org.apache.commons.cli.HelpFormatter;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.dat3m.dartagnan.asserts.AbstractAssert;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.parsers.witness.ParserWitness;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Graph;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.utils.options.DartagnanOptions;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.microsoft.z3.Context;
import com.microsoft.z3.Solver;

public class Dartagnan {

	private static final Logger logger = LogManager.getLogger(Dartagnan.class);  
	
    public static void main(String[] args) throws IOException {
    	
    	CreateGitInfo();
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
        
        Settings settings = options.getSettings();
        Context ctx = new Context();
        Solver s = ctx.mkSolver();
        Result result = selectAndRunAnalysis(options, mcm, p, witness, target, settings, ctx, s);
 
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
        	new WitnessBuilder(p, ctx, s, result, options).write();
        }
        
        if(settings.getDrawGraph() && canDrawGraph(p.getAss(), result.equals(FAIL))) {
        	ctx.setPrintMode(Z3_PRINT_SMTLIB_FULL);
            drawGraph(new Graph(s.getModel(), ctx, p, settings.getGraphRelations()), options.getGraphFilePath());
            System.out.println("Execution graph is written to " + options.getGraphFilePath());
        }

        ctx.close();
    }

	private static Result selectAndRunAnalysis(DartagnanOptions options, Wmm mcm, Program p, WitnessGraph witness, Arch target, Settings settings, Context ctx, Solver s) {
		switch(options.getAnalysis()) {
			case RACES:
				return checkForRaces(s, ctx, p, mcm, target, settings);	
			case REACHABILITY:
                VerificationTask task = new VerificationTask(p, mcm, witness, target, settings);
				switch(options.solver()) {
					case TWO:
						return runAnalysis(s, ctx, task);
					case INCREMENTAL:
						return runAnalysisIncrementalSolver(s, ctx, task);
					case ASSUME:
						return runAnalysisAssumeSolver(s, ctx, task);
					default:
						throw new RuntimeException("Unrecognized solver mode: " + options.solver());
				}
			default:
				throw new RuntimeException("Unrecognized analysis: " + options.getAnalysis());
		}
	}

    public static boolean canDrawGraph(AbstractAssert ass, boolean result){
        String type = ass.getType();
        if(type == null){
            return result;
        }

        if(result){
            return type.equals(AbstractAssert.ASSERT_TYPE_EXISTS) || type.equals(AbstractAssert.ASSERT_TYPE_FINAL);
        }
        return type.equals(AbstractAssert.ASSERT_TYPE_NOT_EXISTS) || type.equals(AbstractAssert.ASSERT_TYPE_FORALL);
    }

    public static void drawGraph(Graph graph, String path) throws IOException {
        File newTextFile = new File(path);
        FileWriter fw = new FileWriter(newTextFile);
        fw.write(graph.toString());
        fw.close();
    }
}
