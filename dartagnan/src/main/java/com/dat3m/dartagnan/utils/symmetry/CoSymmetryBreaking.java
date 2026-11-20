package com.dat3m.dartagnan.utils.symmetry;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.analysis.ExitImplicationAnalysis;
import com.dat3m.dartagnan.program.analysis.LoopAnalysis;
import com.dat3m.dartagnan.program.analysis.ReachingDefinitionsAnalysis;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.analysis.ThreadSymmetry;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Init;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.core.threading.ThreadReturn;
import com.dat3m.dartagnan.utils.equivalence.EquivalenceClass;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.RelationNameRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;

import java.util.*;

/*
    Coherence-based symmetry breaking.

    For every class of symmetric threads T_1 < ... < T_k (ordered by id), we consider the stores W^1, W^2, ... of
    T_1 whose symmetric copies W^l_1, ..., W^l_k must alias. Since co is total per address, the executed copies of
    each W^l have a well-defined co-rank. We restrict the search to executions where the threads are sorted
    lexicographically by the key
        (not exec(W^1), co-rank of W^1, not exec(W^2), co-rank of W^2, ...).
    That is, for threads i < j and each level l, guarded by "both threads skip W^1, ..., W^(l-1)":
        exec(W^l_j) => exec(W^l_i)                           (executing threads come first)
        exec(W^l_i) && exec(W^l_j) => co(W^l_i, W^l_j)       (executing threads are ordered by co)
    The key is invariant under thread renaming, so sorting the threads of any execution by it yields an equivalent
    execution satisfying all constraints: no symmetry orbit is excluded.

    Level order:
      (1) Stores whose value depends on a load from the same address come first, earliest in program order first.
          Coherence ties the rf-edges of that load to the co-order (e.g., "sum++" in a critical section, or the
          "fetch_add" of a ticket lock), and earlier stores are bypassed by fewer paths, so more threads (including
          those cut off later) get ordered by them.
      (2) The remaining stores are ordered by: executed whenever the thread terminates normally (implied by its
          ThreadReturn events), plain over RMW stores (RMW stores without such a dependency typically record lock
          acquisition attempts, e.g., an exchange), execution implies that an enclosing loop exits (e.g., the
          successful CAS of a retry loop, typically the linearization point; earlier iterations first), and
          closeness to the middle of the thread.
 */
public class CoSymmetryBreaking {

    private static final Logger logger = LoggerFactory.getLogger(CoSymmetryBreaking.class);

    private final EncodingContext context;
    private final ThreadSymmetry symm;
    private final AliasAnalysis alias;
    private final ExecutionAnalysis exec;
    private final ReachingDefinitionsAnalysis reachingDefinitions;
    private final Relation co;

    public CoSymmetryBreaking(EncodingContext context) {
        this.context = context;
        this.symm = context.getAnalysisContext().requires(ThreadSymmetry.class);
        this.alias = context.getAnalysisContext().requires(AliasAnalysis.class);
        this.exec = context.getAnalysisContext().requires(ExecutionAnalysis.class);
        this.reachingDefinitions = context.getAnalysisContext().requires(ReachingDefinitionsAnalysis.class);
        this.co = context.getTask().getMemoryModel().getRelation(RelationNameRepository.CO);
    }

    public BooleanFormula encode() {
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        final List<BooleanFormula> enc = new ArrayList<>();
        for (EquivalenceClass<Thread> symmClass : symm.getNonTrivialClasses()) {
            enc.add(encode(symmClass));
        }
        return bmgr.and(enc);
    }

    private BooleanFormula encode(EquivalenceClass<Thread> symmClass) {
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        final EncodingContext.EdgeEncoder edge = context.edge(co);
        final List<Thread> threads = new ArrayList<>(symmClass);
        threads.sort(Comparator.comparingInt(Thread::getId));
        final List<Store> levels = computeLevels(threads);
        logger.info("Co symmetry breaking for class of {} ({} threads): {} levels: {}", threads.getFirst(),
                threads.size(), levels.size(),
                levels.stream().map(w -> "E" + w.getGlobalId() + "@" + threads.getFirst().getEvents().indexOf(w)).toList());
        if (levels.isEmpty()) {
            return bmgr.makeTrue();
        }

        final List<BooleanFormula> enc = new ArrayList<>();
        // The executed copies of the first level form a prefix. This is implied by the constraints below, but
        // emitting these clauses first noticeably helps the solver.
        final Store first = levels.getFirst();
        for (int i = 0; i + 1 < threads.size(); i++) {
            enc.add(bmgr.implication(context.execution(symm.map(first, threads.get(i + 1))),
                    context.execution(symm.map(first, threads.get(i)))));
        }
        // Each level is encoded as two flat clauses; the guard "both threads skip all earlier levels" contributes
        // the disjunction of the earlier execution literals. On the first level (no guard), "e_i && e_j => co"
        // is simplified to "e_j => co" using "e_j => e_i". (Both measurably help the solver.)
        for (int i = 0; i < threads.size(); i++) {
            for (int j = i + 1; j < threads.size(); j++) {
                final List<BooleanFormula> earlierExecs = new ArrayList<>();
                for (Store w : levels) {
                    final Event wi = symm.map(w, threads.get(i));
                    final Event wj = symm.map(w, threads.get(j));
                    final BooleanFormula ei = context.execution(wi);
                    final BooleanFormula ej = context.execution(wj);
                    // guard => (e_j => e_i)
                    final List<BooleanFormula> execOrder = new ArrayList<>(earlierExecs);
                    execOrder.add(bmgr.not(ej));
                    execOrder.add(ei);
                    enc.add(bmgr.or(execOrder));
                    // guard => (e_i && e_j => co(W_i, W_j))
                    final List<BooleanFormula> coOrder = new ArrayList<>(earlierExecs);
                    if (!earlierExecs.isEmpty()) {
                        coOrder.add(bmgr.not(ei));
                    }
                    coOrder.add(bmgr.not(ej));
                    coOrder.add(edge.encode(wi, wj));
                    enc.add(bmgr.or(coOrder));
                    earlierExecs.add(ei);
                    earlierExecs.add(ej);
                }
            }
        }
        return bmgr.and(enc);
    }

    // Maps each store whose execution implies that (the current iteration of) some enclosing loop exits
    // to the number of that iteration (in the unrolled program).
    private Map<Store, Integer> computeLoopExitingStores(Thread thread, List<Store> stores) {
        final Map<Store, Integer> result = new HashMap<>();
        final List<LoopAnalysis.LoopInfo> loops;
        try {
            loops = LoopAnalysis.onFunction(thread).getLoopsOfFunction(thread);
        } catch (RuntimeException e) {
            logger.warn("Could not compute loops of {}: {}", thread, e.getMessage());
            return result;
        }
        for (LoopAnalysis.LoopInfo loop : loops) {
            for (LoopAnalysis.LoopIterationInfo iteration : loop.iterations()) {
                if (iteration.getIterationEnd() == null) {
                    continue;
                }
                final Set<Event> body = new HashSet<>(iteration.computeBody());
                final ExitImplicationAnalysis exitAnalysis = ExitImplicationAnalysis.forIteration(iteration);
                for (Store w : stores) {
                    if (body.contains(w) && exitAnalysis.impliesExit(w)) {
                        result.merge(w, iteration.getIterationNumber(), Math::min);
                    }
                }
            }
        }
        return result;
    }

    // True if the stored value (transitively, through register dependencies) depends on a load from the same address.
    // Then coherence ties the rf-edges of that load closely to the co-order of the store (e.g., "sum++").
    private boolean dependsOnLoadFromSameAddress(Store store) {
        final Deque<RegReader> worklist = new ArrayDeque<>();
        final Set<Event> visited = new HashSet<>();
        final Set<Register> valueRegs = store.getMemValue().getRegs();
        for (Register reg : valueRegs) {
            for (RegWriter writer : reachingDefinitions.getWriters(store).ofRegister(reg).getMayWriters()) {
                if (visited.add(writer)) {
                    if (writer instanceof Load load) {
                        if (alias.mustAlias(load, store)) {
                            return true;
                        }
                    } else if (writer instanceof RegReader reader) {
                        worklist.add(reader);
                    }
                }
            }
        }
        while (!worklist.isEmpty()) {
            final RegReader reader = worklist.poll();
            final ReachingDefinitionsAnalysis.Writers writers = reachingDefinitions.getWriters(reader);
            for (Register reg : writers.getUsedRegisters()) {
                for (RegWriter writer : writers.ofRegister(reg).getMayWriters()) {
                    if (!visited.add(writer)) {
                        continue;
                    }
                    if (writer instanceof Load load) {
                        if (alias.mustAlias(load, store)) {
                            return true;
                        }
                    } else if (writer instanceof RegReader next) {
                        worklist.add(next);
                    }
                }
            }
        }
        return false;
    }

    // Stores of the first thread whose symmetric copies must alias, in breaking order.
    private List<Store> computeLevels(List<Thread> threads) {
        final Thread rep = threads.getFirst();
        final Set<Event> excluded = new HashSet<>();
        threads.forEach(t -> excluded.addAll(t.getSpawningEvents()));
        final List<Event> events = rep.getEvents();
        final List<ThreadReturn> returns = rep.getEvents(ThreadReturn.class);
        final double middle = (events.size() - 1) / 2.0;

        final List<Store> levels = new ArrayList<>();
        for (Event e : events) {
            if (e instanceof Store w && !(w instanceof Init) && !excluded.contains(w)
                    && threads.stream().allMatch(t -> alias.mustAlias(w, (Store) symm.map(w, t)))) {
                levels.add(w);
            }
        }
        final Map<Store, Integer> exitIteration = computeLoopExitingStores(rep, levels);
        final Set<Store> sameAddressDependent = new HashSet<>();
        for (Store w : levels) {
            if (dependsOnLoadFromSameAddress(w)) {
                sameAddressDependent.add(w);
            }
        }
        logger.info("Stores depending on a load from the same address: {}", sameAddressDependent.stream()
                .map(w -> "E" + w.getGlobalId() + "@" + events.indexOf(w)).toList());
        logger.info("Loop-exiting stores (with iteration): {}", exitIteration.entrySet().stream()
                .map(en -> "E" + en.getKey().getGlobalId() + "@" + events.indexOf(en.getKey()) + "#" + en.getValue()).toList());
        levels.sort(Comparator
                // Same-address dependent stores first, earliest in program order first.
                .comparing((Store w) -> !sameAddressDependent.contains(w))
                .thenComparingInt(w -> sameAddressDependent.contains(w) ? events.indexOf(w) : 0)
                // Remaining stores: implied by ThreadReturn, plain over RMW, loop exiting, close to the middle.
                .thenComparing((Store w) -> !returns.stream().allMatch(r -> exec.isImplied(r, w)))
                .thenComparing(w -> w.hasTag(Tag.RMW) || w.hasTag(Tag.EXCL))
                .thenComparing((Store w) -> !exitIteration.containsKey(w))
                .thenComparing(w -> exitIteration.getOrDefault(w, 0))
                .thenComparingDouble(w -> Math.abs(events.indexOf(w) - middle)));
        return levels;
    }
}
