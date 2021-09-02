package com.dat3m.dartagnan.analysis;

import com.dat3m.dartagnan.analysis.graphRefinement.*;
import com.dat3m.dartagnan.analysis.graphRefinement.coreReason.AbstractEdgeLiteral;
import com.dat3m.dartagnan.analysis.graphRefinement.coreReason.AddressLiteral;
import com.dat3m.dartagnan.analysis.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.analysis.graphRefinement.coreReason.EventLiteral;
import com.dat3m.dartagnan.analysis.graphRefinement.logic.Conjunction;
import com.dat3m.dartagnan.analysis.graphRefinement.logic.DNF;
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
import com.dat3m.dartagnan.wmm.utils.Utils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.java_smt.api.*;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Set;
import java.util.function.Function;

import static com.dat3m.dartagnan.GlobalSettings.*;
import static com.dat3m.dartagnan.analysis.graphRefinement.RefinementStatus.INCONCLUSIVE;
import static com.dat3m.dartagnan.analysis.graphRefinement.RefinementStatus.REFUTED;
import static com.dat3m.dartagnan.program.utils.Utils.generalEqual;
import static com.dat3m.dartagnan.utils.Result.*;

public class Refinement {

    private static final Logger logger = LogManager.getLogger(Refinement.class);

    //TODO: Currently, we pop the complete refinement before performing the bound check
    // This may lead to situations where a bound is only reachable because
    // we don't have a memory model and thus the bound check is imprecise.
    // We may even want to perform refinement to check the bounds (we envision a case where the
    // refinement is accurate enough to verify the assertions but not accurate enough to check the bounds)
    public static Result runAnalysisGraphRefinement(SolverContext ctx, ProverEnvironment prover, RefinementTask task)
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
        GraphRefinement refinement = new GraphRefinement(task);
        RefinementStatus status = REFUTED;
        Refiner refiner = new Refiner(task, ctx);

        prover.addConstraint(task.encodeProgram(ctx));
        prover.addConstraint(task.encodeBaselineWmmRelations(ctx));
        prover.addConstraint(task.encodeBaselineWmmConsistency(ctx));
        if (ENABLE_SYMMETRY_BREAKING) {
            prover.addConstraint(task.encodeSymmetryBreaking(ctx));
        }

        prover.push();
        prover.addConstraint(task.encodeAssertions(ctx));

        //  ------ Just for statistics ------
        List<DNF<CoreLiteral>> foundViolations = new ArrayList<>();
        List<RefinementStats> statList = new ArrayList<>();
        int vioCount = 0;
        long lastTime = System.currentTimeMillis();
        long curTime;
        long totalSolvingTime = 0;
        //  ---------------------------------

        while (!prover.isUnsat()) {
            if (logger.isInfoEnabled()) {
                curTime = System.currentTimeMillis();
                totalSolvingTime += (curTime - lastTime);
                logger.info(" ===== Iteration: " + ++vioCount + " =====\n" +
                            "Solving time( ms): " + (curTime - lastTime));
            }

            RefinementResult gRes;
            try (Model model = prover.getModel()) {
                gRes = refinement.kSearch(model, ctx, task.getMaxSaturationDepth());
            }

            if (logger.isInfoEnabled()) {
                RefinementStats stats = gRes.getStatistics();
                statList.add(stats);
                logger.info(stats);
            }

            status = gRes.getStatus();
            if (status == REFUTED) {
                DNF<CoreLiteral> violations = gRes.getViolations();
                foundViolations.add(violations);
                prover.addConstraint(refiner.refine(violations));

                if (logger.isInfoEnabled()) {
                    // Some statistics
                    StringBuilder str = new StringBuilder();
                    for (Conjunction<CoreLiteral> cube : violations.getCubes()) {
                        str.append("Violation size: ").append(cube.getSize()).append("\n")
                                .append(cube).append("\n");
                    }
                    logger.info(str.toString());
                }
            } else {
                // No violations found, we can't refine
                break;
            }
            lastTime = System.currentTimeMillis();
        }

        if (logger.isInfoEnabled()) {
            curTime = System.currentTimeMillis();
            totalSolvingTime += (curTime - lastTime);
            StringBuilder builder = new StringBuilder()
                    .append(" ===== Final Iteration: ").append(vioCount + 1).append(" =====\n")
                    .append("Solving/Proof time(ms): ").append(curTime - lastTime).append("\n");
            switch (status) {
                case INCONCLUSIVE:
                    builder.append("Refinement procedure was inconclusive.");
                    break;
                case VERIFIED:
                    builder.append("Violation verified.");
                    break;
                case REFUTED:
                    builder.append("Bounded safety proven.");
                    break;
                default:
                    throw new IllegalStateException("Unknown result type returned by GraphRefinement.");
            }
            logger.info(builder);
        }

        if (status == INCONCLUSIVE) {
            // Refinement got no result, so we cannot proceed further.
            return UNKNOWN;
        }


        Result res;
        long boundCheckTime = 0;
        if (prover.isUnsat()) {
            // ------- CHECK BOUNDS -------
            lastTime = System.currentTimeMillis();
            prover.pop();
            prover.addConstraint(bmgr.not(program.encodeNoBoundEventExec(ctx)));
            res = !prover.isUnsat() ? UNKNOWN : PASS; // Initial bound check without any WMM constraints
            if (res == UNKNOWN) {
                //TODO: This is just a temporary fallback
                // We probably have to perform a second refinement for the bound checks!
                for (DNF<CoreLiteral> violation : foundViolations) {
                    prover.addConstraint(refiner.refine(violation));
                }
                res = !prover.isUnsat() ? UNKNOWN : PASS;
            }
            boundCheckTime = System.currentTimeMillis() - lastTime;
        } else {
            res = FAIL;
        }

        if (logger.isInfoEnabled()) {
            logSummary(statList, totalSolvingTime, boundCheckTime);
        }

        res = program.getAss().getInvert() ? res.invert() : res;
        logger.info("Verification finished with result " + res);
        return res;
    }


    // ======================= Helper Methods ======================

    // -------------------- Printing -----------------------------

    private static void logSummary(List<RefinementStats> statList, long totalSolvingTime, long boundCheckTime) {
        long totalModelTime = 0;
        long totalSearchTime = 0;
        long totalViolationComputationTime = 0;
        long totalResolutionTime = 0;
        long totalNumGuesses = 0;
        long totalNumViolations = 0;
        long totalModelSize = 0;
        long minModelSize = Long.MAX_VALUE;
        long maxModelSize = Long.MIN_VALUE;
        int satDepth = 0;

        for (RefinementStats stats : statList) {
            totalModelTime += stats.getModelConstructionTime();
            totalSearchTime += stats.getSearchTime();
            totalViolationComputationTime += stats.getViolationComputationTime();
            totalResolutionTime += stats.getResolutionTime();
            totalNumGuesses += stats.getNumGuessedCoherences();
            totalNumViolations += stats.getNumComputedViolations();
            satDepth = Math.max(satDepth, stats.getSaturationDepth());

            totalModelSize += stats.getModelSize();
            minModelSize = Math.min(stats.getModelSize(), minModelSize);
            maxModelSize = Math.max(stats.getModelSize(), maxModelSize);
        }

        StringBuilder builder = new StringBuilder()
                .append(" ======= Summary ========\n")
                .append("Total solving time( ms): ").append(totalSolvingTime).append("\n")
                .append("Total model construction time( ms): ").append(totalModelTime).append("\n");
        if (statList.size() > 0) {
            builder.append("Min model size (#events): ").append(minModelSize).append("\n")
                    .append("Average model size (#events): ").append(totalModelSize / statList.size()).append("\n")
                    .append("Max model size (#events): ").append(maxModelSize).append("\n");
        }
        builder.append("Total violation computation time( ms): ").append(totalViolationComputationTime).append("\n")
                .append("Total resolution time( ms): ").append(totalResolutionTime).append("\n")
                .append("Total search time( ms): ").append(totalSearchTime).append("\n")
                .append("Total guessing: ").append(totalNumGuesses).append("\n")
                .append("Total violations: ").append(totalNumViolations).append("\n")
                .append("Max Saturation Depth: ").append(satDepth).append("\n")
                .append("Bound check time( ms): ").append(boundCheckTime);

        logger.info(builder);
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
        public BooleanFormula refine(DNF<CoreLiteral> coreViolations) {
            BooleanFormulaManager bmgr = context.getFormulaManager().getBooleanFormulaManager();
            BooleanFormula refinement = bmgr.makeTrue();
            // For each symmetry permutation, we will create refinement clauses
            for (Function<Event, Event> perm : symmPermutations) {
                for (Conjunction<CoreLiteral> violation : coreViolations.getCubes()) {
                    BooleanFormula permutedClause = bmgr.makeFalse();
                    for (CoreLiteral literal : violation.getLiterals()) {
                        permutedClause = bmgr.or(permutedClause, bmgr.not(permuteAndConvert(literal, perm)));
                    }
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
            if (literal instanceof EventLiteral) {
                EventLiteral lit = (EventLiteral) literal;
                return perm.apply(lit.getEventData().getEvent()).exec();
            } else if (literal instanceof AddressLiteral) {
                AddressLiteral loc = (AddressLiteral) literal;
                MemEvent e1 = (MemEvent) perm.apply(loc.getEdge().getFirst().getEvent());
                MemEvent e2 = (MemEvent) perm.apply(loc.getEdge().getSecond().getEvent());
                return generalEqual(e1.getMemAddressExpr(), e2.getMemAddressExpr(), context);
            } else if (literal instanceof AbstractEdgeLiteral) {
                AbstractEdgeLiteral lit = (AbstractEdgeLiteral) literal;
                return Utils.edge(lit.getName(),
                        perm.apply(lit.getEdge().getFirst().getEvent()),
                        perm.apply(lit.getEdge().getSecond().getEvent()), context);
            }
            throw new IllegalArgumentException("CoreLiteral " + literal.toString() + " is not supported");
        }

    }

}
