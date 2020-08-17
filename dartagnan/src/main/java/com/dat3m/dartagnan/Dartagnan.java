package com.dat3m.dartagnan;

import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static com.dat3m.dartagnan.utils.Result.UNKNOWN;
import static com.microsoft.z3.Status.SATISFIABLE;
import static com.microsoft.z3.enumerations.Z3_ast_print_mode.Z3_PRINT_SMTLIB_FULL;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.stream.Collectors;

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
        	ctx.setPrintMode(Z3_PRINT_SMTLIB_FULL);
            drawGraph(new Graph(s.getModel(), ctx, p, settings.getGraphRelations()), options.getGraphFilePath());
            System.out.println("Execution graph is written to " + options.getGraphFilePath());
        }

        ctx.close();
    }

    public static Result testProgram(Solver solver, Context ctx, Program program, Wmm wmm, Arch target, Settings settings) {
    	program.unroll(settings.getBound(), 0);
        program.compile(target, 0);
        // AssertionInline depends on compiled events (copies)
        // Thus we need to update the assertion after compilation
        program.updateAssertion();
       	if(program.getAss() instanceof AssertTrue) {
       		return PASS;
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

        Result res = UNKNOWN;
		if(solver.check() == SATISFIABLE) {
        	solver.add(program.encodeNoBoundEventExec(ctx));
			res = solver.check() == SATISFIABLE ? FAIL : UNKNOWN;
        } else {
        	solver.pop();
			solver.add(ctx.mkNot(program.encodeNoBoundEventExec(ctx)));
        	res = solver.check() == SATISFIABLE ? UNKNOWN : PASS;
        }

        return program.getAss().getInvert() ? res.invert() : res;
    }
    
    public static Result runCegar(Solver solver, Context ctx, Program program, Wmm exact, Wmm overApprox, Arch target, Settings settings) {
    	Map<BoolExpr, BoolExpr> track = new HashMap<>();
    	program.unroll(settings.getBound(), 0);
        program.compile(target, 0);
        // AssertionInline depends on compiled events (copies)
        // Thus we need to update the assertion after compilation
        program.updateAssertion();
       	if(program.getAss() instanceof AssertTrue) {
       		return PASS;
       	}

        solver.add(program.encodeCF(ctx));
        solver.add(program.encodeFinalRegisterValues(ctx));
        // Encode over-approximation memory model
        solver.add(overApprox.encode(program, ctx, settings));
       	solver.add(overApprox.consistent(program, ctx));
       	
       	// Assertion + filter
       	BoolExpr ass = program.getAss().encode(ctx);
        if(program.getAssFilter() != null){
            ass = ctx.mkAnd(ass, program.getAssFilter().encode(ctx));
        }
        BoolExpr execution = null;

        Result res = UNKNOWN;
        // Termination guaranteed because we add a new constraint in each 
		// iteration and thus the formula will eventually become UNSAT
		while(true) {
	        solver.push();
	        // This needs to be pop for the else branch below
	        // If not the formula will always remain UNSAT
	       	solver.add(ass);
			if(solver.check() == SATISFIABLE) {
				execution = program.getRf(ctx, solver.getModel());
				solver.push();
				solver.add(program.encodeNoBoundEventExec(ctx));
				res = solver.check() == SATISFIABLE ? FAIL : UNKNOWN;
				solver.pop();
			} else {
				solver.pop();
				solver.push();
				solver.add(ctx.mkNot(program.encodeNoBoundEventExec(ctx)));
				res = solver.check() == SATISFIABLE ? UNKNOWN : PASS;
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
	        // Encode precise memory model
			// In principle having this inside the loop is not a problem because
			// the expensive things to computed (may/active sets) are cached.
			solver.add(exact.encodeBase(program, ctx, settings));
			for(Axiom ax : exact.getAxioms()) {
				// Avoid adding what was already added by the over-approximation
				if(overApprox.getAxioms().stream().map(a -> a.toString()).collect(Collectors.toList()).contains(ax.toString())) {
					continue;
				}
				BoolExpr axVar = ctx.mkBoolConst(ax.toString());
				if(!track.containsKey(axVar)) {
					track.put(axVar, ax.encodeRelAndConsistency(ctx));						
				}
				solver.assertAndTrack(track.get(axVar), axVar);
	    	}
			
			if(solver.check() == SATISFIABLE) {
				return FAIL;
			}

			// Add the axiom that forbids the spurious execution
			BoolExpr[] unsatCore = solver.getUnsatCore();
			solver.pop();
			for(BoolExpr axVar : unsatCore) {
				solver.add(track.get(axVar));					
			}
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
