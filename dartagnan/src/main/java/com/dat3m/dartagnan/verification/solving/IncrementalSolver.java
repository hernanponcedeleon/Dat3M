package com.dat3m.dartagnan.verification.solving;

import com.dat3m.dartagnan.encoding.ProgramEncoder;
import com.dat3m.dartagnan.encoding.PropertyEncoder;
import com.dat3m.dartagnan.encoding.SymmetryEncoder;
import com.dat3m.dartagnan.encoding.WmmEncoder;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Wmm;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverException;

import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;

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

    public static Result run(SolverContext ctx, ProverEnvironment prover, VerificationTask task)
    		throws InterruptedException, SolverException, InvalidConfigurationException {
        return new IncrementalSolver(ctx, prover, task).run();
    }

    private Result run() throws InterruptedException, SolverException, InvalidConfigurationException {
        Result res = Result.UNKNOWN;
        Program program = task.getProgram();
        Wmm memoryModel = task.getMemoryModel();
        Context analysisContext = Context.create();
        Configuration config = task.getConfig();

        memoryModel.configureAll(config);
        preprocessProgram(task, config);
        performStaticProgramAnalyses(task, analysisContext, config);
        performStaticWmmAnalyses(task, analysisContext, config);

        ProgramEncoder programEncoder = ProgramEncoder.fromConfig(program, analysisContext, config);
        PropertyEncoder propertyEncoder = PropertyEncoder.fromConfig(program, memoryModel,analysisContext, config);
        WmmEncoder wmmEncoder = WmmEncoder.fromConfig(program, memoryModel, analysisContext, config);
        SymmetryEncoder symmetryEncoder = SymmetryEncoder.fromConfig(memoryModel, analysisContext, config);

        programEncoder.initializeEncoding(ctx);
        propertyEncoder.initializeEncoding(ctx);
        wmmEncoder.initializeEncoding(ctx);
        symmetryEncoder.initializeEncoding(ctx);
        
        BooleanFormula propertyEncoding = propertyEncoder.encodeSpecification(task.getProperty(), ctx);
        if(ctx.getFormulaManager().getBooleanFormulaManager().isFalse(propertyEncoding)) {
            logger.info("Verification finished: property trivially holds");
       		return PASS;        	
        }

        logger.info("Starting encoding using " + ctx.getVersion());
        prover.addConstraint(programEncoder.encodeFullProgram(ctx));
        prover.addConstraint(wmmEncoder.encodeFullMemoryModel(ctx));
        // For validation this contains information.
        // For verification graph.encode() just returns ctx.mkTrue()
        prover.addConstraint(task.getWitness().encode(task.getProgram(), ctx));
        prover.addConstraint(symmetryEncoder.encodeFullSymmetry(ctx));
        logger.info("Starting push()");
        prover.push();
        prover.addConstraint(propertyEncoding);
        
        logger.info("Starting first solver.check()");
        if(prover.isUnsat()) {
        	prover.pop();
			prover.addConstraint(propertyEncoder.encodeBoundEventExec(ctx));
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