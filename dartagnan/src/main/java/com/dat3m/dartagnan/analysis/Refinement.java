package com.dat3m.dartagnan.analysis;

import com.dat3m.dartagnan.asserts.AssertTrue;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.RefinementResult;
import com.dat3m.dartagnan.wmm.graphRefinement.VerificationContext;
import com.dat3m.dartagnan.wmm.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.wmm.graphRefinement.coreReason.RfLiteral;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.GraphRefinement;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.RefinementStats;
import com.dat3m.dartagnan.wmm.graphRefinement.logic.Conjunction;
import com.dat3m.dartagnan.wmm.graphRefinement.logic.DNF;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Solver;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

import static com.dat3m.dartagnan.utils.Result.*;
import static com.microsoft.z3.Status.SATISFIABLE;
import static com.microsoft.z3.Status.UNSATISFIABLE;

public class Refinement {

    //TODO: Currently, we pop the complete refinement before performing the bound check
    // This may lead to situations where a bound is only reachable because
    // we don't have a memory model and thus the bound check is imprecise.
    // We may want to add the current refinement back to perform the bound check
    // We may even want to perform refinement to check the bounds (we envision a case where the
    // refinement is accurate enough to verify the assertions but not accurate enough to check the bounds)

    //TODO(2): Add flags for printing stats (currently the stats always get printed)

    static final boolean PRINT_STATISTICS = true;


    // Encodes an underapproximation of the target WMM by assuming an empty coherence relation.
    // Then performs graph-based refinement.
    public static Result runAnalysisGraphRefinementEmptyCoherence(Solver solver, Context ctx, Program program, Wmm wmm, Arch target, Settings settings) {
        VerificationContext verificationContext = new VerificationContext(program, wmm, target, settings);
        GraphRefinement refinement = new GraphRefinement(verificationContext);
        program.unroll(settings.getBound(), 0);
        program.compile(target, 0);
        // AssertionInline depends on compiled events (copies)
        // Thus we need to update the assertion after compilation
        program.updateAssertion();
        if(program.getAss() instanceof AssertTrue) {
            return PASS;
        }

        BoolExpr cfEncoding = program.encodeCF(ctx);
        BoolExpr finalRegValueEncoding = program.encodeFinalRegisterValues(ctx);
        BoolExpr wmmCoreEncoding = wmm.encodeEmptyCo(program, ctx, settings);
        BoolExpr wmmConsistency = wmm.consistent(program, ctx);
        BoolExpr assertionEncoding = program.getAss().encode(ctx);
        if (program.getAssFilter() != null) {
            assertionEncoding = ctx.mkAnd(program.getAssFilter().encode(ctx));
        }

        solver.add(cfEncoding);
        solver.add(finalRegValueEncoding);
        solver.add(wmmCoreEncoding);
        solver.add(wmmConsistency);
        solver.push();
        solver.add(assertionEncoding);

        //globalRefinement = ctx.mkTrue();

        Result res = UNKNOWN;

        // Just for statistics
        List<Conjunction<CoreLiteral>> excludedRfs = new ArrayList<>();
        List<DNF<CoreLiteral>> foundViolations = new ArrayList<>();
        List<RefinementStats> statList = new ArrayList<>();
        int vioCount = 0;

        long lastTime = System.currentTimeMillis();
        long curTime;
        long totalSolvingTime = 0;

        while (solver.check() == SATISFIABLE) {
            curTime = System.currentTimeMillis();
            System.out.println(" ===== Iteration: " + ++vioCount + " =====");
            System.out.println("Solving time(ms): " + (curTime - lastTime));
            totalSolvingTime += (curTime - lastTime);

            RefinementResult gRes = refinement.kSearch(solver.getModel(), ctx, 2);
            RefinementStats stats = gRes.getStatistics();
            statList.add(stats);
            System.out.println(stats.toString());

            res = gRes.getResult();
            if (res == Result.FAIL) {
                DNF<CoreLiteral> violations = gRes.getViolations();
                foundViolations.add(violations);
                refine(solver, ctx, violations);
                // Some statistics
                for (Conjunction<CoreLiteral> cube : violations.getCubes()) {
                    System.out.println("Violation size: " + cube.getSize());
                    Conjunction<CoreLiteral> excludedRf = cube.removeIf(x -> !(x instanceof RfLiteral));
                    excludedRfs.add(excludedRf);
                    printStats(excludedRf);
                }
            } else {
                // No violations found, we can't refine
                break;
            }
            lastTime = System.currentTimeMillis();
        }
        curTime = System.currentTimeMillis();
        System.out.println(" ===== Final Iteration: " + (vioCount + 1) + " =====");
        System.out.println("Solving/Proof time(ms): " + (curTime - lastTime));
        totalSolvingTime += (curTime - lastTime);

        // Possible outcomes: - check() == SAT && res == UNKNOWN -> Inconclusive
        //                    - check() == SAT && res == PASS -> Unsafe
        //                    - check() == UNSAT -> Safe

        if (solver.check() == SATISFIABLE && res == UNKNOWN) {
            // We couldn't verify the found counterexample, nor exclude it.
            System.out.println("PROCEDURE was inconclusive");
            return res;
        } else if (solver.check() == SATISFIABLE) {
            // We found a violation, but we still need to test the bounds.
            System.out.println("Violation verified");
        } else {
            System.out.println("Safety proven");
        }

        lastTime = System.currentTimeMillis();
        if(solver.check() == SATISFIABLE) {
            solver.add(program.encodeNoBoundEventExec(ctx));
            res = solver.check() == SATISFIABLE ? FAIL : UNKNOWN;
        } else {
            solver.pop();
            //solver.add(globalRefinement);
            solver.add(ctx.mkNot(program.encodeNoBoundEventExec(ctx)));
            res = solver.check() == SATISFIABLE ? UNKNOWN : PASS;
        }
        long boundCheckTime = System.currentTimeMillis() - lastTime;
        printSummary(statList, totalSolvingTime, boundCheckTime, excludedRfs);

        res = program.getAss().getInvert() ? res.invert() : res;
        return res;
    }


    // Runs graph-based refinement, starting from the empty memory model.
    public static Result runAnalysisGraphRefinement(Solver solver, Context ctx, Program program, Wmm wmm, Arch target, Settings settings) {
        VerificationContext verificationContext = new VerificationContext(program, wmm, target, settings);
        GraphRefinement refinement = new GraphRefinement(verificationContext);
        program.simplify();
        program.unroll(settings.getBound(), 0);
        program.compile(target, 0);
        // AssertionInline depends on compiled events (copies)
        // Thus we need to update the assertion after compilation
        program.updateAssertion();
        if(program.getAss() instanceof AssertTrue) {
            return PASS;
        }

        BoolExpr cfEncoding = program.encodeCF(ctx);
        BoolExpr finalRegValueEncoding = program.encodeFinalRegisterValues(ctx);
        BoolExpr wmmCoreEncoding = wmm.encodeCore(program, ctx, settings);
        BoolExpr assertionEncoding = program.getAss().encode(ctx);
        if (program.getAssFilter() != null) {
            assertionEncoding = ctx.mkAnd(program.getAssFilter().encode(ctx));
        }

        solver.add(cfEncoding);
        solver.add(finalRegValueEncoding);
        solver.add(wmmCoreEncoding);
        solver.push();
        solver.add(assertionEncoding);


        Result res = UNKNOWN;

        // Just for statistics
        List<Conjunction<CoreLiteral>> excludedRfs = new ArrayList<>();
        List<DNF<CoreLiteral>> foundViolations = new ArrayList<>();
        List<RefinementStats> statList = new ArrayList<>();
        int vioCount = 0;

        long lastTime = System.currentTimeMillis();
        long curTime;
        long totalSolvingTime = 0;

        while (solver.check() == SATISFIABLE) {
            curTime = System.currentTimeMillis();
            if (PRINT_STATISTICS) {
                System.out.println(" ===== Iteration: " + ++vioCount + " =====");
            /*System.out.println(solver.getStatistics().get("mk clause"));
            System.out.println(solver.getStatistics().get("mk bool var"));*/
                System.out.println("Solving time(ms): " + (curTime - lastTime));
            }
            totalSolvingTime += (curTime - lastTime);

            RefinementResult gRes = refinement.kSearch(solver.getModel(), ctx, 2);
            RefinementStats stats = gRes.getStatistics();
            statList.add(stats);
            if (PRINT_STATISTICS) {
                System.out.println(stats.toString());
            }

            res = gRes.getResult();
            if (res == Result.FAIL) {
                DNF<CoreLiteral> violations = gRes.getViolations();
                foundViolations.add(violations);
                refine(solver, ctx, violations);
                // Some statistics
                for (Conjunction<CoreLiteral> cube : violations.getCubes()) {
                    if (PRINT_STATISTICS) {
                        System.out.println("Violation size: " + cube.getSize());
                    }
                    Conjunction<CoreLiteral> excludedRf = cube.removeIf(x -> !(x instanceof RfLiteral));
                    excludedRfs.add(excludedRf);
                    if (PRINT_STATISTICS) {
                        printStats(excludedRf);
                    }
                }
            } else {
                // No violations found, we can't refine
                break;
            }
            lastTime = System.currentTimeMillis();
        }
        curTime = System.currentTimeMillis();
        if (PRINT_STATISTICS) {
            System.out.println(" ===== Final Iteration: " + (vioCount + 1) + " =====");
            System.out.println("Solving/Proof time(ms): " + (curTime - lastTime));
        }
        totalSolvingTime += (curTime - lastTime);

        // Possible outcomes: - check() == SAT && res == UNKNOWN -> Inconclusive
        //                    - check() == SAT && res == PASS -> Unsafe
        //                    - check() == UNSAT -> Safe


        if (solver.check() == SATISFIABLE && res == UNKNOWN) {
            // We couldn't verify the found counterexample, nor exclude it.
            System.out.println("PROCEDURE was inconclusive");
            return res;
        } else if (solver.check() == SATISFIABLE) {
            // We found a violation, but we still need to test the bounds.
            System.out.println("Violation verified");
        } else {
            System.out.println("Safety proven");
        }

        lastTime = System.currentTimeMillis();
        if(solver.check() == SATISFIABLE) {
            solver.add(program.encodeNoBoundEventExec(ctx));
            res = solver.check() == SATISFIABLE ? FAIL : UNKNOWN;
        } else {
            solver.pop();
            solver.add(ctx.mkNot(program.encodeNoBoundEventExec(ctx)));
            res = solver.check() == SATISFIABLE ? UNKNOWN : PASS;
            if (res == UNKNOWN) {
                //TODO: This is just a temporary fallback
                // We have to perform a second refinement for the bound checks!
                for (DNF<CoreLiteral> violation : foundViolations) {
                    refine(solver, ctx, violation);
                }
                res = solver.check() == SATISFIABLE ? UNKNOWN : PASS;
            }
        }
        long boundCheckTime = System.currentTimeMillis() - lastTime;
        if (PRINT_STATISTICS) {
            printSummary(statList, totalSolvingTime, boundCheckTime, excludedRfs);
        }

        res = program.getAss().getInvert() ? res.invert() : res;
        return res;
    }


    private static void refine(Solver solver, Context ctx, DNF<CoreLiteral> coreViolations) {
        BoolExpr refinement = ctx.mkTrue();
        for (Conjunction<CoreLiteral> violation : coreViolations.getCubes()) {
            BoolExpr clause = ctx.mkFalse();
            for (CoreLiteral literal : violation.getLiterals()) {
                clause = ctx.mkOr(clause, ctx.mkNot(literal.getZ3BoolExpr(ctx)));
            }
            refinement = ctx.mkAnd(refinement, clause);
        }
        solver.add(refinement);
    }


    private static void printSummary(List<RefinementStats> statList, long totalSolvingTime, long boundCheckTime, List<Conjunction<CoreLiteral>> excludedRfs) {
        final boolean PRINT_RFS = false;

        long totalModelTime = 0;
        long totalSearchTime = 0;
        long totalViolationComputationTime = 0;
        long totalResolutionTime = 0;
        long totalNumGuesses = 0;
        long totalNumViolations = 0;
        int satDepth = 0;

        for (RefinementStats stats : statList) {
            totalModelTime += stats.getModelConstructionTime();
            totalSearchTime += stats.getSearchTime();
            totalViolationComputationTime += stats.getViolationComputationTime();
            totalResolutionTime += stats.getResolutionTime();
            totalNumGuesses += stats.getNumGuessedCoherences();
            totalNumViolations += stats.getNumComputedViolations();
            satDepth = Math.max(satDepth, stats.getSaturationDepth());
        }

        System.out.println(" ======= Summary ========");
        System.out.println("Total solving time(ms): " + totalSolvingTime);
        System.out.println("Total model construction time(ms): " + totalModelTime);
        System.out.println("Total violation computation time(ms): " + totalViolationComputationTime);
        System.out.println("Total resolution time(ms): " + totalResolutionTime);
        System.out.println("Total search time(ms): " + totalSearchTime);
        System.out.println("Total guessing: " + totalNumGuesses);
        System.out.println("Total violations: " + totalNumViolations);
        System.out.println("Max Saturation Depth: " + satDepth);
        System.out.println("Bound check time(ms): " + boundCheckTime);

        if (PRINT_RFS) {
            System.out.println("-------- Excluded Read-Froms --------");
            excludedRfs.sort(Comparator.comparingInt(Conjunction::getSize));
            for (Conjunction<CoreLiteral> cube : excludedRfs) {
                printStats(cube);
            }
        }

    }


    private static void printStats(Conjunction<CoreLiteral> cube) {
        System.out.print(cube);
        if (cube.getLiterals().stream().anyMatch(x -> ((RfLiteral)x).getEdge().isBackwardEdge())) {
            System.out.print(": future read");
        }
        System.out.println();
    }

}
