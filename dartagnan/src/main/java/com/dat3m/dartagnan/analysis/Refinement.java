package com.dat3m.dartagnan.analysis;

import com.dat3m.dartagnan.analysis.saturation.SaturationSolver;
import com.dat3m.dartagnan.analysis.saturation.SolverResult;
import com.dat3m.dartagnan.analysis.saturation.SolverStatistics;
import com.dat3m.dartagnan.analysis.saturation.SolverStatus;
import com.dat3m.dartagnan.analysis.saturation.logic.Conjunction;
import com.dat3m.dartagnan.analysis.saturation.logic.DNF;
import com.dat3m.dartagnan.analysis.saturation.reasoning.AddressLiteral;
import com.dat3m.dartagnan.analysis.saturation.reasoning.CoreLiteral;
import com.dat3m.dartagnan.analysis.saturation.reasoning.EdgeLiteral;
import com.dat3m.dartagnan.analysis.saturation.reasoning.EventLiteral;
import com.dat3m.dartagnan.asserts.AssertTrue;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.MemEvent;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.equivalence.BranchEquivalence;
import com.dat3m.dartagnan.utils.equivalence.EquivalenceClass;
import com.dat3m.dartagnan.utils.symmetry.ThreadSymmetry;
import com.dat3m.dartagnan.verification.RefinementTask;
import com.dat3m.dartagnan.wmm.relation.Relation;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.java_smt.api.*;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Set;
import java.util.function.Function;

import static com.dat3m.dartagnan.GlobalSettings.*;
import static com.dat3m.dartagnan.analysis.saturation.SolverStatus.INCONCLUSIVE;
import static com.dat3m.dartagnan.analysis.saturation.SolverStatus.INCONSISTENT;
import static com.dat3m.dartagnan.program.utils.Utils.generalEqual;
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

    //TODO: Currently, we pop the complete refinement before performing the bound check
    // This may lead to situations where a bound is only reachable because
    // we don't have a memory model and thus the bound check is imprecise.
    // We may even want to perform refinement to check the bounds (we envision a case where the
    // refinement is accurate enough to verify the assertions but not accurate enough to check the bounds)
    //TODO 2: We do not yet use Witness information. The problem is that WitnessGraph.encode() generates
    // constraints on hb, which is not encoded in Refinement.
    public static Result runAnalysisSaturationSolver(SolverContext ctx, ProverEnvironment prover, RefinementTask task)
            throws InterruptedException, SolverException {

        task.unrollAndCompile();
        if(task.getProgram().getAss() instanceof AssertTrue) {
            logger.info("Verification finished: assertion trivially holds");
            return PASS;
        }

        task.initialiseEncoding(ctx);

        // ======= Some preprocessing to use a visible representative for each branch ========
        for (BranchEquivalence.Class c : task.getBranchEquivalence().getAllEquivalenceClasses()) {
            c.stream().sorted().filter(e -> e.is(EType.VISIBLE) && e.cfImpliesExec())
                    .findFirst().ifPresent(c::setRepresentative);
            // NOTE: If the branch has no visible events, Refinement will never care about it.
            // If all visible branch events have cf != exec, then Refinement should never try
            // to make use of any representative.
        }
        // =====================================================================================

        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        Program program = task.getProgram();
        SaturationSolver saturationSolver = new SaturationSolver(task, SATURATION_MODE);
        Refiner refiner = new Refiner(task, ctx);
        SolverStatus status = INCONSISTENT;

        prover.addConstraint(task.encodeProgram(ctx));
        if (SATURATION_REDUCE_REASONS_TO_CORE_REASONS) {
            prover.addConstraint(task.encodeBaselineWmmRelations(ctx));
            prover.addConstraint(task.encodeBaselineWmmConsistency(ctx));
            //task.getMemoryModel().encodeBase(ctx);
        } else {
            // ==== Test Code ====
            // If we do not reduce the reasons to core reasons,
            prover.addConstraint(task.encodeBaselineWmmRelations(ctx));
            task.getMemoryModel().encodeBase(ctx); // Just to trigger min/max-set computation
            prover.addConstraint(task.getMemoryModel().encodeConsistency(ctx));
        }

        if (ENABLE_SYMMETRY_BREAKING) {
            prover.addConstraint(task.encodeSymmetryBreaking(ctx));
        }

        prover.push();
        prover.addConstraint(task.encodeAssertions(ctx));

        //  ------ Just for statistics ------
        List<DNF<CoreLiteral>> foundCoreReasons = new ArrayList<>();
        List<SolverStatistics> statList = new ArrayList<>();
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

            SolverResult solverResult;
            try (Model model = prover.getModel()) {
                solverResult = saturationSolver.check(model, ctx);
            }

            SolverStatistics stats = solverResult.getStatistics();
            statList.add(stats);
            logger.debug("Refinement iteration:\n{}", stats);

            status = solverResult.getStatus();
            if (status == INCONSISTENT) {
                DNF<CoreLiteral> reasons = solverResult.getCoreReasons();
                foundCoreReasons.add(reasons);
                prover.addConstraint(refiner.refine(reasons));

                /*for (Constraint c : saturationSolver.getExecutionGraph().getConstraints()) {
                    RelationGraph g = c.getConstrainedGraph();
                    Relation rel = task.getMemoryModel().getRelationRepository().getRelation(g.getName());
                    for (Edge e : c.getConstrainedGraph()) {
                        BooleanFormula implication = bmgr.or(refiner.refine(new DNF<>(saturationSolver.getReasoner().computeReason(g, e))), rel.getSMTVar(e.toTuple(), ctx));
                        prover.addConstraint(implication);
                    }
                }*/

                /*Map<RelationGraph, Map<Edge, DNF<CoreLiteral>>> cutEdgeReasonMap = saturationSolver.getReasoner().getCutEdgeReasonMap();
                for (RelationGraph g : cutEdgeReasonMap.keySet()) {
                    Relation rel = task.getMemoryModel().getRelationRepository().getRelation(g.getName());
                    for (Map.Entry<Edge, DNF<CoreLiteral>> entry : cutEdgeReasonMap.get(g).entrySet()) {
                        Edge e = entry.getKey();
                        DNF<CoreLiteral> derivation = entry.getValue();
                        BooleanFormula implication = bmgr.or(refiner.refine(derivation), rel.getSMTVar(e.toTuple(), ctx));
                        prover.addConstraint(implication);
                    }
                }*/

                // ====== Test code =======
                /*Map<RelationGraph, Relation> graphRelMap = saturationSolver.getExecutionGraph().getRelationGraphMap().inverse();
                for (DependencyGraph<TypedEdge>.Node node : saturationSolver.getImplicationGraph().getDependencyGraph().getNodes()) {
                    if (node.getDependencies().isEmpty()) {
                        continue;
                    }
                    Relation rel = graphRelMap.get(node.getContent().getGraph());
                    if (rel == null || rel.getDependencies().isEmpty()) {
                        continue; // For the internal sco relation
                    }

                    BooleanFormula edgeExpr = rel.getSMTVar(node.getContent().toTuple(), ctx);
                    BooleanFormula deps = bmgr.makeTrue();
                    for (TypedEdge dep : node.getDependencies().stream().map(DependencyGraph.Node::getContent).collect(Collectors.toList())) {
                        Relation r = graphRelMap.get(dep.getGraph());
                        deps = bmgr.and(deps, r.getSMTVar(dep.toTuple(), ctx));
                    }
                    prover.addConstraint(bmgr.implication(deps, edgeExpr));
                }*/
                // ====================

                if (logger.isTraceEnabled()) {
                    // Some statistics
                    StringBuilder message = new StringBuilder().append("Found inconsistency reasons:");
                    for (Conjunction<CoreLiteral> cube : reasons.getCubes()) {
                        message.append("\n")
                                .append("Reason size: ").append(cube.getSize()).append("\n")
                                .append(cube);
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
                    throw new IllegalStateException("Unknown result type returned by SaturationSolver.");
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

        logSummary(statList, iterationCount, totalSolvingTime, boundCheckTime);

        veriResult = program.getAss().getInvert() ? veriResult.invert() : veriResult;
        logger.info("Verification finished with result " + veriResult);
        return veriResult;
    }


    // ======================= Helper Methods ======================

    // -------------------- Printing -----------------------------

    private static void logSummary(List<SolverStatistics> statList, int iterationCount,
                                   long totalSolvingTime, long boundCheckTime) {
        if (!logger.isInfoEnabled()) {
            return;
        }

        long totalModelTime = 0;
        long totalSearchTime = 0;
        long totalReasonComputationTime = 0;
        long totalResolutionTime = 0;
        long totalNumGuesses = 0;
        long totalNumReasons = 0;
        long totalNumReducedReasons = 0;
        long totalNumCoreReasons = 0;
        long totalModelSize = 0;
        long minModelSize = Long.MAX_VALUE;
        long maxModelSize = Long.MIN_VALUE;
        int satDepth = 0;

        for (SolverStatistics stats : statList) {
            totalModelTime += stats.getModelConstructionTime();
            totalSearchTime += stats.getSearchTime();
            totalReasonComputationTime += stats.getReasonComputationTime();
            totalResolutionTime += stats.getResolutionTime();
            totalNumGuesses += stats.getNumGuessedCoherences();
            totalNumReasons += stats.getNumComputedReasons();
            totalNumReducedReasons += stats.getNumComputedReducedReasons();
            totalNumCoreReasons += stats.getNumComputedCoreReasons();
            satDepth = Math.max(satDepth, stats.getSaturationDepth());

            totalModelSize += stats.getModelSize();
            minModelSize = Math.min(stats.getModelSize(), minModelSize);
            maxModelSize = Math.max(stats.getModelSize(), maxModelSize);
        }

        StringBuilder message = new StringBuilder().append("Summary").append("\n")
                .append(" ======== Summary ========").append("\n")
                .append("Number of iterations: ").append(iterationCount).append("\n")
                .append("Total solving time(ms): ").append(totalSolvingTime).append("\n")
                .append("Total model construction time(ms): ").append(totalModelTime).append("\n")
                .append("Total reason computation time(ms): ").append(totalReasonComputationTime).append("\n")
                .append("Total resolution time(ms): ").append(totalResolutionTime).append("\n")
                .append("Total search time(ms): ").append(totalSearchTime).append("\n")
                .append("Total #guessings: ").append(totalNumGuesses).append("\n")
                .append("Total #computed reasons: ").append(totalNumReasons).append("\n")
                .append("Total #computed reduced reasons: ").append(totalNumReducedReasons).append("\n")
                .append("Total #computed core reasons: ").append(totalNumCoreReasons).append("\n");
        if (statList.size() > 0) {
            message.append("Min model size (#events): ").append(minModelSize).append("\n")
                    .append("Average model size (#events): ").append(totalModelSize / statList.size()).append("\n")
                    .append("Max model size (#events): ").append(maxModelSize).append("\n");
        }
        message.append("Max Saturation Depth: ").append(satDepth).append("\n")
                .append("Bound check time(ms): ").append(boundCheckTime);

        logger.info(message);
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

        public BooleanFormula refineLearned(DNF<CoreLiteral> learnedReasons) {
            //TODO: We might want to handle these clauses in a special way
            // and e.g. avoid negating co-literals but instead flip them
            return refine(learnedReasons);
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
            if (literal instanceof EventLiteral) {
                EventLiteral lit = (EventLiteral) literal;
                return perm.apply(lit.getEventData().getEvent()).exec();
            } else if (literal instanceof AddressLiteral) {
                AddressLiteral loc = (AddressLiteral) literal;
                MemEvent e1 = (MemEvent) perm.apply(loc.getEdge().getFirst().getEvent());
                MemEvent e2 = (MemEvent) perm.apply(loc.getEdge().getSecond().getEvent());
                return generalEqual(e1.getMemAddressExpr(), e2.getMemAddressExpr(), context);
            } else if (literal instanceof EdgeLiteral) {
                EdgeLiteral lit = (EdgeLiteral) literal;
                Relation rel = task.getMemoryModel().getRelationRepository().getRelation(lit.getName());
                return rel.getSMTVar(
                        perm.apply(lit.getEdge().getFirst().getEvent()),
                        perm.apply(lit.getEdge().getSecond().getEvent()),
                        context);
                /*return Utils.edge(lit.getName(),
                        perm.apply(lit.getEdge().getFirst().getEvent()),
                        perm.apply(lit.getEdge().getSecond().getEvent()), context);*/
            }
            throw new IllegalArgumentException("CoreLiteral " + literal.toString() + " is not supported");
        }

    }

}
