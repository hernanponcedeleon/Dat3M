package com.dat3m.dartagnan.verification.solving;

import com.dat3m.dartagnan.configuration.Baseline;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.encoding.*;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.filter.Filter;
import com.dat3m.dartagnan.solver.caat.CAATSolver;
import com.dat3m.dartagnan.solver.caat4wmm.WMMSolver;
import com.dat3m.dartagnan.solver.caat4wmm.coreReasoning.CoreLiteral;
import com.dat3m.dartagnan.solver.onlineCaat.OnlineWMMSolver;
import com.dat3m.dartagnan.utils.logic.DNF;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Assumption;
import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.axiom.Acyclic;
import com.dat3m.dartagnan.wmm.axiom.Empty;
import com.dat3m.dartagnan.wmm.axiom.ForceEncodeAxiom;
import com.dat3m.dartagnan.wmm.definition.*;
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

import java.util.*;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.configuration.OptionNames.BASELINE;
import static com.dat3m.dartagnan.solver.caat.CAATSolver.Status.CONSISTENT;
import static com.dat3m.dartagnan.solver.caat.CAATSolver.Status.INCONSISTENT;
import static com.dat3m.dartagnan.utils.Result.*;
import static com.dat3m.dartagnan.wmm.RelationNameRepository.*;

;

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
        final Wmm baselineModel = createDefaultWmm();
        final Context analysisContext = Context.create();
        final Configuration config = task.getConfig();
        final VerificationTask baselineTask = VerificationTask.builder()
                .withConfig(task.getConfig())
                .build(program, baselineModel, task.getProperty());

        for (Relation rel : memoryModel.getRelations()) {
            if (!rel.isInternal() && rel.getDependencies().stream().allMatch(Relation::isInternal)) {
                getCopyOfRelation(rel, baselineModel);
            }
        }

        // ------------------------ Preprocessing / Analysis ------------------------

        preprocessProgram(task, config);
        preprocessMemoryModel(task);
        // We cut the rhs of differences to get a semi-positive model, if possible.
        // This call modifies the baseline model!
        Set<Relation> cutRelations = cutRelationDifferences(memoryModel, baselineModel);
        memoryModel.configureAll(config);
        baselineModel.configureAll(config); // Configure after cutting!

        performStaticProgramAnalyses(task, analysisContext, config);
        Context baselineContext = Context.createCopyFrom(analysisContext);
        performStaticWmmAnalyses(task, analysisContext, config);
        // Transfer knowledge from target model to baseline model
        final RelationAnalysis ra = analysisContext.requires(RelationAnalysis.class);
        for (Relation baselineRelation : baselineModel.getRelations()) {
            String name = baselineRelation.getNameOrTerm();
            memoryModel.getRelations().stream()
                    .filter(r -> name.equals(r.getNameOrTerm()))
                    .map(ra::getKnowledge)
                    .map(k -> new Assumption(baselineRelation, k.getMaySet(), k.getMustSet()))
                    .forEach(baselineModel::addConstraint);
        }
        performStaticWmmAnalyses(baselineTask, baselineContext, config);

        // ------------------------ Encoding ------------------------

        context = EncodingContext.of(baselineTask, baselineContext, ctx.getFormulaManager());
        final ProgramEncoder programEncoder = ProgramEncoder.withContext(context);
        final PropertyEncoder propertyEncoder = PropertyEncoder.withContext(context);
        // We use the original memory model for symmetry breaking because we need axioms
        // to compute the breaking order.
        final SymmetryEncoder symmetryEncoder = SymmetryEncoder.withContext(context);
        final WmmEncoder baselineEncoder = WmmEncoder.withContext(context);

        final OnlineWMMSolver userPropagator = new OnlineWMMSolver(task, context, analysisContext, cutRelations);
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

    // This method cuts off negated relations that are dependencies of some
    // consistency axiom. It ignores dependencies of flagged axioms, as those get
    // eagerly encoded and can be completely ignored for Refinement.
    private static Set<Relation> cutRelationDifferences(Wmm targetWmm, Wmm baselineWmm) {
        // TODO: Add support to move flagged axioms to the baselineWmm
        Set<Relation> cutRelations = new HashSet<>();
        Set<Relation> cutCandidates = new HashSet<>();
        int cutCounter = 0;
        targetWmm.getAxioms().stream().filter(ax -> !ax.isFlagged())
                .forEach(ax -> collectDependencies(ax.getRelation(), cutCandidates));
        for (Relation rel : cutCandidates) {
            if (rel.getDefinition() instanceof Difference) {
                Relation sec = ((Difference) rel.getDefinition()).complement;
                if (!sec.getDependencies().isEmpty() || sec.getDefinition() instanceof Identity
                        || sec.getDefinition() instanceof CartesianProduct) {
                    // NOTE: The check for RelSetIdentity/RelCartesian is needed because they appear
                    // non-derived in our Wmm but for CAAT they are derived from unary predicates!
                    logger.info("Found difference {}. Cutting rhs relation {}", rel, sec);
                    cutRelations.add(sec);
                    Relation baselineCopy = getCopyOfRelation(sec, baselineWmm);
                    baselineWmm.addConstraint(new ForceEncodeAxiom(baselineCopy));
                    // We give the cut relations new aliases in the original and the baseline wmm
                    // so that we can match them later by name.
                    targetWmm.addAlias("cut#" + cutCounter, sec);
                    baselineWmm.addAlias("cut#" + cutCounter, baselineCopy);
                    cutCounter++;
                }
            }
        }
        return cutRelations;
    }

    private static void collectDependencies(Relation root, Set<Relation> collected) {
        if (collected.add(root)) {
            root.getDependencies().forEach(dep -> collectDependencies(dep, collected));
        }
    }

    private static Relation getCopyOfRelation(Relation rel, Wmm m) {
        Optional<String> name = rel.getName();
        if (name.isPresent() && m.containsRelation(name.get())) {
            return m.getRelation(name.get());
        }
        Relation copy = name.map(m::newRelation).orElseGet(m::newRelation);
        return m.addDefinition(rel.getDefinition().accept(new RelationCopier(m, copy)));
    }

    private static final class RelationCopier implements Definition.Visitor<Definition> {
        final Wmm targetModel;
        final Relation relation;

        RelationCopier(Wmm m, Relation r) {
            targetModel = m;
            relation = r;
        }

        @Override public Definition visitUnion(Relation r, Relation... o) { return new Union(relation, copy(o)); }
        @Override public Definition visitIntersection(Relation r, Relation... o) { return new Intersection(relation, copy(o)); }
        @Override public Definition visitDifference(Relation r, Relation r1, Relation r2) { return new Difference(relation, copy(r1), copy(r2)); }
        @Override public Definition visitComposition(Relation r, Relation r1, Relation r2) { return new Composition(relation, copy(r1), copy(r2)); }
        @Override public Definition visitInverse(Relation r, Relation r1) { return new Inverse(relation, copy(r1)); }
        @Override public Definition visitDomainIdentity(Relation r, Relation r1) { return new DomainIdentity(relation, copy(r1)); }
        @Override public Definition visitRangeIdentity(Relation r, Relation r1) { return new RangeIdentity(relation, copy(r1)); }
        @Override public Definition visitTransitiveClosure(Relation r, Relation r1) { return new TransitiveClosure(relation, copy(r1)); }
        @Override public Definition visitIdentity(Relation r, Filter filter) { return new Identity(relation, filter); }
        @Override public Definition visitProduct(Relation r, Filter f1, Filter f2) { return new CartesianProduct(relation, f1, f2); }
        @Override public Definition visitFences(Relation r, Filter type) { return new Fences(relation, type); }

        private Relation copy(Relation r) { return getCopyOfRelation(r, targetModel); }
        private Relation[] copy(Relation[] r) {
            Relation[] a = new Relation[r.length];
            for (int i = 0; i < r.length; i++) {
                a[i] = copy(r[i]);
            }
            return a;
        }
    }

    private Wmm createDefaultWmm() {
        Wmm baseline = new Wmm();
        Relation rf = baseline.getRelation(RF);
        if (baselines.contains(Baseline.UNIPROC)) {
            // ---- acyclic(po-loc | com) ----
            baseline.addConstraint(new Acyclic(baseline.addDefinition(new Union(baseline.newRelation(),
                    baseline.getRelation(POLOC),
                    rf,
                    baseline.getRelation(CO),
                    baseline.getRelation(FR)))));
        }
        if (baselines.contains(Baseline.NO_OOTA)) {
            // ---- acyclic (dep | rf) ----
            baseline.addConstraint(new Acyclic(baseline.addDefinition(new Union(baseline.newRelation(),
                    baseline.getRelation(CTRL),
                    baseline.getRelation(DATA),
                    baseline.getRelation(ADDR),
                    rf))));
        }
        if (baselines.contains(Baseline.ATOMIC_RMW)) {
            // ---- empty (rmw & fre;coe) ----
            Relation rmw = baseline.getRelation(RMW);
            Relation coe = baseline.getRelation(COE);
            Relation fre = baseline.getRelation(FRE);
            Relation frecoe = baseline.addDefinition(new Composition(baseline.newRelation(), fre, coe));
            Relation rmwANDfrecoe = baseline.addDefinition(new Intersection(baseline.newRelation(), rmw, frecoe));
            baseline.addConstraint(new Empty(rmwANDfrecoe));
        }
        return baseline;
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