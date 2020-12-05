package com.dat3m.dartagnan;

import static com.dat3m.dartagnan.analysis.Base.runAnalysis;
import static com.dat3m.dartagnan.analysis.Base.runAnalysisIncrementalSolver;
import static com.dat3m.dartagnan.analysis.DataRaces.checkForRaces;
import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.microsoft.z3.enumerations.Z3_ast_print_mode.Z3_PRINT_SMTLIB_FULL;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import org.apache.commons.cli.HelpFormatter;

import com.dat3m.dartagnan.analysis.Termination;
import com.dat3m.dartagnan.asserts.AbstractAssert;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Graph;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.utils.Witness;
import com.dat3m.dartagnan.utils.options.DartagnanOptions;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.microsoft.z3.Context;
import com.microsoft.z3.Solver;

public class Dartagnan {

    public static void main(String[] args) throws IOException {

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
        if(target == null) {
            System.out.println("Compilation target cannot be inferred");
            System.exit(0);
            return;
        }
        
        Settings settings = options.getSettings();
        Context ctx = new Context();
        Solver s = ctx.mkSolver();

        Result result = selectAndRunAnalysis(options, mcm, p, target, settings, ctx, s);
 
        if(options.getProgramFilePath().endsWith(".litmus")) {
            System.out.println("Settings: " + options.getSettings());
            if(p.getAssFilter() != null){
                System.out.println("Filter " + (p.getAssFilter()));
            }
            System.out.println("Condition " + p.getAss().toStringWithType());
            System.out.println(result == Result.FAIL ? "Ok" : "No");        	
        } else {
        	System.out.println(result);
        }

        if(options.createWitness() != null) {
        	new Witness(p, options.createWitness()).write(ctx, s, result);
        }
        
        if(settings.getDrawGraph() && canDrawGraph(p.getAss(), result.equals(FAIL))) {
        	ctx.setPrintMode(Z3_PRINT_SMTLIB_FULL);
            drawGraph(new Graph(s.getModel(), ctx, p, settings.getGraphRelations()), options.getGraphFilePath());
            System.out.println("Execution graph is written to " + options.getGraphFilePath());
        }

        ctx.close();
    }

	private static Result selectAndRunAnalysis(DartagnanOptions options, Wmm mcm, Program p, Arch target, Settings settings, Context ctx, Solver s) {
		switch(options.getAnalysis()) {
			case RACES:
				return checkForRaces(s, ctx, p, mcm, target, settings);	
			case TERMINATION:
				return Termination.runAnalysis(s, ctx, p, mcm, target, settings);
			case REACHABILITY:
				return options.useISolver() ? 
						runAnalysisIncrementalSolver(s, ctx, p, mcm, target, settings) : 
						runAnalysis(s, ctx, p, mcm, target, settings); 
			default:
				throw new RuntimeException("Unrecognized analysis");
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
