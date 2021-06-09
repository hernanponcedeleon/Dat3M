package com.dat3m.dartagnan.analysis;

import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static com.dat3m.dartagnan.utils.Result.TIMEOUT;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.dat3m.dartagnan.asserts.AssertTrue;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Params;
import com.microsoft.z3.Solver;

public class Base {

    private static final Logger logger = LogManager.getLogger(Base.class);

    public static Result runAnalysisIncrementalSolver(Solver solver, Context ctx, VerificationTask task) {
        task.unrollAndCompile();
       	if(task.getProgram().getAss() instanceof AssertTrue) {
            logger.info("Verification finished: assertion trivialy holds");
       		return PASS;
       	}

        task.initialiseEncoding(ctx);

        logger.info("Starting encoding");
        solver.add(task.encodeProgram(ctx));
        solver.add(task.encodeWmmRelations(ctx));
        solver.add(task.encodeWmmConsistency(ctx));
        logger.info("Starting push()");
        solver.push();
        solver.add(task.encodeAssertions(ctx));
        solver.add(task.encodeWitness(ctx));
        
		if(task.getSettings().hasSolverTimeout()) {
			Params p = ctx.mkParams();
			p.add("timeout", 1000*task.getSettings().getSolverTimeout());
			try {
				solver.setParameters(p);
			} catch(Exception ignored) { }
		}

        Result res = Result.UNKNOWN;
        logger.info("Starting first solver.check()");
        switch(solver.check()) {
        case UNKNOWN:
        	res = solver.getReasonUnknown().equals("canceled") ? TIMEOUT : Result.UNKNOWN;
        	break;
		case SATISFIABLE:
			res = FAIL;
        	break;
		case UNSATISFIABLE:
        	solver.pop();
			solver.add(ctx.mkNot(task.getProgram().encodeNoBoundEventExec(ctx)));
            logger.info("Starting second solver.check()");
			switch(solver.check()) {
            case UNKNOWN:
            	res = solver.getReasonUnknown().equals("canceled") ? TIMEOUT : Result.UNKNOWN;
            	break;
    		case SATISFIABLE:
    			res = Result.UNKNOWN;
            	break;
    		case UNSATISFIABLE:
    			res = PASS;
            	break;
			}
        	break;
        }
        res = task.getProgram().getAss().getInvert() ? res.invert() : res;
        logger.info("Verification finished with result " + res);
		return res;
    }

    public static Result runAnalysis(Solver s1, Context ctx, VerificationTask task) {
        Program program = task.getProgram();
    	task.unrollAndCompile();
       	if(task.getProgram().getAss() instanceof AssertTrue) {
            logger.info("Verification finished: assertion trivially holds");
       		return PASS;
       	}

        task.initialiseEncoding(ctx);

        // Using two solvers can be faster than using
        // an incremental solver or check-sat-assuming
        Solver s2 = ctx.mkSolver();
        
        logger.info("Starting encoding");
        BoolExpr encodeCF = task.encodeProgram(ctx);
		s1.add(encodeCF);
        s2.add(encodeCF);
        
        BoolExpr encodeWmm = task.encodeWmmRelations(ctx);
		s1.add(encodeWmm);
        s2.add(encodeWmm);
        
        BoolExpr encodeConsistency = task.encodeWmmConsistency(ctx);
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
        s1.add(task.encodeWitness(ctx));

        BoolExpr encodeNoBoundEventExec = program.encodeNoBoundEventExec(ctx);

		if(task.getSettings().hasSolverTimeout()) {
			Params p = ctx.mkParams();
			p.add("timeout", 1000*task.getSettings().getSolverTimeout());
			try {
				s1.setParameters(p);
				s2.setParameters(p);
			} catch (Exception ignored) {

			}
		}

		Result res = Result.UNKNOWN;
        logger.info("Starting first solver.check()");
        switch(s1.check()) {
        case UNKNOWN:
        	res = s1.getReasonUnknown().equals("canceled") ? TIMEOUT : Result.UNKNOWN;
        	break;
		case SATISFIABLE:
			res = FAIL;
			break;
		case UNSATISFIABLE:
			s2.add(ctx.mkNot(encodeNoBoundEventExec));
            logger.info("Starting second solver.check()");
			switch(s2.check()) {
	        case UNKNOWN:
	        	res = s2.getReasonUnknown().equals("canceled") ? TIMEOUT : Result.UNKNOWN;
	        	break;
			case SATISFIABLE:
				res = Result.UNKNOWN;
				break;
			case UNSATISFIABLE:
				res = PASS;
				break;
			}
			break;
        }
        res = task.getProgram().getAss().getInvert() ? res.invert() : res;
        logger.info("Verification finished with result " + res);
        return res;
    }
	
	public static Result runAnalysisAssumeSolver(Solver solver, Context ctx, VerificationTask task) {
		task.unrollAndCompile();
		if(task.getProgram().getAss() instanceof AssertTrue) {
			logger.info("Verification finished: assertion trivially holds");
			return PASS;
		}

		task.initialiseEncoding(ctx);

		logger.info("Starting encoding");
		solver.add(task.encodeProgram(ctx));
		solver.add(task.encodeWmmRelations(ctx));
		solver.add(task.encodeWmmConsistency(ctx));
        solver.add(task.encodeWitness(ctx));

		if(task.getSettings().hasSolverTimeout()) {
			Params p = ctx.mkParams();
			p.add("timeout", 1000*task.getSettings().getSolverTimeout());
			try {
				solver.setParameters(p);
			} catch(Exception ignored) { }
		}

		Result res = Result.UNKNOWN;
		logger.info("Starting first solver.check()");
		switch(solver.check(task.encodeAssertions(ctx))) {
			case UNKNOWN:
				res = solver.getReasonUnknown().equals("canceled") ? TIMEOUT : Result.UNKNOWN;
				break;
			case SATISFIABLE:
				res = FAIL;
				break;
			case UNSATISFIABLE:
				solver.add(ctx.mkNot(task.getProgram().encodeNoBoundEventExec(ctx)));
				logger.info("Starting second solver.check()");
				switch(solver.check()) {
					case UNKNOWN:
						res = solver.getReasonUnknown().equals("canceled") ? TIMEOUT : Result.UNKNOWN;
						break;
					case SATISFIABLE:
						res = Result.UNKNOWN;
						break;
					case UNSATISFIABLE:
						res = PASS;
						break;
				}
				break;
		}
		res = task.getProgram().getAss().getInvert() ? res.invert() : res;
		logger.info("Verification finished with result " + res);
		return res;
    }
}
