package com.dat3m.dartagnan.task.verification;

import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.encoding.*;
import com.dat3m.dartagnan.smt.ProverWithTracker;
import com.dat3m.dartagnan.task.SMTModelChecker;
import com.dat3m.dartagnan.task.*;
import com.google.common.base.Verify;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverException;

import java.util.List;

import static com.dat3m.dartagnan.task.verification.VerificationStatus.*;

public class AssumeSolver extends SMTModelChecker<VerificationTask> implements Verifier {

    private static final Logger logger = LoggerFactory.getLogger(AssumeSolver.class);

    private AssumeSolver(VerificationTask task) throws InvalidConfigurationException {
        super(task);
    }

    public static AssumeSolver create(VerificationTask task) throws InvalidConfigurationException {
        return new AssumeSolver(task);
    }

    protected Context preprocessAndAnalyse(Task task) throws InvalidConfigurationException {
        final Configuration config = task.getConfig();

        preprocessProgram(task, config);
        preprocessMemoryModel(task);

        final Context analysisContext = Context.create();
        performStaticProgramAnalyses(task, analysisContext, config);
        performStaticWmmAnalyses(task, analysisContext, config);
        performIntervalAnalysis(task, analysisContext, config);
        return analysisContext;
    }

    @Override
    public VerificationResult verify() throws InterruptedException, SolverException, InvalidConfigurationException {
        final Context analysisContext = preprocessAndAnalyse(task);

        initSMTSolver(task.getConfig());
        final SolverContext solverContext = this.solverContext;
        final ProverWithTracker prover = this.prover;

        EncodingContext context = EncodingContext.of(task, analysisContext, solverContext.getFormulaManager());
        ProgramEncoder programEncoder = ProgramEncoder.withContext(context);
        SymmetryEncoder symmetryEncoder = SymmetryEncoder.withContext(context);
        // Lazy closures rely on all their uses being negative, which symmetry breaking does not respect.
        WmmEncoder wmmEncoder = WmmEncoder.withContext(context, canUseUserPropagators() && !symmetryEncoder.isEnabled());
        BooleanFormulaManager bmgr = context.getBooleanFormulaManager();

        logger.info("Starting encoding using {}", solverContext.getVersion());
        prover.writeComment("Program encoding");
        prover.addConstraint(programEncoder.encodeFullProgram());
        prover.writeComment("Memory model encoding");
        prover.addConstraint(wmmEncoder.encodeFullMemoryModel());
        final ClosurePropagator closurePropagator = registerClosurePropagator(context, wmmEncoder);
        prover.writeComment("Symmetry breaking encoding");
        prover.addConstraint(symmetryEncoder.encodeFullSymmetryBreaking());

        // Adding bounds
        prover.writeComment("Bounds over variables");
        prover.addConstraint(programEncoder.encodeBounds());

        final BooleanFormula assumption;
        final BooleanFormula assumedEncoding;
        if (task instanceof WitnessValidationTask) {
            assumption = bmgr.makeVariable("DAT3M_witness_assumption");
            assumedEncoding = SvcompWitnessEncoder.withContext(context).encode();
            prover.writeComment("Witness encoding");
        } else {
            assumption = bmgr.makeVariable("DAT3M_spec_assumption");
            assumedEncoding = PropertyEncoder.withContext(context, wmmEncoder).encodeProperties(task.getProperties());
            prover.writeComment("Property encoding");
        }
        prover.addConstraint(bmgr.implication(assumption, assumedEncoding));

        checkForInterrupts();

        logger.info("Starting first solver.check()");
        VerificationStatus res;
        if (prover.isUnsatWithAssumptions(List.of(assumption))) {
            checkForInterrupts();
            prover.writeComment("Bound encoding");
            prover.addConstraint(programEncoder.encodeBoundEventExec());
            logger.info("Starting second solver.check()");
            res = prover.isUnsat() ? PASS : UNKNOWN;
        } else {
            res = FAIL;
        }

        logProverStatistics(logger, prover);
        if (closurePropagator != null) {
            logger.info("Lazy closures: {}", closurePropagator.getStatistics());
        }
        checkForInterrupts();

        final IREvaluator model = (res != PASS) ? context.newEvaluator(prover) : null;
        // For Safety specs, we have SAT=FAIL, but for reachability specs, we have SAT=PASS
        res = Property.getCombinedType(task.getProperties(), task) == Property.Type.SAFETY ? res : res.invert();

        logger.info("Verification finished with result {}", res);
        return new VerificationResult(task, res, model);
    }

    private ClosurePropagator registerClosurePropagator(EncodingContext context, WmmEncoder wmmEncoder)
            throws InterruptedException {
        if (wmmEncoder.getLazyClosures().isEmpty()) {
            return null;
        }
        final ClosurePropagator propagator = new ClosurePropagator(context, wmmEncoder.getLazyClosures());
        prover.addConstraint(propagator.encodeInitialFacts());
        Verify.verify(prover.registerUserPropagator(propagator), "Solver does not support user propagators.");
        return propagator;
    }

}
