package com.dat3m.dartagnan.analysis;

import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static com.dat3m.dartagnan.utils.Result.UNKNOWN;
import static com.microsoft.z3.Status.SATISFIABLE;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.dat3m.dartagnan.asserts.AssertTrue;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.witness.WitnessGraph;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Solver;

public class Base {
	
    private static final Logger logger = LogManager.getLogger(Base.class);
	
    public static Result runAnalysis(Solver s1, Context ctx, Program program, Wmm wmm, Arch target, Settings settings) {
    	return runAnalysis(s1, ctx, program, wmm, new WitnessGraph(), target, settings);
    }
    
    public static Result runAnalysis(Solver s1, Context ctx, Program program, Wmm wmm, WitnessGraph graph, Arch target, Settings settings) {
    	program.simplify();
    	program.unroll(settings.getBound(), 0);
    	program.compile(target, 0);
        // AssertionInline depends on compiled events (copies)
        // Thus we need to set the assertion after compilation
        program.updateAssertion();
       	if(program.getAss() instanceof AssertTrue) {
       		logger.info("Verification finished: assertion trivialy holds");
       		return PASS;
       	}
       	
        // Using two solvers can be faster than using
        // an incremental solver or check-sat-assuming
        Solver s2 = ctx.mkSolver();
        
        logger.info("Starting encoding");
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
        // For validation this contains information.
        // For verification graph.encode() just returns ctx.mkTrue()
        s1.add(graph.encode(program, ctx));

        BoolExpr encodeNoBoundEventExec = program.encodeNoBoundEventExec(ctx);

        Result res = UNKNOWN;
        logger.info("Starting first solver.check()");
		if(s1.check() == SATISFIABLE) {
			logger.info("SAT");
			s1.add(encodeNoBoundEventExec);
			logger.info("Starting second solver.check()");
			res = s1.check() == SATISFIABLE ? FAIL : UNKNOWN;	
		} else {
			logger.info("UNSAT");
			s2.add(ctx.mkNot(encodeNoBoundEventExec));
			logger.info("Starting second solver.check()");
			res = s2.check() == SATISFIABLE ? UNKNOWN : PASS;	
		}
		res = program.getAss().getInvert() ? res.invert() : res;  
		logger.info("Verification finished with result " + res);
		return res;
    }
	
    public static Result runAnalysisIncrementalSolver(Solver solver, Context ctx, Program program, Wmm wmm, Arch target, Settings settings) {
    	return runAnalysisIncrementalSolver(solver, ctx, program, wmm, new WitnessGraph(), target, settings);
    }
    
    public static Result runAnalysisIncrementalSolver(Solver solver, Context ctx, Program program, Wmm wmm, WitnessGraph graph, Arch target, Settings settings) {
    	program.simplify();
    	program.unroll(settings.getBound(), 0);
        program.compile(target, 0);
        // AssertionInline depends on compiled events (copies)
        // Thus we need to update the assertion after compilation
        program.updateAssertion();
       	if(program.getAss() instanceof AssertTrue) {
       		logger.info("Verification finished: assertion trivialy holds");
       		return PASS;
       	}

       	logger.info("Starting encoding");
        solver.add(program.encodeCF(ctx));
        solver.add(program.encodeFinalRegisterValues(ctx));
        solver.add(wmm.encode(program, ctx, settings));
        solver.add(wmm.consistent(program, ctx));
        logger.info("Starting push()");
        solver.push();
        solver.add(program.getAss().encode(ctx));
        if(program.getAssFilter() != null){
            solver.add(program.getAssFilter().encode(ctx));
        }
        // For validation this contains information.
        // For verification graph.encode() just returns ctx.mkTrue()
        solver.add(graph.encode(program, ctx));
        
        Result res = UNKNOWN;
        logger.info("Starting first solver.check()");
		if(solver.check() == SATISFIABLE) {
			logger.info("SAT");
        	solver.add(program.encodeNoBoundEventExec(ctx));
        	logger.info("Starting second solver.check()");
			res = solver.check() == SATISFIABLE ? FAIL : UNKNOWN;
        } else {
        	logger.info("UNSAT");
        	solver.pop();
			solver.add(ctx.mkNot(program.encodeNoBoundEventExec(ctx)));
			logger.info("Starting second solver.check()");
        	res = solver.check() == SATISFIABLE ? UNKNOWN : PASS;
        }
		res = program.getAss().getInvert() ? res.invert() : res;  
		logger.info("Verification finished with result " + res);
		return res;
    }
    
    public static Result runAnalysisAssumeSolver(Solver solver, Context ctx, Program program, Wmm wmm, Arch target, Settings settings) {
    	return runAnalysisAssumeSolver(solver, ctx, program, wmm, new WitnessGraph(), target, settings);
    }
    
    public static Result runAnalysisAssumeSolver(Solver solver, Context ctx, Program program, Wmm wmm, WitnessGraph graph, Arch target, Settings settings) {
    	program.simplify();
    	program.unroll(settings.getBound(), 0);
        program.compile(target, 0);
        // AssertionInline depends on compiled events (copies)
        // Thus we need to update the assertion after compilation
        program.updateAssertion();
       	if(program.getAss() instanceof AssertTrue) {
       		logger.info("Verification finished: assertion trivialy holds");
       		return PASS;
       	}

       	logger.info("Starting encoding");
        solver.add(program.encodeCF(ctx));
        solver.add(program.encodeFinalRegisterValues(ctx));
        solver.add(wmm.encode(program, ctx, settings));
        solver.add(wmm.consistent(program, ctx));
        if(program.getAssFilter() != null){
            solver.add(program.getAssFilter().encode(ctx));
        }
        // For validation this contains information.
        // For verification graph.encode() just returns ctx.mkTrue()
        solver.add(graph.encode(program, ctx));

        Result res = UNKNOWN;
        logger.info("Starting first solver.check()");
		if(solver.check(program.getAss().encode(ctx)) == SATISFIABLE) {
			logger.info("SAT");
        	solver.add(program.encodeNoBoundEventExec(ctx));
        	logger.info("Starting second solver.check()");
			res = solver.check() == SATISFIABLE ? FAIL : UNKNOWN;
        } else {
        	logger.info("UNSAT");
			solver.add(ctx.mkNot(program.encodeNoBoundEventExec(ctx)));
			logger.info("Starting second solver.check()");
        	res = solver.check() == SATISFIABLE ? UNKNOWN : PASS;
        }
		res = program.getAss().getInvert() ? res.invert() : res;  
		logger.info("Verification finished with result " + res);
		return res;
    }
}
