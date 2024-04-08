package com.dat3m.dartagnan.verification.solving;

import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.encoding.*;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Wmm;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverException;

import static com.dat3m.dartagnan.utils.Result.*;

public class IncrementalSolver extends ModelChecker {

    private static final Logger logger = LogManager.getLogger(IncrementalSolver.class);

    private final SolverContext ctx;
    private final ProverEnvironment prover;
    private final VerificationTask task;

    private IncrementalSolver(SolverContext c, ProverEnvironment p, VerificationTask t) {
        ctx = c;
        prover = p;
        task = t;
    }

    public static IncrementalSolver run(SolverContext ctx, ProverEnvironment prover, VerificationTask task)
    		throws InterruptedException, SolverException, InvalidConfigurationException {
        IncrementalSolver s = new IncrementalSolver(ctx, prover, task);
        s.run();
        return s;
    }

    private void run() throws InterruptedException, SolverException, InvalidConfigurationException {
        Wmm memoryModel = task.getMemoryModel();
        Context analysisContext = Context.create();
        Configuration config = task.getConfig();

        memoryModel.configureAll(config);
        preprocessProgram(task, config);
        preprocessMemoryModel(task, config);
        performStaticProgramAnalyses(task, analysisContext, config);
        performStaticWmmAnalyses(task, analysisContext, config);

        context = EncodingContext.of(task, analysisContext, ctx.getFormulaManager());
        ProgramEncoder programEncoder = ProgramEncoder.withContext(context);
        PropertyEncoder propertyEncoder = PropertyEncoder.withContext(context);
        WmmEncoder wmmEncoder = WmmEncoder.withContext(context);
        SymmetryEncoder symmetryEncoder = SymmetryEncoder.withContext(context);

        logger.info("Starting encoding using " + ctx.getVersion());
        prover.addConstraint(programEncoder.encodeFullProgram());
        prover.addConstraint(wmmEncoder.encodeFullMemoryModel());
        // For validation this contains information.
        // For verification graph.encode() just returns ctx.mkTrue()
        prover.addConstraint(task.getWitness().encode(context));
        prover.addConstraint(symmetryEncoder.encodeFullSymmetryBreaking());
        logger.info("Starting push()");
        prover.push();
        prover.addConstraint(propertyEncoder.encodeProperties(task.getProperty()));
        
        logger.info("Starting first solver.check()");
        if(prover.isUnsat()) {
        	prover.pop();
			prover.addConstraint(propertyEncoder.encodeBoundEventExec());
            logger.info("Starting second solver.check()");
            res = prover.isUnsat()? PASS : UNKNOWN;
        } else {
        	res = FAIL;
            saveFlaggedPairsOutput(memoryModel, wmmEncoder, prover, context, task.getProgram());
        }
        
        if(logger.isDebugEnabled()) {        	
    		StringBuilder smtStatistics = new StringBuilder("\n ===== SMT Statistics ===== \n");
    		for(String key : prover.getStatistics().keySet()) {
    			smtStatistics.append(String.format("\t%s -> %s\n", key, prover.getStatistics().get(key)));
    		}
    		logger.debug(smtStatistics.toString());
        }

        // For Safety specs, we have SAT=FAIL, but for reachability specs, we have SAT=PASS
        res = Property.getCombinedType(task.getProperty(), task) == Property.Type.SAFETY ? res : res.invert();
        logger.info("Verification finished with result " + res);
    }
}