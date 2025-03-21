package com.dat3m.dartagnan.utils.symmetry;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.encoding.SymmetryEncoder;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.ThreadSymmetry;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.utils.equivalence.EquivalenceClass;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.RelationNameRepository;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;

import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

/*
    Coherence-based symmetry breaking

    IDEA:
    (1) General symmetry breaking:
    Assume x1 and x2 are boolean variables and that x2 is in some sense symmetric to x1.
    There are 4 possibilities to assign truth values to the pair (x1, x2).
    The idea of symmetry breaking is to eliminate one asymmetric possibility
    (where one is TRUE, the other one is FALSE) by forcing x1 to be the TRUE one.
    If symmetry cannot be broken (because both x1 and x2 take the same value),
    one tries to break symmetry on the next pair (x3, x4) and so on.

    (2) Using coherence properties:
    Suppose we break on a coherence edge x1 = co(w1, w2) where w2 is symmetric to w1 (w2 = perm(w1)).
    The symmetric variable will be x2 = co(w2, w1).
    Due to acyclicity of co, we know that x1=x2=TRUE is impossible.
    Furthermore, if we know that w1 and w2 must alias and that w1 and w2 get executed,
    then by totality we cannot have x1=x2=FALSE either.
    Hence, x1 != x2 and symmetry breaking is then guaranteed to apply, forcing
    x1=TRUE and x2=FALSE.
    Generally, we won't be able to establish that w1 and w2 are guaranteed to execute, so
    the symmetry breaking may not succeed here and may proceed with another pair of variables.
    However, we know that it will succeed if both events get executed (+ we established must-alias)
    and this suffices to establish that (w1, w2) is part of the must-set of co.

    (3) Details/Implementation:
        (1) We take some thread and order its writes by their "synchronisation degree" (a measure that tells how
        strongly a co-edge from that write to some symmetric write would synchronize)
        (2) We find the first write W that is guaranteed to alias with its symmetric writes
        (3) We perform symmetry breaking in the following way:
            - We order the symmetric threads by id and denote by W_i the instance of W that corresponds to thread i.
            - We create a row of the form (exec(W_1), co(W_1, W_2), co(W_1, W_3), ...);(other co-vars independent of W_1)
            - We encode complete row-symmetry breaking on this row and its symmetric rows
              (obtained by the transpositions (i <-> i+1))
        (4) Due to the order of symmetry breaking, we have "co(W_i, W_j) is a must-edge for all i < j".

    NOTE: The addition of "exec(W_1)" to the front of the row allows the following reasoning:
          - If co(W_1, W_3) happens, then so does exec(W_3). By symmetry breaking, we have to have exec(W_2) as well.
            But then, also by symmetry breaking, we have co(W_1, W_2) and co(W_2, W_3).
          - In other words, it allows us to assume that all threads that execute their W_i are adjacent
            and we do not get "gaps" if some intermediate thread does not execute its write W
 */
public class CoSymmetryBreaking {

    private static final Logger logger = LogManager.getLogger(CoSymmetryBreaking.class);

    private final EncodingContext context;
    private final VerificationTask task;
    private final ThreadSymmetry symm;
    private final AliasAnalysis alias;
    private final RelationAnalysis ra;
    private final Relation co;

    private final Map<EquivalenceClass<Thread>, Info> infoMap;

    // Stores information per symmetry class
    private static class Info {
        List<Thread> threads; // Sorted list of threads of the symmetry class
        List<Store> writes; // Writes ordered by importance / breaking order
        boolean hasMustEdges; // True if the coherences of the first write in <writes> can be broken via must-edges.
    }

    public CoSymmetryBreaking(EncodingContext context) {
        this.context = context;
        this.task = context.getTask();
        this.symm = context.getAnalysisContext().requires(ThreadSymmetry.class);
        this.alias = context.getAnalysisContext().requires(AliasAnalysis.class);
        this.ra = context.getAnalysisContext().requires(RelationAnalysis.class);
        this.co = task.getMemoryModel().getRelation(RelationNameRepository.CO);
        infoMap = new HashMap<>();
        for (EquivalenceClass<Thread> symmClass : symm.getNonTrivialClasses()) {
            initialize(symmClass);
        }
    }

    private void initialize(EquivalenceClass<Thread> symmClass) {
        Info info = new Info();
        infoMap.put(symmClass, info);

        // Get symmetric threads and order them by tid
        List<Thread> symmThreads = new ArrayList<>(symmClass);
        symmThreads.sort(Comparator.comparingInt(Thread::getId));
        info.threads = symmThreads;

        // Get stores of first thread
        List<Store> writes = symmThreads.get(0).getEvents().stream()
                .filter(Store.class::isInstance).map(Store.class::cast)
                .collect(Collectors.toList());

        // Symmetric writes that cannot alias are related to e.g. thread-creation
        // We do not want to break on those
        writes.removeIf(w -> !alias.mayAlias(w, (Store)symm.map(w, symmThreads.get(1))));

        // We compute the (overall) sync-degree of a write w as the maximal sync degree over all
        // axioms. The sync-degree of w for axiom(r) is computed via must(r).
        List<Axiom> axioms = task.getMemoryModel().getAxioms();
        Map<Store, Integer> syncDegreeMap = new HashMap<>(writes.size());
        for (final Axiom ax : axioms) {
            final RelationAnalysis.Knowledge k = ra.getKnowledge(ax.getRelation());
            final Map<Event, Set<Event>> mustIn = k.getMustSet().getInMap();
            final Map<Event, Set<Event>> mustOut = k.getMustSet().getOutMap();
            for (final Store w : writes) {
                final int in = 1 + mustIn.getOrDefault(w, Set.of()).size();
                final int out = 1 + mustOut.getOrDefault(w, Set.of()).size();
                syncDegreeMap.merge(w, in * out, Integer::sum);
            }
        }

        // Sort the writes by sync-degree (highest first).
        // This will be the order in which we break coherences!
        Comparator<Store> breakingOrder = Comparator.<Store>comparingInt(syncDegreeMap::get).reversed();
        writes.sort(breakingOrder);

        // To allow the fixation of must-edges for symmetry breaking, we move the
        // very first write that is guaranteed to alias with its symmetric writes to the
        // first position.
        for (int i = 0; i < writes.size(); i++) {
            Store w = writes.get(i);

            boolean mustAlias = symmThreads.stream()
                    .allMatch(t -> alias.mustAlias(w, (Store)symm.map(w, t)));

            if (mustAlias) {
                info.hasMustEdges = true;
                writes.add(0, writes.remove(i)); // Move entry to front
                break;
            }
        }
        info.writes = writes;
    }

    /*
        Computes co must-edges that are implied by this symmetry breaking
        May return an empty list.
    */
    public List<Tuple> computeMustEdges() {
        List<Tuple> mustEdges = new ArrayList<>();

        for (Info info : infoMap.values()) {
            if (!info.hasMustEdges) {
                continue;
            }

            Store w = info.writes.get(0);
            final int numThreads = info.threads.size();
            for (int i = 0; i < numThreads; i++) {
                for (int j = i + 1; j < numThreads; j++) {
                    mustEdges.add(new Tuple(
                            symm.map(w, info.threads.get(i)),
                            symm.map(w, info.threads.get(j))
                    ));
                }
            }
        }

        return mustEdges;
    }

    public BooleanFormula encode() {
        BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        List<BooleanFormula> enc = new ArrayList<>();
        for (EquivalenceClass<Thread> symmClass : symm.getNonTrivialClasses()) {
            enc.add(encode(symmClass));
        }
        return bmgr.and(enc);
    }

    public BooleanFormula encode(EquivalenceClass<Thread> symmClass) {
        BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        if (symmClass.getEquivalence() != symm) {
            return bmgr.makeTrue();
        }
        Info info = infoMap.get(symmClass);
        if (info == null) {
            logger.warn("Cannot encode co-symmetry because no information has been computed. " +
                    "Make sure that <initialize> gets called before encoding.");
            return bmgr.makeTrue();
        }
        List<Thread> symmThreads = info.threads;
        EncodingContext.EdgeEncoder edge = context.edge(co);

        // ============= Construct rows =============
        Thread t1 = symmThreads.get(0);
        List<Thread> otherThreads = symmThreads.subList(1, symmThreads.size());

        List<Tuple> r1Tuples = new ArrayList<>();
        for (Store w : info.writes) {
            for (Thread t2 : otherThreads) {
                r1Tuples.add(new Tuple(w, symm.map(w, t2)));
            }
        }
        // Starting row
        List<BooleanFormula> r1 = new ArrayList<>(r1Tuples.size() + 1);
        if (info.hasMustEdges) {
            r1.add(context.execution(info.writes.get(0)));
        }
        for (Tuple t : r1Tuples) {
            r1.add(edge.encode(t.first(), t.second()));
        }
        // Construct symmetric rows
        List<BooleanFormula> enc = new ArrayList<>();
        Thread rep = symmClass.getRepresentative();
        for (int i = 1; i < symmThreads.size(); i++) {
            Thread t2 = symmThreads.get(i);
            Function<Event, Event> p = symm.createEventTransposition(t1, t2);
            List<Tuple> r2Tuples = r1Tuples.stream().map(t -> new Tuple(p.apply(t.first()), p.apply(t.second()))).collect(Collectors.toList());
            List<BooleanFormula> r2 = new ArrayList<>(r2Tuples.size() + 1);
            if (info.hasMustEdges) {
                r2.add(context.execution(symm.map(info.writes.get(0), t2)));
            }
            for (Tuple t : r2Tuples) {
                r2.add(edge.encode(t.first(), t.second()));
            }

            final String id = "_" + rep.getId() + "_" + i;
            // NOTE: We want to have r1 >= r2 but lexLeader encodes r1 <= r2, so we swap r1 and r2.
            enc.add(SymmetryEncoder.encodeLexLeader(id, r2, r1, context));

            t1 = t2;
            r1Tuples = r2Tuples;
            r1 = r2;
        }

        return bmgr.and(enc);
    }
}
