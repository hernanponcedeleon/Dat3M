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
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverException;

import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;

public class TwoSolvers {

    private static final Logger logger = LogManager.getLogger(TwoSolvers.class);

    public static Result run(SolverContext ctx, ProverEnvironment prover1, ProverEnvironment prover2, VerificationTask task)
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

        BooleanFormula propertyEncoding = propertyEncoder.encodeSpecification(task.getProperty(), ctx);
        if(ctx.getFormulaManager().getBooleanFormulaManager().isFalse(propertyEncoding)) {
            logger.info("Verification finished: property trivially holds");
       		return PASS;        	
        }

        logger.info("Starting encoding using " + ctx.getVersion());
        BooleanFormula encodeProg = programEncoder.encodeFullProgram(ctx);
        prover1.addConstraint(encodeProg);
        prover2.addConstraint(encodeProg);
        
        BooleanFormula encodeWmm = wmmEncoder.encodeFullMemoryModel(ctx);
		prover1.addConstraint(encodeWmm);
        prover2.addConstraint(encodeWmm);
       	
        // For validation this contains information.
        // For verification graph.encode() just returns ctx.mkTrue()
        BooleanFormula encodeWitness = task.getWitness().encode(task.getProgram(), ctx);
		prover1.addConstraint(encodeWitness);
        prover2.addConstraint(encodeWitness);

        BooleanFormula encodeSymm = symmEncoder.encodeFullSymmetry(ctx);
        prover1.addConstraint(encodeSymm);
        prover2.addConstraint(encodeSymm);

        prover1.addConstraint(propertyEncoding);

        logger.info("Starting first solver.check()");
        if(prover1.isUnsat()) {
			prover2.addConstraint(propertyEncoder.encodeBoundEventExec(ctx));
            logger.info("Starting second solver.check()");
            res = prover2.isUnsat() ? PASS : Result.UNKNOWN;
        } else {
        	res = FAIL;
        }

        if(logger.isDebugEnabled()) {        	
    		String smtStatistics = "\n ===== SMT Statistics ===== \n";
    		for(String key : prover1.getStatistics().keySet()) {
    			smtStatistics += String.format("\t%s -> %s\n", key, prover1.getStatistics().get(key));
    		}
    		logger.debug(smtStatistics);
        }

        res = task.getProgram().getAss().getInvert() ? res.invert() : res;
        logger.info("Verification finished with result " + res);
        return res;
    }
}