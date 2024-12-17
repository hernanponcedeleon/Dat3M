package com.dat3m.dartagnan.verification.solving;

import com.dat3m.dartagnan.configuration.Baseline;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.encoding.*;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.BranchEquivalence;
import com.dat3m.dartagnan.program.analysis.SyntacticContextAnalysis;
import com.dat3m.dartagnan.program.analysis.ThreadSymmetry;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.MemoryEvent;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.MemoryCoreEvent;
import com.dat3m.dartagnan.program.event.metadata.OriginalId;
import com.dat3m.dartagnan.program.event.metadata.SourceLocation;
import com.dat3m.dartagnan.program.filter.Filter;
import com.dat3m.dartagnan.solver.caat.CAATSolver;
import com.dat3m.dartagnan.solver.caat4wmm.RefinementModel;
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
import com.dat3m.dartagnan.verification.model.ExecutionModelManager;
import com.dat3m.dartagnan.verification.model.ExecutionModelNext;
import com.dat3m.dartagnan.verification.model.event.EventModel;
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
import org.sosy_lab.java_smt.api.*;

import java.math.BigInteger;
import java.text.DecimalFormat;
import java.util.*;
import java.util.function.BiPredicate;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.GlobalSettings.getOutputDirectory;
import static com.dat3m.dartagnan.configuration.OptionNames.*;
import static com.dat3m.dartagnan.program.analysis.SyntacticContextAnalysis.*;
import static com.dat3m.dartagnan.solver.caat.CAATSolver.Status.*;
import static com.dat3m.dartagnan.utils.Result.*;
import static com.dat3m.dartagnan.utils.Utils.toTimeString;
import static com.dat3m.dartagnan.witness.graphviz.ExecutionGraphVisualizer.generateGraphvizFile;
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

    private static final String FR = "fr";
    private static final String COE = "coe";
    private static final String FRE = "fre";
    private static final String POLOC = "po-loc";

    private EncodingContext contextWithFullWmm;

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

    @Option(name=GRAPHVIZ_DEBUG_FILES,
            description="This option causes Refinement to generate many .dot and .png files that describe EACH iteration." +
                    " It is very expensive and should only be used for debugging purposes.")
    private boolean generateGraphvizDebugFiles = false;

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

    public EncodingContext getContextWithFullWmm() {
        return contextWithFullWmm;
    }

    //TODO: We do not yet use Witness information. The problem is that WitnessGraph.encode() generates
    // constraints on hb, which is not encoded in Refinement.
    //TODO (2): Add possibility for Refinement to handle CAT-properties (it ignores them for now).
    public static RefinementSolver run(SolverContext ctx, ProverWithTracker prover, VerificationTask task)
            throws InterruptedException, SolverException, InvalidConfigurationException {
        RefinementSolver solver = new RefinementSolver();
        task.getConfig().inject(solver);
        logger.info("{}: {}", BASELINE, solver.baselines);
        solver.runInternal(ctx, prover, task);
        return solver;
    }

    private void runInternal(SolverContext ctx, ProverWithTracker prover, VerificationTask task)
            throws InterruptedException, SolverException, InvalidConfigurationException {
        final Program program = task.getProgram();
        final Wmm memoryModel = task.getMemoryModel();
        final Context analysisContext = Context.create();
        final Configuration config = task.getConfig();

        // ------------------------ Preprocessing / Analysis ------------------------

        // TODO: This is a reasonable transformation for all methods (eager/lazy), however,
        //  our current processing pipelines (WmmProcessor/ProgramProcessor) are unaware of the property
        //  so we cannot perform property-aware transformation in those pipelines right now.
        removeFlaggedAxiomsIfNotNeeded(task);

        memoryModel.configureAll(config);
        preprocessProgram(task, config);
        preprocessMemoryModel(task, config);
        instrumentPolaritySeparation(memoryModel);

        performStaticProgramAnalyses(task, analysisContext, config);
        // Copy context without WMM analyses because we want to analyse a second model later
        Context baselineContext = Context.createCopyFrom(analysisContext);
        performStaticWmmAnalyses(task, analysisContext, config);

        // Encoding context with the original Wmm and the analysis context for relation extraction.
        contextWithFullWmm = EncodingContext.of(task, analysisContext, ctx.getFormulaManager());

        //  ------- Generate refinement model -------
        final RefinementModel refinementModel = generateRefinementModel(memoryModel);
        final Wmm baselineModel = refinementModel.getBaseModel();
        addBiases(baselineModel, baselines);
        baselineModel.configureAll(config); // Configure after cutting!
        refinementModel.transferKnowledgeFromOriginal(analysisContext.requires(RelationAnalysis.class));
        refinementModel.forceEncodeBoundary();

        final VerificationTask baselineTask = VerificationTask.builder()
                .withConfig(task.getConfig())
                .withProgressModel(task.getProgressModel())
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

        final BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        final WMMSolver solver = WMMSolver.withContext(refinementModel, context, analysisContext, config);
        final Refiner refiner = new Refiner(refinementModel);
        final Property.Type propertyType = Property.getCombinedType(task.getProperty(), task);

        logger.info("Starting encoding using {}", ctx.getVersion());
        prover.writeComment("Program encoding");
        prover.addConstraint(programEncoder.encodeFullProgram());
        prover.writeComment("Memory model (baseline) encoding");
        prover.addConstraint(baselineEncoder.encodeFullMemoryModel());
        prover.writeComment("Symmetry breaking encoding");
        prover.addConstraint(symmetryEncoder.encodeFullSymmetryBreaking());

        // ------------------------ Solving ------------------------
        logger.info("Refinement procedure started.");

        logger.info("Checking target property.");
        prover.push();
        prover.writeComment("Property encoding");
        prover.addConstraint(propertyEncoder.encodeProperties(task.getProperty()));

        final RefinementTrace propertyTrace = runRefinement(task, prover, solver, refiner);
        SMTStatus smtStatus = propertyTrace.getFinalResult();

        if (smtStatus == SMTStatus.UNKNOWN) {
            // Refinement got no result (should not be able to happen), so we cannot proceed further.
            logger.warn("Refinement procedure was inconclusive. Trying to find reason of inconclusiveness.");
            analyzeInconclusiveness(task, analysisContext, solver.getExecution());
            throw new RuntimeException("Terminated verification due to inconclusiveness (bug?).");
        }

        if (logger.isInfoEnabled()) {
            final String message = switch (smtStatus) {
                case SAT -> propertyType == Property.Type.SAFETY ? "Specification violation found."
                        : "Specification witness found.";
                case UNSAT -> propertyType == Property.Type.SAFETY ? "Bounded specification proven."
                        : "Bounded specification falsified.";
                // Cannot be reached due to the above checks.
                default -> throw new RuntimeException("unreachable");
            };
            logger.info(message);
        }

        RefinementTrace combinedTrace = propertyTrace;

        long boundCheckTime = 0;
        if (smtStatus == SMTStatus.UNSAT) {
            // Do bound check
            logger.info("Checking unrolling bounds.");
            final long lastTime = System.currentTimeMillis();
            prover.pop();
            prover.writeComment("Bound encoding");
            prover.addConstraint(propertyEncoder.encodeBoundEventExec());
            // Add back the refinement clauses we already found, hoping that this improves the performance.
            prover.writeComment("Refinement encoding");
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
            saveFlaggedPairsOutput(baselineModel, baselineEncoder, prover, context, task.getProgram());
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

    private void analyzeInconclusiveness(VerificationTask task, Context analysisContext, ExecutionModel model) {
        final AliasAnalysis alias = analysisContext.get(AliasAnalysis.class);
        if (alias == null) {
            return;
        }
        SyntacticContextAnalysis synContext = analysisContext.get(SyntacticContextAnalysis.class);
        if (synContext == null) {
            synContext = newInstance(task.getProgram());
        }

        final Map<BigInteger, Set<EventData>> addr2Events = new HashMap<>();
        model.getAddressReadsMap().forEach((addr, reads) -> addr2Events.computeIfAbsent(addr, key -> new HashSet<>()).addAll(reads));
        model.getAddressWritesMap().forEach((addr, writes) -> addr2Events.computeIfAbsent(addr, key -> new HashSet<>()).addAll(writes));
        model.getAddressInitMap().forEach((addr, init) -> addr2Events.computeIfAbsent(addr, key -> new HashSet<>()).add(init));

        for (Set<EventData> sameLocEvents : addr2Events.values()) {
            final List<EventData> events = sameLocEvents.stream().sorted().toList();

            for (int i = 0; i < events.size() - 1; i++) {
                for (int j = i + 1; j < events.size(); j++) {
                    final MemoryCoreEvent e1 = (MemoryCoreEvent) events.get(i).getEvent();
                    final MemoryCoreEvent e2 = (MemoryCoreEvent) events.get(j).getEvent();
                    if (!alias.mayAlias(e1, e2)) {
                        final StringBuilder builder = new StringBuilder();
                        builder.append("Found unexpected aliasing between:\n");
                        builder.append("\t")
                                .append(synContext.getSourceLocationWithContext(e1, true))
                                .append("\n")
                                .append("AND\n")
                                .append("\t")
                                .append(synContext.getSourceLocationWithContext(e2, true))
                                .append("\n");
                        builder.append("Possible out-of-bounds access in source code or error in alias analysis.");

                        logger.warn(builder.toString());
                        return;
                    }
                }
            }
        }
    }

    // ================================================================================================================
    // Refinement core algorithm

    // TODO: We could expose the following method(s) to allow for more general application of refinement.
    private RefinementTrace runRefinement(VerificationTask task, ProverWithTracker prover, WMMSolver solver, Refiner refiner)
            throws SolverException, InterruptedException {

        final List<RefinementIteration> trace = new ArrayList<>();
        boolean isFinalIteration = false;
        while (!isFinalIteration) {

            final RefinementIteration iteration = doRefinementIteration(prover, solver, refiner);
            trace.add(iteration);
            isFinalIteration = !checkProgress(trace) || iteration.isConclusive();

            // ------------------------- Debugging/Logging -------------------------
            if (generateGraphvizDebugFiles) {
                final ExecutionModelNext model = new ExecutionModelManager().buildExecutionModel(contextWithFullWmm, prover.getModel());
                generateGraphvizFiles(task, model, trace.size(), iteration.inconsistencyReasons);
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

    private boolean checkProgress(List<RefinementIteration> trace) {
        if (trace.size() < 2 || trace.get(trace.size() - 1).isConclusive()) {
            return true;
        }
        final RefinementIteration last = trace.get(trace.size() - 1);
        final RefinementIteration prev = trace.get(trace.size() - 2);
        return !last.inconsistencyReasons.equals(prev.inconsistencyReasons);
    }

    private RefinementIteration doRefinementIteration(ProverWithTracker prover, WMMSolver solver, Refiner refiner)
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
                prover.writeComment("Refinement encoding");
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

    private static boolean isUnknownDefinitionForCAAT(Definition def) {
        // TODO: We should probably automatically cut all "unknown relation",
        //  i.e., use a white-list of known relations instead of a blacklist of unknown one's.
        return def instanceof LinuxCriticalSections // LKMM
                || def instanceof CASDependency // IMM
                // GPUs
                || def instanceof SameScope || def instanceof SyncWith
                || def instanceof SyncFence || def instanceof SyncBar || def instanceof SameVirtualLocation;
    }

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
                // (ii) Negated relations (if derived)
                final Relation sub = diff.getSubtrahend();
                final Definition subDef = sub.getDefinition();
                if (!sub.getDependencies().isEmpty()
                        // The following three definitions are "semi-derived" and need to get cut
                        // to get a semi-positive model.
                        || subDef instanceof SetIdentity
                        || subDef instanceof CartesianProduct) {
                    constraintsToCut.add(subDef);
                }
            } else if (c instanceof Definition def && def.getDefinedRelation().hasName()) {
                // (iii) Special relations
                final String name = def.getDefinedRelation().getName().get();
                if (name.equals(DATA) || name.equals(CTRL) || name.equals(ADDR) || isUnknownDefinitionForCAAT(def)) {
                    constraintsToCut.add(c);
                }
            }
        }

        return RefinementModel.fromCut(Cut.computeInducedCut(original, constraintsToCut));
    }

    private static void addBiases(Wmm wmm, EnumSet<Baseline> biases) {

        // Base relations
        final Relation rf = wmm.getRelation(RF);
        final Relation co = wmm.getOrCreatePredefinedRelation(CO);
        final Relation loc = wmm.getOrCreatePredefinedRelation(LOC);
        final Relation po = wmm.getOrCreatePredefinedRelation(PO);
        final Relation ext = wmm.getOrCreatePredefinedRelation(EXT);
        final Relation rmw = wmm.getOrCreatePredefinedRelation(RMW);

        // rf^-1;co
        final Relation rfinv = wmm.addDefinition(new Inverse(wmm.newRelation(), rf));
        final Relation frStandard = wmm.addDefinition(new Composition(wmm.newRelation(), rfinv, co));

        // ([R] \ [range(rf)]);loc;[W]
        final Relation reads = wmm.addDefinition(new SetIdentity(wmm.newRelation(), wmm.getFilter(Tag.READ)));
        final Relation rfRange = wmm.addDefinition(new RangeIdentity(wmm.newRelation(), rf));
        final Relation writes = wmm.addDefinition(new SetIdentity(wmm.newRelation(), Filter.byTag(Tag.WRITE)));
        final Relation ur = wmm.addDefinition(new Difference(wmm.newRelation(), reads, rfRange));
        final Relation urloc = wmm.addDefinition(new Composition(wmm.newRelation(), ur, loc));
        final Relation urlocwrites = wmm.addDefinition(new Composition(wmm.newRelation(), urloc, writes));

        // let fr = rf^-1;co | ([R] \ [range(rf)]);loc;[W]
        final Relation fr = wmm.addDefinition(new Union(wmm.newRelation(), frStandard, urlocwrites));

        if (biases.contains(Baseline.UNIPROC)) {
            // ---- acyclic(po-loc | com) ----
            wmm.addConstraint(new Acyclicity(wmm.addDefinition(new Union(wmm.newRelation(),
                wmm.addDefinition(new Intersection(wmm.newRelation(), po, loc)),
                rf,
                co,
                fr
            ))));
        }
        if (biases.contains(Baseline.NO_OOTA)) {
            // ---- acyclic (dep | rf) ----
            wmm.addConstraint(new Acyclicity(wmm.addDefinition(new Union(wmm.newRelation(),
                wmm.getOrCreatePredefinedRelation(CTRL),
                wmm.getOrCreatePredefinedRelation(DATA),
                wmm.getOrCreatePredefinedRelation(ADDR),
                rf)
            )));
        }
        if (biases.contains(Baseline.ATOMIC_RMW)) {
            // ---- empty (rmw & fre;coe) ----
            Relation coe = wmm.addDefinition(new Intersection(wmm.newRelation(), co, ext));
            Relation fre = wmm.addDefinition(new Intersection(wmm.newRelation(), fr, ext));
            Relation frecoe = wmm.addDefinition(new Composition(wmm.newRelation(), fre, coe));
            Relation rmwANDfrecoe = wmm.addDefinition(new Intersection(wmm.newRelation(), rmw, frecoe));
            wmm.addConstraint(new Emptiness(rmwANDfrecoe));
        }
    }

    private static void removeFlaggedAxiomsIfNotNeeded(VerificationTask task) {
        // We remove flagged axioms if we do not check for them.
        if (!task.getProperty().contains(Property.CAT_SPEC)) {
            List.copyOf(task.getMemoryModel().getAxioms()).stream()
                    .filter(Axiom::isFlagged)
                    .forEach(task.getMemoryModel()::removeConstraint);
        }
    }

    /*
        The constraints/relations of the Wmm can be categorised into positive and negative,
        depending on whether the number of negations applied to the constraint/relation is even (=positive)
        or odd (=negative).
        Negations come from negated axioms (~empty(r)), RHS of differences (c = a \ b), or
        complementation (Y = ~X). Complementation is just a difference: ~X = _ \ X, so there is no special
        treatment required.
        A relation can be both negative and positive if it is used multiple times,
        once with odd negations and once with even negations.
        It can also be neither, if the relation is dead (i.e., irrelevant for all axioms).
     */
    private record PolaritySeparator(Set<Constraint> positives, Set<Constraint> negatives) { }

    private PolaritySeparator computePolaritySeparator(Wmm wmm) {
        final Set<Constraint> positives = new HashSet<>();
        final Set<Constraint> negatives = new HashSet<>();
        final Constraint.Visitor<Void> collector = new Constraint.Visitor<>() {
            private boolean polarity = true;

            @Override
            public Void visitAxiom(Axiom axiom) {
                polarity = !axiom.isNegated();
                process(axiom);
                return axiom.getRelation().getDefinition().accept(this);
            }

            @Override
            public Void visitDefinition(Definition def) {
                if (process(def)) {
                    def.getConstrainedRelations().subList(1, def.getConstrainedRelations().size())
                            .forEach(r -> r.getDefinition().accept(this));
                }
                return null;
            }

            @Override
            public Void visitDifference(Difference def) {
                if (process(def)) {
                    def.getMinuend().getDefinition().accept(this);
                    polarity = !polarity;
                    def.getSubtrahend().getDefinition().accept(this);
                    polarity = !polarity;
                }
                return null;
            }

            private boolean process(Constraint c) {
                return (polarity ? positives : negatives).add(c);
            }
        };

        wmm.getAxioms().forEach(ax -> ax.accept(collector));
        return new PolaritySeparator(positives, negatives);
    }

    /*
        This pass rewrites the memory model so that no non-negative constraints appear on the RHS of a difference.
        Consider "r = a \ b" where b is non-negative (note that r and a must be non-positive then).
        For example, this is the case if there is a constraint "~empty(r)"
        We rewrite the model to

            let b'= free()
            let r = a \ b' // b' gets cut, but it is effectively a base relation so this causes no large encoding.
            empty (r & b) // b is now in a positive position and thus not need to get cut.

        We claim that this model is equisatisfiable to the original memory model.
        To understand this intuitively, it is helpful so think of the fresh b' as the original b but with "some slack".
        We will argue that the best choice for b' is precisely b.
        Any larger choice for b' will make r smaller, but since r is non-positive this reduces the chances
        of satisfying negated axioms (e.g., if "~empty(r)" is true for some small r, then it is also true for all larger r).
        On the other hand, if b' is chosen too small, then r gets so large that it violates "empty(r & b)".

        We prove this formally. Towards this, we reason about executions M which are to be understood
        as an interpretation of the relations of the memory model.
        So, e.g., M(rf) is the value of rf (=the concrete binary relation) in the execution M.

        "NEW => ORIGINAL":
        Suppose M' is a consistent execution under the new memory model.
        Then from "let r = a \ b'" it follows that
            M'(r) \subseteq M'(a).
        Furthermore, from "empty (r & b)" it follows that
            M'(r) \subseteq ~M'(b).
        Combining both, we get
            M'(r) \subseteq (M'(a) & ~M'(b)) = (M'(a) \ M'(b)).
        Now consider an execution M under the original memory model that matches with M' on the base relations
        (modulo b' which does not exist in the original model).
        Since both models agree on all base relations except b', they also agree on all derived relations
        that are independent of b'.
        In particular, since a and b are independent of b', we have M(a) = M'(a) and M(b) = M'(b), so that
            M'(r) \subseteq (M'(a) \ M'(b)) = (M(a) \ M(b)) = M(r).
        So the original memory model has a potentially larger interpretation for r (M'(r) \subseteq M(r)).
        Since r is non-positive, we know that a larger relation satisfies more axioms (e.g.,
        if r' is non-empty/non-acyclic/non-irreflexive, then the larger r will also satisfy these).
        So M is a consistent execution under the original memory model.

        "NEW <= ORIGINAL":
        Suppose M is a consistent execution under the original model.
        Then we can construct M' that matches with M on all common base relations but also sets M'(b') := M(b).
        It is clear that M' now matches on all derived relations with M and so it satisfies the same axioms
        and thus is also consistent.

        NOTE: We argued about consistency only, but the same reasoning also applies to violation of flagged axioms,
        i.e., the difference between "~empty(r)" and "flag ~empty(r)" is irrelevant for the argumentation.

        NOTE 2: This rewriting is always possible.

        NOTE 3: There is a minor caveat in the new memory model.
        If an execution under the original memory model violates, e.g., "flag ~empty(r)" with multiple edges {e1, ..., ek},
        then for the same execution the new memory model could report only a subset of those violations.
        The reason is that the SMT solver has some slack in the choice of b':
        it will choose b' such "flag ~empty(r)" holds (i.e., we have a violation), but it will not guarantee to
        make the choice in such a way that it maximizes the number of violations.
        If we want to get all violations of an execution, we could take the found execution (under the new memory model)
        and simply recompute it under the original memory model, giving us the precise violations.
     */
    private void instrumentPolaritySeparation(Wmm wmm) {
        final PolaritySeparator separator = computePolaritySeparator(wmm);
        final Set<Difference> negDiff = separator.negatives().stream()
                .filter(Difference.class::isInstance).map(Difference.class::cast)
                .filter(diff -> !separator.negatives().contains(diff.getSubtrahend().getDefinition()))
                .collect(Collectors.toSet());

        final Map<Relation, Relation> replacements = new HashMap<>();
        int counter = 0;
        for (Difference diff : negDiff) {
            // r = a \ b where r and a are non-positive and b is non-negative.
            final Relation r = diff.getDefinedRelation();
            final Relation a = diff.getMinuend();
            final Relation b = diff.getSubtrahend();

            // (1) Create b' (if not already existing)
            final Relation bPrime;
            if (replacements.containsKey(b)) {
                bPrime = replacements.get(b);
            } else {
                final String bPrimeName = b.getName().map(n -> n + "__POS").orElse("__POS" + counter++);
                bPrime = wmm.addDefinition(new Free(wmm.newRelation(bPrimeName)));
                replacements.put(b, bPrime);
            }
            // (2) Rewrite  r = a \ b  to  r = a \ b'
            wmm.removeDefinition(r);
            wmm.addDefinition(new Difference(r, a, bPrime));
            // (3) Add empty (r & b)
            final Relation intersection = wmm.addDefinition(new Intersection(wmm.newRelation(), r, b));
            wmm.addConstraint(new Emptiness(intersection));
        }
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
                .append("Total native solving time: ").append(toTimeString(totalNativeSolvingTime)).append("\n")
                .append("   -- Bound check time: ").append(toTimeString(boundCheckTime)).append("\n")
                .append("Total CAAT solving time: ").append(toTimeString(totalCaatTime)).append("\n")
                .append("   -- Model extraction time: ").append(toTimeString(totalModelExtractTime)).append("\n")
                .append("   -- Population time: ").append(toTimeString(totalPopulationTime)).append("\n")
                .append("   -- Consistency check time: ").append(toTimeString(totalConsistencyCheckTime)).append("\n")
                .append("   -- Reason computation time: ").append(toTimeString(totalReasonComputationTime)).append("\n")
                .append("   -- Refining time: ").append(toTimeString(totalRefiningTime)).append("\n")
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
    private static void generateGraphvizFiles(
            VerificationTask task, ExecutionModelNext model, int iterationCount, DNF<CoreLiteral> reasons) {
        // =============== Visualization code ==================
        // The edgeFilter filters those co/rf that belong to some violation reason
        BiPredicate<EventModel, EventModel> edgeFilter = (e1, e2) -> {
            for (Conjunction<CoreLiteral> cube : reasons.getCubes()) {
                for (CoreLiteral lit : cube.getLiterals()) {
                    if (lit instanceof RelLiteral edgeLit) {
                        if (model.getEventModelByEvent(edgeLit.getSource()) == e1 &&
                                model.getEventModelByEvent(edgeLit.getTarget()) == e2) {
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
        generateGraphvizFile(model, iterationCount, edgeFilter, edgeFilter, directoryName, fileNameBase,
                emptySynContext);
        // File with all edges
        generateGraphvizFile(model, iterationCount, (x, y) -> true, (x, y) -> true, directoryName,
                fileNameBase + "-full", emptySynContext);
    }
}