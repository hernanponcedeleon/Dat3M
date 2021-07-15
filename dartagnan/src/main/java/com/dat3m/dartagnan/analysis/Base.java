package com.dat3m.dartagnan.analysis;

import static com.dat3m.dartagnan.utils.Result.ERROR;
import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static java.util.Collections.singletonList;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverContext.ProverOptions;
import com.dat3m.dartagnan.asserts.AssertTrue;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.verification.VerificationTask;

public class Base {

    private static final Logger logger = LogManager.getLogger(Base.class);

    public static Result runAnalysisIncrementalSolver(SolverContext ctx, VerificationTask task) {
        Result res = Result.UNKNOWN;
        ProverEnvironment prover = ctx.newProverEnvironment(ProverOptions.GENERATE_MODELS);
        
        task.unrollAndCompile();
       	if(task.getProgram().getAss() instanceof AssertTrue) {
            logger.info("Verification finished: assertion trivialy holds");
       		return PASS;
       	}
        task.initialiseEncoding(ctx);

        try {
            logger.info("Starting encoding");
            prover.addConstraint(task.encodeProgram(ctx));
            prover.addConstraint(task.encodeWmmRelations(ctx));
            prover.addConstraint(task.encodeWmmConsistency(ctx));
            logger.info("Starting push()");
            prover.push();
            prover.addConstraint(task.encodeAssertions(ctx));
            prover.addConstraint(task.encodeWitness(ctx));
            
            logger.info("Starting first solver.check()");
            if(prover.isUnsat()) {
            	prover.pop();
    			prover.addConstraint(ctx.getFormulaManager().getBooleanFormulaManager().not(task.getProgram().encodeNoBoundEventExec(ctx)));
                logger.info("Starting second solver.check()");
                res = prover.isUnsat()? PASS : Result.UNKNOWN;
            } else {
            	res = FAIL;
            }

            res = task.getProgram().getAss().getInvert() ? res.invert() : res;
            logger.info("Verification finished with result " + res);
            return res;

        } catch (Exception e) {
        	logger.error(e.getMessage());
            return ERROR;
        }
    }

    public static Result runAnalysisAssumeSolver(SolverContext ctx, VerificationTask task) {
        Result res = Result.UNKNOWN;
        ProverEnvironment prover = ctx.newProverEnvironment(ProverOptions.GENERATE_MODELS);
        
        task.unrollAndCompile();
       	if(task.getProgram().getAss() instanceof AssertTrue) {
            logger.info("Verification finished: assertion trivialy holds");
       		return PASS;
       	}
        task.initialiseEncoding(ctx);

        try {
            logger.info("Starting encoding");
            prover.addConstraint(task.encodeProgram(ctx));
            prover.addConstraint(task.encodeWmmRelations(ctx));
            prover.addConstraint(task.encodeWmmConsistency(ctx));
            prover.addConstraint(task.encodeWitness(ctx));
            
            logger.info("Starting first solver.check()");
            if(prover.isUnsatWithAssumptions(singletonList(task.encodeAssertions(ctx)))) {
    			prover.addConstraint(ctx.getFormulaManager().getBooleanFormulaManager().not(task.getProgram().encodeNoBoundEventExec(ctx)));
                logger.info("Starting second solver.check()");
                res = prover.isUnsat()? PASS : Result.UNKNOWN;
            } else {
            	res = FAIL;
            }
        
            res = task.getProgram().getAss().getInvert() ? res.invert() : res;
            logger.info("Verification finished with result " + res);        
            return res;

        } catch (Exception e) {
        	logger.error(e.getMessage());
            return ERROR;
        }
    }

    public static Result runAnalysis(SolverContext ctx, VerificationTask task) {
    	Result res = Result.UNKNOWN;
    	ProverEnvironment prover1 = ctx.newProverEnvironment(ProverOptions.GENERATE_MODELS);
    	ProverEnvironment prover2 = ctx.newProverEnvironment(ProverOptions.GENERATE_MODELS);
    	
    	task.unrollAndCompile();
       	if(task.getProgram().getAss() instanceof AssertTrue) {
            logger.info("Verification finished: assertion trivially holds");
       		return PASS;
       	}

        task.initialiseEncoding(ctx);

        try {
        logger.info("Starting encoding");
        BooleanFormula encodeCF = task.encodeProgram(ctx);
        prover1.addConstraint(encodeCF);
        prover2.addConstraint(encodeCF);
        
        BooleanFormula encodeWmm = task.encodeWmmRelations(ctx);
		prover1.addConstraint(encodeWmm);
        prover2.addConstraint(encodeWmm);
        
        BooleanFormula encodeConsistency = task.encodeWmmConsistency(ctx);
		prover1.addConstraint(encodeConsistency);
        prover2.addConstraint(encodeConsistency);
       	
        prover1.addConstraint(task.getProgram().getAss().encode(ctx));
        if(task.getProgram().getAssFilter() != null){
        	BooleanFormula encodeFilter = task.getProgram().getAssFilter().encode(ctx);
			prover1.addConstraint(encodeFilter);
            prover2.addConstraint(encodeFilter);
        }
        // For validation this contains information.
        // For verification graph.encode() just returns ctx.mkTrue()
        prover1.addConstraint(task.encodeWitness(ctx));

        logger.info("Starting first solver.check()");
        if(prover1.isUnsat()) {
			prover2.addConstraint(ctx.getFormulaManager().getBooleanFormulaManager().not(task.getProgram().encodeNoBoundEventExec(ctx)));
            logger.info("Starting second solver.check()");
            res = prover2.isUnsat() ? PASS : Result.UNKNOWN;
        } else {
        	res = FAIL;
        }
        
        res = task.getProgram().getAss().getInvert() ? res.invert() : res;
        logger.info("Verification finished with result " + res);
        return res;
        
        } catch (Exception e) {
        	logger.error(e.getMessage());
        	return ERROR;
        }
    }
}
