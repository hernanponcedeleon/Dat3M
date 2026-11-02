package com.dat3m.dartagnan.task.verification;

import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.encoding.*;
import com.dat3m.dartagnan.smt.ProverWithTracker;
import com.dat3m.dartagnan.solver.propagators.AcyclicityPropagator;
import com.dat3m.dartagnan.solver.propagators.PathAutomaton;
import com.dat3m.dartagnan.solver.propagators.PathShapePropagator;
import com.dat3m.dartagnan.task.Context;
import com.dat3m.dartagnan.task.SMTModelChecker;
import com.dat3m.dartagnan.task.Task;
import com.dat3m.dartagnan.wmm.Constraint;
import com.dat3m.dartagnan.wmm.axiom.Acyclicity;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.axiom.Irreflexivity;
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
import org.sosy_lab.java_smt.basicimpl.AbstractUserPropagator;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static com.dat3m.dartagnan.configuration.OptionNames.*;
import static com.dat3m.dartagnan.task.verification.VerificationStatus.*;
import static java.util.Collections.singletonList;

/*
    Eager SMT encoding where (some) acyclicity/irreflexivity axioms are not encoded but handled by a
    user propagator instead (requires Z3).
 */
@Options
public class PropagatorSolver extends SMTModelChecker<VerificationTask> implements Verifier {

    private static final Logger logger = LoggerFactory.getLogger(PropagatorSolver.class);

    @Option(name = PROPAGATOR_MAX_AUTOMATON_STATES,
            description = "Maximal number of automaton states for an axiom to be handled by the path shape propagator.",
            secure = true)
    private int maxAutomatonStates = 4;

    @Option(name = PROPAGATOR_IRREFLEXIVITY,
            description = "Handle irreflexivity axioms (and not only acyclicity axioms) with the propagator.",
            secure = true)
    private boolean propagateIrreflexivity = true;

    @Option(name = PROPAGATOR_LEGACY_ACYCLICITY,
            description = "Use the (non-unfolding) acyclicity propagator instead of the path shape propagator.",
            secure = true)
    private boolean useLegacyAcyclicityPropagator = true;

    private PropagatorSolver(VerificationTask task) throws InvalidConfigurationException {
        super(task);
        task.getConfig().inject(this);
    }

    public static PropagatorSolver create(VerificationTask task) throws InvalidConfigurationException {
        return new PropagatorSolver(task);
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

        // ---- Select the axioms to propagate ----
        // <constraintsToEncode> are the roots of the encoding; their dependencies get encoded as well.
        // For propagated axioms, we encode only the (definitions of the) relations the propagator works on,
        // otherwise their edge variables would be unconstrained.
        final List<Constraint> constraintsToEncode = new ArrayList<>();
        final List<PathAutomaton> shapesToPropagate = new ArrayList<>();
        final List<Acyclicity> legacyAxiomsToPropagate = new ArrayList<>();
        for (Axiom axiom : task.getMemoryModel().getAxioms()) {
            if (useLegacyAcyclicityPropagator) {
                if (axiom instanceof Acyclicity acyc && !acyc.isFlagged() && !acyc.isNegated()) {
                    legacyAxiomsToPropagate.add(acyc);
                    constraintsToEncode.add(acyc.getRelation().getDefinition());
                    continue;
                }
            } else if (axiom instanceof Acyclicity || (propagateIrreflexivity && axiom instanceof Irreflexivity)) {
                final Optional<PathAutomaton> shape = PathAutomaton.fromAxiom(axiom, maxAutomatonStates);
                if (shape.isPresent()) {
                    shapesToPropagate.add(shape.get());
                    shape.get().getAlphabet().forEach(atom -> constraintsToEncode.add(atom.getDefinition()));
                    continue;
                }
                logger.info("Axiom '{}' is not supported by the propagator and gets encoded instead.", axiom);
            }
            constraintsToEncode.add(axiom);
        }

        EncodingContext context = EncodingContext.of(task, analysisContext, solverContext.getFormulaManager(), constraintsToEncode);
        ProgramEncoder programEncoder = ProgramEncoder.withContext(context);
        WmmEncoder wmmEncoder = WmmEncoder.withContext(context);
        PropertyEncoder propertyEncoder = PropertyEncoder.withContext(context, wmmEncoder);
        SymmetryEncoder symmetryEncoder = SymmetryEncoder.withContext(context);

        final AbstractUserPropagator userPropagator;
        final Runnable printPropagatorStatistics;
        if (useLegacyAcyclicityPropagator) {
            logger.info("Propagating axioms: {}", legacyAxiomsToPropagate);
            final AcyclicityPropagator propagator = new AcyclicityPropagator(wmmEncoder, context);
            legacyAxiomsToPropagate.forEach(propagator::registerAxiom);
            userPropagator = propagator;
            printPropagatorStatistics = propagator::printStatistics;
        } else {
            logger.info("Propagating axioms: {}", shapesToPropagate.stream().map(PathAutomaton::getAxiom).toList());
            final PathShapePropagator propagator = new PathShapePropagator(wmmEncoder, context, shapesToPropagate);
            userPropagator = propagator;
            printPropagatorStatistics = propagator::printStatistics;
        }

        logger.info("Starting encoding using {}", solverContext.getVersion());
        prover.writeComment("Program encoding");
        prover.addConstraint(programEncoder.encodeFullProgram());
        prover.writeComment("Memory model encoding");
        prover.addConstraint(wmmEncoder.encodeFullMemoryModel());
        prover.writeComment("Symmetry breaking encoding");
        prover.addConstraint(symmetryEncoder.encodeFullSymmetryBreaking());

        BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        // Adding bounds
        prover.writeComment("Bounds over variables");
        prover.addConstraint(programEncoder.encodeBounds());
        BooleanFormula assumptionLiteral = bmgr.makeVariable("DAT3M_spec_assumption");
        BooleanFormula propertyEncoding = propertyEncoder.encodeProperties(task.getProperties());
        BooleanFormula assumedSpec = bmgr.implication(assumptionLiteral, propertyEncoding);
        prover.writeComment("Property encoding");
        prover.addConstraint(assumedSpec);

        // NOTE: The propagator must be registered only after the encoding is added.
        //  Registering a user propagator makes Z3 configure its SMT core immediately, based on the formulas
        //  asserted so far. With no formulas, it falls back to a generic configuration (e.g. with relevancy
        //  propagation enabled), which slows down the search considerably (2-3x in our experiments).
        prover.registerUserPropagator(userPropagator);

        checkForInterrupts();

        logger.info("Starting first solver.check()");
        VerificationStatus res;
        if (prover.isUnsatWithAssumptions(singletonList(assumptionLiteral))) {
            checkForInterrupts();
            prover.writeComment("Bound encoding");
            prover.addConstraint(programEncoder.encodeBoundEventExec());
            logger.info("Starting second solver.check()");
            res = prover.isUnsat() ? PASS : UNKNOWN;
        } else {
            res = FAIL;
        }

        printPropagatorStatistics.run();

        logProverStatistics(logger, prover);
        checkForInterrupts();

        final IREvaluator model = (res != PASS) ? context.newEvaluator(prover) : null;
        // For Safety specs, we have SAT=FAIL, but for reachability specs, we have SAT=PASS
        res = Property.getCombinedType(task.getProperties(), task) == Property.Type.SAFETY ? res : res.invert();

        logger.info("Verification finished with result {}", res);
        return new VerificationResult(task, res, model);
    }
}
