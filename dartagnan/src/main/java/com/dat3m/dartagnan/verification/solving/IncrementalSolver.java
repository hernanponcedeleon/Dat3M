package com.dat3m.dartagnan.verification.solving;

import com.dat3m.dartagnan.asserts.AssertTrue;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.verification.VerificationTask;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverException;

import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;

public class IncrementalSolver {

    private static final Logger logger = LogManager.getLogger(IncrementalSolver.class);

    public static Result run(SolverContext ctx, ProverEnvironment prover, VerificationTask task) 
    		throws InterruptedException, SolverException, InvalidConfigurationException {
        Result res = Result.UNKNOWN;
        
        task.preprocessProgram();
       	if(task.getProgram().getAss() instanceof AssertTrue) {
            logger.info("Verification finished: assertion trivially holds");
       		return PASS;
       	}
        task.performStaticProgramAnalyses();
        task.initialiseEncoding(ctx);

        logger.info("Starting encoding using " + ctx.getVersion());
        prover.addConstraint(task.encodeProgram(ctx));
        prover.addConstraint(task.encodeWmmRelations(ctx));
        prover.addConstraint(task.encodeWmmConsistency(ctx));
        // For validation this contains information.
        // For verification graph.encode() just returns ctx.mkTrue()
        prover.addConstraint(task.encodeWitness(ctx));
        prover.addConstraint(task.encodeSymmetryBreaking(ctx));
        logger.info("Starting push()");
        prover.push();
        prover.addConstraint(task.encodeAssertions(ctx));
        
        logger.info("Starting first solver.check()");
        if(prover.isUnsat()) {
        	prover.pop();
			prover.addConstraint(task.getProgramEncoder().encodeBoundEventExec(ctx));
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