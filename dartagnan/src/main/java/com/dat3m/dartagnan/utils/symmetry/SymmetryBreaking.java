package com.dat3m.dartagnan.utils.symmetry;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.ThreadSymmetry;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.utils.equivalence.EquivalenceClass;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.RelationRepository;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.google.common.base.Preconditions;
import com.google.common.collect.Lists;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.GlobalSettings.BREAK_SYMMETRY_BY_SYNC_DEGREE;
import static com.dat3m.dartagnan.GlobalSettings.BREAK_SYMMETRY_ON_RELATION;

public class SymmetryBreaking {

    private final VerificationTask task;
    private final ThreadSymmetry symm;
    private final Relation rel;

    public SymmetryBreaking(VerificationTask task) {
        this.task = task;
        this.symm = task.getThreadSymmetry();

        RelationRepository repo = task.getMemoryModel().getRelationRepository();
        Preconditions.checkState(repo.containsRelation(BREAK_SYMMETRY_ON_RELATION),
                "Unknown relation: " + BREAK_SYMMETRY_ON_RELATION);
        this.rel = repo.getRelation(BREAK_SYMMETRY_ON_RELATION);

    }

    public BooleanFormula encode(SolverContext ctx) {
        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        BooleanFormula enc = bmgr.makeTrue();
        for (EquivalenceClass<Thread> symmClass : symm.getNonTrivialClasses()) {
            enc = bmgr.and(enc, encode(symmClass, ctx));
        }
        return enc;
    }

    public BooleanFormula encode(EquivalenceClass<Thread> symmClass, SolverContext ctx) {
        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        BooleanFormula enc = bmgr.makeTrue();
        if (symmClass.getEquivalence() != symm) {
            return enc;
        }

        Thread rep = symmClass.getRepresentative();
        List<Thread> symmThreads = new ArrayList<>(symmClass);
        symmThreads.sort(Comparator.comparingInt(Thread::getId));


        // ===== Construct row =====
        //IMPORTANT: Each thread writes to its own special location for the purpose of starting/terminating threads
        // These need to get skipped.
        Thread t1 = symmThreads.get(0);
        List<Tuple> r1Tuples = new ArrayList<>();
        for (Tuple t : rel.getMaxTupleSet()) {
            Event a = t.getFirst();
            Event b = t.getSecond();
            if (!a.is(EType.PTHREAD) && !b.is(EType.PTHREAD) && a.getThread() == t1) {
                r1Tuples.add(t);
            }
        }
        sort(r1Tuples);

        // Construct symmetric rows
        for (int i = 1; i < symmThreads.size(); i++) {
            Thread t2 = symmThreads.get(i);
            Function<Event, Event> p = symm.createTransposition(t1, t2);
            List<Tuple> r2Tuples = r1Tuples.stream().map(t -> t.permute(p)).collect(Collectors.toList());

            List<BooleanFormula> r1 = Lists.transform(r1Tuples, t -> rel.getSMTVar(t, ctx));
            List<BooleanFormula> r2 = Lists.transform(r2Tuples, t -> rel.getSMTVar(t, ctx));
            final String id = "_" + rep.getId() + "_" + i;
            enc = bmgr.and(enc, encodeLexLeader(id, r2, r1, ctx)); // r1 >= r2

            t1 = t2;
            r1Tuples = r2Tuples;
        }

        return enc;
    }

    private void sort(List<Tuple> row) {
        if (!BREAK_SYMMETRY_BY_SYNC_DEGREE) {
            // ===== Natural order =====
            row.sort(Comparator.naturalOrder());
            return;
        }

        // ====== Sync-degree based order ======

        // Setup of data structures
        Set<Event> inEvents = new HashSet<>();
        Set<Event> outEvents = new HashSet<>();
        for (Tuple t : row) {
            inEvents.add(t.getFirst());
            outEvents.add(t.getSecond());
        }

        Map<Event, Integer> combInDegree = new HashMap<>(inEvents.size());
        Map<Event, Integer> combOutDegree = new HashMap<>(outEvents.size());

        List<Axiom> axioms = task.getAxioms();
        for (Event e : inEvents) {
            int syncDeg = axioms.stream()
                    .mapToInt(ax -> ax.getRelation().getMinTupleSet().getBySecond(e).size() + 1).max().orElse(0);
            combInDegree.put(e, syncDeg);
        }
        for (Event e : outEvents) {
            int syncDec = axioms.stream()
                    .mapToInt(ax -> ax.getRelation().getMinTupleSet().getByFirst(e).size() + 1).max().orElse(0);
            combOutDegree.put(e, syncDec);
        }

        // Sort by sync degrees
        row.sort(Comparator.<Tuple>comparingInt(t -> combInDegree.get(t.getFirst()) * combOutDegree.get(t.getSecond())).reversed());
    }

    // ========================= Static utility ===========================


    /*
        Encodes that any assignment obeys "r1 <= r2" where the order is
        the lexicographic order based on "false < true".
        In other words, for all assignments to the variables of r1/r2,
        the first time r1(i) and r2(i) get different truth values,
        we will have r1(i) = FALSE and r2(i) = TRUE.

        NOTE: Creates extra variables named "yi_<uniqueIdent>" which can cause conflicts if
              <uniqueIdent> is not uniquely used.
    */
    public static BooleanFormula encodeLexLeader(String uniqueIdent, List<BooleanFormula> r1, List<BooleanFormula> r2, SolverContext ctx) {
        Preconditions.checkArgument(r1.size() == r2.size());

        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        final int size = r1.size();
        final String suffix = "_" + uniqueIdent;

        // We interpret the variables of <ri> as x1(ri), ..., xn(ri).
        // We create helper variables y0_suffix, ..., y(n-1)_suffix (note the index shift compared to xi)
        // xi gets related to y(i-1) and yi

        BooleanFormula ylast = bmgr.makeVariable("y0" + suffix); // y(i-1)
        BooleanFormula enc = bmgr.equivalence(ylast, bmgr.makeTrue());
        // From x1 to x(n-1)
        for (int i = 1; i < size; i++) {
            BooleanFormula y = bmgr.makeVariable("y" + i + suffix); // yi
            BooleanFormula a = r1.get(i-1); // xi(r1)
            BooleanFormula b = r2.get(i-1); // xi(r2)
            enc = bmgr.and(
                    enc,
                    bmgr.or(y, bmgr.not(ylast), bmgr.not(a)), // (see below)
                    bmgr.or(y, bmgr.not(ylast), b),           // "y(i-1) implies ((xi(r1) >= xi(r2))  =>  yi)"
                    bmgr.or(bmgr.not(ylast), bmgr.not(a), b)  // "y(i-1) implies (xi(r1) <= xi(r2))"
                    // NOTE: yi = TRUE means the prefixes (x1, x2, ..., xi) of the rows r1/r2 are equal
                    //       yi = FALSE means that no conditions are imposed on xi
                    // The first point, where y(i-1) is TRUE but yi is FALSE, is the breaking point
                    // where xi(r1) < xi(r2) holds (afterwards all yj (j >= i+1) are unconstrained and can be set to
                    // FALSE by the solver)
            );
            ylast = y;
        }
        // Final iteration for xn is handled differently as there is no variable yn anymore.
        BooleanFormula a = r1.get(size-1);
        BooleanFormula b = r2.get(size-1);
        enc = bmgr.and(enc, bmgr.or(bmgr.not(ylast), bmgr.not(a), b));


        return enc;
    }
}
