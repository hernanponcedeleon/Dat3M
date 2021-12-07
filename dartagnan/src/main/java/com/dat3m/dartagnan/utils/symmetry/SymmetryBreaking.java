package com.dat3m.dartagnan.utils.symmetry;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.utils.equivalence.EquivalenceClass;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.RelationRepository;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import com.google.common.base.Preconditions;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.GlobalSettings.*;


// A first rough implementation for symmetry breaking
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
        // These need to get skipped!
        Thread t1 = symmThreads.get(0);
        List<Tuple> r1 = new ArrayList<>();
        for (Tuple t : rel.getMaxTupleSet()) {
            Event a = t.getFirst();
            Event b = t.getSecond();
            if (!a.is(EType.PTHREAD) && !b.is(EType.PTHREAD) && a.getThread() == t1) {
                r1.add(t);
            }
        }
        sort(r1);

        // Construct symmetric rows
        for (int i = 1; i < symmThreads.size(); i++) {
            Thread t2 = symmThreads.get(i);
            Function<Event, Event> p = symm.createTransposition(t1, t2);
            List<Tuple> r2 = r1.stream().map(t -> mapTuple(t, p)).collect(Collectors.toList());
            enc = bmgr.and(enc, encodeLexLeader(rep, i, r1, r2, ctx));
            t1 = t2;
            r1 = r2;
        }

        return enc;
    }

    private void sort(List<Tuple> row) {
        if (!BREAK_SYMMETRY_BY_SYNC_DEGREE) {
            row.sort(Comparator.naturalOrder());
            return;
        }

        // Setup of data structures
        Map<Axiom, Map<Event, Integer>> inDegrees = new HashMap<>();
        Map<Axiom, Map<Event, Integer>> outDegrees = new HashMap<>();
        Set<Event> inEvents = new HashSet<>();
        Set<Event> outEvents = new HashSet<>();
        for (Tuple t : row) {
            inEvents.add(t.getFirst());
            outEvents.add(t.getSecond());
        }

        // Compute sync degrees per axiom
        for (Axiom ax : task.getAxioms()) {
            TupleSet mustSet = ax.getRelation().getMinTupleSet();
            Map<Event, Integer> in = inDegrees.computeIfAbsent(ax, key -> new HashMap<>());
            Map<Event, Integer> out = outDegrees.computeIfAbsent(ax, key -> new HashMap<>());

            for (Event e : inEvents) {
                in.put(e, mustSet.getBySecond(e).size());
            }
            for (Event e : outEvents) {
                out.put(e, mustSet.getByFirst(e).size());
            }
        }

        // Combine sync degrees of axioms
        Map<Event, Integer> combInDegree = new HashMap<>(inEvents.size());
        Map<Event, Integer> combOutDegree = new HashMap<>(outEvents.size());
        for (Axiom ax : task.getAxioms()) {
            for (Map.Entry<Event, Integer> entry : inDegrees.get(ax).entrySet()) {
                combInDegree.compute(entry.getKey(), (k, v) -> Math.max(v == null ? -1 : v, entry.getValue()));
            }
            for (Map.Entry<Event, Integer> entry : outDegrees.get(ax).entrySet()) {
                combOutDegree.compute(entry.getKey(), (k, v) -> Math.max(v == null ? -1 : v, entry.getValue()));
            }
        }

        // Sort by sync degrees
        row.sort(Comparator.<Tuple>comparingInt(t -> combInDegree.get(t.getFirst()) * combOutDegree.get(t.getSecond())).reversed());
    }

    /*
    Used variables:
    - y0, ..., y(n-1)
    - x1, ..., xn
    with a suffix for the involved symmetry class.
     */
    private BooleanFormula encodeLexLeader(Thread rep, int index, List<Tuple> r1, List<Tuple> r2, SolverContext ctx) {
        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        int size = Math.min(r1.size(), LEX_LEADER_SIZE);
        String suffix = "_" + rep.getId() + "_" + index;
        BooleanFormula ylast = bmgr.makeVariable("y0" + suffix);
        BooleanFormula enc = bmgr.equivalence(ylast, bmgr.makeTrue());
        // From x1 to x(n-1)
        for (int i = 1; i < size; i++) {
            BooleanFormula y = bmgr.makeVariable("y" + i + suffix);
            BooleanFormula orig = rel.getSMTVar(r1.get(i-1), ctx);
            BooleanFormula perm = rel.getSMTVar(r2.get(i-1), ctx);
            enc = bmgr.and(
                    enc,
                    bmgr.or(y, bmgr.not(ylast), bmgr.not(orig)),
                    bmgr.or(y, bmgr.not(ylast), perm),
                    bmgr.or(bmgr.not(ylast), bmgr.not(orig), perm)
            );
            ylast = y;
        }
        // Final iteration is handled differently
        BooleanFormula orig = rel.getSMTVar(r1.get(size-1), ctx);
        BooleanFormula perm = rel.getSMTVar(r2.get(size-1), ctx);
        enc = bmgr.and(enc, bmgr.or(bmgr.not(ylast), bmgr.not(orig), perm));


        return enc;
    }

    private Tuple mapTuple(Tuple t, Function<Event, Event> p) {
        return new Tuple(p.apply(t.getFirst()), p.apply(t.getSecond()));
    }
}
