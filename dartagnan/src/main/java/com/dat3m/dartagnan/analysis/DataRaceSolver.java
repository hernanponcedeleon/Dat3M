package com.dat3m.dartagnan.analysis;

import com.dat3m.dartagnan.encoding.DataRaceEncoder;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.verification.VerificationTask;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.java_smt.api.*;
import org.sosy_lab.java_smt.api.SolverContext.ProverOptions;

import static com.dat3m.dartagnan.utils.Result.*;

public class DataRaceSolver {
	
	// This analysis assumes that CAT file defining the memory model has a happens-before 
	// relation named hb: it should contain the following axiom "acyclic hb"

    private static final Logger logger = LogManager.getLogger(DataRaceSolver.class);

	public static Result run(SolverContext ctx, VerificationTask task) {

		task.preProcessProgram();
		task.initialiseEncoding(ctx);
		
		try (ProverEnvironment prover = ctx.newProverEnvironment(ProverOptions.GENERATE_MODELS)) {
			prover.addConstraint(task.encodeProgram(ctx));
			prover.addConstraint(task.encodeWmmRelations(ctx));
	        prover.addConstraint(task.encodeWmmConsistency(ctx));
	        prover.push();
	        
	        DataRaceEncoder encoder = DataRaceEncoder.fromConfig(task.getConfig());
	        encoder.initialise(task, ctx);
	        prover.addConstraint(encoder.encodeDataRaces(ctx));
	        
			BooleanFormula noBoundEventExec = task.getProgramEncoder().encodeNoBoundEventExec(ctx);
			
			if(prover.isUnsat()) {
	        	prover.pop();
				prover.addConstraint(noBoundEventExec);
	        	return prover.isUnsat() ? PASS : UNKNOWN;
	        } else {
				return FAIL;
	        }
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
		return UNKNOWN;
    }
}