package com.dat3m.dartagnan.verification.solving;

import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.encoding.*;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Wmm;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.java_smt.api.*;

import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static java.util.Collections.singletonList;

public class AssumeSolver extends ModelChecker {

    private static final Logger logger = LogManager.getLogger(AssumeSolver.class);

    private final SolverContext ctx;
    private final ProverWithTracker prover;
    private final VerificationTask task;

    private AssumeSolver(SolverContext c, ProverWithTracker p, VerificationTask t) {
        ctx = c;
        prover = p;
        task = t;
    }

    public static AssumeSolver run(SolverContext ctx, ProverWithTracker prover, VerificationTask task)
            throws InterruptedException, SolverException, InvalidConfigurationException {
        AssumeSolver s = new AssumeSolver(ctx, prover, task);
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
        prover.writeComment("Program encoding");
        prover.addConstraint(programEncoder.encodeFullProgram());
        prover.writeComment("Memory model encoding");
        prover.addConstraint(wmmEncoder.encodeFullMemoryModel());
        // For validation this contains information.
        // For verification graph.encode() just returns ctx.mkTrue()
        prover.writeComment("Witness encoding");
        prover.addConstraint(task.getWitness().encode(context));
        prover.writeComment("Symmetry breaking encoding");
        prover.addConstraint(symmetryEncoder.encodeFullSymmetryBreaking());

        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        BooleanFormula assumptionLiteral = bmgr.makeVariable("DAT3M_spec_assumption");
        BooleanFormula propertyEncoding = propertyEncoder.encodeProperties(task.getProperty());
        BooleanFormula assumedSpec = bmgr.implication(assumptionLiteral, propertyEncoding);
        prover.writeComment("Property encoding");
        prover.addConstraint(assumedSpec);
        
        logger.info("Starting first solver.check()");
        if(prover.isUnsatWithAssumptions(singletonList(assumptionLiteral))) {
            prover.writeComment("Bound encoding");
			prover.addConstraint(propertyEncoder.encodeBoundEventExec());
            logger.info("Starting second solver.check()");
            res = prover.isUnsat()? PASS : Result.UNKNOWN;
        } else {
            res = FAIL;
            saveFlaggedPairsOutput(memoryModel, wmmEncoder, prover, context, task.getProgram());
        }

        if(logger.isDebugEnabled()) {        	
    		String smtStatistics = "\n ===== SMT Statistics ===== \n";
    		for(String key : prover.getStatistics().keySet()) {
    			smtStatistics += String.format("\t%s -> %s\n", key, prover.getStatistics().get(key));
    		}
    		logger.debug(smtStatistics);
        }

        // For Safety specs, we have SAT=FAIL, but for reachability specs, we have SAT=PASS
        res = Property.getCombinedType(task.getProperty(), task) == Property.Type.SAFETY ? res : res.invert();
        logger.info("Verification finished with result " + res);
    }
}