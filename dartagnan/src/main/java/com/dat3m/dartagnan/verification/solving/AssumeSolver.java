package com.dat3m.dartagnan.verification.solving;


import com.dat3m.dartagnan.configuration.OptionNames;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.encoding.*;
import com.dat3m.dartagnan.smt.ProverWithTracker;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverException;

import static com.dat3m.dartagnan.utils.Result.*;
import static java.util.Collections.singletonList;

@Options
public class AssumeSolver extends ModelChecker {


    private static final Logger logger = LoggerFactory.getLogger(AssumeSolver.class);

    @Option(name = OptionNames.INCREMENTAL_SOLVING,
            description = "If true (default), the solver will run in incremental mode.",
            secure = true
    )
    private boolean incremental = true;

    private AssumeSolver(VerificationTask task) throws InvalidConfigurationException {
        super(task);
        task.getConfig().inject(this);
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

        context = EncodingContext.of(task, analysisContext, solverContext.getFormulaManager());
        final ProgramEncoder programEncoder = ProgramEncoder.withContext(context);
        final PropertyEncoder propertyEncoder = PropertyEncoder.withContext(context);
        final WmmEncoder wmmEncoder = WmmEncoder.withContext(context);
        final SymmetryEncoder symmetryEncoder = SymmetryEncoder.withContext(context);

        logger.info("Starting encoding using {}", solverContext.getVersion());
        final BooleanFormula progEnc = programEncoder.encodeFullProgram();
        final BooleanFormula wmmEnc = wmmEncoder.encodeFullMemoryModel();
        final BooleanFormula witnessEnc = task.getWitness().encode(context);
        final BooleanFormula symEnc = symmetryEncoder.encodeFullSymmetryBreaking();
        final BooleanFormula propertyEnc = propertyEncoder.encodeProperties(task.getProperty());

        final ProverWithTracker prover = this.prover;
        prover.writeComment("Program encoding");
        prover.addConstraint(progEnc);
        prover.writeComment("Memory model encoding");
        prover.addConstraint(wmmEnc);
        // For validation this contains information.
        // For verification graph.encode() just returns ctx.mkTrue()
        prover.writeComment("Witness encoding");
        prover.addConstraint(witnessEnc);
        prover.writeComment("Symmetry breaking encoding");
        prover.addConstraint(symEnc);

        checkForInterrupts();

        if (incremental) {
            final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
            final BooleanFormula assumptionLiteral = bmgr.makeVariable("DAT3M_spec_assumption");
            final BooleanFormula assumedSpec = bmgr.implication(assumptionLiteral, propertyEnc);
            prover.writeComment("Property encoding");
            prover.addConstraint(assumedSpec);

            logger.info("Starting first solver.check()");
            if (prover.isUnsatWithAssumptions(singletonList(assumptionLiteral))) {
                checkForInterrupts();
                prover.writeComment("Bound encoding");
                prover.addConstraint(propertyEncoder.encodeBoundEventExec());
                logger.info("Starting second solver.check()");
                res = prover.isUnsat() ? PASS : UNKNOWN;
            } else {
                res = FAIL;
            }

            if (logger.isDebugEnabled()) {
                logProverStatistics(logger, prover);
            }
        } else {
            prover.writeComment("Property encoding");
            prover.addConstraint(propertyEnc);

            logger.info("Starting first solver.check()");
            res = prover.isUnsat() ? UNKNOWN : FAIL;

            if (logger.isDebugEnabled()) {
                logger.info("First SMT query statistics:");
                logProverStatistics(logger, prover);
            }

            if (res == UNKNOWN) {
                // TODO: This second prover does not dump its content into
                //  an smt file: Shall we create a second dump file for this case?
                final ProverWithTracker prover2 = closeOldAndGetNewProver();
                prover2.addConstraint(progEnc);
                prover2.addConstraint(wmmEnc);
                prover2.addConstraint(witnessEnc);
                prover2.addConstraint(symEnc);
                prover2.addConstraint(propertyEncoder.encodeBoundEventExec());
                logger.info("Starting second solver.check()");
                res = prover2.isUnsat() ? PASS : UNKNOWN;

                if (logger.isDebugEnabled()) {
                    logger.info("Second SMT query statistics:");
                    logProverStatistics(logger, prover);
                }
            }
        }

        // For Safety specs, we have SAT=FAIL, but for reachability specs, we have SAT=PASS
        res = Property.getCombinedType(task.getProperty(), task) == Property.Type.SAFETY ? res : res.invert();
        logger.info("Verification finished with result {}", res);
    }

    private ProverWithTracker closeOldAndGetNewProver() {
        if (this.prover != null) {
            prover.close();
        }
        this.prover = new ProverWithTracker(solverContext, "", SolverContext.ProverOptions.GENERATE_MODELS);
        return this.prover;
    }

}