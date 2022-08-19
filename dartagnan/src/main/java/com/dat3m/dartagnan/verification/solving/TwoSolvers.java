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

public class TwoSolvers extends ModelChecker {

    private static final Logger logger = LogManager.getLogger(TwoSolvers.class);

    private final SolverContext ctx;
    private final ProverEnvironment prover1,prover2;
    private final VerificationTask task;

    private TwoSolvers(SolverContext c, ProverEnvironment p1, ProverEnvironment p2, VerificationTask t) {
        ctx = c;
        prover1 = p1;
        prover2 = p2;
        task = t;
    }

    public static Result run(SolverContext ctx, ProverEnvironment prover1, ProverEnvironment prover2, VerificationTask task)
            throws InterruptedException, SolverException, InvalidConfigurationException {
        return new TwoSolvers(ctx, prover1, prover2, task).run();
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
        WmmEncoder wmmEncoder = WmmEncoder.fromConfig(memoryModel, analysisContext, config);
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

        BooleanFormula encodeSymm = symmetryEncoder.encodeFullSymmetry(ctx);
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