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
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverException;

import static com.dat3m.dartagnan.utils.Result.*;

public class TwoSolvers extends ModelChecker {

    private static final Logger logger = LogManager.getLogger(TwoSolvers.class);

    private final SolverContext ctx;
    private final ProverEnvironment prover1, prover2;
    private final VerificationTask task;

    private TwoSolvers(SolverContext c, ProverEnvironment p1, ProverEnvironment p2, VerificationTask t) {
        ctx = c;
        prover1 = p1;
        prover2 = p2;
        task = t;
    }

    public static TwoSolvers run(SolverContext ctx, ProverEnvironment prover1, ProverEnvironment prover2, VerificationTask task)
            throws InterruptedException, SolverException, InvalidConfigurationException {
        TwoSolvers s = new TwoSolvers(ctx, prover1, prover2, task);
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
        BooleanFormula encodeProg = programEncoder.encodeFullProgram();
        prover1.addConstraint(encodeProg);
        prover2.addConstraint(encodeProg);

        BooleanFormula encodeWmm = wmmEncoder.encodeFullMemoryModel();
        prover1.addConstraint(encodeWmm);
        prover2.addConstraint(encodeWmm);

        // For validation this contains information.
        // For verification graph.encode() just returns ctx.mkTrue()
        BooleanFormula encodeWitness = task.getWitness().encode(context);
        prover1.addConstraint(encodeWitness);
        prover2.addConstraint(encodeWitness);

        BooleanFormula encodeSymm = symmetryEncoder.encodeFullSymmetryBreaking();
        prover1.addConstraint(encodeSymm);
        prover2.addConstraint(encodeSymm);

        prover1.addConstraint(propertyEncoder.encodeProperties(task.getProperty()));

        logger.info("Starting first solver.check()");
        if (prover1.isUnsat()) {
            prover2.addConstraint(propertyEncoder.encodeBoundEventExec());
            logger.info("Starting second solver.check()");
            res = prover2.isUnsat() ? PASS : UNKNOWN;
        } else {
            res = FAIL;
            saveFlaggedPairsOutput(memoryModel, wmmEncoder, prover1, context, task.getProgram());
        }

        if (logger.isDebugEnabled()) {
            String smtStatistics = "\n ===== SMT Statistics ===== \n";
            for (String key : prover1.getStatistics().keySet()) {
                smtStatistics += String.format("\t%s -> %s\n", key, prover1.getStatistics().get(key));
            }
            logger.debug(smtStatistics);
        }

        // For Safety specs, we have SAT=FAIL, but for reachability specs, we have SAT=PASS
        res = Property.getCombinedType(task.getProperty(), task) == Property.Type.SAFETY ? res : res.invert();
        logger.info("Verification finished with result " + res);
    }
}