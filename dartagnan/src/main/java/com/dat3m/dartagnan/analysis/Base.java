package com.dat3m.dartagnan.analysis;

import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static com.dat3m.dartagnan.utils.Result.UNKNOWN;
import static com.microsoft.z3.Status.SATISFIABLE;

import com.dat3m.dartagnan.asserts.AssertTrue;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Solver;

public class Base {

    public static Result runAnalysis(Solver s1, Context ctx, VerificationTask task) {
        Program program = task.getProgram();
    	task.unrollAndCompile();
       	if(task.getProgram().getAss() instanceof AssertTrue) {
       		return PASS;
       	}
       	
        // Using two solvers can be faster than using
        // an incremental solver or check-sat-assuming
        Solver s2 = ctx.mkSolver();
        
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
	
    public static Result runAnalysisIncrementalSolver(Solver solver, Context ctx, VerificationTask task) {
        task.unrollAndCompile();
       	if(task.getProgram().getAss() instanceof AssertTrue) {
       		return PASS;
       	}

        solver.add(task.encodeProgram(ctx));
        solver.add(task.encodeWmmRelations(ctx));
        solver.add(task.encodeWmmConsistency(ctx));
        solver.push();
        solver.add(task.encodeAssertions(ctx));

        Result res = UNKNOWN;
		if(solver.check() == SATISFIABLE) {
        	solver.add(task.getProgram().encodeNoBoundEventExec(ctx));
			res = solver.check() == SATISFIABLE ? FAIL : UNKNOWN;
        } else {
        	solver.pop();
			solver.add(ctx.mkNot(task.getProgram().encodeNoBoundEventExec(ctx)));
        	res = solver.check() == SATISFIABLE ? UNKNOWN : PASS;
        }

        return task.getProgram().getAss().getInvert() ? res.invert() : res;
    }
}
