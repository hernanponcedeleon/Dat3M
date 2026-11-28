package com.dat3m.dartagnan.task.verification;

import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.encoding.*;
import com.dat3m.dartagnan.smt.ProverWithTracker;
import com.dat3m.dartagnan.task.SMTModelChecker;
import com.dat3m.dartagnan.task.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.Model;
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
        WmmEncoder wmmEncoder = WmmEncoder.withContext(context);
        SymmetryEncoder symmetryEncoder = SymmetryEncoder.withContext(context);
        BooleanFormulaManager bmgr = context.getBooleanFormulaManager();

        logger.info("Starting encoding using {}", solverContext.getVersion());
        prover.writeComment("Program encoding");
        prover.addConstraint(programEncoder.encodeFullProgram());
        prover.writeComment("Memory model encoding");
        prover.addConstraint(wmmEncoder.encodeFullMemoryModel());
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

        // A single query for "property violated or bound event executed": UNSAT proves the property with one
        // check. A violation is real even if a bound event executes in the same execution.
        final BooleanFormula boundAssumption = bmgr.makeVariable("DAT3M_bound_assumption");
        final BooleanFormula combinedAssumption = bmgr.makeVariable("DAT3M_combined_assumption");
        prover.writeComment("Bound encoding");
        prover.addConstraint(bmgr.implication(boundAssumption, programEncoder.encodeBoundEventExec()));
        prover.addConstraint(bmgr.implication(combinedAssumption, bmgr.or(assumption, boundAssumption)));

        // For Safety specs, we have SAT=FAIL, but for reachability specs, we have SAT=PASS
        final VerificationStatus satStatus =
                Property.getCombinedType(task.getProperties(), task) == Property.Type.SAFETY ? FAIL : PASS;

        checkForInterrupts();
        logger.info("Starting combined (property or bound) solver.check()");
        final VerificationResult result;
        if (prover.isUnsatWithAssumptions(List.of(combinedAssumption))) {
            result = VerificationResult.withoutExecution(task, satStatus.invert());
        } else if (modelSatisfies(assumption)) {
            result = resultFromModel(context, satStatus);
        } else {
            // The model executes a bound event but does not violate the property.
            final VerificationResult unknownResult = resultFromModel(context, UNKNOWN);
            checkForInterrupts();
            logger.info("Starting property-only solver.check()");
            result = prover.isUnsatWithAssumptions(List.of(assumption))
                    ? unknownResult
                    : resultFromModel(context, satStatus);
        }

        logProverStatistics(logger, prover);
        logger.info("Verification finished with result {}", result.getStatus());
        return result;
    }

    private boolean modelSatisfies(BooleanFormula literal) throws SolverException {
        try (Model model = prover.getModel()) {
            return Boolean.TRUE.equals(model.evaluate(literal));
        }
    }

    private VerificationResult resultFromModel(EncodingContext context, VerificationStatus status)
            throws SolverException {
        try (IREvaluator model = context.newEvaluator(prover)) {
            return VerificationResult.fromModel(task, status, model);
        }
    }

}
