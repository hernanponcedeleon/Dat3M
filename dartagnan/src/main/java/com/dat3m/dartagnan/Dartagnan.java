package com.dat3m.dartagnan;

import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static com.dat3m.dartagnan.utils.Result.UNKNOWN;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.cli.HelpFormatter;

import com.dat3m.dartagnan.asserts.AbstractAssert;
import com.dat3m.dartagnan.asserts.AssertTrue;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Graph;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.utils.options.DartagnanOptions;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Solver;
import com.microsoft.z3.Status;
import com.microsoft.z3.enumerations.Z3_ast_print_mode;

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
        Wmm overApprox = options.getOverApproxPath() != null ? new ParserCat().parse(new File(options.getOverApproxPath())) : null;
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

        Result result = overApprox != null ? runCegar(s, ctx, p, mcm, overApprox, target, settings) : testProgram(s, ctx, p, mcm, target, settings);

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

        if(settings.getDrawGraph() && canDrawGraph(p.getAss(), result.equals(FAIL))) {
        	ctx.setPrintMode(Z3_ast_print_mode.Z3_PRINT_SMTLIB_FULL);
            drawGraph(new Graph(s.getModel(), ctx, p, settings.getGraphRelations()), options.getGraphFilePath());
            System.out.println("Execution graph is written to " + options.getGraphFilePath());
        }

        ctx.close();
    }

    public static Result testProgram(Solver solver, Context ctx, Program program, Wmm wmm, Arch target, Settings settings) {
    	program.unroll(settings.getBound(), 0);
        program.compile(target, 0);
        // AssertionInline depends on compiled events (copies)
        // Thus we need to set the assertion after compilation
        if(program.getAss() == null){
        	AbstractAssert ass = program.createAssertion();
			program.setAss(ass);
        	// Due to optimizations, the program might be trivially true
        	// Not returning here might loop forever for cyclic programs
        	if(ass instanceof AssertTrue) {
        		return PASS;
        	}
        }

        solver.add(program.encodeCF(ctx));
        solver.add(program.encodeFinalRegisterValues(ctx));
        solver.add(wmm.encode(program, ctx, settings));
        solver.add(wmm.consistent(program, ctx));
        
        solver.push();
        solver.add(program.getAss().encode(ctx));
        if(program.getAssFilter() != null){
            solver.add(program.getAssFilter().encode(ctx));
        }

        BoolExpr encodeNoBoundEventExec = program.encodeNoBoundEventExec(ctx);

        Result res;
        if(solver.check() == Status.SATISFIABLE) {
        	solver.add(encodeNoBoundEventExec);
        	res = solver.check() == Status.SATISFIABLE ? FAIL : UNKNOWN;
        } else {
        	solver.pop();
			solver.add(ctx.mkNot(encodeNoBoundEventExec));
        	res = solver.check() == Status.SATISFIABLE ? UNKNOWN : PASS;
        }
		if(program.getAss().getInvert()) {
			res = res.invert();
		}
		return res;
    }
    
    public static Result runCegar(Solver solver, Context ctx, Program program, Wmm exact, Wmm overApprox, Arch target, Settings settings) {
    	Map<BoolExpr, BoolExpr> track = new HashMap<>();
    	program.unroll(settings.getBound(), 0);
        program.compile(target, 0);
        // AssertionInline depends on compiled events (copies)
        // Thus we need to set the assertion after compilation
        if(program.getAss() == null){
        	AbstractAssert ass = program.createAssertion();
			program.setAss(ass);
        	// Due to optimizations, the program might be trivially true
        	// Not returning here might loop forever for cyclic programs
        	if(ass instanceof AssertTrue) {
        		return PASS;
        	}
        }

        solver.add(program.encodeCF(ctx));
        solver.add(program.encodeFinalRegisterValues(ctx));
        solver.add(overApprox.encode(program, ctx, settings));
       	solver.add(overApprox.consistent(program, ctx));
       	
       	// Assertion + filter
       	BoolExpr ass = program.getAss().encode(ctx);
        if(program.getAssFilter() != null){
            ass = ctx.mkAnd(ass, program.getAssFilter().encode(ctx));
        }
        BoolExpr execution = null;
        
        // Termination guaranteed because we add a new constraint in each 
		// iteration and thus the formula will eventually become UNSAT
		Result res;
		while(true) {
	        solver.push();
	        // This needs to be pop for the else branch below
	        // If not the formula will always remain UNSAT
	       	solver.add(ass);
			if(solver.check() == Status.SATISFIABLE) {
				execution = program.getRf(ctx, solver.getModel());
				solver.push();
				solver.add(program.encodeNoBoundEventExec(ctx));
				res = solver.check() == Status.SATISFIABLE ? FAIL : UNKNOWN;
				solver.pop();
			} else {
				solver.pop();
				solver.push();
				solver.add(ctx.mkNot(program.encodeNoBoundEventExec(ctx)));
				res = solver.check() == Status.SATISFIABLE ? UNKNOWN : PASS;
			}
			// We get rid of the formulas added in the above branches
			solver.pop();
			
			if(program.getAss().getInvert()) {
				res = res.invert();
			}
			
			// If any of the formulas was UNSAT, we return
			if(res.equals(PASS) || res.equals(UNKNOWN)) {
				return res;
			}

			// Check if the execution consistent in the exact model
			solver.push();
			solver.add(execution);
    		solver.add(exact.encodeBase(program, ctx, settings));        	
    		for(Axiom ax : exact.getAxioms()) {
        		BoolExpr enc = ax.encodeRelAndConsistency(ctx);
        		BoolExpr axVar = ctx.mkBoolConst(ax.toString());
        		solver.assertAndTrack(enc, axVar);
        		track.put(axVar, enc);
        	}
			
			if(solver.check() == Status.SATISFIABLE) {
				return FAIL;
			}

			BoolExpr[] unsatCore = solver.getUnsatCore();
			solver.pop();
			for(BoolExpr axVar : unsatCore) {
				solver.add(track.get(axVar));					
			}
			solver.add(ctx.mkNot(execution));
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
