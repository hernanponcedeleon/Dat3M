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
import com.microsoft.z3.Context;
import com.microsoft.z3.Solver;

public class Validation {
	
    private static final Logger logger = LogManager.getLogger(Validation.class);
	
    public static Result runValidation(Solver solver, Context ctx, Program program, Wmm wmm, WitnessGraph graph, Arch target, Settings settings) {
    	program.simplify();
    	program.unroll(settings.getBound(), 0);
        program.compile(target, 0);
        // AssertionInline depends on compiled events (copies)
        // Thus we need to update the assertion after compilation
        program.updateAssertion();
       	if(program.getAss() instanceof AssertTrue) {
       		logger.info("Validation finished: assertion trivialy holds");
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
        solver.add(graph.encode(program, ctx));
        if(program.getAssFilter() != null){
            solver.add(program.getAssFilter().encode(ctx));
        }

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
		logger.info("Validation finished with result " + res);
		return res;
    }
}
