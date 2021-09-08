package com.dat3m.dartagnan.analysis;

import com.dat3m.dartagnan.asserts.AssertTrue;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.verification.VerificationTask;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverException;

import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static java.util.Collections.singletonList;


//TODO: Add symmetry breaking
public class Base {

    private static final Logger logger = LogManager.getLogger(Base.class);

    public static Result runAnalysisIncrementalSolver(SolverContext ctx, ProverEnvironment prover, VerificationTask task) throws InterruptedException, SolverException {
        Result res = Result.UNKNOWN;
        
        task.unrollAndCompile();
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
        logger.info("Starting push()");
        prover.push();
        prover.addConstraint(task.encodeAssertions(ctx));
        
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
    }

    public static Result runAnalysisAssumeSolver(SolverContext ctx, ProverEnvironment prover, VerificationTask task) throws InterruptedException, SolverException {
        Result res = Result.UNKNOWN;
        
        task.unrollAndCompile();
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
        
        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        BooleanFormula assumptionLiteral = bmgr.makeVariable("DAT3M_assertion_assumption");
        BooleanFormula assumedAssertion = bmgr.implication(assumptionLiteral, task.encodeAssertions(ctx));
        prover.addConstraint(assumedAssertion);
        
        logger.info("Starting first solver.check()");
        if(prover.isUnsatWithAssumptions(singletonList(assumptionLiteral))) {
			prover.addConstraint(ctx.getFormulaManager().getBooleanFormulaManager().not(task.getProgram().encodeNoBoundEventExec(ctx)));
            logger.info("Starting second solver.check()");
            res = prover.isUnsat()? PASS : Result.UNKNOWN;
        } else {
        	res = FAIL;
        }
    
        res = task.getProgram().getAss().getInvert() ? res.invert() : res;
        logger.info("Verification finished with result " + res);        
        return res;
    }

    public static Result runAnalysisTwoSolvers(SolverContext ctx, ProverEnvironment prover1, ProverEnvironment prover2, VerificationTask task) throws InterruptedException, SolverException {
    	Result res = Result.UNKNOWN;
    	
    	task.unrollAndCompile();
       	if(task.getProgram().getAss() instanceof AssertTrue) {
            logger.info("Verification finished: assertion trivially holds");
       		return PASS;
       	}

        task.initialiseEncoding(ctx);

        logger.info("Starting encoding using " + ctx.getVersion());
        BooleanFormula encodeCF = task.encodeProgram(ctx);
        prover1.addConstraint(encodeCF);
        prover2.addConstraint(encodeCF);
        
        BooleanFormula encodeWmm = task.encodeWmmRelations(ctx);
		prover1.addConstraint(encodeWmm);
        prover2.addConstraint(encodeWmm);
        
        BooleanFormula encodeConsistency = task.encodeWmmConsistency(ctx);
		prover1.addConstraint(encodeConsistency);
        prover2.addConstraint(encodeConsistency);
       	
        // For validation this contains information.
        // For verification graph.encode() just returns ctx.mkTrue()
        BooleanFormula encodeWitness = task.encodeWitness(ctx);
		prover1.addConstraint(encodeWitness);
        prover2.addConstraint(encodeWitness);
        
        prover1.addConstraint(task.encodeAssertions(ctx));

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
    }
}
