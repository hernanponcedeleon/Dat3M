package com.dat3m.dartagnan.analysis;

import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static com.dat3m.dartagnan.utils.Result.UNKNOWN;
import static com.microsoft.z3.Status.SATISFIABLE;

import com.dat3m.dartagnan.asserts.AssertTrue;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.graphRefinement.analysis.BranchEquivalence;
import com.dat3m.dartagnan.wmm.graphRefinement.GraphRefinement;
import com.dat3m.dartagnan.wmm.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.wmm.graphRefinement.coreReason.RfLiteral;
import com.dat3m.dartagnan.wmm.graphRefinement.logic.Conjunction;
import com.dat3m.dartagnan.wmm.graphRefinement.logic.DNF;
import com.dat3m.dartagnan.wmm.graphRefinement.logic.SortedClauseSet;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.microsoft.z3.*;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

public class Base {

    public static Result runAnalysis(Solver s1, Context ctx, Program program, Wmm wmm, Arch target, Settings settings) {
    	program.unroll(settings.getBound(), 0);
        program.compile(target, 0);
        // AssertionInline depends on compiled events (copies)
        // Thus we need to set the assertion after compilation
        program.updateAssertion();
       	if(program.getAss() instanceof AssertTrue) {
       		return PASS;
       	}
       	
        // Using two solvers is much faster than using
        // an incremental solver or check-sat-assuming
        Solver s2 = ctx.mkSolver();
        
        BoolExpr encodeCF = program.encodeCF(ctx);
		s1.add(encodeCF);
        s2.add(encodeCF);
        
        BoolExpr encodeFinalRegisterValues = program.encodeFinalRegisterValues(ctx);
		s1.add(encodeFinalRegisterValues);
        s2.add(encodeFinalRegisterValues);
        
        BoolExpr encodeWmm = wmm.encode(program, ctx, settings);
		s1.add(encodeWmm);
        s2.add(encodeWmm);
        
        BoolExpr encodeConsistency = wmm.consistent(program, ctx);
		s1.add(encodeConsistency);
        s2.add(encodeConsistency);
       	
        s1.add(program.getAss().encode(ctx));
        if(program.getAssFilter() != null){
            BoolExpr encodeFilter = program.getAssFilter().encode(ctx);
			s1.add(encodeFilter);
            s2.add(encodeFilter);
        }

        BoolExpr encodeNoBoundEventExec = program.encodeNoBoundEventExec(ctx);

        Result res;
		if(s1.check() == SATISFIABLE) {
			s1.add(encodeNoBoundEventExec);
			res = s1.check() == SATISFIABLE ? FAIL : UNKNOWN;	
		} else {
			s2.add(ctx.mkNot(encodeNoBoundEventExec));
			res = s2.check() == SATISFIABLE ? UNKNOWN : PASS;	
		}
        
		if(program.getAss().getInvert()) {
			res = res.invert();
		}
		return res;
    }
	
    public static Result runAnalysisIncrementalSolver(Solver solver, Context ctx, Program program, Wmm wmm, Arch target, Settings settings) {
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

		// Test code
        res = program.getAss().getInvert() ? res.invert() : res;
        return res; //program.getAss().getInvert() ? res.invert() : res;
    }


    public static Result runAnalysisGraphRefinement(Solver solver, Context ctx, Program program, Wmm wmm, Arch target, Settings settings) {
        program.unroll(settings.getBound(), 0);
        program.compile(target, 0);
        // AssertionInline depends on compiled events (copies)
        // Thus we need to update the assertion after compilation
        program.updateAssertion();
        if(program.getAss() instanceof AssertTrue) {
            return PASS;
        }

        BoolExpr cfEncoding = program.encodeCF(ctx);
        BoolExpr finalRegValueEncoding = program.encodeFinalRegisterValues(ctx);
        BoolExpr wmmCoreEncoding = wmm.encodeCore(program, ctx, settings);
        //BoolExpr wmmConsistency = wmm.consistent(program, ctx);
        BoolExpr assertionEncoding = program.getAss().encode(ctx);
        if (program.getAssFilter() != null) {
            assertionEncoding = ctx.mkAnd(program.getAssFilter().encode(ctx));
        }

        solver.add(cfEncoding);
        solver.add(finalRegValueEncoding);
        solver.add(wmmCoreEncoding);
        //solver.add(wmmConsistency);
        solver.push();
        solver.add(assertionEncoding);

        Result res = UNKNOWN;

        GraphRefinement graph = new GraphRefinement(program, wmm);
        DNF<CoreLiteral> violations;
        List<Conjunction<CoreLiteral>> excludedRfs = new ArrayList<>();
        List<DNF<CoreLiteral>> foundViolations = new ArrayList<>();
        int vioCount = 0;
        do {
            violations = DNF.FALSE;
            Status status = solver.check();
            if (status == SATISFIABLE) {
                vioCount++;
                System.out.println("Violation count: " + vioCount);
                graph.populateFromModel(solver.getModel(), ctx);
                violations = graph.search();
                foundViolations.add(violations);
                refine(solver, ctx, violations);
                // Some statistics
                for (Conjunction<CoreLiteral> cube : violations.getCubes()) {
                    Conjunction<CoreLiteral> excludedRf = cube.removeIf(x -> !(x instanceof RfLiteral));
                    excludedRfs.add(excludedRf);
                    printStats(excludedRf);
                }
            }
        } while (!violations.isFalse());

        System.out.println("Summary: ");
        excludedRfs.sort(Comparator.comparingInt(Conjunction::getSize));
        for (Conjunction<CoreLiteral> cube : excludedRfs) {
            printStats(cube);
        }

        if(solver.check() == SATISFIABLE) {
            solver.add(program.encodeNoBoundEventExec(ctx));
            res = solver.check() == SATISFIABLE ? FAIL : UNKNOWN;
        } else {
            solver.pop();
            solver.add(ctx.mkNot(program.encodeNoBoundEventExec(ctx)));
            res = solver.check() == SATISFIABLE ? UNKNOWN : PASS;
        }

        res = program.getAss().getInvert() ? res.invert() : res;
        return res;
    }

    private static void refine(Solver solver, Context ctx, DNF<CoreLiteral> coreViolations) {
        BoolExpr refinement = ctx.mkTrue();
        for (Conjunction<CoreLiteral> violation : coreViolations.getCubes()) {
            BoolExpr clause = ctx.mkFalse();
            for (CoreLiteral literal : violation.getLiterals()) {
                clause = ctx.mkOr(clause, ctx.mkNot(literal.getZ3BoolExpr(ctx)));
            }
            refinement = ctx.mkAnd(refinement, clause);
        }
        solver.add(refinement);
    }


    private static void printStats(Conjunction<CoreLiteral> cube) {
        System.out.print(cube);
        if (cube.getLiterals().stream().anyMatch(x -> ((RfLiteral)x).getEdge().isBackwardEdge())) {
            System.out.print(": future read");
        }
        System.out.println();
    }
}
