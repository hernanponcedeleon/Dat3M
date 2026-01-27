package com.dat3m.dartagnan.verification.solving;

import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.encoding.*;
import com.dat3m.dartagnan.smt.ProverWithTracker;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import org.apache.logging.log4j.Level;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverException;

import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static java.util.Collections.singletonList;

public class AssumeSolver extends ModelChecker {

    private static final Logger logger = LogManager.getLogger(AssumeSolver.class);

    private AssumeSolver(VerificationTask task) throws InvalidConfigurationException {
        super(task);
    }

    public static AssumeSolver create(VerificationTask task) throws InvalidConfigurationException {
        return new AssumeSolver(task);
    }

    protected Context preprocessAndAnalyse(VerificationTask task) throws InvalidConfigurationException {
        final Configuration config = task.getConfig();
        task.getMemoryModel().configureAll(config);
        preprocessProgram(task, config);
        preprocessMemoryModel(task, config);

        final Context analysisContext = Context.create();
        performStaticProgramAnalyses(task, analysisContext, config);
        performStaticWmmAnalyses(task, analysisContext, config);
        return analysisContext;
    }

    @Override
    protected void runInternal() throws InterruptedException, SolverException, InvalidConfigurationException {
        final Context analysisContext = preprocessAndAnalyse(task);

        initSMTSolver(task.getConfig());
        final SolverContext solverContext = this.solverContext;
        final ProverWithTracker prover = this.prover;

        context = EncodingContext.of(task, analysisContext, solverContext.getFormulaManager());
        ProgramEncoder programEncoder = ProgramEncoder.withContext(context);
        PropertyEncoder propertyEncoder = PropertyEncoder.withContext(context);
        WmmEncoder wmmEncoder = WmmEncoder.withContext(context);
        SymmetryEncoder symmetryEncoder = SymmetryEncoder.withContext(context);

        logger.info("Starting encoding using {}", solverContext.getVersion());
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

        BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        BooleanFormula assumptionLiteral = bmgr.makeVariable("DAT3M_spec_assumption");
        BooleanFormula propertyEncoding = propertyEncoder.encodeProperties(task.getProperty());
        BooleanFormula assumedSpec = bmgr.implication(assumptionLiteral, propertyEncoding);
        prover.writeComment("Property encoding");
        prover.addConstraint(assumedSpec);

        logger.info("Starting first solver.check()");
        if (prover.isUnsatWithAssumptions(singletonList(assumptionLiteral))) {
            prover.writeComment("Bound encoding");
            prover.addConstraint(propertyEncoder.encodeBoundEventExec());
            logger.info("Starting second solver.check()");
            res = prover.isUnsat() ? PASS : Result.UNKNOWN;
        } else {
            res = FAIL;
        }

        logProverStatistics(Level.DEBUG, logger, prover);

        // For Safety specs, we have SAT=FAIL, but for reachability specs, we have SAT=PASS
        res = Property.getCombinedType(task.getProperty(), task) == Property.Type.SAFETY ? res : res.invert();
        logger.info("Verification finished with result {}", res);
    }
}