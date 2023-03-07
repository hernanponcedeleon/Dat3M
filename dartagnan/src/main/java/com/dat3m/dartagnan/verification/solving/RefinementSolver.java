package com.dat3m.dartagnan.verification.solving;

import com.dat3m.dartagnan.configuration.Baseline;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.encoding.*;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.BranchEquivalence;
import com.dat3m.dartagnan.program.analysis.ThreadSymmetry;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.MemEvent;
import com.dat3m.dartagnan.program.filter.FilterAbstract;
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
import static com.dat3m.dartagnan.configuration.OptionNames.BASELINE;
import static com.dat3m.dartagnan.configuration.OptionNames.COVERAGE;
import static com.dat3m.dartagnan.solver.caat.CAATSolver.Status.INCONCLUSIVE;
import static com.dat3m.dartagnan.solver.caat.CAATSolver.Status.INCONSISTENT;
import static com.dat3m.dartagnan.utils.Result.*;
import static com.dat3m.dartagnan.utils.visualization.ExecutionGraphVisualizer.generateGraphvizFile;
import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.*;

;

/*
    Refinement is a custom solving procedure that starts from a weak memory model (possibly the empty model)
    and iteratively refines it to perform a verification task.
    It can be understood as a lazy offline-SMT solver.
    More concretely, it iteratively:
        - Finds some assertion-violating execution w.r.t. to some (very weak) baseline memory model
        - Checks the consistency of this execution using a custom theory solver (CAAT-Solver)
        - Refines the used memory model if the found execution was inconsistent, using the explanations
          provided by the theory solver.
 */
@Options
public class RefinementSolver extends ModelChecker {

    private static final Logger logger = LogManager.getLogger(RefinementSolver.class);

    private final SolverContext ctx;
    private final ProverEnvironment prover;
    private final VerificationTask task;

    // =========================== Configurables ===========================

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

    // ======================================================================

    private RefinementSolver(SolverContext c, ProverEnvironment p, VerificationTask t) {
        ctx = c;
        prover = p;
        task = t;
    }

    //TODO: We do not yet use Witness information. The problem is that WitnessGraph.encode() generates
    // constraints on hb, which is not encoded in Refinement.
    //TODO (2): Add possibility for Refinement to handle CAT-properties (it ignores them for now).
    public static RefinementSolver run(SolverContext ctx, ProverEnvironment prover, VerificationTask task)
            throws InterruptedException, SolverException, InvalidConfigurationException {
        RefinementSolver solver = new RefinementSolver(ctx, prover, task);
        task.getConfig().inject(solver);
        logger.info("{}: {}", BASELINE, solver.baselines);
        solver.run();
        return solver;
    }

    private void run() throws InterruptedException, SolverException, InvalidConfigurationException {

        Program program = task.getProgram();
        Wmm memoryModel = task.getMemoryModel();
        Wmm baselineModel = createDefaultWmm();
        Context analysisContext = Context.create();
        Configuration config = task.getConfig();
        VerificationTask baselineTask = VerificationTask.builder()
                .withConfig(task.getConfig()).build(program, baselineModel, task.getProperty());

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
        RelationAnalysis ra = analysisContext.requires(RelationAnalysis.class);
        for (Relation baselineRelation : baselineModel.getRelations()) {
            String name = baselineRelation.getNameOrTerm();
            memoryModel.getRelations().stream()
                    .filter(r -> name.equals(r.getNameOrTerm()))
                    .map(ra::getKnowledge)
                    .map(k -> new Assumption(baselineRelation, k.getMaySet(), k.getMustSet()))
                    .forEach(baselineModel::addConstraint);
        }
        performStaticWmmAnalyses(baselineTask, baselineContext, config);

        context = EncodingContext.of(baselineTask, baselineContext, ctx.getFormulaManager());
        ProgramEncoder programEncoder = ProgramEncoder.withContext(context);
        PropertyEncoder propertyEncoder = PropertyEncoder.withContext(context);
        // We use the original memory model for symmetry breaking because we need axioms
        // to compute the breaking order.
        SymmetryEncoder symmetryEncoder = SymmetryEncoder.withContext(context);
        WmmEncoder baselineEncoder = WmmEncoder.withContext(context);

        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        WMMSolver solver = WMMSolver.withContext(context, cutRelations, task, analysisContext);
        Refiner refiner = new Refiner(analysisContext);
        CAATSolver.Status status = INCONSISTENT;
        Property.Type propertyType = Property.getCombinedType(task.getProperty(), task);

        logger.info("Starting encoding using " + ctx.getVersion());
        prover.addConstraint(programEncoder.encodeFullProgram());
        prover.addConstraint(baselineEncoder.encodeFullMemoryModel());
        prover.addConstraint(symmetryEncoder.encodeFullSymmetryBreaking());

        prover.push();
        prover.addConstraint(propertyEncoder.encodeProperties(task.getProperty()));

        // ------ Just for statistics ------
        List<WMMSolver.Statistics> statList = new ArrayList<>();
        Set<Event> coveredEvents = new HashSet<>(); // For "coverage" report
        int iterationCount = 0;
        long lastTime = System.currentTimeMillis();
        long curTime;
        long totalNativeSolvingTime = 0;
        long totalCaatTime = 0;
        long totalRefiningTime = 0;
        // ---------------------------------
        List<BooleanFormula> globalRefinement = new ArrayList<>();
        logger.info("Refinement procedure started.");
        while (!prover.isUnsat()) {
            if (iterationCount == 0 && logger.isDebugEnabled()) {
                StringBuilder smtStatistics = new StringBuilder(
                        "\n ===== SMT Statistics (after first iteration) ===== \n");
                for (String key : prover.getStatistics().keySet()) {
                    smtStatistics.append(String.format("\t%s -> %s\n", key, prover.getStatistics().get(key)));
                }
                logger.debug(smtStatistics.toString());
            }
            iterationCount++;
            curTime = System.currentTimeMillis();
            totalNativeSolvingTime += (curTime - lastTime);

            logger.debug("Solver iteration: \n" +
                    " ===== Iteration: {} =====\n" +
                    "Solving time(ms): {}", iterationCount, curTime - lastTime);

            curTime = System.currentTimeMillis();
            WMMSolver.Result solverResult;
            try (Model model = prover.getModel()) {
                solverResult = solver.check(model);
            } catch (SolverException e) {
                logger.error(e);
                throw e;
            }

            WMMSolver.Statistics stats = solverResult.getStatistics();
            statList.add(stats);
            coveredEvents.addAll(Lists.transform(solver.getExecution().getEventList(), EventData::getEvent));
            logger.debug("Refinement iteration:\n{}", stats);

            status = solverResult.getStatus();
            if (status == INCONSISTENT) {
                long refineTime = System.currentTimeMillis();
                DNF<CoreLiteral> reasons = solverResult.getCoreReasons();
                BooleanFormula refinement = refiner.refine(reasons, context);
                prover.addConstraint(refinement);
                globalRefinement.add(refinement); // Track overall refinement progress
                totalRefiningTime += (System.currentTimeMillis() - refineTime);

                if (REFINEMENT_GENERATE_GRAPHVIZ_DEBUG_FILES) {
                    generateGraphvizFiles(task, solver.getExecution(), iterationCount, reasons);
                }
                if (logger.isTraceEnabled()) {
                    // Some statistics
                    StringBuilder message = new StringBuilder().append("Found inconsistency reasons:");
                    for (Conjunction<CoreLiteral> cube : reasons.getCubes()) {
                        message.append("\n").append(cube);
                    }
                    logger.trace(message);
                }
            } else {
                // No inconsistencies found, we can't refine
                break;
            }
            totalCaatTime += (System.currentTimeMillis() - curTime);
            lastTime = System.currentTimeMillis();
        }
        iterationCount++;
        curTime = System.currentTimeMillis();
        totalNativeSolvingTime += (curTime - lastTime);

        logger.debug("Final solver iteration:\n" +
                " ===== Final Iteration: {} =====\n" +
                "Native Solving/Proof time(ms): {}", iterationCount, curTime - lastTime);

        if (logger.isInfoEnabled()) {
            String message;
            switch (status) {
                case INCONCLUSIVE:
                    message = "CAAT Solver was inconclusive (bug?).";
                    break;
                case CONSISTENT:
                    message = propertyType == Property.Type.SAFETY ? "Specification violation found."
                            : "Specification witness found.";
                    break;
                case INCONSISTENT:
                    message = propertyType == Property.Type.SAFETY ? "Bounded specification proven."
                            : "Bounded specification falsified.";
                    break;
                default:
                    throw new IllegalStateException("Unknown result type returned by CAAT Solver.");
            }
            logger.info(message);
        }

        if (status == INCONCLUSIVE) {
            // CAATSolver got no result (should not be able to happen), so we cannot proceed
            // further.
            res = UNKNOWN;
            return;
        }

        long boundCheckTime = 0;
        if (prover.isUnsat()) {
            // ------- CHECK BOUNDS -------
            lastTime = System.currentTimeMillis();
            prover.pop();
            // Add bound check
            prover.addConstraint(propertyEncoder.encodeBoundEventExec());
            // Add back the constraints found during Refinement
            // TODO: We actually need to perform a second refinement to check for bound reachability
            // This is needed for the seqlock.c benchmarks!
            prover.addConstraint(bmgr.and(globalRefinement));
            res = !prover.isUnsat() ? UNKNOWN : PASS;
            boundCheckTime = System.currentTimeMillis() - lastTime;
        } else {
            res = FAIL;
        }

        if (logger.isInfoEnabled()) {
            logger.info(generateSummary(statList, iterationCount, totalNativeSolvingTime,
                    totalCaatTime, totalRefiningTime, boundCheckTime));
        }

        if (logger.isDebugEnabled()) {
            StringBuilder smtStatistics = new StringBuilder("\n ===== SMT Statistics (after final iteration) ===== \n");
            for (String key : prover.getStatistics().keySet()) {
                smtStatistics.append(String.format("\t%s -> %s\n", key, prover.getStatistics().get(key)));
            }
            logger.debug(smtStatistics.toString());
        }

        if (printCovReport) {
            System.out.println(generateCoverageReport(coveredEvents, program, analysisContext));
        }

        // For Safety specs, we have SAT=FAIL, but for reachability specs, we have
        // SAT=PASS
        res = propertyType == Property.Type.SAFETY ? res : res.invert();
        logger.info("Verification finished with result " + res);
    }
    // ======================= Helper Methods ======================

    // This method cuts off negated relations that are dependencies of some
    // consistency axiom. It ignores dependencies of flagged axioms, as those get
    // eagarly encoded and can be completely ignored for Refinement.
    private static Set<Relation> cutRelationDifferences(Wmm targetWmm, Wmm baselineWmm) {
        // TODO: Add support to move flagged axioms to the baselineWmm
        Set<Relation> cutRelations = new HashSet<>();
        Set<Relation> cutCandidates = new HashSet<>();
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
                    baselineWmm.addConstraint(new ForceEncodeAxiom(getCopyOfRelation(sec, baselineWmm)));
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
        @Override public Definition visitIdentity(Relation r, FilterAbstract filter) { return new Identity(relation, filter); }
        @Override public Definition visitProduct(Relation r, FilterAbstract f1, FilterAbstract f2) { return new CartesianProduct(relation, f1, f2); }
        @Override public Definition visitFences(Relation r, FilterAbstract type) { return new Fences(relation, type); }

        private Relation copy(Relation r) { return getCopyOfRelation(r, targetModel); }
        private Relation[] copy(Relation[] r) {
            Relation[] a = new Relation[r.length];
            for (int i = 0; i < r.length; i++) {
                a[i] = copy(r[i]);
            }
            return a;
        }
    }

    // -------------------- Printing -----------------------------

    private static CharSequence generateSummary(List<WMMSolver.Statistics> statList, int iterationCount,
            long totalNativeSolvingTime, long totalCaatTime,
            long totalRefiningTime, long boundCheckTime) {
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
                .append("Number of iterations: ").append(iterationCount).append("\n")
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
        if (statList.size() > 0) {
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

        // Track covered events and branches via oId
        final Set<Integer> coveredOIds = new HashSet<>();
        final Set<Integer> coveredBranches = new HashSet<>();
        for (Event e : coveredEvents) {
            if (e.getCLine() > 0) {
                Event symmRep = symm.map(e, symm.getRepresentative(e.getThread()));
                coveredOIds.add(symmRep.getOId());
                Event cfRep = cf.getRepresentative(symmRep);
                coveredBranches.add(cfRep.getOId());
            }
        }

        final Set<Event> programEvents = program.getEvents(MemEvent.class).stream()
                .filter(e -> e.getCLine() > 0).collect(Collectors.toSet());
        final Set<String> messageSet = new TreeSet<>(); // TreeSet to keep strings in order
        for (Event e : programEvents) {
            EquivalenceClass<Thread> clazz = symm.getEquivalenceClass(e.getThread());
            Event rep = symm.map(e, clazz.getRepresentative());
            if (!coveredOIds.contains(rep.getOId())) {
                // Events not executed in any violating execution
                final String threads = clazz.stream().map(t -> "T" + t.getId())
                        .collect(Collectors.joining(" / "));
                messageSet.add(String.format("%s -> %s#%s", threads, e.getSourceCodeFile(), rep.getCLine()));
            }
        }

        final Set<Integer> branches = new HashSet<>();
        for (Event e : programEvents) {
            Event symmRep = symm.map(e, symm.getRepresentative(e.getThread()));
            // Since coveredEvents only containes MemEvents, we only count those branches
            // containig at least one such event
            if (cf.getEquivalenceClass(symmRep).stream().anyMatch(f -> f instanceof MemEvent)) {
                Event cfRep = cf.getRepresentative(symmRep);
                branches.add(cfRep.getOId());
            }
        }

        // When using the % symbol, the value multiplied by 100 before applying the format string. 
        DecimalFormat df = new DecimalFormat("#.##%");
        // messageSet contains the missing ones, thus the 100 - X ...
        final double eventCoveragePercentage = 1d - (messageSet.size() * 1d / programEvents.size());
        final double branchCoveragePercentage = coveredBranches.size() * 1d / branches.size();

        final StringBuilder report = new StringBuilder()
                .append("Property-based coverage (executed by at least one property-violating execution, including inconsistent executions): \n")
                .append("\t-- Events: ")
                .append(String.format("%s (%s / %s)", df.format(eventCoveragePercentage),
                        programEvents.size() - messageSet.size(), programEvents.size()))
                .append("\n")
                .append("\t-- Branches: ")
                .append(String.format("%s (%s / %s)", df.format(branchCoveragePercentage), coveredBranches.size(),
                        branches.size()))
                .append("\n");
        if (programEvents.size() != messageSet.size()) {
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
                    if (lit instanceof RelLiteral) {
                        RelLiteral edgeLit = (RelLiteral) lit;
                        if (model.getData(edgeLit.getData().getFirst()).get() == e1 &&
                                model.getData(edgeLit.getData().getSecond()).get() == e2) {
                            return true;
                        }
                    }
                }
            }
            return false;
        };

        String programName = task.getProgram().getName();
        programName = programName.substring(0, programName.lastIndexOf("."));
        String directoryName = String.format("%s/refinement/%s-%s-debug/", System.getenv("DAT3M_OUTPUT"), programName,
                task.getProgram().getArch());
        String fileNameBase = String.format("%s-%d", programName, iterationCount);
        // File with reason edges only
        generateGraphvizFile(model, iterationCount, edgeFilter, edgeFilter, edgeFilter, directoryName, fileNameBase,
                new HashMap<>());
        // File with all edges
        generateGraphvizFile(model, iterationCount, (x, y) -> true, (x, y) -> true, (x, y) -> true, directoryName,
                fileNameBase + "-full", new HashMap<>());
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
}