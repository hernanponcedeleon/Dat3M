package com.dat3m.dartagnan.analysis;

import com.dat3m.dartagnan.analysis.graphRefinement.GraphRefinement;
import com.dat3m.dartagnan.analysis.graphRefinement.RefinementResult;
import com.dat3m.dartagnan.analysis.graphRefinement.RefinementStats;
import com.dat3m.dartagnan.analysis.graphRefinement.coreReason.*;
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
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Acyclic;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.relation.binary.RelUnion;
import com.dat3m.dartagnan.wmm.utils.RelationRepository;
import com.dat3m.dartagnan.wmm.utils.Utils;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Solver;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Set;
import java.util.function.Function;

import static com.dat3m.dartagnan.GlobalSettings.*;
import static com.dat3m.dartagnan.utils.Result.*;
import static com.microsoft.z3.Status.SATISFIABLE;

public class Refinement {

    private static final Logger logger = LogManager.getLogger(Refinement.class);

    //TODO: Currently, we pop the complete refinement before performing the bound check
    // This may lead to situations where a bound is only reachable because
    // we don't have a memory model and thus the bound check is imprecise.
    // We may want to add the current refinement back to perform the bound check
    // We may even want to perform refinement to check the bounds (we envision a case where the
    // refinement is accurate enough to verify the assertions but not accurate enough to check the bounds)

    //TODO(2): Add flags for printing stats (currently the stats always get printed)


    // Runs graph-based refinement, starting from the empty memory model.
    public static Result runAnalysisGraphRefinement(Solver solver, Context ctx, VerificationTask task) {
        task.unrollAndCompile();
        if(task.getProgram().getAss() instanceof AssertTrue) {
            return PASS;
        }

        task.initialiseEncoding(ctx);
        solver.add(task.encodeProgram(ctx));
        if (REF_USE_OUTER_WMM) {
            Wmm outer = createOuterWmm(task);
            outer.initialise(task, ctx); // this is a little suspicious
            solver.add(outer.encode(ctx));
            solver.add(outer.consistent(ctx));
        } else {
            solver.add(task.encodeWmmCore(ctx));
        }

        return refinementCore(solver, ctx, task);
    }

    // Test code
    private static Wmm createOuterWmm(VerificationTask task) {
        Wmm original = task.getMemoryModel();
        Wmm outerWmm = new Wmm();
        outerWmm.setEncodeCo(false);
        RelationRepository origRepo = original.getRelationRepository();
        RelationRepository repo = outerWmm.getRelationRepository();
        // We copy relations from the original WMM to avoid recomputations of max-/minSets
        // This causes active set computations to be reflected in the original WMM (which shouldn't be problematic)
        repo.addRelation(origRepo.getRelation("rf"));
        repo.addRelation(origRepo.getRelation("po"));
        repo.addRelation(origRepo.getRelation("co"));
        repo.addRelation(origRepo.getRelation("idd"));
        repo.addRelation(origRepo.getRelation("addrDirect"));
        if (origRepo.containsRelation("loc")) {
            repo.addRelation(origRepo.getRelation("loc"));
        }
        if (origRepo.containsRelation("po-loc")) {
            repo.addRelation(origRepo.getRelation("po-loc"));
        }

        // ---- acyclic(po-loc | rf) ----
        Relation poloc = repo.getRelation("po-loc");
        Relation rf = repo.getRelation("rf");
        Relation porf = new RelUnion(poloc, rf);
        repo.addRelation(porf);
        outerWmm.addAxiom(new Acyclic(porf));

        // ---- acyclic (dep | rf) ----
        if (REF_ADD_ACYCLIC_DEP_RF) {
            if (origRepo.containsRelation("data")) {
                repo.addRelation(origRepo.getRelation("data"));
            }
            if (origRepo.containsRelation("ctrl")) {
                repo.addRelation(origRepo.getRelation("ctrl"));
            }
            if (origRepo.containsRelation("addr")) {
                repo.addRelation(origRepo.getRelation("addr"));
            }
            Relation data = repo.getRelation("data");
            Relation ctrl = repo.getRelation("ctrl");
            Relation addr = repo.getRelation("addr");
            Relation dep = new RelUnion(data, addr);
            repo.addRelation(dep);
            dep = new RelUnion(ctrl, dep);
            repo.addRelation(dep);
            Relation hb = new RelUnion(dep, rf);
            repo.addRelation(hb);
            outerWmm.addAxiom(new Acyclic(hb));
        }

        return outerWmm;
    }


    private static List<Function<Event, Event>> computePerms(VerificationTask task) {

        ThreadSymmetry symm = task.getThreadSymmetry();
        Set<? extends EquivalenceClass<Thread>> symmClasses = symm.getNonTrivialClasses();
        List<Function<Event, Event>> perms = new ArrayList<>();
        if (symmClasses.isEmpty() || REF_SYMMETRY_LEARNING == SymmetryLearning.NONE) {
            perms.add(Function.identity());
            return perms;
        }

        for (EquivalenceClass<Thread> c : symmClasses) {
            List<Thread> threads = new ArrayList<>(c);
            threads.sort(Comparator.comparingInt(Thread::getId));
            if (REF_SYMMETRY_LEARNING == SymmetryLearning.LINEAR) {
                // ==== Linear ====
                perms.add(Function.identity());
                for (int i = 0; i < threads.size(); i++) {
                    int j = (i + 1) < threads.size() ? i + 1 : 0;
                    perms.add(symm.createTransposition(threads.get(i), threads.get(j)));
                }
            } else if (REF_SYMMETRY_LEARNING == SymmetryLearning.QUADRATIC) {
                // ==== Quadratic ====
                perms.add(Function.identity());
                for (int i = 0; i < threads.size(); i++) {
                    for (int j = i + 1; j < threads.size(); j++) {
                        perms.add(symm.createTransposition(threads.get(i), threads.get(j)));
                    }
                }
            } else if (REF_SYMMETRY_LEARNING == SymmetryLearning.FULL) {
                // ==== Full ====
                perms.addAll(symm.createAllPermutations(c));
            }
        }

        return perms;
    }


    private static Result refinementCore(Solver solver, Context ctx, VerificationTask task) {

        // ======= Some preprocessing to use a visible representative for each branch ========
        for (BranchEquivalence.Class c : task.getBranchEquivalence().getAllEquivalenceClasses()) {
            ArrayList<Event> events = new ArrayList<>(c);
            events.sort(Comparator.naturalOrder());
            for (Event e : events) {
                if (e.is(EType.VISIBLE)) {
                    c.setRepresentative(e);
                    break;
                }
            }
        }
        // =====================================================================================

        Program program = task.getProgram();
        GraphRefinement refinement = new GraphRefinement(task);
        Result res = UNKNOWN;

        // ====== Test code ======
        List<Function<Event, Event>> perms = computePerms(task);
        // ----------
        if (ENABLE_SYMMETRY_BREAKING) {
            solver.add(task.encodeSymmetryBreaking(ctx));
        }
        // =======================

        solver.push();
        solver.add(task.encodeAssertions(ctx));

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
            if (REF_PRINT_STATISTICS) {
                System.out.println(" ===== Iteration: " + ++vioCount + " =====");
            /*System.out.println(solver.getStatistics().get("mk clause"));
            System.out.println(solver.getStatistics().get("mk bool var"));*/
                System.out.println("Solving time( ms): " + (curTime - lastTime));
            }
            totalSolvingTime += (curTime - lastTime);

            RefinementResult gRes = refinement.kSearch(solver.getModel(), ctx, 2);
            RefinementStats stats = gRes.getStatistics();
            statList.add(stats);
            if (REF_PRINT_STATISTICS) {
                System.out.println(stats.toString());
            }

            res = gRes.getResult();
            if (res == FAIL) {
                DNF<CoreLiteral> violations = gRes.getViolations();
                foundViolations.add(violations);
                refine(solver, ctx, violations, perms);
                // Some statistics
                for (Conjunction<CoreLiteral> cube : violations.getCubes()) {
                    if (REF_PRINT_STATISTICS) {
                        System.out.println("Violation size: " + cube.getSize());
                        //System.out.println(cube);
                    }
                    Conjunction<CoreLiteral> excludedRf = cube.removeIf(x -> !(x instanceof RfLiteral));
                    excludedRfs.add(excludedRf);
                    if (REF_PRINT_STATISTICS) {
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
        if (REF_PRINT_STATISTICS) {
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
            // We found a violation
            System.out.println("Violation verified");
        } else {
            // We showed safety but still need to verify bounds
            System.out.println("Safety proven");
        }

        long boundCheckTime = 0;
        if(solver.check() == SATISFIABLE) {
            res = FAIL;
        } else {
            // ------- CHECK BOUNDS -------
            lastTime = System.currentTimeMillis();
            solver.pop();
            solver.add(ctx.mkNot(program.encodeNoBoundEventExec(ctx)));
            res = solver.check() == SATISFIABLE ? UNKNOWN : PASS;
            if (res == UNKNOWN) {
                //TODO: This is just a temporary fallback
                // We have to perform a second refinement for the bound checks!
                for (DNF<CoreLiteral> violation : foundViolations) {
                    refine(solver, ctx, violation, perms);
                }
                res = solver.check() == SATISFIABLE ? UNKNOWN : PASS;
            }
            boundCheckTime = System.currentTimeMillis() - lastTime;
        }
        if (REF_PRINT_STATISTICS) {
            printSummary(statList, totalSolvingTime, boundCheckTime, excludedRfs);
        }

        res = program.getAss().getInvert() ? res.invert() : res;
        logger.info("Verification finished with result " + res);
        return res;
    }


    private static void refine(Solver solver, Context ctx, DNF<CoreLiteral> coreViolations, List<Function<Event, Event>> perms) {
        for (Function<Event, Event> p : perms) {

            BoolExpr refinement = ctx.mkTrue();
            for (Conjunction<CoreLiteral> violation : coreViolations.getCubes()) {
                BoolExpr clause = ctx.mkFalse();
                for (CoreLiteral literal : violation.getLiterals()) {
                    clause = ctx.mkOr(clause, ctx.mkNot(permute(literal, p, ctx)/*literal.getZ3BoolExpr(ctx))*/));
                }
                refinement = ctx.mkAnd(refinement, clause);
            }
            solver.add(refinement);
        }
    }

    private static BoolExpr permute(CoreLiteral literal, Function<Event, Event> p, Context ctx) {
        if (literal instanceof EventLiteral) {
            EventLiteral lit = (EventLiteral) literal;
            return p.apply(lit.getEvent().getEvent()).exec();
        } else if (literal instanceof LocLiteral) {
            LocLiteral loc = (LocLiteral) literal;
            MemEvent e1 = (MemEvent) p.apply(loc.getEdge().getFirst().getEvent());
            MemEvent e2 = (MemEvent) p.apply(loc.getEdge().getSecond().getEvent());
            return ctx.mkEq(e1.getMemAddressExpr(), e2.getMemAddressExpr());
        } else if (literal instanceof AbstractEdgeLiteral) {
            AbstractEdgeLiteral lit = (AbstractEdgeLiteral) literal;
            return Utils.edge(lit.getName(), p.apply(lit.getEdge().getFirst().getEvent()), p.apply(lit.getEdge().getSecond().getEvent()), ctx);
        }
        return null;
    }


    private static void printSummary(List<RefinementStats> statList, long totalSolvingTime, long boundCheckTime, List<Conjunction<CoreLiteral>> excludedRfs) {
        final boolean PRINT_RFS = false;

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

        System.out.println(" ======= Summary ========");
        System.out.println("Total solving time( ms): " + totalSolvingTime);
        System.out.println("Total model construction time( ms): " + totalModelTime);
        if (statList.size() > 0) {
            System.out.println("Min model size (#events): " + minModelSize);
            System.out.println("Average model size (#events): " + totalModelSize / statList.size());
            System.out.println("Max model size (#events): " + maxModelSize);
        }
        System.out.println("Total violation computation time( ms): " + totalViolationComputationTime);
        System.out.println("Total resolution time( ms): " + totalResolutionTime);
        System.out.println("Total search time( ms): " + totalSearchTime);
        System.out.println("Total guessing: " + totalNumGuesses);
        System.out.println("Total violations: " + totalNumViolations);
        System.out.println("Max Saturation Depth: " + satDepth);
        System.out.println("Bound check time( ms): " + boundCheckTime);

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
