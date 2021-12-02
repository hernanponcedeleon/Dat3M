package com.dat3m.dartagnan.analysis;

import com.dat3m.dartagnan.asserts.AssertTrue;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.MemEvent;
import com.dat3m.dartagnan.solver.newcaat.CAATSolver;
import com.dat3m.dartagnan.solver.newcaat4wmm.WMMSolver;
import com.dat3m.dartagnan.solver.newcaat4wmm.coreReasoning.AddressLiteral;
import com.dat3m.dartagnan.solver.newcaat4wmm.coreReasoning.CoreLiteral;
import com.dat3m.dartagnan.solver.newcaat4wmm.coreReasoning.ExecLiteral;
import com.dat3m.dartagnan.solver.newcaat4wmm.coreReasoning.RelLiteral;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.equivalence.EquivalenceClass;
import com.dat3m.dartagnan.utils.logic.Conjunction;
import com.dat3m.dartagnan.utils.logic.DNF;
import com.dat3m.dartagnan.utils.symmetry.ThreadSymmetry;
import com.dat3m.dartagnan.utils.visualization.ExecutionGraphVisualizer;
import com.dat3m.dartagnan.verification.RefinementTask;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.verification.model.ExecutionModel;
import com.dat3m.dartagnan.wmm.relation.Relation;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.java_smt.api.*;

import java.io.File;
import java.io.FileWriter;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Set;
import java.util.concurrent.TimeUnit;
import java.util.function.BiPredicate;
import java.util.function.Function;

import static com.dat3m.dartagnan.GlobalSettings.*;
import static com.dat3m.dartagnan.program.utils.Utils.generalEqual;
import static com.dat3m.dartagnan.solver.newcaat.CAATSolver.Status.INCONCLUSIVE;
import static com.dat3m.dartagnan.solver.newcaat.CAATSolver.Status.INCONSISTENT;
import static com.dat3m.dartagnan.utils.Result.*;

/*
    Refinement is a custom solving procedure that starts from a weak memory model (possibly the empty model)
    and iteratively refines it to perform a verification task.
    More concretely, it iteratively:
        - Finds some assertion-violating execution w.r.t. to some (very weak) baseline memory model
        - Checks the consistency of this execution using a Saturation-based solver
        - Refines the used memory model if the found execution was inconsistent, using the explanations
          provided by the Saturation-based solver.
 */
public class Refinement {

    private static final Logger logger = LogManager.getLogger(Refinement.class);

    //TODO: We do not yet use Witness information. The problem is that WitnessGraph.encode() generates
    // constraints on hb, which is not encoded in Refinement.
    public static Result runAnalysisWMMSolver(SolverContext ctx, ProverEnvironment prover, RefinementTask task)
            throws InterruptedException, SolverException {

        task.unrollAndCompile();
        if(task.getProgram().getAss() instanceof AssertTrue) {
            logger.info("Verification finished: assertion trivially holds");
            return PASS;
        }

        task.initialiseEncoding(ctx);

        // ======= Some preprocessing to use a visible representative for each branch ========
        /*for (BranchEquivalence.Class c : task.getBranchEquivalence().getAllEquivalenceClasses()) {
            c.stream().sorted().filter(e -> e.is(EType.VISIBLE) && e.cfImpliesExec())
                    .findFirst().ifPresent(c::setRepresentative);
            // NOTE: If the branch has no visible events, Refinement will never care about it.
            // If all visible branch events have cf != exec, then Refinement should never try
            // to make use of any representative.
        }*/
        // =====================================================================================

        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        Program program = task.getProgram();
        WMMSolver solver = new WMMSolver(task);
        Refiner refiner = new Refiner(task, ctx);
        CAATSolver.Status status = INCONSISTENT;

        task.getMemoryModel().performRelationalAnalysis(false);

        prover.addConstraint(task.encodeProgram(ctx));
        prover.addConstraint(task.encodeBaselineWmmRelations(ctx));
        prover.addConstraint(task.encodeBaselineWmmConsistency(ctx));

        if (ENABLE_SYMMETRY_BREAKING) {
            prover.addConstraint(task.encodeSymmetryBreaking(ctx));
        }

        prover.push();
        prover.addConstraint(task.encodeAssertions(ctx));

        //  ------ Just for statistics ------
        List<DNF<CoreLiteral>> foundCoreReasons = new ArrayList<>();
        List<WMMSolver.Statistics> statList = new ArrayList<>();
        int iterationCount = 0;
        long lastTime = System.currentTimeMillis();
        long curTime;
        long totalSolvingTime = 0;
        //  ---------------------------------

        logger.info("Refinement procedure started.");
        while (!prover.isUnsat()) {
            iterationCount++;
            curTime = System.currentTimeMillis();
            totalSolvingTime += (curTime - lastTime);

            logger.debug("Solver iteration: \n" +
                            " ===== Iteration: {} =====\n" +
                            "Solving time(ms): {}", iterationCount, curTime - lastTime);

            WMMSolver.Result solverResult;
            try (Model model = prover.getModel()) {
                solverResult = solver.check(model, ctx);
            } catch (SolverException e) {
                logger.error(e);
                throw e;
            }

            WMMSolver.Statistics stats = solverResult.getStatistics();
            statList.add(stats);
            logger.debug("Refinement iteration:\n{}", stats);

            status = solverResult.getStatus();
            if (status == INCONSISTENT) {

                DNF<CoreLiteral> reasons = solverResult.getCoreReasons();
                foundCoreReasons.add(reasons);
                prover.addConstraint(refiner.refine(reasons));

                if (REFINEMENT_GENERATE_GRAPHVIZ_FILES) {
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
                // No violations found, we can't refine
                break;
            }
            lastTime = System.currentTimeMillis();
        }
        iterationCount++;
        curTime = System.currentTimeMillis();
        totalSolvingTime += (curTime - lastTime);

        logger.debug("Final solver iteration:\n" +
                        " ===== Final Iteration: {} =====\n" +
                        "Solving/Proof time(ms): {}", iterationCount, curTime - lastTime);

        if (logger.isInfoEnabled()) {
            String message;
            switch (status) {
                case INCONCLUSIVE:
                    message = "Refinement procedure was inconclusive.";
                    break;
                case CONSISTENT:
                    message = "Violation verified.";
                    break;
                case INCONSISTENT:
                    message = "Bounded safety proven.";
                    break;
                default:
                    throw new IllegalStateException("Unknown result type returned by CAATSolver.");
            }
            logger.info(message);
        }

        if (status == INCONCLUSIVE) {
            // Saturation got no result, so we cannot proceed further.
            return UNKNOWN;
        }


        Result veriResult;
        long boundCheckTime = 0;
        if (prover.isUnsat()) {
            // ------- CHECK BOUNDS -------
            lastTime = System.currentTimeMillis();
            prover.pop();
            // Add bound check
            prover.addConstraint(bmgr.not(program.encodeNoBoundEventExec(ctx)));
            // Add back the constraints found during Refinement (TODO: We might need to perform a second refinement)
            for (DNF<CoreLiteral> reason : foundCoreReasons) {
                prover.addConstraint(refiner.refine(reason));
            }
            veriResult = !prover.isUnsat() ? UNKNOWN : PASS;
            boundCheckTime = System.currentTimeMillis() - lastTime;
        } else {
            veriResult = FAIL;
        }

        if (logger.isInfoEnabled()) {
            logger.info(generateSummary(statList, iterationCount, totalSolvingTime, boundCheckTime));
            //logger.info("Base reasoning time: " + CAATSolver.baseReasoningTime);
        }

        veriResult = program.getAss().getInvert() ? veriResult.invert() : veriResult;
        logger.info("Verification finished with result " + veriResult);
        return veriResult;
    }
    // ======================= Helper Methods ======================

    // -------------------- Printing -----------------------------

    private static CharSequence generateSummary(List<WMMSolver.Statistics> statList, int iterationCount,
                                                long totalSolvingTime, long boundCheckTime) {
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
                .append("Total solving time(ms): ").append(totalSolvingTime).append("\n")
                .append("Total model extraction time(ms): ").append(totalModelExtractTime).append("\n")
                .append("Total population time(ms): ").append(totalPopulationTime).append("\n")
                .append("Total consistency check time(ms): ").append(totalConsistencyCheckTime).append("\n")
                .append("Total reason computation time(ms): ").append(totalReasonComputationTime).append("\n")
                .append("Total #computed core reasons: ").append(totalNumReasons).append("\n")
                .append("Total #computed core reduced reasons: ").append(totalNumReducedReasons).append("\n");
        if (statList.size() > 0) {
            message.append("Min model size (#events): ").append(minModelSize).append("\n")
                    .append("Average model size (#events): ").append(totalModelSize / statList.size()).append("\n")
                    .append("Max model size (#events): ").append(maxModelSize).append("\n");
        }
        message.append("Bound check time(ms): ").append(boundCheckTime);

        return message;
    }

    //TODO: This code is very specific to visualize the core reasons found
    // in refinement iterations. We might want to generalize this.
    private static void generateGraphvizFiles(RefinementTask task, ExecutionModel model, int iterationCount, DNF<CoreLiteral> reasons) {
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

        String directoryName = String.format("%s/dartagnan/output/refinement/", System.getenv("DAT3M_HOME"));
        String fileNameBase = String.format("%s-%d", programName, iterationCount);
        File fileVio = new File(directoryName + fileNameBase + ".dot");
        fileVio.getParentFile().mkdirs();
        try (FileWriter writer = new FileWriter(fileVio)) {
            // Create .dot file
            new ExecutionGraphVisualizer()
                    .setReadFromFilter(edgeFilter)
                    .setCoherenceFilter(edgeFilter)
                    .generateGraphOfExecutionModel(writer, "Iteration " + iterationCount, model);

            writer.flush();
            // Convert .dot file to pdf
            Process p = new ProcessBuilder()
                    .directory(new File(directoryName))
                    .command("dot", "-Tpdf", fileNameBase + ".dot", "-o", fileNameBase + ".pdf")
                    .start();
            p.waitFor(1000, TimeUnit.MILLISECONDS);
        } catch (Exception e) {
            logger.error(e);
        }

        fileNameBase += "-full";
        File fileFull = new File(directoryName + fileNameBase + ".dot");
        try (FileWriter writer = new FileWriter(fileFull)) {
            // Create .dot file
            new ExecutionGraphVisualizer()
                    //.setReadFromFilter(edgeFilter)
                    //.setCoherenceFilter(edgeFilter)
                    .generateGraphOfExecutionModel(writer, "Iteration " + iterationCount, model);

            writer.flush();
            // Convert .dot file to pdf
            Process p = new ProcessBuilder()
                    .directory(new File(directoryName))
                    .command("dot", "-Tpdf", fileNameBase + ".dot", "-o", fileNameBase + ".pdf")
                    .start();
            p.waitFor(1000, TimeUnit.MILLISECONDS);
        } catch (Exception e) {
            logger.error(e);
        }
    }




    /*
        This class handles the computation of refinement clauses from violations found by the saturation procedure.
        Furthermore, it incorporates symmetry reasoning if possible.
     */
    private static class Refiner {
        private final RefinementTask task;
        private final SolverContext context;
        private final List<Function<Event, Event>> symmPermutations;

        public Refiner(RefinementTask task, SolverContext ctx) {
            this.task = task;
            this.context = ctx;
            symmPermutations = computeSymmetryPermutations(REFINEMENT_SYMMETRY_LEARNING);
        }


        // This method computes a refinement clause from a set of violations.
        // Furthermore, it computes symmetric violations if symmetry learning is enabled.
        public BooleanFormula refine(DNF<CoreLiteral> coreReasons) {
            BooleanFormulaManager bmgr = context.getFormulaManager().getBooleanFormulaManager();
            BooleanFormula refinement = bmgr.makeTrue();
            // For each symmetry permutation, we will create refinement clauses
            for (Function<Event, Event> perm : symmPermutations) {
                for (Conjunction<CoreLiteral> reason : coreReasons.getCubes()) {
                    BooleanFormula permutedClause = reason.getLiterals().stream()
                            .map(lit -> bmgr.not(permuteAndConvert(lit, perm)))
                            .reduce(bmgr.makeFalse(), bmgr::or);
                    refinement = bmgr.and(refinement, permutedClause);
                }
            }
            return refinement;
        }

        // Computes a list of permutations allowed by the program.
        // Depending on the <learningOption>, the set of computed permutations differs.
        // In particular, for the option NONE, only the identity permutation will be returned.
        private List<Function<Event, Event>> computeSymmetryPermutations(SymmetryLearning learningOption) {
            ThreadSymmetry symm = task.getThreadSymmetry();
            Set<? extends EquivalenceClass<Thread>> symmClasses = symm.getNonTrivialClasses();
            List<Function<Event, Event>> perms = new ArrayList<>();
            perms.add(Function.identity());

            for (EquivalenceClass<Thread> c : symmClasses) {
                List<Thread> threads = new ArrayList<>(c);
                threads.sort(Comparator.comparingInt(Thread::getId));

                switch (learningOption) {
                    case NONE:
                        break;
                    case LINEAR:
                        for (int i = 0; i < threads.size(); i++) {
                            int j = (i + 1) % threads.size();
                            perms.add(symm.createTransposition(threads.get(i), threads.get(j)));
                        }
                        break;
                    case QUADRATIC:
                        for (int i = 0; i < threads.size(); i++) {
                            for (int j = i + 1; j < threads.size(); j++) {
                                perms.add(symm.createTransposition(threads.get(i), threads.get(j)));
                            }
                        }
                        break;
                    case FULL:
                        List<Function<Event, Event>> allPerms = symm.createAllPermutations(c);
                        allPerms.remove(Function.identity()); // We avoid adding multiple identities
                        perms.addAll(allPerms);
                        break;
                    default:
                        throw new UnsupportedOperationException("Symmetry learning option: "
                                + learningOption.name() + " is not recognized.");
                }
            }

            return perms;
        }


        // Changes a reasoning <literal> based on a given permutation <perm> and translates the result
        // into a BooleanFormula for Refinement.
        private BooleanFormula permuteAndConvert(CoreLiteral literal, Function<Event, Event> perm) {
            BooleanFormulaManager bmgr = context.getFormulaManager().getBooleanFormulaManager();
            BooleanFormula enc;
            if (literal instanceof ExecLiteral) {
                ExecLiteral lit = (ExecLiteral) literal;
                enc =  perm.apply(lit.getData()).exec();
            } else if (literal instanceof AddressLiteral) {
                AddressLiteral loc = (AddressLiteral) literal;
                MemEvent e1 = (MemEvent) perm.apply(loc.getFirst());
                MemEvent e2 = (MemEvent) perm.apply(loc.getSecond());
                enc =  generalEqual(e1.getMemAddressExpr(), e2.getMemAddressExpr(), context);
            } else if (literal instanceof RelLiteral) {
                RelLiteral lit = (RelLiteral) literal;
                Relation rel = task.getMemoryModel().getRelationRepository().getRelation(lit.getName());
                enc =  rel.getSMTVar(
                        perm.apply(lit.getData().getFirst()),
                        perm.apply(lit.getData().getSecond()),
                        context);
            } else {
                throw new IllegalArgumentException("CoreLiteral " + literal.toString() + " is not supported");
            }

            return literal.isNegative() ? bmgr.not(enc) : enc;
        }

    }

}
