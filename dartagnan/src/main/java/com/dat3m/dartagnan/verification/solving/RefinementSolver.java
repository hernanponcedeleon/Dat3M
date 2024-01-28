package com.dat3m.dartagnan.verification.solving;

import com.dat3m.dartagnan.configuration.Baseline;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.encoding.*;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.BranchEquivalence;
import com.dat3m.dartagnan.program.analysis.SyntacticContextAnalysis;
import com.dat3m.dartagnan.program.analysis.ThreadSymmetry;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.MemoryEvent;
import com.dat3m.dartagnan.program.event.metadata.OriginalId;
import com.dat3m.dartagnan.program.event.metadata.SourceLocation;
import com.dat3m.dartagnan.program.filter.Filter;
import com.dat3m.dartagnan.solver.caat.CAATSolver;
import com.dat3m.dartagnan.solver.caat4wmm.Refiner;
import com.dat3m.dartagnan.solver.caat4wmm.WMMSolver;
import com.dat3m.dartagnan.solver.caat4wmm.coreReasoning.CoreLiteral;
import com.dat3m.dartagnan.solver.caat4wmm.coreReasoning.RelLiteral;
import com.dat3m.dartagnan.utils.equivalence.EquivalenceClass;
import com.dat3m.dartagnan.utils.logic.Conjunction;
import com.dat3m.dartagnan.utils.logic.DNF;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.verification.model.ExecutionModel;
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
import org.sosy_lab.java_smt.api.*;

import java.text.DecimalFormat;
import java.util.*;
import java.util.function.BiPredicate;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.GlobalSettings.REFINEMENT_GENERATE_GRAPHVIZ_DEBUG_FILES;
import static com.dat3m.dartagnan.GlobalSettings.getOutputDirectory;
import static com.dat3m.dartagnan.configuration.OptionNames.BASELINE;
import static com.dat3m.dartagnan.configuration.OptionNames.COVERAGE;
import static com.dat3m.dartagnan.program.analysis.SyntacticContextAnalysis.*;
import static com.dat3m.dartagnan.solver.caat.CAATSolver.Status.*;
import static com.dat3m.dartagnan.utils.Result.*;
import static com.dat3m.dartagnan.utils.visualization.ExecutionGraphVisualizer.generateGraphvizFile;
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
public class RefinementSolver extends ModelChecker {

    private static final Logger logger = LogManager.getLogger(RefinementSolver.class);

    // ================================================================================================================
    // Configuration

    @Option(name=BASELINE,
            description="Refinement starts from this baseline WMM.",
            secure=true,
            toUppercase=true)
    private EnumSet<Baseline> baselines = EnumSet.noneOf(Baseline.class);

    @Option(name=COVERAGE,
            description="Prints the coverage report (this option requires --method=caat).",
            secure=true,
            toUppercase=true)
    private boolean printCovReport = false;

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

    private RefinementSolver() {
    }

    //TODO: We do not yet use Witness information. The problem is that WitnessGraph.encode() generates
    // constraints on hb, which is not encoded in Refinement.
    //TODO (2): Add possibility for Refinement to handle CAT-properties (it ignores them for now).
    public static RefinementSolver run(SolverContext ctx, ProverEnvironment prover, VerificationTask task)
            throws InterruptedException, SolverException, InvalidConfigurationException {
        RefinementSolver solver = new RefinementSolver();
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

        final BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        final WMMSolver solver = WMMSolver.withContext(context, cutRelations, task, analysisContext);
        final Refiner refiner = new Refiner();
        final Property.Type propertyType = Property.getCombinedType(task.getProperty(), task);

        logger.info("Starting encoding using " + ctx.getVersion());
        prover.addConstraint(programEncoder.encodeFullProgram());
        prover.addConstraint(baselineEncoder.encodeFullMemoryModel());
        prover.addConstraint(symmetryEncoder.encodeFullSymmetryBreaking());

        // ------------------------ Solving ------------------------
        logger.info("Refinement procedure started.");

        logger.info("Checking target property.");
        prover.push();
        prover.addConstraint(propertyEncoder.encodeProperties(task.getProperty()));

        final RefinementTrace propertyTrace = runRefinement(task, prover, solver, refiner);
        SMTStatus smtStatus = propertyTrace.getFinalResult();

        if (logger.isInfoEnabled()) {
            final String message = switch (smtStatus) {
                case UNKNOWN -> "SMT Solver was inconclusive (bug?).";
                case SAT -> propertyType == Property.Type.SAFETY ? "Specification violation found."
                        : "Specification witness found.";
                case UNSAT -> propertyType == Property.Type.SAFETY ? "Bounded specification proven."
                        : "Bounded specification falsified.";
            };
            logger.info(message);
        }

        if (smtStatus == SMTStatus.UNKNOWN) {
            // Refinement got no result (should not be able to happen), so we cannot proceed further.
            res = UNKNOWN;
            return;
        }

        RefinementTrace combinedTrace = propertyTrace;

        long boundCheckTime = 0;
        if (smtStatus == SMTStatus.UNSAT) {
            // Do bound check
            logger.info("Checking unrolling bounds.");
            final long lastTime = System.currentTimeMillis();
            prover.pop();
            prover.addConstraint(propertyEncoder.encodeBoundEventExec());
            // Add back the refinement clauses we already found, hoping that this improves the performance.
            prover.addConstraint(bmgr.and(propertyTrace.getRefinementFormulas()));
            final RefinementTrace boundTrace = runRefinement(task, prover, solver, refiner);
            boundCheckTime = System.currentTimeMillis() - lastTime;

            smtStatus = boundTrace.getFinalResult();
            combinedTrace = combinedTrace.concat(boundTrace);
            res = smtStatus == SMTStatus.UNSAT ? PASS : UNKNOWN;

            if (logger.isInfoEnabled()) {
                final String message = switch (smtStatus) {
                    case UNKNOWN -> "Bound check was inconclusive (bug?)";
                    case SAT -> "Bounds are reachable: Unbounded specification unknown.";
                    case UNSAT -> "Bounds are unreachable: Unbounded specification proven.";
                };
                logger.info(message);
            }
        } else {
            res = FAIL;
        }

        // -------------------------- Report statistics summary --------------------------

        if (logger.isInfoEnabled()) {
            logger.info(generateSummary(combinedTrace, boundCheckTime));
        }

        if (logger.isDebugEnabled()) {
            StringBuilder smtStatistics = new StringBuilder("\n ===== SMT Statistics (after final iteration) ===== \n");
            for (String key : prover.getStatistics().keySet()) {
                smtStatistics.append(String.format("\t%s -> %s\n", key, prover.getStatistics().get(key)));
            }
            logger.debug(smtStatistics.toString());
        }

        if (printCovReport) {
            System.out.println(generateCoverageReport(combinedTrace.getObservedEvents(), program, analysisContext));
        }

        // For Safety specs, we have SAT=FAIL, but for reachability specs, we have
        // SAT=PASS
        res = propertyType == Property.Type.SAFETY ? res : res.invert();
        logger.info("Verification finished with result " + res);
    }

    // ================================================================================================================
    // Refinement core algorithm

    // TODO: We could expose the following method(s) to allow for more general application of refinement.
    private RefinementTrace runRefinement(VerificationTask task, ProverEnvironment prover, WMMSolver solver, Refiner refiner)
            throws SolverException, InterruptedException {

        final List<RefinementIteration> trace = new ArrayList<>();
        boolean isFinalIteration = false;
        while (!isFinalIteration) {

            final RefinementIteration iteration = doRefinementIteration(prover, solver, refiner);
            trace.add(iteration);
            isFinalIteration = iteration.isConclusive();

            // ------------------------- Debugging/Logging -------------------------
            if (REFINEMENT_GENERATE_GRAPHVIZ_DEBUG_FILES) {
                generateGraphvizFiles(task, solver.getExecution(), trace.size(), iteration.inconsistencyReasons);
            }
            if (logger.isDebugEnabled()) {
                // ---- Internal SMT stats after the first iteration ----
                if (trace.size() == 1) {
                    StringBuilder smtStatistics = new StringBuilder(
                            "\n ===== SMT Statistics (after first iteration) ===== \n");
                    for (String key : prover.getStatistics().keySet()) {
                        smtStatistics.append(String.format("\t%s -> %s\n", key, prover.getStatistics().get(key)));
                    }
                    logger.debug(smtStatistics);
                }

                // ---- Debug iteration stats ----
                final StringBuilder debugMessage = new StringBuilder();
                debugMessage.append("\n").append(String.format("""
                        ===== Solver iteration: %d =====
                        Native solving time(ms): %s
                        """, trace.size(), iteration.nativeSmtTime));
                if (!isFinalIteration) {
                    debugMessage.append(iteration.caatStats);
                }
                logger.debug(debugMessage);

                // ---- Trace iteration stats ----
                if (logger.isTraceEnabled() && !isFinalIteration) {
                    final StringBuilder traceMessage = new StringBuilder().append("Found inconsistency reasons:\n");
                    for (Conjunction<CoreLiteral> cube : iteration.inconsistencyReasons.getCubes()) {
                        traceMessage.append(cube).append("\n");
                    }
                    logger.trace(traceMessage);
                }
            }
        }

        return new RefinementTrace(trace);
    }

    private RefinementIteration doRefinementIteration(ProverEnvironment prover, WMMSolver solver, Refiner refiner)
            throws SolverException, InterruptedException {

        long nativeTime = 0;
        long caatTime = 0;
        long refineTime = 0;
        CAATSolver.Status caatStatus = INCONCLUSIVE;
        BooleanFormula refinementFormula = null;
        WMMSolver.Statistics caatStats = null;
        DNF<CoreLiteral> inconsistencyReasons = null;
        List<Event> observedEvents = null;

        // ------------ Native SMT solving ------------
        long lastTime = System.currentTimeMillis();
        final SMTStatus smtStatus = prover.isUnsat() ? SMTStatus.UNSAT : SMTStatus.SAT;
        nativeTime = (System.currentTimeMillis() - lastTime);

        if (smtStatus == SMTStatus.SAT) {
            // ------------ CAAT solving ------------
            lastTime = System.currentTimeMillis();
            final WMMSolver.Result solverResult;
            try (Model model = prover.getModel()) {
                solverResult = solver.check(model);
            } catch (SolverException e) {
                logger.error(e);
                throw e;
            }
            caatTime = (System.currentTimeMillis() - lastTime);

            observedEvents = new ArrayList<>(Lists.transform(solver.getExecution().getEventList(), EventData::getEvent));
            caatStatus = solverResult.getStatus();
            caatStats = solverResult.getStatistics();
            if (caatStatus == INCONSISTENT) {
                // ------------ Refining ------------
                inconsistencyReasons = solverResult.getCoreReasons();
                lastTime = System.currentTimeMillis();
                refinementFormula = refiner.refine(inconsistencyReasons, context);
                prover.addConstraint(refinementFormula);
                refineTime = (System.currentTimeMillis() - lastTime);
            }
        }

        return new RefinementIteration(
                smtStatus, nativeTime, caatTime, refineTime, caatStatus,
                refinementFormula, caatStats, inconsistencyReasons, observedEvents
        );
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

    private static CharSequence generateCoverageReport(Set<Event> coveredEvents, Program program,
                                                       Context analysisContext) {
        // We track symmetric events
        final ThreadSymmetry symm = analysisContext.requires(ThreadSymmetry.class);
        final BranchEquivalence cf = analysisContext.requires(BranchEquivalence.class);

        final Set<Event> programEvents = program.getThreadEvents(MemoryEvent.class).stream()
                // TODO: Can we have events with source information but without oid?
                .filter(e -> e.hasMetadata(SourceLocation.class) && e.hasMetadata(OriginalId.class))
                .collect(Collectors.toSet());
        
        // Track (covered) events and branches via oId
        final Set<OriginalId> branches = new HashSet<>();
        final Set<OriginalId> coveredBranches = new HashSet<>();

        // Events not executed in any violating execution
        final Set<String> messageSet = new TreeSet<>(); // TreeSet to keep strings in order
        
        final SyntacticContextAnalysis synContext = newInstance(program);

        for (Event e : programEvents) {
            EquivalenceClass<Thread> clazz = symm.getEquivalenceClass(e.getThread());
            Event symmRep = symm.map(e, clazz.getRepresentative());
            OriginalId branchRepId = cf.getRepresentative(symmRep).getMetadata(OriginalId.class);
            assert branchRepId != null;

            if(coveredEvents.contains(e)) {
                coveredBranches.add(branchRepId);
            } else {
                final String threads = clazz.stream().map(t -> "T" + t.getId())
                        .collect(Collectors.joining(" / "));
                final String callStack = makeContextString(
                            synContext.getContextInfo(e).getContextOfType(CallContext.class), " -> ");
                messageSet.add(String.format("%s: %s%s", threads,
                        callStack.isEmpty() ? callStack : callStack + " -> ",
                        getSourceLocationString(symmRep)));
            }
            branches.add(branchRepId);
        }

        // When using the % symbol, the value multiplied by 100 before applying the format string. 
        DecimalFormat df = new DecimalFormat("#.##%");
        // messageSet contains the missing ones, thus the 100 - X ...
        final double eventCoveragePercentage = 1d - (messageSet.size() * 1d / programEvents.size());
        final double branchCoveragePercentage = coveredBranches.size() * 1d / branches.size();

        final StringBuilder report = new StringBuilder()
                .append("Events executed by at least one property-violating behavior, including inconsistent executions: \n")
                .append("\t-- Events: ")
                .append(String.format("%s (%s / %s)", df.format(eventCoveragePercentage),
                        programEvents.size() - messageSet.size(), programEvents.size()))
                .append("\n")
                .append("\t-- Branches: ")
                .append(String.format("%s (%s / %s)", df.format(branchCoveragePercentage), coveredBranches.size(),
                        branches.size()))
                .append("\n");
        if (eventCoveragePercentage < 1d) {
            report.append("\t-- Missing events: \n");
            messageSet.forEach(s -> report.append("\t\t").append(s).append("\n"));
        }

        return report;
    }

    // This code is pure debugging code that will generate graphical representations
    // of each refinement iteration.
    // Generate .dot files and .png files per iteration
    private static void generateGraphvizFiles(VerificationTask task, ExecutionModel model, int iterationCount,
            DNF<CoreLiteral> reasons) {
        // =============== Visualization code ==================
        // The edgeFilter filters those co/rf that belong to some violation reason
        BiPredicate<EventData, EventData> edgeFilter = (e1, e2) -> {
            for (Conjunction<CoreLiteral> cube : reasons.getCubes()) {
                for (CoreLiteral lit : cube.getLiterals()) {
                    if (lit instanceof RelLiteral edgeLit) {
                        if (model.getData(edgeLit.getData().first()).get() == e1 &&
                                model.getData(edgeLit.getData().second()).get() == e2) {
                            return true;
                        }
                    }
                }
            }
            return false;
        };

        String programName = task.getProgram().getName();
        programName = programName.substring(0, programName.lastIndexOf("."));
        String directoryName = String.format("%s/refinement/%s-%s-debug/", getOutputDirectory(), programName,
                task.getProgram().getArch());
        String fileNameBase = String.format("%s-%d", programName, iterationCount);
        final SyntacticContextAnalysis emptySynContext = getEmptyInstance();
        // File with reason edges only
        generateGraphvizFile(model, iterationCount, edgeFilter, edgeFilter, edgeFilter, directoryName, fileNameBase,
                emptySynContext);
        // File with all edges
        generateGraphvizFile(model, iterationCount, (x, y) -> true, (x, y) -> true, (x, y) -> true, directoryName,
                fileNameBase + "-full", emptySynContext);
    }
}