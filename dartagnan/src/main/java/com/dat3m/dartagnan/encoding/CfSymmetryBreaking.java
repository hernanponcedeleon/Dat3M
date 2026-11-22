package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.BranchEquivalence;
import com.dat3m.dartagnan.program.analysis.ThreadSymmetry;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.smt.EncodingUtils;
import com.dat3m.dartagnan.utils.equivalence.EquivalenceClass;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;

import java.util.*;
import java.util.function.Function;

/*
    Control-flow-based symmetry breaking.

    For every class of symmetric threads T_1 < ... < T_k (ordered by id), each thread's row consists of the execution
    variables of its own branch representatives, in a fixed order that is the same for all threads (up to the thread
    renaming). We encode the lex-leader constraints r_1 >= r_2 >= ... >= r_k on consecutive rows.
    Since every row only refers to its own thread, all constraints compare the same key (the thread's control-flow
    vector), so they just sort the threads by that key: sorting the threads of any execution by it yields an
    equivalent execution satisfying all constraints, i.e., no symmetry orbit is excluded.
 */
class CfSymmetryBreaking {

    private final EncodingContext context;
    private final ThreadSymmetry symm;
    private final BranchEquivalence branchEq;

    CfSymmetryBreaking(EncodingContext context) {
        this.context = context;
        this.symm = context.getAnalysisContext().requires(ThreadSymmetry.class);
        this.branchEq = context.getAnalysisContext().requires(BranchEquivalence.class);
    }

    BooleanFormula encode() {
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        final Set<Event> branchReps = computeBranchRepresentatives();
        final List<BooleanFormula> enc = new ArrayList<>();
        for (EquivalenceClass<Thread> symmClass : symm.getNonTrivialClasses()) {
            enc.add(encode(symmClass, branchReps));
        }
        return bmgr.and(enc);
    }

    private BooleanFormula encode(EquivalenceClass<Thread> symmClass, Set<Event> branchReps) {
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        final EncodingUtils utils = context.getFormulaManager().getEncodingUtils();
        final Thread rep = symmClass.getRepresentative();
        final List<Thread> threads = new ArrayList<>(symmClass);
        threads.sort(Comparator.comparingInt(Thread::getId));

        // IMPORTANT: Each thread writes to its own special location for the purpose of starting/terminating threads.
        // These need to get skipped.
        Thread t1 = threads.getFirst();
        final Set<Event> spawning = new HashSet<>(t1.getSpawningEvents());
        List<Event> t1Row = t1.getEvents().stream()
                .filter(e -> branchReps.contains(e) && !spawning.contains(e))
                .sorted(Event::compareTo)
                .toList();

        final List<BooleanFormula> enc = new ArrayList<>();
        for (int i = 1; i < threads.size(); i++) {
            final Thread t2 = threads.get(i);
            final Function<Event, Event> p = symm.createEventTransposition(t1, t2);
            final List<Event> t2Row = t1Row.stream().map(p).toList();

            final List<BooleanFormula> r1 = t1Row.stream().map(context::execution).toList();
            final List<BooleanFormula> r2 = t2Row.stream().map(context::execution).toList();
            final String id = String.format("T%d_%d", rep.getId(), i);
            enc.add(utils.encodeLexLeader(r2, r1, id)); // r1 >= r2

            t1 = t2;
            t1Row = t2Row;
        }
        return bmgr.and(enc);
    }

    private Set<Event> computeBranchRepresentatives() {
        final Set<Event> reps = new HashSet<>();
        branchEq.getAllEquivalenceClasses().forEach(c -> {
            if (c != branchEq.getInitialClass() && c != branchEq.getUnreachableClass()) {
                reps.add(c.getRepresentative());
            }
        });
        return reps;
    }
}
