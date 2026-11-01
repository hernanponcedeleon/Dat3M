package com.dat3m.dartagnan.solver.onlinecaat;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.analysis.ThreadSymmetry;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.MemoryCoreEvent;
import com.dat3m.dartagnan.solver.caat.CAATModel;
import com.dat3m.dartagnan.solver.caat.constraints.AcyclicityConstraint;
import com.dat3m.dartagnan.solver.caat.constraints.Constraint;
import com.dat3m.dartagnan.solver.caat.domain.Domain;
import com.dat3m.dartagnan.solver.caat.domain.GenericDomain;
import com.dat3m.dartagnan.solver.caat.misc.PathAlgorithm;
import com.dat3m.dartagnan.solver.caat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.caat.predicates.Derivable;
import com.dat3m.dartagnan.solver.caat.predicates.PredicateHierarchy;
import com.dat3m.dartagnan.solver.caat.predicates.misc.PredicateListener;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.RelationGraph;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.derived.*;
import com.dat3m.dartagnan.solver.caat.predicates.sets.Element;
import com.dat3m.dartagnan.solver.caat.predicates.sets.SetPredicate;
import com.dat3m.dartagnan.solver.caat.reasoning.CAATLiteral;
import com.dat3m.dartagnan.solver.caat.reasoning.EdgeLiteral;
import com.dat3m.dartagnan.solver.caat.reasoning.ElementLiteral;
import com.dat3m.dartagnan.solver.caat.reasoning.Reasoner;
import com.dat3m.dartagnan.solver.caat4wmm.ExecutionGraph;
import com.dat3m.dartagnan.solver.caat4wmm.coreReasoning.CoreReasoner.SymmetricLearning;
import com.dat3m.dartagnan.utils.equivalence.EquivalenceClass;
import com.dat3m.dartagnan.utils.logic.Conjunction;
import com.dat3m.dartagnan.utils.logic.DNF;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.RelationNameRepository;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.definition.*;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.PropagatorBackend;
import org.sosy_lab.java_smt.basicimpl.AbstractUserPropagator;

import java.util.*;
import java.util.function.BiPredicate;
import java.util.function.Function;

import static com.dat3m.dartagnan.configuration.OptionNames.SYMMETRIC_LEARNING;

/*
    An online theory solver for memory model consistency based on CAAT
    (Haas et al., "CAAT: Consistency as a Theory", OOPSLA 2022).

    Unlike the offline refinement procedure, this solver is integrated into the SMT solver via the
    user-propagator interface and is consulted on PARTIAL assignments:
        - The theory atoms are the execution variables of events, the edge variables of the encoded relations
          (rf, co, and relations below the cut), and a few address equalities used by "loc".
        - Every time an atom gets fixed, the corresponding base edges are added to the CAAT model
          (with the current decision level as timestamp) and propagated to the derived relations.
        - Consistency is checked incrementally after each assignment.
          If an axiom is violated, the CAAT reason of the violation is translated back into
          (already fixed) atoms and reported to the SMT solver as a conflict.
          As in the offline procedure, we also learn the clauses that are symmetric to the conflict.
        - For acyclicity axioms, we propagate the negation of atoms that would close a cycle.
        - On backtracking, the CAAT model is backtracked to the decision level using the timestamps.

    Because every materialized edge is justified by currently fixed atoms, all edges are
    implied by every total extension of the current partial assignment.
    Since the CAAT axioms are monotone (more edges never fix a violation), any violation found on a
    partial assignment is a genuine conflict.
    Relations that appear negatively (on the right-hand side of differences) are handled via anti-monotone
    views that contain all pairs not yet known to be absent.
 */
@Options
public class OnlineCAATPropagator extends AbstractUserPropagator {

    private static final Logger logger = LoggerFactory.getLogger(OnlineCAATPropagator.class);

    @Option(name = SYMMETRIC_LEARNING,
            description = "Sets the kind of clauses learned in each refinement step. Effective only in lazy methods." +
                    " If NONE, only learns the reasons for inconsistency of the currently modelled execution."+
                    " If FULL, additionally learns all clauses symmetric to reasons.",
            secure = true)
    private SymmetricLearning symmetricLearning = SymmetricLearning.FULL;

    // Upper bound on the number of symmetric clauses derived from a single conflict.
    private static final int MAX_ORBIT_SIZE = 128;
    // Upper bound on the number of theory propagations per callback.
    private static final int MAX_PROPAGATIONS_PER_CALL = 64;

    // ======================================== Fields ========================================

    private final EncodingContext context;
    private final BooleanFormulaManager bmgr;
    private final RelationAnalysis ra;
    private final ExecutionAnalysis exec;

    // Domain: all visible events that can be executed.
    private final List<Event> events = new ArrayList<>();
    private final Map<Event, Integer> eventIds;
    private final GenericDomain<Event> domain;

    // Atoms
    private final List<BooleanFormula> atomFormulas = new ArrayList<>();
    private final Map<BooleanFormula, Integer> atomIds = new HashMap<>();
    // The backend reports canonical formula objects, so an identity lookup avoids (native) equality checks.
    private final IdentityHashMap<BooleanFormula, Integer> identityAtomIds = new IdentityHashMap<>();
    private byte[] atomValues; // 1 = true, -1 = false, 0 = unassigned
    private List<Watch>[] watches;

    // Execution status of events
    private static final int ALWAYS = -1;
    private final int[] execAtom;
    private final boolean[] executed;

    // CAAT model
    private final ExecutionGraph executionGraph;
    private final CAATModel caatModel;
    private final PredicateHierarchy hierarchy;
    private final Reasoner reasoner = new Reasoner();
    private final List<Constraint> constraints;
    private final List<OnlineBaseGraph> createdGraphs = new ArrayList<>();
    private final Map<OnlineBaseGraph, Runnable> pendingInit = new HashMap<>();
    private final List<OnlineBaseSet> createdSets = new ArrayList<>();
    private final List<AntiMonotoneGraphView> createdGraphViews = new ArrayList<>();
    private final List<AntiMonotoneSetView> createdSetViews = new ArrayList<>();
    // The base predicates that need to be materialized.
    private final List<OnlineBaseGraph> graphs = new ArrayList<>();
    private final List<OnlineBaseSet> sets = new ArrayList<>();

    // Propagation buffers (one per base predicate)
    private final Map<CAATPredicate, List<Derivable>> buffers = new LinkedHashMap<>();

    // Search state
    private int level = 0;
    private final IntList trail = new IntList();
    private final IntList trailLimits = new IntList();
    private boolean conflictPending = false;

    // Theory propagation
    private final List<PendingPropagation> propagationQueue = new ArrayList<>();

    // Batched mode: assignments are processed per decision level (see onPush).
    private static final boolean BATCHED = !"false".equals(System.getProperty("caat.online.batched"));
    private final IntList pending = new IntList();
    private BooleanFormula[] deferredConflict = null;
    private boolean inPush = false;
    // The highest decision level at which edges may have been added to the CAAT model.
    private int maxModifiedLevel = 0;

    // Learning
    private final List<int[]> symmetryGenerators = new ArrayList<>(); // Permutations of the domain
    private final Set<LitKey> knownClauses = new HashSet<>();
    private final List<BooleanFormula> pendingLemmas = new ArrayList<>();
    private static final BooleanFormula[] NO_JUSTIFICATION = new BooleanFormula[0];
    // All learned clauses (as atom ids with their values), so that they can be added permanently later.
    private final List<int[]> learned = new ArrayList<>();
    private int numExportedLearned = 0;

    private final Statistics stats = new Statistics();

    // ======================================== Construction ========================================

    @SuppressWarnings("unchecked")
    public OnlineCAATPropagator(EncodingContext context, Configuration config) throws InvalidConfigurationException {
        config.inject(this);
        this.context = context;
        this.bmgr = context.getBooleanFormulaManager();
        this.ra = context.getAnalysisContext().requires(RelationAnalysis.class);
        this.exec = context.getAnalysisContext().requires(ExecutionAnalysis.class);

        // (1) Domain and execution atoms
        for (Event e : context.getTask().getProgram().getThreadEvents()) {
            if (e.hasTag(Tag.VISIBLE) && !bmgr.isFalse(context.execution(e))) {
                events.add(e);
            }
        }
        this.eventIds = new HashMap<>(events.size() * 4 / 3 + 1);
        for (int i = 0; i < events.size(); i++) {
            eventIds.put(events.get(i), i);
        }
        this.domain = new GenericDomain<>(events);
        this.execAtom = new int[events.size()];
        this.executed = new boolean[events.size()];
        for (int i = 0; i < events.size(); i++) {
            final BooleanFormula execVar = context.execution(events.get(i));
            execAtom[i] = bmgr.isTrue(execVar) ? ALWAYS : getOrCreateAtom(execVar);
        }

        // (2) CAAT model with online base predicates.
        //     All encoded relations are base relations whose edges are taken from the SMT encoding.
        this.executionGraph = new ExecutionGraph(context.getTask().getMemoryModel(), context::isEncoded, new Factory());
        this.caatModel = executionGraph.getCAATModel();
        this.hierarchy = caatModel.getHierarchy();
        this.constraints = new ArrayList<>(caatModel.getConstraints());

        final Set<CAATPredicate> basePreds = hierarchy.getBasePredicates();
        createdGraphs.stream().filter(basePreds::contains).forEach(g -> pendingInit.get(g).run());
        pendingInit.clear();
        // Predicates whose changes are irrelevant need not be maintained.
        final Set<CAATPredicate> constrained = new HashSet<>();
        constraints.forEach(c -> constrained.add(c.getConstrainedPredicate()));
        final Set<CAATPredicate> dead = hierarchy.computeDeadPredicates(constrained, p ->
                (p instanceof OnlineBaseGraph g && g.isInitialized() && g.numPairs() == 0)
                || (p instanceof OnlineBaseSet s && Arrays.stream(s.atom).allMatch(a -> a == OnlineBaseSet.NOT_MEMBER)));
        createdGraphs.stream().filter(basePreds::contains).filter(p -> !dead.contains(p)).forEach(graphs::add);
        createdSets.stream().filter(basePreds::contains).filter(p -> !dead.contains(p)).forEach(sets::add);

        // (3) Watches: only for atoms used by maintained predicates.
        watches = new List[atomFormulas.size()];
        for (int e = 0; e < events.size(); e++) {
            if (execAtom[e] >= 0) {
                watch(execAtom[e], new Watch(Watch.EXEC, null, e));
            }
        }
        for (OnlineBaseGraph g : graphs) {
            buffers.put(g, new ArrayList<>());
            for (int p = 0; p < g.numPairs(); p++) {
                if (g.atom[p] >= 0) {
                    watch(g.atom[p], new Watch(Watch.GRAPH_TRUE, g, p));
                }
            }
        }
        for (OnlineBaseSet s : sets) {
            buffers.put(s, new ArrayList<>());
            for (int e = 0; e < s.atom.length; e++) {
                if (s.atom[e] >= 0) {
                    watch(s.atom[e], new Watch(Watch.SET_TRUE, s, e));
                }
            }
        }
        for (AntiMonotoneGraphView v : createdGraphViews) {
            if (basePreds.contains(v) && !dead.contains(v)) {
                buffers.put(v, new ArrayList<>());
                for (int p = 0; p < v.base.numPairs(); p++) {
                    if (v.base.atom[p] >= 0) {
                        watch(v.base.atom[p], new Watch(Watch.GRAPH_FALSE, v, p));
                    }
                }
            }
        }
        for (AntiMonotoneSetView v : createdSetViews) {
            if (basePreds.contains(v) && !dead.contains(v)) {
                buffers.put(v, new ArrayList<>());
                for (int e = 0; e < v.base.atom.length; e++) {
                    if (v.base.atom[e] >= 0) {
                        watch(v.base.atom[e], new Watch(Watch.SET_FALSE, v, e));
                    }
                }
            }
        }
        atomValues = new byte[atomFormulas.size()];

        // (4) Theory propagation for acyclicity constraints.
        for (Constraint c : constraints) {
            if (c instanceof AcyclicityConstraint) {
                setupCyclePropagation((RelationGraph) c.getConstrainedPredicate());
            }
        }

        // (5) Initialize the CAAT model and add facts that hold in every execution.
        PathAlgorithm.ensureCapacity(domain.size());
        executionGraph.initializeToDomain(domain);
        caatModel.populate();
        for (int e = 0; e < events.size(); e++) {
            executed[e] = execAtom[e] == ALWAYS;
        }
        for (int e = 0; e < events.size(); e++) {
            if (execAtom[e] == ALWAYS) {
                collectOnExec(e);
            }
        }
        flush();

        // Time 0 is reserved for facts that hold in every execution: assignments start at level 1.
        // This matters if the propagator is registered within a scope that gets popped later.
        level = 1;
        trailLimits.add(trail.size());

        // (6) Symmetry
        if (symmetricLearning == SymmetricLearning.FULL) {
            computeSymmetryGenerators(context.getAnalysisContext().requires(ThreadSymmetry.class));
        }

        if (logger.isInfoEnabled()) {
            logger.info("Online CAAT: {} events, {} maintained base predicates, {} predicates ({} dead), " +
                            "{} constraints, {} theory atoms",
                    events.size(), graphs.size() + sets.size(), hierarchy.getPredicates().size(), dead.size(),
                    constraints.size(), Arrays.stream(watches).filter(Objects::nonNull).count());
        }
    }

    private int getOrCreateAtom(BooleanFormula f) {
        final Integer id = atomIds.get(f);
        if (id != null) {
            return id;
        }
        final int newId = atomFormulas.size();
        atomFormulas.add(f);
        atomIds.put(f, newId);
        return newId;
    }

    private void watch(int atom, Watch w) {
        if (watches[atom] == null) {
            watches[atom] = new ArrayList<>(2);
        }
        watches[atom].add(w);
    }

    // Generators of the symmetry group of threads (as permutations of the domain).
    private void computeSymmetryGenerators(ThreadSymmetry symm) {
        for (EquivalenceClass<Thread> c : symm.getNonTrivialClasses()) {
            final List<Thread> threads = new ArrayList<>(c);
            threads.sort(Comparator.comparingInt(Thread::getId));
            for (int i = 0; i < threads.size(); i++) {
                final int j = (i + 1) % threads.size();
                if (i == j) {
                    continue;
                }
                final Function<Event, Event> f = symm.createEventTransposition(threads.get(i), threads.get(j));
                final int[] perm = new int[events.size()];
                for (int e = 0; e < events.size(); e++) {
                    final Integer id = eventIds.get(f.apply(events.get(e)));
                    perm[e] = id == null ? -1 : id;
                }
                symmetryGenerators.add(perm);
            }
        }
    }

    // ======================================== Accessors ========================================

    boolean isExecuted(int e) { return executed[e]; }

    int atomValue(int atom) { return atomValues[atom]; }

    public Statistics getStatistics() { return stats; }

    /*
        Returns the clauses learned since the last call.
        These are valid lemmas of the theory, so they can be added permanently to the solver
        (the SMT solver may have forgotten them, e.g., due to popping the scope they were learned in).
        NOTE: Must not be called during solving.
     */
    public List<BooleanFormula> exportLearnedClauses() {
        final List<BooleanFormula> clauses = new ArrayList<>(learned.size() - numExportedLearned);
        for (int i = numExportedLearned; i < learned.size(); i++) {
            clauses.add(toClause(learned.get(i)));
        }
        numExportedLearned = learned.size();
        return clauses;
    }

    // Converts a conjunction of literals (atom id + 1, negative if false) into the clause forbidding it.
    private BooleanFormula toClause(int[] lits) {
        final List<BooleanFormula> clause = new ArrayList<>(lits.length);
        for (int lit : lits) {
            final BooleanFormula atom = atomFormulas.get(Math.abs(lit) - 1);
            clause.add(lit > 0 ? bmgr.not(atom) : atom);
        }
        return bmgr.or(clause);
    }

    // ======================================== Propagator callbacks ========================================

    @Override
    public void initializeWithBackend(PropagatorBackend backend) {
        super.initializeWithBackend(backend);
        backend.notifyOnKnownValue();
        backend.notifyOnFinalCheck();
        for (int a = 0; a < atomFormulas.size(); a++) {
            if (watches[a] != null) {
                backend.registerExpression(atomFormulas.get(a));
            }
        }
    }

    @Override
    public void onPush() {
        if (BATCHED && deferredConflict == null && !conflictPending && pending.size() > 0) {
            // The decision level is complete: process its assignments in one batch.
            // Conflicts and propagations cannot be reported here, so they are reported on the next callback.
            final long start = System.nanoTime();
            inPush = true;
            for (int i = 0; i < pending.size(); i++) {
                process(pending.get(i));
            }
            pending.truncate(0);
            flush();
            checkConsistency(false);
            inPush = false;
            stats.propagationTime += System.nanoTime() - start;
        }
        level++;
        trailLimits.add(trail.size());
    }

    // Reports what was found during the last onPush (if anything). Returns true if a conflict was raised.
    private boolean reportDeferred() {
        if (deferredConflict != null) {
            final BooleanFormula[] conflict = deferredConflict;
            deferredConflict = null;
            raiseConflict(conflict, false);
            return true;
        }
        if (!propagationQueue.isEmpty()) {
            emitPropagations();
        }
        return false;
    }

    @Override
    public void onPop(int numLevels) {
        final long start = System.nanoTime();
        // NOTE: The propagator may get registered within a scope, so it may see pops below its initial level.
        // In that case, all assignments are undone.
        final int target = Math.max(0, level - numLevels);
        final int limit = trailLimits.get(target);
        for (int i = trail.size() - 1; i >= limit; i--) {
            final int atom = trail.get(i);
            if (atomValues[atom] > 0) {
                for (Watch w : watches[atom]) {
                    if (w.kind == Watch.EXEC) {
                        executed[w.index] = false;
                    }
                }
            }
            atomValues[atom] = 0;
        }
        trail.truncate(limit);
        trailLimits.truncate(target);
        level = target;
        if (maxModifiedLevel > target) {
            // Only backtrack the CAAT model if something was added above the target level.
            executionGraph.backtrackTo(target);
            maxModifiedLevel = target;
        }
        conflictPending = false;
        propagationQueue.clear();
        pending.truncate(0);
        deferredConflict = null;
        stats.numPops++;
        stats.backtrackTime += System.nanoTime() - start;
    }

    @Override
    public void onKnownValue(BooleanFormula expr, boolean value) {
        if (conflictPending) {
            return;
        }
        Integer atom = identityAtomIds.get(expr);
        if (atom == null) {
            atom = atomIds.get(expr);
            identityAtomIds.put(expr, atom == null ? -1 : atom);
        }
        if (atom < 0 || watches[atom] == null || atomValues[atom] != 0) {
            return;
        }
        if (BATCHED && reportDeferred()) {
            return;
        }
        final long start = System.nanoTime();
        stats.numFixed++;
        atomValues[atom] = (byte) (value ? 1 : -1);
        trail.add(atom);
        if (BATCHED) {
            pending.add(atom);
            return;
        }

        process(atom);
        flush();
        checkConsistency(false);
        if (!conflictPending && !propagationQueue.isEmpty()) {
            emitPropagations();
        }
        stats.propagationTime += System.nanoTime() - start;
    }

    @Override
    public void onFinalCheck() {
        if (conflictPending) {
            return;
        }
        if (BATCHED) {
            if (reportDeferred()) {
                return;
            }
            for (int i = 0; i < pending.size(); i++) {
                process(pending.get(i));
            }
            pending.truncate(0);
            flush();
        }
        // All atoms are assigned, and we checked consistency after each assignment.
        // As a safety net, we do a full (non-incremental) check.
        final long start = System.nanoTime();
        stats.numFinalChecks++;
        for (Constraint c : constraints) {
            if (c instanceof AcyclicityConstraint acyc) {
                acyc.markAllNodes();
            }
        }
        checkConsistency(true);
        stats.finalCheckTime += System.nanoTime() - start;
    }

    // ======================================== Propagation ========================================

    private void process(int atom) {
        final List<Watch> ws = watches[atom];
        if (atomValues[atom] > 0) {
            // First mark all events as executed, then compute the new edges
            for (Watch w : ws) {
                if (w.kind == Watch.EXEC) {
                    executed[w.index] = true;
                }
            }
            for (Watch w : ws) {
                switch (w.kind) {
                    case Watch.EXEC -> collectOnExec(w.index);
                    case Watch.GRAPH_TRUE -> ((OnlineBaseGraph) w.target).collectOnAtomTrue(w.index, level, edgeBuffer(w.target));
                    case Watch.SET_TRUE -> ((OnlineBaseSet) w.target).collectOnAtomTrue(w.index, level, elementBuffer(w.target));
                    default -> { }
                }
            }
        } else {
            for (Watch w : ws) {
                switch (w.kind) {
                    case Watch.GRAPH_FALSE -> ((AntiMonotoneGraphView) w.target).collectOnAtomFalse(w.index, level, edgeBuffer(w.target));
                    case Watch.SET_FALSE -> ((AntiMonotoneSetView) w.target).collectOnAtomFalse(w.index, level, elementBuffer(w.target));
                    default -> { }
                }
            }
        }
    }

    @SuppressWarnings("unchecked")
    private List<Edge> edgeBuffer(CAATPredicate pred) {
        return (List<Edge>) (List<?>) buffers.get(pred);
    }

    @SuppressWarnings("unchecked")
    private List<Element> elementBuffer(CAATPredicate pred) {
        return (List<Element>) (List<?>) buffers.get(pred);
    }

    private void collectOnExec(int e) {
        for (OnlineBaseGraph g : graphs) {
            g.collectOnExec(e, level, edgeBuffer(g));
        }
        for (OnlineBaseSet s : sets) {
            s.collectOnExec(e, level, elementBuffer(s));
        }
    }

    private void flush() {
        maxModifiedLevel = Math.max(maxModifiedLevel, level);
        for (Map.Entry<CAATPredicate, List<Derivable>> entry : buffers.entrySet()) {
            final List<Derivable> buffer = entry.getValue();
            if (!buffer.isEmpty()) {
                hierarchy.addAndPropagate(entry.getKey(), buffer);
                buffer.clear();
            }
        }
    }

    // ======================================== Consistency & Conflicts ========================================

    private void checkConsistency(boolean isFinal) {
        final long start = System.nanoTime();
        for (Constraint c : constraints) {
            if (c.checkForViolations()) {
                stats.checkTime += System.nanoTime() - start;
                reportConflict(c, isFinal);
                return;
            }
        }
        stats.checkTime += System.nanoTime() - start;
    }

    private void reportConflict(Constraint violated, boolean isFinal) {
        final long start = System.nanoTime();
        final DNF<CAATLiteral> reasons = reasoner.computeViolationReasons(violated);
        Set<Integer> best = null;
        for (Conjunction<CAATLiteral> cube : reasons.getCubes()) {
            final Set<Integer> atoms = toAtoms(cube);
            if (atoms != null && (best == null || atoms.size() < best.size())) {
                best = atoms;
            }
        }
        stats.reasonTime += System.nanoTime() - start;
        if (best == null) {
            logger.warn("Online CAAT: could not translate violation reasons of {}.", violated.getConstrainedPredicate());
            return;
        }

        final BooleanFormula[] conflict = new BooleanFormula[best.size()];
        final int[] conflictLits = new int[best.size()];
        int i = 0;
        for (int atom : best) {
            conflictLits[i] = atomValues[atom] > 0 ? atom + 1 : -(atom + 1);
            conflict[i++] = atomFormulas.get(atom);
        }
        learned.add(conflictLits);
        knownClauses.add(new LitKey(conflictLits));
        if (!symmetryGenerators.isEmpty()) {
            learnSymmetricClauses(conflictLits);
        }

        if (inPush) {
            deferredConflict = conflict;
            return;
        }
        raiseConflict(conflict, isFinal);
    }

    private void raiseConflict(BooleanFormula[] conflict, boolean isFinal) {
        // Symmetric clauses are sent as lemmas (propagations without justification) before the conflict.
        pendingLemmasFlush();
        propagationQueue.clear();
        conflictPending = true;
        stats.numConflicts++;
        if (isFinal) {
            stats.numFinalConflicts++;
        }
        stats.totalConflictSize += conflict.length;
        getBackend().propagateConflict(conflict);
    }

    // Translates a base reason into the set of atoms (all currently fixed) that justify it.
    // Returns null, if the translation failed.
    private Set<Integer> toAtoms(Conjunction<CAATLiteral> cube) {
        final Set<Integer> atoms = new LinkedHashSet<>();
        // Events whose execution must be part of the reason (later events tend to imply earlier ones) ...
        final Set<Integer> execNeeded = new TreeSet<>(Comparator.reverseOrder());
        // ... and events whose execution is implied by the reason.
        final Set<Integer> anchors = new HashSet<>();
        for (CAATLiteral lit : cube.getLiterals()) {
            final CAATPredicate pred = lit.getPredicate();
            if (lit instanceof EdgeLiteral edgeLit) {
                final Edge edge = edgeLit.getData();
                final int x = edge.getFirst();
                final int y = edge.getSecond();
                if (pred instanceof OnlineBaseGraph g) {
                    if (lit.isNegative()) {
                        // Only static relations can appear negatively; their absence is a fact.
                        if (!g.isStatic()) {
                            return null;
                        }
                        continue;
                    }
                    final int p = g.lookup(x, y);
                    if (p < 0) {
                        return null;
                    }
                    final int a = g.atom[p];
                    if (a >= 0) {
                        if (atomValues[a] <= 0) {
                            return null;
                        }
                        atoms.add(a);
                        if (!g.execInReason) {
                            anchors.add(x);
                            anchors.add(y);
                            continue;
                        }
                    }
                    execNeeded.add(x);
                    execNeeded.add(y);
                } else if (pred instanceof AntiMonotoneGraphView v) {
                    if (lit.isPositive()) {
                        return null;
                    }
                    final int p = v.base.lookup(x, y);
                    if (p >= 0) {
                        final int a = v.base.atom[p];
                        if (a < 0 || atomValues[a] >= 0) {
                            return null;
                        }
                        atoms.add(a);
                    }
                } else {
                    return null;
                }
            } else if (lit instanceof ElementLiteral eleLit) {
                final int e = eleLit.getData().getId();
                if (pred instanceof OnlineBaseSet s) {
                    if (lit.isNegative()) {
                        if (!s.isStatic()) {
                            return null;
                        }
                        continue;
                    }
                    final int a = s.atom[e];
                    if (a >= 0) {
                        if (atomValues[a] <= 0) {
                            return null;
                        }
                        atoms.add(a);
                    } else if (a != OnlineBaseSet.STATIC) {
                        return null;
                    }
                    execNeeded.add(e);
                } else if (pred instanceof AntiMonotoneSetView v) {
                    if (lit.isPositive()) {
                        return null;
                    }
                    final int a = v.base.atom[e];
                    if (a >= 0) {
                        if (atomValues[a] >= 0) {
                            return null;
                        }
                        atoms.add(a);
                    } else if (a == OnlineBaseSet.STATIC) {
                        return null;
                    }
                } else {
                    return null;
                }
            } else {
                return null;
            }
        }
        // Remove execution literals that are implied by the remaining reason (cf. CoreReasoner).
        final List<Integer> kept = new ArrayList<>();
        for (int e : execNeeded) {
            final Event ev = events.get(e);
            final boolean implied = anchors.stream().anyMatch(a -> a == e || exec.isImplied(events.get(a), ev))
                    || kept.stream().anyMatch(k -> exec.isImplied(events.get(k), ev));
            if (!implied) {
                kept.add(e);
            }
        }
        for (int e : kept) {
            if (!addExec(e, atoms)) {
                return null;
            }
        }
        return atoms;
    }

    private boolean addExec(int e, Set<Integer> atoms) {
        final int a = execAtom[e];
        if (a == ALWAYS) {
            return true;
        }
        if (a < 0 || atomValues[a] <= 0) {
            return false;
        }
        atoms.add(a);
        return true;
    }

    private void pendingLemmasFlush() {
        if (inPush) {
            return;
        }
        for (BooleanFormula lemma : pendingLemmas) {
            getBackend().propagateConsequence(NO_JUSTIFICATION, lemma);
        }
        pendingLemmas.clear();
    }

    // ======================================== Theory propagation ========================================
    /*
        For an acyclicity constraint on G and a dynamic base relation B that is (essentially) a union member of G:
        whenever an edge (u, v) is added to G, setting the B-atom of (v, u) to true would close a cycle.
        Hence, we propagate its negation (justified by the reason of (u, v)).
        If G is transitively closed, this covers all cycles through a single B-edge; otherwise only 2-cycles.
     */

    // A dynamic base relation (optionally intersected with relations of static membership) that is part of a union.
    private record CycleLeaf(OnlineBaseGraph base, List<CAATPredicate> staticFilters) { }
    private record PendingPropagation(int atom, RelationGraph graph, Edge edge, CycleLeaf leaf) { }

    private void setupCyclePropagation(RelationGraph g) {
        final List<CycleLeaf> leaves = new ArrayList<>();
        collectCycleLeaves(g, leaves, new HashSet<>());
        if (leaves.isEmpty()) {
            return;
        }
        hierarchy.addListener(g, new PredicateListener() {
            @Override public void onDomainInit(CAATPredicate predicate, Domain<?> domain) { }
            @Override public void onPopulation(CAATPredicate predicate) { }
            @Override public void onBacktrack(CAATPredicate predicate, int time) { }

            @Override
            @SuppressWarnings("unchecked")
            public void onChanged(CAATPredicate predicate, Collection<? extends Derivable> added) {
                if (conflictPending) {
                    return;
                }
                for (Edge e : (Collection<Edge>) added) {
                    final int u = e.getFirst();
                    final int v = e.getSecond();
                    if (u == v || !executed[u] || !executed[v]) {
                        continue;
                    }
                    for (CycleLeaf leaf : leaves) {
                        final int p = leaf.base.lookup(v, u);
                        if (p >= 0) {
                            final int a = leaf.base.atom[p];
                            if (a >= 0 && atomValues[a] == 0 && passesFilters(leaf, v, u)) {
                                propagationQueue.add(new PendingPropagation(a, g, e, leaf));
                            }
                        }
                    }
                }
            }
        });
    }

    private static boolean passesFilters(CycleLeaf leaf, int x, int y) {
        for (CAATPredicate f : leaf.staticFilters) {
            if (!((RelationGraph) f).containsById(x, y)) {
                return false;
            }
        }
        return true;
    }

    private void collectCycleLeaves(CAATPredicate pred, List<CycleLeaf> leaves, Set<CAATPredicate> visited) {
        if (!visited.add(pred)) {
            return;
        }
        if (pred instanceof UnionGraph || pred instanceof RecursiveGraph || pred instanceof TransitiveGraph) {
            for (CAATPredicate dep : pred.getDependencies()) {
                collectCycleLeaves(dep, leaves, visited);
            }
        } else if (pred instanceof OnlineBaseGraph b && !b.isStatic()) {
            leaves.add(new CycleLeaf(b, List.of()));
        } else if (pred instanceof IntersectionGraph) {
            final List<CAATPredicate> deps = new ArrayList<>(pred.getDependencies());
            final List<CAATPredicate> dynamic = deps.stream().filter(d -> !d.hasStaticMembership()).toList();
            if (dynamic.size() == 1 && dynamic.get(0) instanceof OnlineBaseGraph b) {
                deps.remove(b);
                leaves.add(new CycleLeaf(b, deps));
            }
        }
    }

    private void emitPropagations() {
        final long start = System.nanoTime();
        int count = 0;
        final Set<Integer> done = new HashSet<>();
        for (PendingPropagation prop : propagationQueue) {
            if (count >= MAX_PROPAGATIONS_PER_CALL) {
                break;
            }
            if (atomValues[prop.atom] != 0 || !done.add(prop.atom)) {
                continue;
            }
            final Edge edge = prop.graph.get(prop.edge);
            if (edge == null) {
                continue;
            }
            final Set<Integer> justification = toAtoms(reasoner.computeReason(prop.graph, edge));
            if (justification == null) {
                continue;
            }
            // The base edge (v, u) also requires the execution of its endpoints (unless implied by its atom).
            if (prop.leaf.base.execInReason
                    && (!addExec(prop.edge.getFirst(), justification) || !addExec(prop.edge.getSecond(), justification))) {
                continue;
            }
            final BooleanFormula[] just = new BooleanFormula[justification.size()];
            int i = 0;
            for (int a : justification) {
                just[i++] = atomFormulas.get(a);
            }
            getBackend().propagateConsequence(just, bmgr.not(atomFormulas.get(prop.atom)));
            count++;
        }
        propagationQueue.clear();
        stats.numPropagations += count;
    }

    // ======================================== Symmetry ========================================

    private static final int LIT_TRUE = 0;   // The permuted literal is always true (can be dropped)
    private static final int LIT_FALSE = Integer.MIN_VALUE; // The permuted literal is always false
    private static final int LIT_UNKNOWN = Integer.MAX_VALUE; // Cannot be permuted safely

    // Computes the orbit of the conflict (a conjunction of literals) under the symmetry group
    // and queues all new symmetric clauses as lemmas.
    private void learnSymmetricClauses(int[] conflict) {
        final Set<LitKey> orbit = new HashSet<>();
        final Deque<int[]> queue = new ArrayDeque<>();
        orbit.add(new LitKey(conflict));
        queue.add(conflict);
        while (!queue.isEmpty() && orbit.size() < MAX_ORBIT_SIZE) {
            final int[] lits = queue.poll();
            for (int[] perm : symmetryGenerators) {
                final int[] permuted = permute(lits, perm);
                if (permuted == null) {
                    continue;
                }
                final LitKey key = new LitKey(permuted);
                if (orbit.add(key)) {
                    queue.add(permuted);
                    if (knownClauses.add(key)) {
                        learned.add(permuted);
                        pendingLemmas.add(toClause(permuted));
                        stats.numSymmetricClauses++;
                    }
                }
            }
        }
    }

    // Returns the permuted conjunction of literals, or null if it is trivially false or cannot be permuted.
    private int[] permute(int[] lits, int[] perm) {
        final IntList result = new IntList();
        for (int lit : lits) {
            final int permAtom = permuteAtom(Math.abs(lit) - 1, perm);
            final boolean value = lit > 0;
            if (permAtom == LIT_UNKNOWN || (permAtom == LIT_TRUE && !value) || (permAtom == LIT_FALSE && value)) {
                return null;
            } else if (permAtom != LIT_TRUE && permAtom != LIT_FALSE) {
                result.add(value ? permAtom + 1 : -(permAtom + 1));
            }
        }
        final int[] arr = result.toArray();
        Arrays.sort(arr);
        return arr;
    }

    // Maps an atom along a permutation of events. Returns an atom id, LIT_TRUE, LIT_FALSE, or LIT_UNKNOWN.
    private int permuteAtom(int atom, int[] perm) {
        final Watch w = watches[atom].get(0);
        switch (w.kind) {
            case Watch.EXEC -> {
                final int e = perm[w.index];
                if (e < 0) {
                    return LIT_FALSE;
                }
                final int a = execAtom[e];
                return a == ALWAYS ? LIT_TRUE : a;
            }
            case Watch.GRAPH_TRUE, Watch.GRAPH_FALSE -> {
                final OnlineBaseGraph g = w.kind == Watch.GRAPH_TRUE ? (OnlineBaseGraph) w.target
                        : ((AntiMonotoneGraphView) w.target).base;
                final int x = perm[g.src[w.index]];
                final int y = perm[g.dst[w.index]];
                final int p = (x < 0 || y < 0) ? -1 : g.lookup(x, y);
                final int a = p < 0 ? -1 : g.atom[p];
                return a < 0 || watches[a] == null ? LIT_UNKNOWN : a;
            }
            case Watch.SET_TRUE, Watch.SET_FALSE -> {
                final OnlineBaseSet set = w.kind == Watch.SET_TRUE ? (OnlineBaseSet) w.target
                        : ((AntiMonotoneSetView) w.target).base;
                final int e = perm[w.index];
                final int a = e < 0 ? -1 : set.atom[e];
                return a < 0 || watches[a] == null ? LIT_UNKNOWN : a;
            }
            default -> {
                return LIT_UNKNOWN;
            }
        }
    }

    // ======================================== Base predicate factory ========================================

    private static boolean isBaseRelationClass(Class<?> cls) {
        return cls == ReadFrom.class || cls == Coherence.class || cls == SameLocation.class
                || cls == ProgramOrder.class || cls == SameInstruction.class
                || cls == External.class || cls == Internal.class;
    }

    private final class Factory implements ExecutionGraph.BasePredicateFactory {

        private final Map<Relation, OnlineBaseGraph> baseCache = new HashMap<>();
        private final Map<Relation, Boolean> purelyStatic = new HashMap<>();

        @Override
        public RelationGraph createBaseGraph(Relation rel, boolean isEncoded) {
            final Class<?> cls = rel.getDefinition().getClass();
            if (cls == Empty.class) {
                return null;
            }
            final RelationAnalysis.Knowledge k = ra.getKnowledge(rel);
            final boolean isStaticOnDomain = isStaticOnDomain(k.getMaySet(), k.getMustSet());
            if (cls == SameLocation.class && !isStaticOnDomain) {
                return createDerivedLocation(rel);
            }
            final OnlineBaseGraph cached = baseCache.get(rel);
            if (cached != null) {
                return cached;
            }
            if (!(isEncoded || isBaseRelationClass(cls))) {
                // A derived relation that (transitively) depends only on static relations and whose may- and
                // must-sets coincide (on the domain) only depends on the execution of its endpoints.
                // We treat it as a static base relation.
                // NOTE: We cannot do this for relations that depend on dynamic relations, because the
                // (extended) relation analysis uses the axioms to prune may-sets, which would be circular.
                if (!isPurelyStatic(rel) || !isStaticOnDomain) {
                    return null;
                }
            }
            // The edge variables of rf and co imply the execution of their endpoints.
            final boolean execInReason = !(cls == ReadFrom.class || cls == Coherence.class);
            final OnlineBaseGraph g = new OnlineBaseGraph(OnlineCAATPropagator.this, rel, execInReason, isStaticOnDomain);
            createdGraphs.add(g);
            baseCache.put(rel, g);
            // Pairs (and atoms) are only computed if the graph is actually used.
            pendingInit.put(g, () -> initPairs(g, isEncoded, null));
            return g;
        }

        /*
            Watching address equalities is expensive for the solver. Instead, we mostly derive "loc" from rf and co:
                loc = (id_W | rf^-1) ; (id_W | co | co^-1) ; (id_W | rf)  |  id_M  |  must-alias pairs
            Each executed read with an rf-edge reads from exactly one write, rf/co edges imply equal addresses,
            and co totally orders the executed writes to the same address.
            Reads without rf-edge are only consistent if their location has no init write (cf. "force-init-read").
            To detect violations of this and to handle reads of uninitialized memory, we keep the address equalities
            between reads and init writes, and those involving reads that may access uninitialized memory.
            Hence, this is exact on total assignments and a sound under-approximation on partial ones.
         */
        private RelationGraph createDerivedLocation(Relation locRel) {
            final Wmm wmm = context.getTask().getMemoryModel();
            final Relation rfRel = wmm.getRelation(RelationNameRepository.RF);
            final Relation coRel = wmm.getRelation(RelationNameRepository.CO);
            final RelationGraph rf = createBaseGraph(rfRel, context.isEncoded(rfRel.getDefinition()));
            final RelationGraph co = createBaseGraph(coRel, context.isEncoded(coRel.getDefinition()));
            final RelationGraph idW = new SetIdentityGraph(createTagSet(Tag.WRITE));
            final RelationGraph coSym = new UnionGraph(co, new InverseGraph(co), idW);
            final RelationGraph toWrite = new UnionGraph(idW, new InverseGraph(rf));
            final RelationGraph fromWrite = new UnionGraph(idW, rf);

            final EventGraph locMay = ra.getKnowledge(locRel).getMaySet();
            final EventGraph locMust = ra.getKnowledge(locRel).getMustSet();
            final Set<Event> mayReadUninit = new HashSet<>();
            for (Event e : events) {
                if (e.hasTag(Tag.READ) && locMay.getRange(e).stream().noneMatch(x -> x.hasTag(Tag.INIT))) {
                    mayReadUninit.add(e);
                }
            }
            final OnlineBaseGraph locAtoms = new OnlineBaseGraph(OnlineCAATPropagator.this, locRel, true, false);
            createdGraphs.add(locAtoms);
            pendingInit.put(locAtoms, () -> initPairs(locAtoms, false, (x, y) ->
                    (x.hasTag(Tag.READ) && (y.hasTag(Tag.INIT) || mayReadUninit.contains(x)))
                    || (y.hasTag(Tag.READ) && (x.hasTag(Tag.INIT) || mayReadUninit.contains(y)))));
            final OnlineBaseGraph locStatic = new OnlineBaseGraph(OnlineCAATPropagator.this, locRel, true, true);
            createdGraphs.add(locStatic);
            pendingInit.put(locStatic, () -> initPairs(locStatic, false, locMust::contains));

            idW.setName("[W]#loc");
            coSym.setName("(co | co^-1 | [W])#loc");
            toWrite.setName("([W] | rf^-1)#loc");
            fromWrite.setName("([W] | rf)#loc");
            locAtoms.setName("loc#atoms");
            locStatic.setName("loc#must");
            return new UnionGraph(
                    new CompositionGraph(new CompositionGraph(toWrite, coSym), fromWrite),
                    new SetIdentityGraph(createTagSet(Tag.MEMORY)), locAtoms, locStatic);
        }

        private OnlineBaseSet createTagSet(String tag) {
            final int[] atom = new int[events.size()];
            for (int i = 0; i < events.size(); i++) {
                atom[i] = events.get(i).hasTag(tag) ? OnlineBaseSet.STATIC : OnlineBaseSet.NOT_MEMBER;
            }
            final OnlineBaseSet set = new OnlineBaseSet(OnlineCAATPropagator.this, null, atom);
            set.setName("[" + tag + "]#loc");
            createdSets.add(set);
            return set;
        }

        // Computes the pairs of <g>, optionally restricted to the pairs satisfying <restriction>.
        private void initPairs(OnlineBaseGraph g, boolean isEncoded, BiPredicate<Event, Event> restriction) {
            final Relation rel = g.getRelation();
            final Class<?> cls = rel.getDefinition().getClass();
            final boolean isDynamicBase = cls == ReadFrom.class || cls == Coherence.class || cls == SameLocation.class;
            final RelationAnalysis.Knowledge k = ra.getKnowledge(rel);
            final EventGraph may = k.getMaySet();
            final EventGraph must = k.getMustSet();
            final EncodingContext.EdgeEncoder encoder = cls == SameLocation.class ? null : context.edge(rel);

            final IntList src = new IntList();
            final IntList dst = new IntList();
            final IntList atom = new IntList();
            for (Event x : events) {
                final int xId = eventIds.get(x);
                for (Event y : may.getRange(x)) {
                    final Integer yId = eventIds.get(y);
                    if (yId == null || (restriction != null && !restriction.test(x, y))) {
                        continue;
                    }
                    final int a;
                    if (must.contains(x, y)) {
                        a = -1;
                    } else {
                        final BooleanFormula f;
                        if (cls == SameLocation.class) {
                            if (!(x instanceof MemoryCoreEvent mx) || !(y instanceof MemoryCoreEvent my)) {
                                throw new UnsupportedOperationException(
                                        "Online CAAT: unsupported location pair " + x + ", " + y);
                            }
                            f = context.sameAddress(mx, my);
                        } else {
                            f = encoder.encode(x, y);
                        }
                        if (bmgr.isFalse(f)) {
                            continue;
                        } else if (bmgr.isTrue(f)) {
                            a = -1;
                        } else {
                            if (!isEncoded && !isDynamicBase) {
                                throw new UnsupportedOperationException(String.format(
                                        "Online CAAT: relation %s is neither encoded nor static.", rel));
                            }
                            a = getOrCreateAtom(f);
                        }
                    }
                    src.add(xId);
                    dst.add(yId);
                    atom.add(a);
                }
            }
            g.init(src.toArray(), dst.toArray(), atom.toArray(), events.size());
        }

        // True if the relation does not (transitively) depend on rf, co, loc, or encoded relations.
        private boolean isPurelyStatic(Relation rel) {
            final Boolean known = purelyStatic.get(rel);
            if (known != null) {
                return known;
            }
            purelyStatic.put(rel, false); // Recursion is treated as non-static
            final Class<?> cls = rel.getDefinition().getClass();
            final boolean result;
            if (context.isEncoded(rel.getDefinition())
                    || cls == ReadFrom.class || cls == Coherence.class || cls == SameLocation.class) {
                result = false;
            } else if (rel.getDependencies().isEmpty()) {
                result = cls == ProgramOrder.class || cls == Internal.class || cls == External.class
                        || cls == SameInstruction.class || cls == TagSet.class || cls == Empty.class;
            } else {
                result = rel.getDependencies().stream().allMatch(this::isPurelyStatic);
            }
            purelyStatic.put(rel, result);
            return result;
        }

        private boolean isStaticOnDomain(EventGraph may, EventGraph must) {
            for (Event x : events) {
                for (Event y : may.getRange(x)) {
                    if (eventIds.containsKey(y) && !must.contains(x, y)) {
                        return false;
                    }
                }
            }
            return true;
        }

        @Override
        public SetPredicate createBaseSet(Relation rel, boolean isEncoded) {
            final Class<?> cls = rel.getDefinition().getClass();
            final RelationAnalysis.Knowledge k = ra.getKnowledge(rel);
            final EventGraph may = k.getMaySet();
            final EventGraph must = k.getMustSet();
            if (!(isEncoded || cls == TagSet.class)) {
                if (!isPurelyStatic(rel)) {
                    return null;
                }
                for (Event e : events) {
                    if (may.contains(e, e) && !must.contains(e, e)) {
                        return null;
                    }
                }
            }
            final EncodingContext.EdgeEncoder encoder = context.edge(rel);
            final int[] atom = new int[events.size()];
            for (int i = 0; i < events.size(); i++) {
                final Event e = events.get(i);
                if (must.contains(e, e)) {
                    atom[i] = OnlineBaseSet.STATIC;
                } else if (!may.contains(e, e)) {
                    atom[i] = OnlineBaseSet.NOT_MEMBER;
                } else {
                    final BooleanFormula f = encoder.encode(e, e);
                    if (bmgr.isFalse(f)) {
                        atom[i] = OnlineBaseSet.NOT_MEMBER;
                    } else if (bmgr.isTrue(f)) {
                        atom[i] = OnlineBaseSet.STATIC;
                    } else {
                        if (!isEncoded) {
                            throw new UnsupportedOperationException(String.format(
                                    "Online CAAT: set %s is neither encoded nor static.", rel));
                        }
                        atom[i] = getOrCreateAtom(f);
                    }
                }
            }
            final OnlineBaseSet s = new OnlineBaseSet(OnlineCAATPropagator.this, rel, atom);
            createdSets.add(s);
            return s;
        }

        @Override
        public RelationGraph createSubtrahendGraph(Relation rel, RelationGraph graph, Relation minuend) {
            if (graph instanceof OnlineBaseGraph g && !g.isStatic()) {
                // The view only matters for pairs that can be in the minuend.
                final OnlineBaseGraph restricted = new OnlineBaseGraph(OnlineCAATPropagator.this, rel,
                        g.execInReason, false);
                final EventGraph minuendMay = ra.getKnowledge(minuend).getMaySet();
                initPairs(restricted, context.isEncoded(rel.getDefinition()), minuendMay::contains);
                final AntiMonotoneGraphView view = new AntiMonotoneGraphView(OnlineCAATPropagator.this, restricted);
                view.setName(rel.getNameOrTerm() + "#upper");
                createdGraphViews.add(view);
                return view;
            }
            return graph;
        }

        @Override
        public SetPredicate createSubtrahendSet(Relation rel, SetPredicate set, Relation minuend) {
            if (set instanceof OnlineBaseSet s && !s.isStatic()) {
                final AntiMonotoneSetView view = new AntiMonotoneSetView(OnlineCAATPropagator.this, s);
                view.setName(rel.getNameOrTerm() + "#upper");
                createdSetViews.add(view);
                return view;
            }
            return set;
        }
    }

    // ======================================== Internal classes ========================================

    private record Watch(int kind, CAATPredicate target, int index) {
        static final int EXEC = 0;
        static final int GRAPH_TRUE = 1;
        static final int SET_TRUE = 2;
        static final int GRAPH_FALSE = 3;
        static final int SET_FALSE = 4;
    }

    // A conjunction of literals, normalized for hashing.
    private record LitKey(int[] lits) {
        LitKey {
            lits = lits.clone();
            Arrays.sort(lits);
        }
        @Override
        public boolean equals(Object o) { return o instanceof LitKey k && Arrays.equals(lits, k.lits); }
        @Override
        public int hashCode() { return Arrays.hashCode(lits); }
    }

    private static final class IntList {
        private int[] data = new int[16];
        private int size = 0;

        void add(int v) {
            if (size == data.length) {
                data = Arrays.copyOf(data, size * 2);
            }
            data[size++] = v;
        }

        int get(int i) { return data[i]; }
        int size() { return size; }
        void truncate(int newSize) { size = newSize; }
        int[] toArray() { return Arrays.copyOf(data, size); }
    }

    public static class Statistics {
        long numFixed;
        long numConflicts;
        long numFinalConflicts;
        long numFinalChecks;
        long numPops;
        long totalConflictSize;
        long numSymmetricClauses;
        long numPropagations;
        long propagationTime;
        long checkTime;
        long reasonTime;
        long backtrackTime;
        long finalCheckTime;

        @Override
        public String toString() {
            return String.format("""
                    ======== Online CAAT statistics ========
                    #Fixed atoms: %d
                    #Conflicts: %d (on final check: %d), avg. size %.1f
                    #Symmetric clauses: %d
                    #Theory propagations: %d
                    #Final checks: %d
                    #Pops: %d
                    Propagation time (incl. checks): %d ms
                       -- Consistency check time: %d ms
                       -- Reason computation time: %d ms
                    Backtracking time: %d ms
                    Final check time: %d ms""",
                    numFixed, numConflicts, numFinalConflicts,
                    numConflicts == 0 ? 0.0 : (double) totalConflictSize / numConflicts,
                    numSymmetricClauses, numPropagations, numFinalChecks, numPops,
                    propagationTime / 1_000_000, checkTime / 1_000_000, reasonTime / 1_000_000,
                    backtrackTime / 1_000_000, finalCheckTime / 1_000_000);
        }
    }
}
