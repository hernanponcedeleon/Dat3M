package com.dat3m.dartagnan.verification.solving;

import com.dat3m.dartagnan.encoding.ProgramEncoder;
import com.dat3m.dartagnan.encoding.PropertyEncoder;
import com.dat3m.dartagnan.encoding.SymmetryEncoder;
import com.dat3m.dartagnan.encoding.WmmEncoder;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.verification.VerificationTask;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.java_smt.api.*;

import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static java.util.Collections.singletonList;

public class AssumeSolver {

    private static final Logger logger = LogManager.getLogger(AssumeSolver.class);

    public static Result run(SolverContext ctx, ProverEnvironment prover, VerificationTask task)
            throws InterruptedException, SolverException, InvalidConfigurationException {
        Result res = Result.UNKNOWN;
        
        task.preprocessProgram();
       	task.performStaticProgramAnalyses();
       	task.performStaticWmmAnalyses();

        task.initializeEncoders(ctx);
        ProgramEncoder programEncoder = task.getProgramEncoder();
        PropertyEncoder propertyEncoder = task.getPropertyEncoder();
        WmmEncoder wmmEncoder = task.getWmmEncoder();
        SymmetryEncoder symmEncoder = task.getSymmetryEncoder();

        BooleanFormula propertyEncoding = propertyEncoder.encodeSpecification(task.getProperty());
        if(ctx.getFormulaManager().getBooleanFormulaManager().isFalse(propertyEncoding)) {
            logger.info("Verification finished: property trivially holds");
       		return PASS;        	
        }

        logger.info("Starting encoding using " + ctx.getVersion());
        prover.addConstraint(programEncoder.encodeFullProgram());
        prover.addConstraint(wmmEncoder.encodeFullMemoryModel());
        // For validation this contains information.
        // For verification graph.encode() just returns ctx.mkTrue()
        prover.addConstraint(task.getWitness().encode(task.getProgram(), ctx));
        prover.addConstraint(symmEncoder.encodeFullSymmetry());

        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        BooleanFormula assumptionLiteral = bmgr.makeVariable("DAT3M_spec_assumption");
        BooleanFormula assumedSpec = bmgr.implication(assumptionLiteral, propertyEncoding);
        prover.addConstraint(assumedSpec);
        
        logger.info("Starting first solver.check()");
        if(prover.isUnsatWithAssumptions(singletonList(assumptionLiteral))) {
			prover.addConstraint(propertyEncoder.encodeBoundEventExec());
            logger.info("Starting second solver.check()");
            res = prover.isUnsat()? PASS : Result.UNKNOWN;
        } else {
        	res = FAIL;
        }
    
        if(logger.isDebugEnabled()) {        	
    		String smtStatistics = "\n ===== SMT Statistics ===== \n";
    		for(String key : prover.getStatistics().keySet()) {
    			smtStatistics += String.format("\t%s -> %s\n", key, prover.getStatistics().get(key));
    		}
    		logger.debug(smtStatistics);
        }

        res = task.getProgram().getAss().getInvert() ? res.invert() : res;
        logger.info("Verification finished with result " + res);        
        return res;
    }
}