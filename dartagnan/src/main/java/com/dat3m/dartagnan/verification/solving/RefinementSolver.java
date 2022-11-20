package com.dat3m.dartagnan.verification.solving;

import com.dat3m.dartagnan.configuration.Baseline;
import com.dat3m.dartagnan.encoding.*;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.filter.FilterAbstract;
import com.dat3m.dartagnan.solver.caat.CAATSolver;
import com.dat3m.dartagnan.solver.caat4wmm.Refiner;
import com.dat3m.dartagnan.solver.caat4wmm.WMMSolver;
import com.dat3m.dartagnan.solver.caat4wmm.coreReasoning.CoreLiteral;
import com.dat3m.dartagnan.solver.caat4wmm.coreReasoning.RelLiteral;
import com.dat3m.dartagnan.utils.logic.Conjunction;
import com.dat3m.dartagnan.utils.logic.DNF;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.verification.model.ExecutionModel;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Acyclic;
import com.dat3m.dartagnan.wmm.axiom.Empty;
import com.dat3m.dartagnan.wmm.axiom.ForceEncodeAxiom;
import com.dat3m.dartagnan.wmm.relation.RecursiveRelation;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.relation.base.stat.RelCartesian;
import com.dat3m.dartagnan.wmm.relation.base.stat.RelFencerel;
import com.dat3m.dartagnan.wmm.relation.base.stat.RelSetIdentity;
import com.dat3m.dartagnan.wmm.relation.binary.RelComposition;
import com.dat3m.dartagnan.wmm.relation.binary.RelIntersection;
import com.dat3m.dartagnan.wmm.relation.binary.RelMinus;
import com.dat3m.dartagnan.wmm.relation.binary.RelUnion;
import com.dat3m.dartagnan.wmm.relation.unary.RelDomainIdentity;
import com.dat3m.dartagnan.wmm.relation.unary.RelInverse;
import com.dat3m.dartagnan.wmm.relation.unary.RelRangeIdentity;
import com.dat3m.dartagnan.wmm.relation.unary.RelTrans;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.java_smt.api.*;

import java.util.*;
import java.util.function.BiPredicate;

import static com.dat3m.dartagnan.GlobalSettings.REFINEMENT_GENERATE_GRAPHVIZ_DEBUG_FILES;
import static com.dat3m.dartagnan.configuration.OptionNames.BASELINE;
import static com.dat3m.dartagnan.solver.caat.CAATSolver.Status.INCONCLUSIVE;
import static com.dat3m.dartagnan.solver.caat.CAATSolver.Status.INCONSISTENT;
import static com.dat3m.dartagnan.utils.Result.*;
import static com.dat3m.dartagnan.utils.visualization.ExecutionGraphVisualizer.generateGraphvizFile;
import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.*;
import static com.google.common.base.Preconditions.checkArgument;

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
        // We cut the rhs of differences to get a semi-positive model, if possible.
        // This call modifies the baseline model!
        Set<Relation> cutRelations = cutRelationDifferences(memoryModel, baselineModel);
        memoryModel.configureAll(config);
        baselineModel.configureAll(config); // Configure after cutting!

        performStaticProgramAnalyses(task, analysisContext, config);
        Context baselineContext = Context.createCopyFrom(analysisContext);
        performStaticWmmAnalyses(task, analysisContext, config);
        performStaticWmmAnalyses(baselineTask, baselineContext, config);

        context = EncodingContext.of(baselineTask, baselineContext, ctx);
        ProgramEncoder programEncoder = ProgramEncoder.withContext(context);
        PropertyEncoder propertyEncoder = PropertyEncoder.withContext(context);
        // We use the original memory model for symmetry breaking because we need axioms
        // to compute the breaking order.
        SymmetryEncoder symmEncoder = SymmetryEncoder.withContext(context, memoryModel, analysisContext);
        WmmEncoder baselineEncoder = WmmEncoder.withContext(context);
        programEncoder.initializeEncoding(ctx);
        propertyEncoder.initializeEncoding(ctx);
        symmEncoder.initializeEncoding(ctx);
        baselineEncoder.initializeEncoding(ctx);

        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        BooleanFormula globalRefinement = bmgr.makeTrue();

        WMMSolver solver = WMMSolver.withContext(context, cutRelations, task, analysisContext);
        Refiner refiner = new Refiner(memoryModel, analysisContext);
        CAATSolver.Status status = INCONSISTENT;

        BooleanFormula propertyEncoding = propertyEncoder.encodeSpecification();
        if(bmgr.isFalse(propertyEncoding)) {
            logger.info("Verification finished: property trivially holds");
            res = PASS;
       	    return;
        }

        logger.info("Starting encoding using " + ctx.getVersion());
        prover.addConstraint(programEncoder.encodeFullProgram());
        prover.addConstraint(baselineEncoder.encodeFullMemoryModel());
        prover.addConstraint(symmEncoder.encodeFullSymmetryBreaking());

        prover.push();
        prover.addConstraint(propertyEncoding);

        //  ------ Just for statistics ------
        List<WMMSolver.Statistics> statList = new ArrayList<>();
        int iterationCount = 0;
        long lastTime = System.currentTimeMillis();
        long curTime;
        long totalNativeSolvingTime = 0;
        long totalCaatTime = 0;
        long totalRefiningTime = 0;
        //  ---------------------------------

        logger.info("Refinement procedure started.");
        while (!prover.isUnsat()) {
        	if(iterationCount == 0 && logger.isDebugEnabled()) {
        		StringBuilder smtStatistics = new StringBuilder("\n ===== SMT Statistics (after first iteration) ===== \n");
        		for(String key : prover.getStatistics().keySet()) {
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
            logger.debug("Refinement iteration:\n{}", stats);

            status = solverResult.getStatus();
            if (status == INCONSISTENT) {
                long refineTime = System.currentTimeMillis();
                DNF<CoreLiteral> reasons = solverResult.getCoreReasons();
                BooleanFormula refinement = refiner.refine(reasons, context);
                prover.addConstraint(refinement);
                globalRefinement = bmgr.and(globalRefinement, refinement); // Track overall refinement progress
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
                    message = "Violation verified.";
                    break;
                case INCONSISTENT:
                    message = "Bounded specification proven.";
                    break;
                default:
                    throw new IllegalStateException("Unknown result type returned by CAAT Solver.");
            }
            logger.info(message);
        }

        if (status == INCONCLUSIVE) {
            // CAATSolver got no result (should not be able to happen), so we cannot proceed further.
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
            //  This is needed for the seqlock.c benchmarks!
            prover.addConstraint(globalRefinement);
            res = !prover.isUnsat() ? UNKNOWN : PASS;
            boundCheckTime = System.currentTimeMillis() - lastTime;
        } else {
            res = FAIL;
        }

        if (logger.isInfoEnabled()) {
            logger.info(generateSummary(statList, iterationCount, totalNativeSolvingTime,
                    totalCaatTime, totalRefiningTime, boundCheckTime));
        }

        if(logger.isDebugEnabled()) {        	
            StringBuilder smtStatistics = new StringBuilder("\n ===== SMT Statistics (after final iteration) ===== \n");
    		for(String key : prover.getStatistics().keySet()) {
    			smtStatistics.append(String.format("\t%s -> %s\n", key, prover.getStatistics().get(key)));
    		}
    		logger.debug(smtStatistics.toString());
        }

        res = program.getAss().getInvert() ? res.invert() : res;
        logger.info("Verification finished with result " + res);
    }
    // ======================= Helper Methods ======================

    // This method cuts off negated relations that are dependencies of some consistency axiom
    // It ignores dependencies of flagged axioms, as those get eagarly encoded and can be completely
    // ignored for Refinement.
    private static Set<Relation> cutRelationDifferences(Wmm targetWmm, Wmm baselineWmm) {
        // TODO: Add support to move flagged axioms to the baselineWmm
        Set<Relation> cutRelations = new HashSet<>();
        Set<Relation> cutCandidates = new HashSet<>();
        targetWmm.getAxioms().stream().filter(ax -> !ax.isFlagged())
                .forEach(ax -> collectDependencies(ax.getRelation(), cutCandidates));
        for (Relation rel : cutCandidates) {
            if (rel instanceof RelMinus) {
                Relation sec = rel.getSecond();
                if (sec.getDependencies().size() != 0 || sec instanceof RelSetIdentity || sec instanceof RelCartesian) {
                    // NOTE: The check for RelSetIdentity/RelCartesian is needed because they appear non-derived
                    // in our Wmm but for CAAT they are derived from unary predicates!
                    logger.info("Found difference {}. Cutting rhs relation {}", rel, sec);
                    cutRelations.add(sec);
                    baselineWmm.addAxiom(new ForceEncodeAxiom(getCopyOfRelation(sec, baselineWmm)));
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
        checkArgument(!(rel instanceof RecursiveRelation), "Cannot cut recursively defined relation %s from memory model. ", rel);
        Relation namedCopy = m.getRelation(rel.getName());
        if (namedCopy != null) {
            return namedCopy;
        }
        Relation copy = rel.accept(new RelationCopier(m));
        if (rel.getIsNamed()) {
            copy.setName(rel.getName());
        }
        m.addRelation(copy);
        return copy;
    }

    private static final class RelationCopier implements Relation.Visitor<Relation> {
        final Wmm targetModel;
        RelationCopier(Wmm m) { targetModel = m; }
        @Override public Relation visitUnion(Relation rel, Relation... r) { return new RelUnion(copy(r[0]), copy(r[1])); }
        @Override public Relation visitIntersection(Relation rel, Relation... r) { return new RelIntersection(copy(r[0]), copy(r[1])); }
        @Override public Relation visitDifference(Relation rel, Relation r1, Relation r2) { return new RelMinus(copy(r1), copy(r2)); }
        @Override public Relation visitComposition(Relation rel, Relation r1, Relation r2) { return new RelComposition(copy(r1), copy(r2)); }
        @Override public Relation visitInverse(Relation rel, Relation r1) { return new RelInverse(copy(r1)); }
        @Override public Relation visitDomainIdentity(Relation rel, Relation r1) { return new RelDomainIdentity(copy(r1)); }
        @Override public Relation visitRangeIdentity(Relation rel, Relation r1) { return new RelRangeIdentity(copy(r1)); }
        @Override public Relation visitTransitiveClosure(Relation rel, Relation r1) { return new RelTrans(copy(r1)); }
        @Override public Relation visitIdentity(Relation rel, FilterAbstract filter) { return new RelSetIdentity(filter); }
        @Override public Relation visitProduct(Relation rel, FilterAbstract f1, FilterAbstract f2) { return new RelCartesian(f1, f2); }
        @Override public Relation visitFences(Relation rel, FilterAbstract type) { return new RelFencerel(type); }
        private Relation copy(Relation r) { return getCopyOfRelation(r, targetModel); }
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
                    .append("   -- Average model size (#events): ").append(totalModelSize / statList.size()).append("\n")
                    .append("   -- Max model size (#events): ").append(maxModelSize).append("\n");
        }

        return message;
    }

    // This code is pure debugging code that will generate graphical representations
    // of each refinement iteration.
    // Generate .dot files and .png files per iteration
    private static void generateGraphvizFiles(VerificationTask task, ExecutionModel model, int iterationCount, DNF<CoreLiteral> reasons) {
        //   =============== Visualization code ==================
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
        String directoryName = String.format("%s/refinement/%s-%s-debug/", System.getenv("DAT3M_OUTPUT"), programName, task.getProgram().getArch());
        String fileNameBase = String.format("%s-%d", programName, iterationCount);
        // File with reason edges only
        generateGraphvizFile(model, iterationCount, edgeFilter, directoryName, fileNameBase);
        // File with all edges
        generateGraphvizFile(model, iterationCount, (x,y) -> true, directoryName, fileNameBase + "-full");
    }

    private Wmm createDefaultWmm() {
        Wmm baseline = new Wmm();
        Relation rf = baseline.getRelation(RF);
        if(baselines.contains(Baseline.UNIPROC)) {
            // ---- acyclic(po-loc | rf) ----
            Relation poloc = baseline.getRelation(POLOC);
            Relation co = baseline.getRelation(CO);
            Relation fr = baseline.getRelation(FR);
            Relation porf = new RelUnion(poloc, rf);
            baseline.addRelation(porf);
            Relation porfco = new RelUnion(porf, co);
            baseline.addRelation(porfco);
            Relation porfcofr = new RelUnion(porfco, fr);
            baseline.addRelation(porfcofr);
            baseline.addAxiom(new Acyclic(porfcofr));
        }
        if(baselines.contains(Baseline.NO_OOTA)) {
            // ---- acyclic (dep | rf) ----
            Relation data = baseline.getRelation(DATA);
            Relation ctrl = baseline.getRelation(CTRL);
            Relation addr = baseline.getRelation(ADDR);
            Relation dep = new RelUnion(data, addr);
            baseline.addRelation(dep);
            dep = new RelUnion(ctrl, dep);
            baseline.addRelation(dep);
            Relation hb = new RelUnion(dep, rf);
            baseline.addRelation(hb);
            baseline.addAxiom(new Acyclic(hb));
        }
        if(baselines.contains(Baseline.ATOMIC_RMW)) {
            // ---- empty (rmw & fre;coe) ----
            Relation rmw = baseline.getRelation(RMW);
            Relation coe = baseline.getRelation(COE);
            Relation fre = baseline.getRelation(FRE);
            Relation frecoe = new RelComposition(fre, coe);
            baseline.addRelation(frecoe);
            Relation rmwANDfrecoe = new RelIntersection(rmw, frecoe);
            baseline.addRelation(rmwANDfrecoe);
            baseline.addAxiom(new Empty(rmwANDfrecoe));
        }
        return baseline;
    }
}