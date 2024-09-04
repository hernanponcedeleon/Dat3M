package com.dat3m.dartagnan.verification.solving;

import com.dat3m.dartagnan.configuration.Baseline;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.encoding.*;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.CAATSolver;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat4wmm.RefinementModel;
import com.dat3m.dartagnan.solver.caat4wmm.WMMSolver;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat4wmm.coreReasoning.CoreLiteral;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat4wmm.OnlineWMMSolver;
import com.dat3m.dartagnan.utils.logic.DNF;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Constraint;
import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.axiom.Acyclicity;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.axiom.Emptiness;
import com.dat3m.dartagnan.wmm.definition.*;
import com.dat3m.dartagnan.wmm.utils.Cut;
import com.google.common.collect.Iterables;
import com.google.common.collect.Lists;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverException;

import java.util.EnumSet;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.configuration.OptionNames.BASELINE;
import static com.dat3m.dartagnan.solver.onlineCaatTest.caat.CAATSolver.Status.CONSISTENT;
import static com.dat3m.dartagnan.solver.onlineCaatTest.caat.CAATSolver.Status.INCONSISTENT;
import static com.dat3m.dartagnan.utils.Result.*;
import static com.dat3m.dartagnan.wmm.RelationNameRepository.*;



/*
    Refinement is a custom solving procedure that starts from a weak memory model (possibly the empty model)
    and iteratively refines it to perform a verification task.
    It can be understood as a lazy offline-SMT solver.
    More concretely, it iteratively
        - finds some assertion-violating execution w.r.t. to some (very weak) baseline memory model
        - checks the consistency of this execution using a custom theory solver (CAAT-Solver)
        - refines the used memory model if the found execution was inconsistent, using the explanations
          provided by the theory solver.
 */
@Options
public class OnlineRefinementSolver extends ModelChecker {

    private static final Logger logger = LogManager.getLogger(OnlineRefinementSolver.class);

    // ================================================================================================================
    // Configuration

    @Option(name=BASELINE,
            description="Refinement starts from this baseline WMM.",
            secure=true,
            toUppercase=true)
    private EnumSet<Baseline> baselines = EnumSet.noneOf(Baseline.class);


    // ================================================================================================================
    // Data classes

    private enum SMTStatus {
        SAT, UNSAT, UNKNOWN
    }

    private record RefinementIteration(
            SMTStatus smtStatus,
            long nativeSmtTime,
            long caatTime,
            long refineTime,
            // The following are only meaningful if <smtStatus>==SAT
            CAATSolver.Status caatStatus,
            BooleanFormula refinementFormula,
            // The following are only for statistics keeping
            WMMSolver.Statistics caatStats,
            DNF<CoreLiteral> inconsistencyReasons,
            List<Event> observedEvents
    ) {
        public boolean isInconclusive() { return smtStatus == SMTStatus.SAT && caatStatus == INCONSISTENT; }
        public boolean isConclusive() { return !isInconclusive(); }
    }

    private record RefinementTrace(List<RefinementIteration> iterations) {
        public RefinementIteration getFinalIteration() { return iterations.get(iterations.size() - 1); }

        public SMTStatus getFinalResult() {
            final RefinementIteration finalIteration = getFinalIteration();
            if (finalIteration.smtStatus != SMTStatus.SAT) {
                return finalIteration.smtStatus;
            } else if (finalIteration.caatStatus == CONSISTENT) {
                return SMTStatus.SAT;
            } else {
                return SMTStatus.UNKNOWN;
            }
        }

        public long getNativeSmtTime() { return iterations.stream().mapToLong(RefinementIteration::nativeSmtTime).sum(); }
        public long getCaatTime() { return iterations.stream().mapToLong(RefinementIteration::caatTime).sum(); }
        public long getRefiningTime() { return iterations.stream().mapToLong(RefinementIteration::refineTime).sum(); }

        public Set<Event> getObservedEvents() {
            return iterations.stream().filter(iter -> iter.observedEvents != null)
                    .flatMap(iter -> iter.observedEvents.stream()).collect(Collectors.toSet());
        }

        public List<BooleanFormula> getRefinementFormulas() {
            return iterations.stream().filter(iter -> iter.refinementFormula != null)
                    .map(RefinementIteration::refinementFormula).toList();
        }

        public RefinementTrace concat(RefinementTrace other) {
            return new RefinementTrace(Lists.newArrayList(Iterables.concat(this.iterations, other.iterations)));
        }
    }

    // ================================================================================================================
    // Refinement solver

    private OnlineRefinementSolver() {
    }

    //TODO: We do not yet use Witness information. The problem is that WitnessGraph.encode() generates
    // constraints on hb, which is not encoded in Refinement.
    //TODO (2): Add possibility for Refinement to handle CAT-properties (it ignores them for now).
    public static OnlineRefinementSolver run(SolverContext ctx, ProverEnvironment prover, VerificationTask task)
            throws InterruptedException, SolverException, InvalidConfigurationException {
        OnlineRefinementSolver solver = new OnlineRefinementSolver();
        task.getConfig().inject(solver);
        logger.info("{}: {}", BASELINE, solver.baselines);
        solver.runInternal(ctx, prover, task);
        return solver;
    }

    private void runInternal(SolverContext ctx, ProverEnvironment prover, VerificationTask task)
            throws InterruptedException, SolverException, InvalidConfigurationException {
        final Program program = task.getProgram();
        final Wmm memoryModel = task.getMemoryModel();
        final Context analysisContext = Context.create();
        final Configuration config = task.getConfig();

        // ------------------------ Preprocessing / Analysis ------------------------

        removeFlaggedAxiomsAndReduce(memoryModel);
        memoryModel.configureAll(config);
        preprocessProgram(task, config);
        preprocessMemoryModel(task, config);

        performStaticProgramAnalyses(task, analysisContext, config);
        // Copy context without WMM analyses because we want to analyse a second model later
        Context baselineContext = Context.createCopyFrom(analysisContext);
        performStaticWmmAnalyses(task, analysisContext, config);

        //  ------- Generate refinement model -------
        final RefinementModel refinementModel = generateRefinementModel(memoryModel);
        final Wmm baselineModel = refinementModel.getBaseModel();
        addBiases(baselineModel, baselines);
        baselineModel.configureAll(config); // Configure after cutting!
        refinementModel.transferKnowledgeFromOriginal(analysisContext.requires(RelationAnalysis.class));
        refinementModel.forceEncodeBoundary();

        final VerificationTask baselineTask = VerificationTask.builder()
                .withConfig(task.getConfig())
                .build(program, baselineModel, task.getProperty());
        performStaticWmmAnalyses(baselineTask, baselineContext, config);

        // ------------------------ Encoding ------------------------

        context = EncodingContext.of(baselineTask, baselineContext, ctx.getFormulaManager());
        final ProgramEncoder programEncoder = ProgramEncoder.withContext(context);
        final PropertyEncoder propertyEncoder = PropertyEncoder.withContext(context);
        // We use the original memory model for symmetry breaking because we need axioms
        // to compute the breaking order.
        final SymmetryEncoder symmetryEncoder = SymmetryEncoder.withContext(context);
        final WmmEncoder baselineEncoder = WmmEncoder.withContext(context);

        final OnlineWMMSolver userPropagator = new OnlineWMMSolver(refinementModel, analysisContext, context);
        final Property.Type propertyType = Property.getCombinedType(task.getProperty(), task);

        logger.info("Starting encoding using " + ctx.getVersion());
        prover.addConstraint(programEncoder.encodeFullProgram());
        prover.addConstraint(baselineEncoder.encodeFullMemoryModel());
        prover.addConstraint(symmetryEncoder.encodeFullSymmetryBreaking());

        prover.registerUserPropagator(userPropagator);

        // ------------------------ Solving ------------------------
        logger.info("Refinement procedure started.");

        logger.info("Checking target property.");
        prover.push();
        prover.addConstraint(propertyEncoder.encodeProperties(task.getProperty()));

        boolean isUnsat = prover.isUnsat();

        logger.info(userPropagator.getTotalStats());

        if (logger.isInfoEnabled()) {
            final String message = !isUnsat ?
                    (propertyType == Property.Type.SAFETY ? "Specification violation found." : "Specification witness found.")
                    : (propertyType == Property.Type.SAFETY ? "Bounded specification proven." : "Bounded specification falsified.");
            logger.info(message);
        }

        long boundCheckTime = 0;
        if (isUnsat) {
            // Do bound check
            logger.info("Checking unrolling bounds.");
            final long lastTime = System.currentTimeMillis();
            prover.pop();
            prover.addConstraint(propertyEncoder.encodeBoundEventExec());
            isUnsat = prover.isUnsat();
            boundCheckTime = System.currentTimeMillis() - lastTime;

            res = isUnsat ? PASS : UNKNOWN;

            if (logger.isInfoEnabled()) {
                final String message = !isUnsat ?
                        "Bounds are reachable: Unbounded specification unknown."
                        : "Bounds are unreachable: Unbounded specification proven.";
                logger.info(message);
            }
        } else {
            res = FAIL;
        }

        // -------------------------- Report statistics summary --------------------------

        if (logger.isInfoEnabled()) {
            //logger.info(generateSummary(combinedTrace, boundCheckTime));
        }

        // TODO: fix stats
        System.out.println(userPropagator.getTotalStats());

        if (logger.isDebugEnabled()) {
            StringBuilder smtStatistics = new StringBuilder("\n ===== SMT Statistics (after final iteration) ===== \n");
            for (String key : prover.getStatistics().keySet()) {
                smtStatistics.append(String.format("\t%s -> %s\n", key, prover.getStatistics().get(key)));
            }
            logger.debug(smtStatistics.toString());
        }

        // For Safety specs, we have SAT=FAIL, but for reachability specs, we have
        // SAT=PASS
        res = propertyType == Property.Type.SAFETY ? res : res.invert();
        logger.info("Verification finished with result " + res);
    }

    // ================================================================================================================
    // Special memory model processing

    private static RefinementModel generateRefinementModel(Wmm original) {
        // We cut (i) negated axioms, (ii) negated relations (if derived),
        // and (iii) some special relations because they are derived from internal relations (like data/addr/ctrl)
        // or because we have no dedicated implementation for them in CAAT (like Linux' rscs).
        final Set<Constraint> constraintsToCut = new HashSet<>();
        for (Constraint c : original.getConstraints()) {
            if (c instanceof Axiom ax && ax.isNegated()) {
                // (i) Negated axioms
                constraintsToCut.add(ax);
            } else if (c instanceof Difference diff) {
                    constraintsToCut.add(c);
            } else if (c instanceof Definition def && def.getDefinedRelation().getDependencies().isEmpty()) {
                // For online solving, we cut all base relations
                constraintsToCut.add(c);
            } else if (c instanceof Definition def && def.getDefinedRelation().hasName()) {
                // (iii) Special relations
                final String name = def.getDefinedRelation().getName().get();
                if (name.equals(DATA) || name.equals(CTRL) || name.equals(ADDR) || name.equals(CRIT)) {
                    constraintsToCut.add(c);
                }
            }
        }

        return RefinementModel.fromCut(Cut.computeInducedCut(original, constraintsToCut));
    }

    private static void addBiases(Wmm memoryModel, EnumSet<Baseline> biases) {
        // FIXME: This can (in theory) add redundant intermediate relations and/or constraints that
        //  already exist in the model.
        final Relation rf = memoryModel.getRelation(RF);
        if (biases.contains(Baseline.UNIPROC)) {
            // ---- acyclic(po-loc | com) ----
            memoryModel.addConstraint(new Acyclicity(memoryModel.addDefinition(new Union(memoryModel.newRelation(),
                    memoryModel.getOrCreatePredefinedRelation(POLOC),
                    rf,
                    memoryModel.getOrCreatePredefinedRelation(CO),
                    memoryModel.getOrCreatePredefinedRelation(FR)))));
        }
        if (biases.contains(Baseline.NO_OOTA)) {
            // ---- acyclic (dep | rf) ----
            memoryModel.addConstraint(new Acyclicity(memoryModel.addDefinition(new Union(memoryModel.newRelation(),
                    memoryModel.getOrCreatePredefinedRelation(CTRL),
                    memoryModel.getOrCreatePredefinedRelation(DATA),
                    memoryModel.getOrCreatePredefinedRelation(ADDR),
                    rf))));
        }
        if (biases.contains(Baseline.ATOMIC_RMW)) {
            // ---- empty (rmw & fre;coe) ----
            Relation rmw = memoryModel.getOrCreatePredefinedRelation(RMW);
            Relation coe = memoryModel.getOrCreatePredefinedRelation(COE);
            Relation fre = memoryModel.getOrCreatePredefinedRelation(FRE);
            Relation frecoe = memoryModel.addDefinition(new Composition(memoryModel.newRelation(), fre, coe));
            Relation rmwANDfrecoe = memoryModel.addDefinition(new Intersection(memoryModel.newRelation(), rmw, frecoe));
            memoryModel.addConstraint(new Emptiness(rmwANDfrecoe));
        }
    }

    private static void removeFlaggedAxiomsAndReduce(Wmm memoryModel) {
        // We remove flagged axioms.
        // NOTE: Theoretically, we could cut them but in practice this causes the whole model to get eagerly encoded,
        // resulting in the worst combination: eagerly encoded model relations + lazy axiom checks.
        // The performance on, e.g., LKMM is horrendous!!!!
        List.copyOf(memoryModel.getAxioms()).stream()
                .filter(Axiom::isFlagged)
                .forEach(memoryModel::removeConstraint);
    }

    // ================================================================================================================
    // Statistics & Debugging

    private static CharSequence generateSummary(RefinementTrace trace, long boundCheckTime) {
        final List<WMMSolver.Statistics> statList = trace.iterations.stream()
                .filter(iter -> iter.caatStats != null).map(RefinementIteration::caatStats).toList();
        final long totalNativeSolvingTime = trace.getNativeSmtTime();
        final long totalCaatTime = trace.getCaatTime();
        final long totalRefiningTime = trace.getRefiningTime();

        long totalModelExtractTime = 0;
        long totalPopulationTime = 0;
        long totalConsistencyCheckTime = 0;
        long totalReasonComputationTime = 0;
        long totalNumReasons = 0;
        long totalNumReducedReasons = 0;
        long totalModelSize = 0;
        long minModelSize = Long.MAX_VALUE;
        long maxModelSize = Long.MIN_VALUE;

        for (WMMSolver.Statistics stats : statList) {
            totalModelExtractTime += stats.getModelExtractionTime();
            totalPopulationTime += stats.getPopulationTime();
            totalConsistencyCheckTime += stats.getConsistencyCheckTime();
            totalReasonComputationTime += stats.getBaseReasonComputationTime() + stats.getCoreReasonComputationTime();
            totalNumReasons += stats.getNumComputedCoreReasons();
            totalNumReducedReasons += stats.getNumComputedReducedCoreReasons();

            totalModelSize += stats.getModelSize();
            minModelSize = Math.min(stats.getModelSize(), minModelSize);
            maxModelSize = Math.max(stats.getModelSize(), maxModelSize);
        }

        StringBuilder message = new StringBuilder().append("Summary").append("\n")
                .append(" ======== Summary ========").append("\n")
                .append("Number of iterations: ").append(trace.iterations.size()).append("\n")
                .append("Total native solving time(ms): ").append(totalNativeSolvingTime + boundCheckTime).append("\n")
                .append("   -- Bound check time(ms): ").append(boundCheckTime).append("\n")
                .append("Total CAAT solving time(ms): ").append(totalCaatTime).append("\n")
                .append("   -- Model extraction time(ms): ").append(totalModelExtractTime).append("\n")
                .append("   -- Population time(ms): ").append(totalPopulationTime).append("\n")
                .append("   -- Consistency check time(ms): ").append(totalConsistencyCheckTime).append("\n")
                .append("   -- Reason computation time(ms): ").append(totalReasonComputationTime).append("\n")
                .append("   -- Refining time(ms): ").append(totalRefiningTime).append("\n")
                .append("   -- #Computed core reasons: ").append(totalNumReasons).append("\n")
                .append("   -- #Computed core reduced reasons: ").append(totalNumReducedReasons).append("\n");
        if (!statList.isEmpty()) {
            message.append("   -- Min model size (#events): ").append(minModelSize).append("\n")
                    .append("   -- Average model size (#events): ").append(totalModelSize / statList.size())
                    .append("\n")
                    .append("   -- Max model size (#events): ").append(maxModelSize).append("\n");
        }

        return message;
    }

}