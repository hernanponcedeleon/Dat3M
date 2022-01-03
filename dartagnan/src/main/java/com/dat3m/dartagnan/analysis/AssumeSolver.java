package com.dat3m.dartagnan.analysis;

import com.dat3m.dartagnan.asserts.AssertTrue;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.verification.VerificationTask;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.java_smt.api.*;

import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static java.util.Collections.singletonList;

public class AssumeSolver {

    private static final Logger logger = LogManager.getLogger(AssumeSolver.class);

    public static Result run(SolverContext ctx, ProverEnvironment prover, VerificationTask task) throws InterruptedException, SolverException {
        Result res = Result.UNKNOWN;
        
        task.preProcessProgram();
       	if(task.getProgram().getAss() instanceof AssertTrue) {
            logger.info("Verification finished: assertion trivially holds");
       		return PASS;
       	}
        task.initialiseEncoding(ctx);

        logger.info("Starting encoding using " + ctx.getVersion());
        prover.addConstraint(task.encodeProgram(ctx));
        prover.addConstraint(task.encodeWmmRelations(ctx));
        prover.addConstraint(task.encodeWmmConsistency(ctx));
        // For validation this contains information.
        // For verification graph.encode() just returns ctx.mkTrue()
        prover.addConstraint(task.encodeWitness(ctx));
        prover.addConstraint(task.encodeSymmetryBreaking(ctx));

        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        BooleanFormula assumptionLiteral = bmgr.makeVariable("DAT3M_assertion_assumption");
        BooleanFormula assumedAssertion = bmgr.implication(assumptionLiteral, task.encodeAssertions(ctx));
        prover.addConstraint(assumedAssertion);
        
        logger.info("Starting first solver.check()");
        if(prover.isUnsatWithAssumptions(singletonList(assumptionLiteral))) {
			prover.addConstraint(task.getProgramEncoder().encodeNoBoundEventExec(ctx));
            logger.info("Starting second solver.check()");
            res = prover.isUnsat()? PASS : Result.UNKNOWN;
        } else {
        	res = FAIL;
        }
    
        res = task.getProgram().getAss().getInvert() ? res.invert() : res;
        logger.info("Verification finished with result " + res);        
        return res;
    }
}