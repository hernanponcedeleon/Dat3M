package com.dat3m.dartagnan.wmm.analysis;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.Dependency;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.ExecutionStatus;
import com.dat3m.dartagnan.program.event.core.IfAsJump;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.MemEvent;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.core.rmw.RMWStore;
import com.dat3m.dartagnan.program.event.core.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.lang.svcomp.EndAtomic;
import com.dat3m.dartagnan.program.filter.FilterAbstract;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.dat3m.dartagnan.program.filter.FilterIntersection;
import com.dat3m.dartagnan.program.filter.FilterMinus;
import com.dat3m.dartagnan.program.filter.FilterUnion;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Constraint;
import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.configuration.Arch.RISCV;
import static com.dat3m.dartagnan.configuration.OptionNames.*;
import static com.dat3m.dartagnan.program.event.Tag.*;
import static com.google.common.base.Preconditions.checkNotNull;
import static com.google.common.base.Verify.verify;
import static com.google.common.collect.Lists.reverse;
import static com.google.common.collect.Sets.difference;
import static com.google.common.collect.Sets.intersection;
import static java.util.stream.Collectors.toList;
import static java.util.stream.Collectors.toSet;
import static java.util.stream.IntStream.iterate;

@Options
public class RelationAnalysis {

    private static final Logger logger = LogManager.getLogger(RelationAnalysis.class);

    private static final Delta EMPTY = new Delta(Set.of(), Set.of());

    private final VerificationTask task;
    private final Context analysisContext;
    private final ExecutionAnalysis exec;
    private final AliasAnalysis alias;
    private final Dependency dep;
    private final WmmAnalysis wmmAnalysis;
    private final Map<Relation, Knowledge> knowledgeMap = new HashMap<>();

    @Option(name = ENABLE_RELATION_ANALYSIS,
            description = "Derived relations of the memory model ",
            secure = true)
    private boolean enable = true;

    @Option(name = ENABLE_MUST_SETS,
            description = "Tracks relationships of the memory model, which exist in all execution that execute the two participating events.",
            secure = true)
    private boolean enableMustSets = true;

    @Option(name = ENABLE_EXTENDED_RELATION_ANALYSIS,
            description = "Marks relationships as trivially false, if they alone would violate a consistency property of the target memory model.",
            secure = true)
    private boolean enableExtended = true;

    private RelationAnalysis(VerificationTask t, Context context, Configuration config) {
        task = checkNotNull(t);
        analysisContext = context;
        exec = context.requires(ExecutionAnalysis.class);
        alias = context.requires(AliasAnalysis.class);
        dep = context.requires(Dependency.class);
        wmmAnalysis = context.requires(WmmAnalysis.class);
    }

    /**
     * Performs a static analysis on the relationships that may occur in an execution.
     *
     * @param task    Program, target memory model and property to check.
     * @param context Collection of static analyses already performed on {@code task} with respect to {@code memoryModel}.
     *                Should at least include the following elements:
     *                <ul>
     *                    <li>{@link ExecutionAnalysis}
     *                    <li>{@link Dependency}
     *                    <li>{@link AliasAnalysis}
     *                    <li>{@link WmmAnalysis}
     *                </ul>
     * @param config  User-defined options to further specify the behavior.
     */
    public static RelationAnalysis fromConfig(VerificationTask task, Context context, Configuration config) throws InvalidConfigurationException {
        RelationAnalysis a = new RelationAnalysis(task, context, config);
        task.getConfig().inject(a);
        logger.info("{}: {}", ENABLE_RELATION_ANALYSIS, a.enable);
        logger.info("{}: {}", ENABLE_MUST_SETS, a.enableMustSets);
        logger.info("{}: {}", ENABLE_EXTENDED_RELATION_ANALYSIS, a.enableExtended);
        if (a.enableMustSets && !a.enable) {
            logger.warn("{} implies {}", ENABLE_MUST_SETS, ENABLE_RELATION_ANALYSIS);
            a.enable = true;
        }
        if (a.enableExtended && !a.enable) {
            logger.warn("{} implies {}", ENABLE_EXTENDED_RELATION_ANALYSIS, ENABLE_RELATION_ANALYSIS);
            a.enable = true;
        }
        a.run();
        if (a.enableExtended) {
            a.runExtended();
        }
        return a;
    }

    /**
     * Fetches results of this analysis.
     *
     * @param relation Some element in the associated task's memory model.
     * @return Pairs of events of the program that may be related in some execution or even must be related in all executions.
     */
    public Knowledge getKnowledge(Relation relation) {
        return knowledgeMap.get(relation);
    }

    /*
        Returns a set of co-edges (w1, w2) (subset of maxTupleSet) whose clock-constraints
        do not need to get encoded explicitly.
        The reason is that whenever we have co(w1,w2) then there exists an intermediary
        w3 s.t. co(w1, w3) /\ co(w3, w2). As a result we have c(w1) < c(w3) < c(w2) transitively.
        Reasoning: Let (w1, w2) be a potential co-edge. Suppose there exists a w3 different to w1 and w2,
        whose execution is either implied by either w1 or w2.
        Now, if co(w1, w3) is a must-edge and co(w2, w3) is impossible, then we can reason as follows.
            - Suppose w1 and w2 get executed and their addresses match, then w3 must also get executed.
            - Since co(w1, w3) is a must-edge, we have that w3 accesses the same address as w1 and w2,
              and c(w1) < c(w3).
            - Because addr(w2)==addr(w3), we must also have either co(w2, e3) or co(w3, w2).
              The former is disallowed by assumption, so we have co(w3, w2) and hence c(w3) < c(w2).
            - By transitivity, we have c(w1) < c(w3) < c(w2) as desired.
            - Note that this reasoning has to be done inductively, because co(w1, w3) or co(w3, w2) may
              not involve encoding a clock constraint (due to this optimization).
        There is also a symmetric case where co(w3, w1) is impossible and co(w3, w2) is a must-edge.
     */
    public Set<Tuple> findTransitivelyImpliedCo(Relation co) {
        final RelationAnalysis.Knowledge k = getKnowledge(co);
        Set<Tuple> transCo = new HashSet<>();
        for (final Tuple t : k.may) {
            final MemEvent x = (MemEvent) t.getFirst();
            final MemEvent z = (MemEvent) t.getSecond();
            final boolean hasIntermediary = k.getMustOut(x).stream().map(Tuple::getSecond)
                    .anyMatch(y -> y != x && y != z && (exec.isImplied(x, y) || exec.isImplied(z, y)) && !k.may.contains(new Tuple(z, y))) ||
                    k.getMustIn(z).stream().map(Tuple::getFirst)
                            .anyMatch(y -> y != x && y != z && (exec.isImplied(x, y) || exec.isImplied(z, y)) && !k.may.contains(new Tuple(y, x)));
            if (hasIntermediary) {
                transCo.add(t);
            }
        }
        return transCo;
    }

    private void run() {
        Wmm memoryModel = task.getMemoryModel();
        Map<Relation, List<Definition>> dependents = new HashMap<>();
        for (Relation r : memoryModel.getRelations()) {
            for (Relation d : r.getDependencies()) {
                dependents.computeIfAbsent(d, k -> new ArrayList<>()).add(r.getDefinition());
            }
        }
        // ------------------------------------------------
        Initializer initializer = new Initializer();
        Map<Relation, List<Delta>> qGlobal = new HashMap<>();
        for (Relation r : memoryModel.getRelations()) {
            Knowledge k = r.getDefinition().accept(initializer);
            knowledgeMap.put(r, k);
            if (!k.may.isEmpty() || !k.must.isEmpty()) {
                qGlobal.computeIfAbsent(r, x -> new ArrayList<>(1))
                        .add(new Delta(k.may, k.must));
            }
        }
        // ------------------------------------------------
        Propagator propagator = new Propagator();
        for (Set<DependencyGraph<Relation>.Node> scc : DependencyGraph.from(memoryModel.getRelations()).getSCCs()) {
            Set<Relation> stratum = scc.stream().map(DependencyGraph.Node::getContent).collect(toSet());
            // the algorithm has deterministic order, only if all components are deterministically-ordered
            Map<Relation, List<Delta>> qLocal = new LinkedHashMap<>();
            // move from global queue
            for (Relation r : stratum) {
                List<Delta> d = qGlobal.remove(r);
                if (d != null) {
                    qLocal.put(r, d);
                }
            }
            // repeat until convergence
            while (!qLocal.isEmpty()) {
                Relation relation = qLocal.keySet().iterator().next();
                Delta delta = knowledgeMap.get(relation).joinSet(qLocal.remove(relation));
                if (delta.may.isEmpty() && delta.must.isEmpty()) {
                    continue;
                }
                propagator.source = relation;
                propagator.may = delta.may;
                propagator.must = delta.must;
                for (Definition c : dependents.getOrDefault(relation, List.of())) {
                    Relation r = c.getDefinedRelation();
                    Delta d = c.accept(propagator);
                    verify(enableMustSets || d.must.isEmpty(),
                            "although disabled, computed a non-empty must set for relation %s", r);
                    (stratum.contains(r) ? qLocal : qGlobal)
                            .computeIfAbsent(r, k -> new ArrayList<>())
                            .add(d);
                }
            }
        }
        verify(qGlobal.isEmpty(), "knowledge buildup propagated downwards");
    }

    public static final class Knowledge {
        private final Set<Tuple> may;
        private final Set<Tuple> must;
        private Knowledge(Set<Tuple> maySet, Set<Tuple> mustSet) {
            may = checkNotNull(maySet);
            must = checkNotNull(mustSet);
        }
        public Set<Tuple> getMaySet() {
            return may;
        }
        public Set<Tuple> getMayIn(Event second) {
            checkNotNull(second);
            return may.stream().filter(t -> t.getSecond().equals(second)).collect(toSet());
        }
        public Set<Tuple> getMayOut(Event first) {
            checkNotNull(first);
            return may.stream().filter(t -> t.getFirst().equals(first)).collect(toSet());
        }
        public Set<Tuple> getMustSet() {
            return must;
        }
        public Set<Tuple> getMustIn(Event second) {
            checkNotNull(second);
            return must.stream().filter(t -> t.getSecond().equals(second)).collect(toSet());
        }
        public Set<Tuple> getMustOut(Event first) {
            checkNotNull(first);
            return must.stream().filter(t -> t.getFirst().equals(first)).collect(toSet());
        }
        private Delta joinSet(List<Delta> l) {
            verify(!l.isEmpty(), "empty update");
            // NOTE optimization due to initial deltas carrying references to knowledge sets
            Set<Tuple> maySet = may.isEmpty() || l.get(0).may == may ? may : new HashSet<>();
            Set<Tuple> mustSet = must.isEmpty() || l.get(0).must == must ? must : new HashSet<>();
            for (Delta d : l) {
                for (Tuple t : d.may) {
                    if (may.add(t)) {
                        maySet.add(t);
                    }
                }
                for (Tuple t : d.must) {
                    if (must.add(t)) {
                        mustSet.add(t);
                    }
                }
            }
            return new Delta(maySet, mustSet);
        }
        private ExtendedDelta join(List<ExtendedDelta> l) {
            verify(!l.isEmpty(), "empty update in extended analysis");
            Set<Tuple> disableSet = new HashSet<>();
            Set<Tuple> enableSet = new HashSet<>();
            for (ExtendedDelta d : l) {
                for (Tuple t : Set.copyOf(d.disabled)) {
                    if (may.remove(t)) {
                        disableSet.add(t);
                    }
                }
                for (Tuple t : Set.copyOf(d.enabled)) {
                    if (must.add(t)) {
                        enableSet.add(t);
                    }
                }
            }
            return new ExtendedDelta(disableSet, enableSet);
        }
    }

    private void runExtended() {
        Wmm memoryModel = task.getMemoryModel();
        Map<Relation, List<Constraint>> dependents = new HashMap<>();
        for (Relation r : memoryModel.getRelations()) {
            Definition d = r.getDefinition();
            if (d == null) {
                continue;
            }
            for (Relation x : d.getConstrainedRelations()) {
                dependents.computeIfAbsent(x, k -> new ArrayList<>()).add(d);
            }
        }
        Map<Relation, List<ExtendedDelta>> q = new LinkedHashMap<>();
        for (Axiom a : memoryModel.getAxioms()) {
            if (a.isFlagged()) {
                continue;
            }
            dependents.computeIfAbsent(a.getRelation(), k ->new ArrayList<>()).add(a);
            for (Map.Entry<Relation, ExtendedDelta> e :
                    a.computeInitialKnowledgeClosure(knowledgeMap, analysisContext).entrySet()) {
                q.computeIfAbsent(e.getKey(), k -> new ArrayList<>()).add(e.getValue());
            }
        }
        ExtendedPropagator propagator = new ExtendedPropagator();
        // repeat until convergence
        while (!q.isEmpty()) {
            Relation relation = q.keySet().iterator().next();
            ExtendedDelta delta = knowledgeMap.get(relation).join(q.remove(relation));
            if (delta.disabled.isEmpty() && delta.enabled.isEmpty()) {
                continue;
            }
            propagator.origin = relation;
            Set<Tuple> disabled = propagator.disabled = delta.disabled;
            Set<Tuple> enabled = propagator.enabled = delta.enabled;
            for (Constraint c : dependents.getOrDefault(relation, List.of())) {
                for (Map.Entry<Relation, ExtendedDelta> e :
                        c.computeIncrementalKnowledgeClosure(
                                relation, disabled, enabled, knowledgeMap, analysisContext).entrySet()) {
                    q.computeIfAbsent(e.getKey(), k -> new ArrayList<>()).add(e.getValue());
                }
                if (!(c instanceof Definition)) {
                    continue;
                }
                for (Map.Entry<Relation, ExtendedDelta> e : ((Definition) c).accept(propagator).entrySet()) {
                    q.computeIfAbsent(e.getKey(), k -> new ArrayList<>()).add(e.getValue());
                }
            }
        }
    }

    public static final class Delta {
        public final Set<Tuple> may;
        public final Set<Tuple> must;
        Delta(Set<Tuple> maySet, Set<Tuple> mustSet) {
            may = maySet;
            must = mustSet;
        }
    }

    //FIXME should be visible only to implementations of Constraint
    public static final class ExtendedDelta {
        final Set<Tuple> disabled;
        final Set<Tuple> enabled;
        public ExtendedDelta(Set<Tuple> d, Set<Tuple> e) {
            disabled = d;
            enabled = e;
        }
    }

    private final class Initializer implements Definition.Visitor<Knowledge> {
        final Program program = task.getProgram();
        final Knowledge defaultKnowledge;
        Initializer() {
            if (enable) {
                defaultKnowledge = null;
            } else {
                Set<Tuple> may = new HashSet<>();
                List<Event> events = program.getCache().getEvents(FilterBasic.get(VISIBLE));
                for (Event x : events) {
                    for (Event y : events) {
                        may.add(new Tuple(x, y));
                    }
                }
                defaultKnowledge = new Knowledge(may, Set.of());
            }
        }
        @Override
        public Knowledge visitDefinition(Relation r, List<? extends Relation> d) {
            return defaultKnowledge != null ? defaultKnowledge : new Knowledge(new HashSet<>(), new HashSet<>());
        }
        @Override
        public Knowledge visitProduct(Relation rel, FilterAbstract domain, FilterAbstract range) {
            Set<Tuple> must = new HashSet<>();
            List<Event> l1 = program.getCache().getEvents(domain);
            List<Event> l2 = program.getCache().getEvents(range);
            for (Event e1 : l1) {
                for (Event e2 : l2) {
                    if (!exec.areMutuallyExclusive(e1, e2)) {
                        must.add(new Tuple(e1, e2));
                    }
                }
            }
            return new Knowledge(must, new HashSet<>(must));
        }
        @Override
        public Knowledge visitIdentity(Relation rel, FilterAbstract set) {
            Set<Tuple> must = new HashSet<>();
            for (Event e : program.getCache().getEvents(set)) {
                must.add(new Tuple(e, e));
            }
            return new Knowledge(must, new HashSet<>(must));
        }
        @Override
        public Knowledge visitExternal(Relation rel) {
            Set<Tuple> must = new HashSet<>();
            List<Thread> threads = program.getThreads();
            for (int i = 0; i < threads.size(); i++) {
                Thread t1 = threads.get(i);
                for (int j = i + 1; j < threads.size(); j++) {
                    Thread t2 = threads.get(j);
                    for (Event e1 : t1.getCache().getEvents(FilterBasic.get(VISIBLE))) {
                        for (Event e2 : t2.getCache().getEvents(FilterBasic.get(VISIBLE))) {
                            must.add(new Tuple(e1, e2));
                            must.add(new Tuple(e2, e1));
                        }
                    }
                }
            }
            return new Knowledge(must, new HashSet<>(must));
        }
        @Override
        public Knowledge visitInternal(Relation rel) {
            Set<Tuple> must = new HashSet<>();
            for (Thread t : program.getThreads()) {
                List<Event> events = t.getCache().getEvents(FilterBasic.get(VISIBLE));
                for (Event e1 : events) {
                    for (Event e2 : events) {
                        if (!exec.areMutuallyExclusive(e1, e2)) {
                            must.add(new Tuple(e1, e2));
                        }
                    }
                }
            }
            return new Knowledge(must, new HashSet<>(must));
        }
        @Override
        public Knowledge visitProgramOrder(Relation rel, FilterAbstract type) {
            Set<Tuple> must = new HashSet<>();
            for (Thread t : program.getThreads()) {
                List<Event> events = t.getCache().getEvents(type);
                for (int i = 0; i < events.size(); i++) {
                    Event e1 = events.get(i);
                    for (int j = i + 1; j < events.size(); j++) {
                        Event e2 = events.get(j);
                        must.add(new Tuple(e1, e2));
                    }
                }
            }
            return new Knowledge(must, new HashSet<>(must));
        }
        @Override
        public Knowledge visitControl(Relation rel) {
            //TODO: We can restrict the codomain to visible events as the only usage of this Relation is in
            // ctrl := idd^+;ctrlDirect & (R*V)
            Set<Tuple> must = new HashSet<>();
            // NOTE: If's (under Linux) have different notion of ctrl dependency than conditional jumps!
            for (Thread thread : program.getThreads()) {
                for (Event e1 : thread.getCache().getEvents(FilterBasic.get(CMP))) {
                    for (Event e2 : ((IfAsJump) e1).getBranchesEvents()) {
                        if (!exec.areMutuallyExclusive(e1, e2)) {
                            must.add(new Tuple(e1, e2));
                        }
                    }
                }
                // Relates jumps (except those implementing Ifs and their internal jump to end) with all later events
                List<Event> condJumps = thread.getCache().getEvents(FilterMinus.get(
                        FilterBasic.get(JUMP),
                        FilterUnion.get(FilterBasic.get(CMP), FilterBasic.get(IFI))));
                if (!condJumps.isEmpty()) {
                    for (Event e2 : thread.getCache().getEvents(FilterBasic.get(ANY))) {
                        for (Event e1 : condJumps) {
                            if (e1.getGlobalId() < e2.getGlobalId() && !exec.areMutuallyExclusive(e1, e2)) {
                                must.add(new Tuple(e1, e2));
                            }
                        }
                    }
                }
            }
            return new Knowledge(must, new HashSet<>(must));
        }
        @Override
        public Knowledge visitAddressDependency(Relation rel) {
            return visitDependency(program.getCache().getEvents(FilterBasic.get(MEMORY)), e -> ((MemEvent) e).getAddress().getRegs());
        }
        @Override
        public Knowledge visitInternalDataDependency(Relation rel) {
            return visitDependency(program.getCache().getEvents(FilterBasic.get(REG_READER)), e -> ((RegReaderData) e).getDataRegs());
        }
        @Override
        public Knowledge visitFences(Relation rel, FilterAbstract fence) {
            Set<Tuple> may = new HashSet<>();
            Set<Tuple> must = new HashSet<>();
            for (Event f : program.getCache().getEvents(fence)) {
                List<Event> memEvents = f.getThread().getCache().getEvents(FilterBasic.get(MEMORY));
                int numEventsBeforeFence = (int) memEvents.stream()
                        .mapToInt(Event::getGlobalId).filter(id -> id < f.getGlobalId())
                        .count();
                List<Event> eventsBefore = memEvents.subList(0, numEventsBeforeFence);
                List<Event> eventsAfter = memEvents.subList(numEventsBeforeFence, memEvents.size());
                for (Event e1 : eventsBefore) {
                    boolean isImpliedByE1 = enableMustSets && exec.isImplied(e1, f);
                    for (Event e2 : eventsAfter) {
                        if (!exec.areMutuallyExclusive(e1, e2)) {
                            may.add(new Tuple(e1, e2));
                            if (isImpliedByE1 || enableMustSets && exec.isImplied(e2, f)) {
                                must.add(new Tuple(e1, e2));
                            }
                        }
                    }
                }
            }
            return new Knowledge(may, must);
        }
        @Override
        public Knowledge visitCompareAndSwapDependency(Relation rel) {
            Set<Tuple> must = new HashSet<>();
            for (Event e : program.getCache().getEvents(FilterBasic.get(IMM.CASDEPORIGIN))) {
                // The target of a CASDep is always the successor of the origin
                must.add(new Tuple(e, e.getSuccessor()));
            }
            return new Knowledge(must, new HashSet<>(must));
        }
        @Override
        public Knowledge visitCriticalSections(Relation rel) {
            Set<Tuple> may = new HashSet<>();
            Set<Tuple> must = new HashSet<>();
            //assume locks and unlocks are distinct
            Map<Event, Set<Event>> mayMap = new HashMap<>();
            Map<Event, Set<Event>> mustMap = new HashMap<>();
            for (Thread thread : program.getThreads()) {
                // assume order by cId
                // assume cId describes a topological sorting over the control flow
                List<Event> locks = reverse(thread.getCache().getEvents(FilterBasic.get(Linux.RCU_LOCK)));
                for (Event unlock : thread.getCache().getEvents(FilterBasic.get(Linux.RCU_UNLOCK))) {
                    // iteration order assures that all intermediaries were already iterated
                    for (Event lock : locks) {
                        if (unlock.getGlobalId() < lock.getGlobalId() ||
                                exec.areMutuallyExclusive(lock, unlock) ||
                                Stream.concat(mustMap.getOrDefault(lock, Set.of()).stream(),
                                                mustMap.getOrDefault(unlock, Set.of()).stream())
                                        .anyMatch(e -> exec.isImplied(lock, e) || exec.isImplied(unlock, e))) {
                            continue;
                        }
                        boolean noIntermediary = enableMustSets &&
                                mayMap.getOrDefault(unlock, Set.of()).stream()
                                        .allMatch(e -> exec.areMutuallyExclusive(lock, e)) &&
                                mayMap.getOrDefault(lock, Set.of()).stream()
                                        .allMatch(e -> exec.areMutuallyExclusive(e, unlock));
                        Tuple tuple = new Tuple(lock, unlock);
                        may.add(tuple);
                        mayMap.computeIfAbsent(lock, x -> new HashSet<>()).add(unlock);
                        mayMap.computeIfAbsent(unlock, x -> new HashSet<>()).add(lock);
                        if (noIntermediary) {
                            must.add(tuple);
                            mustMap.computeIfAbsent(lock, x -> new HashSet<>()).add(unlock);
                            mustMap.computeIfAbsent(unlock, x -> new HashSet<>()).add(lock);
                        }
                    }
                }
            }
            return new Knowledge(may, must);
        }
        @Override
        public Knowledge visitReadModifyWrites(Relation rel) {
            //NOTE: Changes to the semantics of this method may need to be reflected in RMWGraph for Refinement!
            // ----- Compute minTupleSet -----
            Set<Tuple> must = new HashSet<>();
            // RMWLoad -> RMWStore
            for (Event store : program.getCache().getEvents(
                    FilterIntersection.get(FilterBasic.get(RMW), FilterBasic.get(WRITE)))) {
                if (store instanceof RMWStore) {
                    must.add(new Tuple(((RMWStore) store).getLoadEvent(), store));
                }
            }
            // Locks: Load -> Assume/CondJump -> Store
            for (Event e : program.getCache().getEvents(FilterIntersection.get(
                    FilterIntersection.get(FilterBasic.get(RMW), FilterBasic.get(READ)),
                    FilterUnion.get(FilterBasic.get(C11.LOCK), FilterBasic.get(Linux.LOCK_READ))))) {
                // Connect Load to Store
                must.add(new Tuple(e, e.getSuccessor().getSuccessor()));
            }
            // Atomics blocks: BeginAtomic -> EndAtomic
            for (Event end : program.getCache().getEvents(
                    FilterIntersection.get(FilterBasic.get(RMW), FilterBasic.get(SVCOMP.SVCOMPATOMIC)))) {
                List<Event> block = ((EndAtomic) end).getBlock().stream().filter(x -> x.is(VISIBLE)).collect(toList());
                for (int i = 0; i < block.size(); i++) {
                    Event e = block.get(i);
                    for (int j = i + 1; j < block.size(); j++) {
                        if (!exec.areMutuallyExclusive(e, block.get(j))) {
                            must.add(new Tuple(e, block.get(j)));
                        }
                    }
                }
            }
            // ----- Compute maxTupleSet -----
            Set<Tuple> may = new HashSet<>(must);
            // LoadExcl -> StoreExcl
            for (Thread thread : program.getThreads()) {
                List<Event> events = thread.getCache().getEvents(FilterBasic.get(EXCL));
                // assume order by cId
                // assume cId describes a topological sorting over the control flow
                for (int end = 1; end < events.size(); end++) {
                    Event store = events.get(end);
                    if (!store.is(WRITE)) {
                        continue;
                    }
                    int start = iterate(end - 1, i -> i >= 0, i -> i - 1)
                            .filter(i -> exec.isImplied(store, events.get(i)))
                            .findFirst().orElse(0);
                    List<Event> candidates = events.subList(start, end).stream()
                            .filter(e -> !exec.areMutuallyExclusive(e, store))
                            .collect(toList());
                    int size = candidates.size();
                    for (int i = 0; i < size; i++) {
                        Event load = candidates.get(i);
                        List<Event> intermediaries = candidates.subList(i + 1, size);
                        if (!load.is(READ) || intermediaries.stream().anyMatch(e -> exec.isImplied(load, e))) {
                            continue;
                        }
                        Tuple tuple = new Tuple(load, store);
                        may.add(tuple);
                        if (enableMustSets &&
                                intermediaries.stream().allMatch(e -> exec.areMutuallyExclusive(load, e)) &&
                                (store.is(MATCHADDRESS) || alias.mustAlias((MemEvent) load, (MemEvent) store))) {
                            must.add(tuple);
                        }
                    }
                }
            }
            return new Knowledge(may, must);
        }
        @Override
        public Knowledge visitMemoryOrder(Relation rel) {
            logger.trace("Computing maxTupleSet for memory order");
            final List<Event> nonInitWrites = program.getCache().getEvents(FilterMinus.get(FilterBasic.get(WRITE), FilterBasic.get(INIT)));
            Set<Tuple> may = new HashSet<>();
            for (Event w1 : program.getCache().getEvents(FilterBasic.get(WRITE))) {
                for (Event w2 : nonInitWrites) {
                    if (w1.getGlobalId() != w2.getGlobalId() && !exec.areMutuallyExclusive(w1, w2)
                            && alias.mayAlias((MemEvent) w1, (MemEvent) w2)) {
                        may.add(new Tuple(w1, w2));
                    }
                }
            }
            Set<Tuple> must = new HashSet<>();
            if (wmmAnalysis.isLocallyConsistent()) {
                may.removeIf(Tuple::isBackward);
                for (Tuple t : enableMustSets ? may : Set.<Tuple>of()) {
                    MemEvent w1 = (MemEvent) t.getFirst();
                    MemEvent w2 = (MemEvent) t.getSecond();
                    if (!w2.is(INIT) && alias.mustAlias(w1, w2) && (w1.is(INIT) || t.isForward())) {
                        must.add(t);
                    }
                }
            }
            logger.debug("maxTupleSet size for memory order: " + may.size());
            return new Knowledge(may, must);
        }
        @Override
        public Knowledge visitReadFrom(Relation rel) {
            logger.trace("Computing maxTupleSet for read-from");
            Set<Tuple> may = new HashSet<>();
            List<Event> loadEvents = program.getCache().getEvents(FilterBasic.get(READ));
            List<Event> storeEvents = program.getCache().getEvents(FilterBasic.get(WRITE));
            for (Event e1 : storeEvents) {
                for (Event e2 : loadEvents) {
                    if (alias.mayAlias((MemEvent) e1, (MemEvent) e2) && !exec.areMutuallyExclusive(e1, e2)) {
                        may.add(new Tuple(e1, e2));
                    }
                }
            }
            if (wmmAnalysis.isLocallyConsistent()) {
                // Remove future reads
                may.removeIf(Tuple::isBackward);
                // Remove past reads
                Set<Tuple> deletedTuples = new HashSet<>();
                Map<Event, List<Event>> writesByRead = new HashMap<>();
                for (Tuple t : may) {
                    writesByRead.computeIfAbsent(t.getSecond(), x -> new ArrayList<>()).add(t.getFirst());
                }
                for (Event r : program.getCache().getEvents(FilterBasic.get(READ))) {
                    MemEvent read = (MemEvent) r;
                    // The set of same-thread writes as well as init writes that could be read from (all before the read)
                    // sorted by order (init events first)
                    List<MemEvent> possibleWrites = writesByRead.get(read).stream()
                            .filter(e -> (e.getThread() == read.getThread() || e.is(INIT)))
                            .map(x -> (MemEvent) x)
                            .sorted((o1, o2) -> o1.is(INIT) == o2.is(INIT) ? (o1.getGlobalId() - o2.getGlobalId()) : o1.is(INIT) ? -1 : 1)
                            .collect(Collectors.toList());
                    // The set of writes that won't be readable due getting overwritten.
                    Set<MemEvent> deletedWrites = new HashSet<>();
                    // A rf-edge (w1, r) is impossible, if there exists a write w2 such that
                    // - w2 is exec-implied by w1 or r (i.e. cf-implied + w2.cfImpliesExec)
                    // - w2 must alias with either w1 or r.
                    for (int i = 0; i < possibleWrites.size(); i++) {
                        MemEvent w1 = possibleWrites.get(i);
                        for (MemEvent w2 : possibleWrites.subList(i + 1, possibleWrites.size())) {
                            // w2 dominates w1 if it aliases with it and it is guaranteed to execute if either w1 or the read are
                            // executed
                            if ((exec.isImplied(w1, w2) || exec.isImplied(read, w2))
                                    && (alias.mustAlias(w1, w2) || alias.mustAlias(w2, read))) {
                                deletedWrites.add(w1);
                                break;
                            }
                        }
                    }
                    for (Event w : deletedWrites) {
                        deletedTuples.add(new Tuple(w, read));
                    }
                }
                may.removeAll(deletedTuples);
            }
            if (wmmAnalysis.doesRespectAtomicBlocks()) {
                //TODO: This function can not only reduce rf-edges
                // but we could also figure out implied coherences:
                // Assume w1 and w2 are aliasing in the same block and w1 is before w2,
                // then if w1 is co-before some external w3, then so is w2, i.e.
                // co(w1, w3) => co(w2, w3), but we also have co(w2, w3) => co(w1, w3)
                // so co(w1, w3) <=> co(w2, w3).
                // This information is not expressible in terms of min/must sets, but
                // we could still encode it.
                int sizeBefore = may.size();
                // Atomics blocks: BeginAtomic -> EndAtomic
                FilterAbstract filter = FilterIntersection.get(FilterBasic.get(RMW), FilterBasic.get(SVCOMP.SVCOMPATOMIC));
                for (Event end : program.getCache().getEvents(filter)) {
                    // Collect memEvents of the atomic block
                    List<Store> writes = new ArrayList<>();
                    List<Load> reads = new ArrayList<>();
                    EndAtomic endAtomic = (EndAtomic) end;
                    for (Event b : endAtomic.getBlock()) {
                        if (b instanceof Load) {
                            reads.add((Load) b);
                        } else if (b instanceof Store) {
                            writes.add((Store) b);
                        }
                    }
                    for (Load r : reads) {
                        // If there is any write w inside the atomic block that is guaranteed to
                        // execute before the read and that aliases with it,
                        // then the read won't be able to read any external writes
                        boolean hasImpliedWrites = writes.stream()
                                .anyMatch(w -> w.getGlobalId() < r.getGlobalId()
                                        && exec.isImplied(r, w) && alias.mustAlias(r, w));
                        if (hasImpliedWrites) {
                            may.removeIf(t -> t.getSecond() == r && t.isCrossThread());
                        }
                    }
                }
                logger.debug("Atomic block optimization eliminated {} reads", sizeBefore - may.size());
            }
            logger.debug("maxTupleSet size for read-from: {}", may.size());
            return new Knowledge(may, new HashSet<>());
        }
        @Override
        public Knowledge visitSameAddress(Relation rel) {
            Set<Tuple> may = new HashSet<>();
            Collection<Event> events = program.getCache().getEvents(FilterBasic.get(MEMORY));
            for (Event e1 : events) {
                for (Event e2 : events) {
                    if (alias.mayAlias((MemEvent) e1, (MemEvent) e2) && !exec.areMutuallyExclusive(e1, e2)) {
                        may.add(new Tuple(e1, e2));
                    }
                }
            }
            Set<Tuple> must = new HashSet<>();
            for (Tuple t : enableMustSets ? may : Set.<Tuple>of()) {
                if (alias.mustAlias((MemEvent) t.getFirst(), (MemEvent) t.getSecond())) {
                    must.add(t);
                }
            }
            return new Knowledge(may, must);
        }
        private Knowledge visitDependency(List<Event> events, Function<Event, Set<Register>> registers) {
            Set<Tuple> may = new HashSet<>();
            Set<Tuple> must = new HashSet<>();
            // We need to track ExecutionStatus events separately, because they induce data-dependencies
            // without reading from a register.
            Set<ExecutionStatus> execStatusRegWriter = new HashSet<>();
            for (Event regReader : events) {
                for (Register register : registers.apply(regReader)) {
                    // Register x0 is hardwired to the constant 0 in RISCV
                    // https://en.wikichip.org/wiki/risc-v/registers,
                    // and thus it generates no dependency, see
                    // https://github.com/herd/herdtools7/issues/408
                    if (program.getArch().equals(RISCV) && register.getName().equals("x0")) {
                        continue;
                    }
                    Dependency.State r = dep.of(regReader, register);
                    for (Event regWriter : r.may) {
                        may.add(new Tuple(regWriter, regReader));
                        if (regWriter instanceof ExecutionStatus) {
                            execStatusRegWriter.add((ExecutionStatus) regWriter);
                        }
                    }
                    for (Event regWriter : enableMustSets ? r.must : List.<Event>of()) {
                        must.add(new Tuple(regWriter, regReader));
                    }
                }
            }
            for (ExecutionStatus execStatus : execStatusRegWriter) {
                if (execStatus.doesTrackDep()) {
                    Tuple t = new Tuple(execStatus.getStatusEvent(), execStatus);
                    may.add(t);
                    must.add(t);
                }
            }
            return new Knowledge(may, must);
        }
    }

    public final class Propagator implements Definition.Visitor<Delta> {
        public Relation source;
        public Set<Tuple> may;
        public Set<Tuple> must;
        @Override
        public Delta visitUnion(Relation rel, Relation... operands) {
            if (Arrays.asList(operands).contains(source)) {
                return new Delta(may, enableMustSets ? must : Set.of());
            }
            return EMPTY;
        }
        @Override
        public Delta visitIntersection(Relation rel, Relation... operands) {
            if (Arrays.asList(operands).contains(source)) {
                return new Delta(
                        may.stream()
                                .filter(t -> Arrays.stream(operands)
                                        .allMatch(r -> source.equals(r) || knowledgeMap.get(r).may.contains(t)))
                                .collect(toSet()),
                        enableMustSets ?
                                must.stream()
                                        .filter(t -> Arrays.stream(operands)
                                                .allMatch(r -> source.equals(r) || knowledgeMap.get(r).must.contains(t)))
                                        .collect(toSet()) :
                                Set.of());
            }
            return EMPTY;
        }
        @Override
        public Delta visitDifference(Relation rel, Relation r1, Relation r2) {
            if (r1.equals(source)) {
                Knowledge k = knowledgeMap.get(r2);
                return new Delta(
                        enableMustSets ? difference(may, k.must) : may,
                        enableMustSets ? difference(must, k.may) : Set.of());
            }
            // cannot handle updates from r2
            return EMPTY;
        }
        @Override
        public Delta visitComposition(Relation rel, Relation r1, Relation r2) {
            Set<Tuple> maySet = new HashSet<>();
            Set<Tuple> mustSet = new HashSet<>();
            if (r1.equals(source)) {
                Knowledge k = knowledgeMap.get(r2);
                Map<Event, List<Event>> mayMap = map(k.may);
                for (Tuple t : may) {
                    Event e1 = t.getFirst();
                    for (Event e2 : mayMap.getOrDefault(t.getSecond(), List.of())) {
                        if (!exec.areMutuallyExclusive(e1, e2)) {
                            maySet.add(new Tuple(e1, e2));
                        }
                    }
                }
                Map<Event, List<Event>> mustMap = map(k.must);
                for (Tuple t : enableMustSets ? must : Set.<Tuple>of()) {
                    Event e1 = t.getFirst();
                    Event e = t.getSecond();
                    boolean implies = exec.isImplied(e1, e);
                    for (Event e2 : mustMap.getOrDefault(e, List.of())) {
                        if ((implies || exec.isImplied(e2, e)) && !exec.areMutuallyExclusive(e1, e2)) {
                            mustSet.add(new Tuple(e1, e2));
                        }
                    }
                }
            }
            if (r2.equals(source)) {
                Knowledge k = knowledgeMap.get(r1);
                Map<Event, List<Event>> mayMap = mapReverse(k.may);
                for (Tuple t : may) {
                    Event e2 = t.getSecond();
                    for (Event e1 : mayMap.getOrDefault(t.getFirst(), List.of())) {
                        if (!exec.areMutuallyExclusive(e1, e2)) {
                            maySet.add(new Tuple(e1, e2));
                        }
                    }
                }
                Map<Event, List<Event>> mustMap = mapReverse(k.must);
                for (Tuple t : enableMustSets ? must : Set.<Tuple>of()) {
                    Event e2 = t.getSecond();
                    Event e = t.getFirst();
                    boolean implies = exec.isImplied(e2, e);
                    for (Event e1 : mustMap.getOrDefault(e, List.of())) {
                        if ((implies || exec.isImplied(e1, e)) && !exec.areMutuallyExclusive(e1, e2)) {
                            mustSet.add(new Tuple(e1, e2));
                        }
                    }
                }
            }
            return new Delta(maySet, mustSet);
        }
        @Override
        public Delta visitDomainIdentity(Relation rel, Relation r1) {
            if (r1.equals(source)) {
                Set<Tuple> maySet = new HashSet<>();
                Set<Tuple> mustSet = new HashSet<>();
                for (Tuple t : may) {
                    maySet.add(new Tuple(t.getFirst(), t.getFirst()));
                }
                for (Tuple t : enableMustSets ? must : Set.<Tuple>of()) {
                    if (exec.isImplied(t.getFirst(), t.getSecond())) {
                        mustSet.add(new Tuple(t.getFirst(), t.getFirst()));
                    }
                }
                return new Delta(maySet, mustSet);
            }
            return EMPTY;
        }
        @Override
        public Delta visitRangeIdentity(Relation rel, Relation r1) {
            if (r1.equals(source)) {
                Set<Tuple> maySet = new HashSet<>();
                Set<Tuple> mustSet = new HashSet<>();
                for (Tuple t : may) {
                    maySet.add(new Tuple(t.getSecond(), t.getSecond()));
                }
                for (Tuple t : enableMustSets ? must : Set.<Tuple>of()) {
                    if (exec.isImplied(t.getSecond(), t.getFirst())) {
                        mustSet.add(new Tuple(t.getSecond(), t.getSecond()));
                    }
                }
                return new Delta(maySet, mustSet);
            }
            return EMPTY;
        }
        @Override
        public Delta visitInverse(Relation rel, Relation r1) {
            if (r1.equals(source)) {
                return new Delta(inverse(may), enableMustSets ? inverse(must) : Set.of());
            }
            return EMPTY;
        }
        @Override
        public Delta visitTransitiveClosure(Relation rel, Relation r1) {
            if (r1.equals(source)) {
                Set<Tuple> maySet = new HashSet<>(may);
                Knowledge k = knowledgeMap.get(rel);
                Map<Event, List<Event>> mayMap = map(k.may);
                for (Collection<Tuple> current = may; !current.isEmpty(); ) {
                    update(mayMap, current);
                    Collection<Tuple> next = new HashSet<>();
                    for (Tuple tuple : current) {
                        Event e1 = tuple.getFirst();
                        for (Event e2 : mayMap.getOrDefault(tuple.getSecond(), List.of())) {
                            Tuple t = new Tuple(e1, e2);
                            if (!k.may.contains(t) && !maySet.contains(t) && !exec.areMutuallyExclusive(e1, e2)) {
                                next.add(t);
                            }
                        }
                    }
                    maySet.addAll(next);
                    current = next;
                }
                if (!enableMustSets) {
                    return new Delta(maySet, Set.of());
                }
                Set<Tuple> mustSet = new HashSet<>(must);
                Map<Event, List<Event>> mustMap = map(k.must);
                for (Collection<Tuple> current = must; !current.isEmpty(); ) {
                    update(mustMap, current);
                    Collection<Tuple> next = new HashSet<>();
                    for (Tuple tuple : current) {
                        Event e1 = tuple.getFirst();
                        Event e = tuple.getSecond();
                        boolean implies = exec.isImplied(e1, e);
                        for (Event e2 : mustMap.getOrDefault(e, List.of())) {
                            Tuple t = new Tuple(e1, e2);
                            if (!k.must.contains(t) && !mustSet.contains(t) && (implies || exec.isImplied(e2, e)) && !exec.areMutuallyExclusive(e1, e2)) {
                                next.add(t);
                            }
                        }
                    }
                    mustSet.addAll(next);
                    current = next;
                }
                return new Delta(maySet, mustSet);
            }
            return EMPTY;
        }
    }

    private final class ExtendedPropagator implements Definition.Visitor<Map<Relation, ExtendedDelta>> {
        Relation origin;
        Set<Tuple> disabled;
        Set<Tuple> enabled;

        @Override
        public Map<Relation, ExtendedDelta> visitDefinition(Relation rel, List<? extends Relation> dependencies) {
            return Map.of();
        }

        @Override
        public Map<Relation, ExtendedDelta> visitUnion(Relation rel, Relation... operands) {
            Map<Relation, ExtendedDelta> map = new HashMap<>();
            if (origin.equals(rel)) {
                for (Relation o : operands) {
                    map.put(o, new ExtendedDelta(disabled, Set.of()));
                }
            }
            if (List.of(operands).contains(origin)) {
                Set<Tuple> d = new HashSet<>();
                for (Tuple t : disabled) {
                    if (Arrays.stream(operands).noneMatch(o -> knowledgeMap.get(o).may.contains(t))) {
                        d.add(t);
                    }
                }
                map.put(rel, new ExtendedDelta(d, enabled));
            }
            return map;
        }

        @Override
        public Map<Relation, ExtendedDelta> visitIntersection(Relation rel, Relation... operands) {
            Map<Relation, ExtendedDelta> map = new HashMap<>();
            if (origin.equals(rel)) {
                for (Relation o : operands) {
                    map.putIfAbsent(o, new ExtendedDelta(new HashSet<>(), enabled));
                }
                for (Tuple t : disabled) {
                    Relation[] r = Arrays.stream(operands)
                            .filter(o -> !knowledgeMap.get(o).must.contains(t))
                            .limit(2)
                            .toArray(Relation[]::new);
                    if (r.length == 1) {
                        map.get(r[0]).disabled.add(t);
                    }
                }
            }
            if (List.of(operands).contains(origin)) {
                Set<Tuple> e = new HashSet<>();
                for (Tuple t : enabled) {
                    if (Arrays.stream(operands).allMatch(o -> knowledgeMap.get(o).must.contains(t))) {
                        e.add(t);
                    }
                }
                map.put(rel, new ExtendedDelta(disabled, e));
            }
            return map;
        }

        @Override
        public Map<Relation, ExtendedDelta> visitDifference(Relation r0, Relation r1, Relation r2) {
            Map<Relation, ExtendedDelta> map = new HashMap<>();
            if (origin.equals(r0)) {
                map.put(r1, new ExtendedDelta(difference(disabled, knowledgeMap.get(r2).may), enabled));
                //map.put(r2, new ExtendedDelta(Set.of(), intersection(disabled, knowledgeMap.get(r1).getMustSet())));
            }
            if (origin.equals(r1)) {
                map.put(r0, new ExtendedDelta(disabled, difference(enabled, knowledgeMap.get(r2).may)));
            }
            if (origin.equals(r2)) {
                Knowledge k1 = knowledgeMap.get(r1);
                map.put(r0, new ExtendedDelta(intersection(enabled, k1.may), intersection(disabled, k1.must)));
                map.put(r1, new ExtendedDelta(difference(disabled, knowledgeMap.get(r0).may), Set.of()));
            }
            return map;
        }

        @Override
        public Map<Relation, ExtendedDelta> visitComposition(Relation r0, Relation r1, Relation r2) {
            Set<Tuple> d0 = new HashSet<>();
            Set<Tuple> e0 = new HashSet<>();
            Set<Tuple> d1 = new HashSet<>();
            Set<Tuple> d2 = new HashSet<>();
            Knowledge k0 = knowledgeMap.get(r0);
            Knowledge k1 = knowledgeMap.get(r1);
            Knowledge k2 = knowledgeMap.get(r2);
            if (origin.equals(r0)) {
                for (Tuple xz : disabled) {
                    Event x = xz.getFirst();
                    Event z = xz.getSecond();
                    boolean implies = exec.isImplied(x, z);
                    boolean implied = exec.isImplied(z, x);
                    for (Tuple xy : k1.getMustOut(x)) {
                        Event y = xy.getSecond();
                        if (implied || exec.isImplied(y, x)) {
                            Tuple yz = new Tuple(y, z);
                            if (k2.may.contains(yz)) {
                                d2.add(yz);
                            }
                        }
                    }
                    for (Tuple yz : k2.getMustIn(z)) {
                        Event y = yz.getFirst();
                        if (implies || exec.isImplied(y, z)) {
                            Tuple xy = new Tuple(x, y);
                            if (k1.may.contains(xy)) {
                                d1.add(xy);
                            }
                        }
                    }
                }
            }
            if (origin.equals(r1)) {
                for (Tuple xy : disabled) {
                    Event x = xy.getFirst();
                    Event y = xy.getSecond();
                    for (Tuple yz : k2.getMayOut(y)) {
                        Event z = yz.getSecond();
                        if (!exec.areMutuallyExclusive(x, z)
                                && k1.getMayOut(x).stream().noneMatch(t -> k2.may.contains(new Tuple(t.getSecond(), z)))) {
                            d0.add(new Tuple(x, z));
                        }
                    }
                }
                for (Tuple xy : enabled) {
                    Event x = xy.getFirst();
                    Event y = xy.getSecond();
                    boolean implies = exec.isImplied(x, y);
                    for (Tuple yz : k2.getMayOut(y)) {
                        Event z = yz.getSecond();
                        if (exec.areMutuallyExclusive(x, z)) {
                            continue;
                        }
                        Tuple xz = new Tuple(x, z);
                        if ((implies || exec.isImplied(z, y))) {
                            e0.add(xz);
                        }
                        if (!k0.may.contains(xz)) {
                            d2.add(yz);
                        }
                    }
                }
            }
            if (origin.equals(r2)) {
                for (Tuple xy : disabled) {
                    Event x = xy.getFirst();
                    Event y = xy.getSecond();
                    for (Tuple wx : k1.getMayIn(x)) {
                        Event w = wx.getFirst();
                        if (!exec.areMutuallyExclusive(w, y)
                                && k1.getMayOut(w).stream().noneMatch(t -> k2.may.contains(new Tuple(t.getSecond(), y)))) {
                            d0.add(new Tuple(w, y));
                        }
                    }
                }
                for (Tuple xy : enabled) {
                    Event x = xy.getFirst();
                    Event y = xy.getSecond();
                    boolean implied = exec.isImplied(y, x);
                    for (Tuple wx : k1.getMayIn(x)) {
                        Event w = wx.getFirst();
                        if (exec.areMutuallyExclusive(w, y)) {
                            continue;
                        }
                        Tuple wy = new Tuple(w, y);
                        if ((implied || exec.isImplied(w, x))) {
                            e0.add(wy);
                        }
                        if (!k0.may.contains(wy)) {
                            d1.add(wx);
                        }
                    }
                }
            }
            Map<Relation, ExtendedDelta> map = new HashMap<>();
            map.put(r0, new ExtendedDelta(d0, e0));
            map.computeIfAbsent(r1, k -> new ExtendedDelta(d1, new HashSet<>())).disabled.addAll(d1);
            map.computeIfAbsent(r2, k -> new ExtendedDelta(d2, new HashSet<>())).disabled.addAll(d2);
            return map;
        }

        @Override
        public Map<Relation, ExtendedDelta> visitInverse(Relation r0, Relation r1) {
            if (origin.equals(r0)) {
                return Map.of(r1, new ExtendedDelta(inverse(disabled), Set.of()));
            }
            if (origin.equals(r1)) {
                return Map.of(r0, new ExtendedDelta(inverse(disabled), inverse(enabled)));
            }
            return Map.of();
        }

        @Override
        public Map<Relation, ExtendedDelta> visitTransitiveClosure(Relation r0, Relation r1) {
            Set<Tuple> d0 = new HashSet<>();
            Set<Tuple> e0 = new HashSet<>();
            Set<Tuple> d1 = new HashSet<>();
            Knowledge k0 = knowledgeMap.get(r0);
            Knowledge k1 = knowledgeMap.get(r1);
            if (origin.equals(r1)) {
                for (Collection<Tuple> next = disabled; !next.isEmpty();) {
                    Collection<Tuple> current = next;
                    next = new ArrayList<>();
                    for (Tuple xy : current) {
                        Event x = xy.getFirst();
                        Event y = xy.getSecond();
                        for (Tuple yz : k0.getMustOut(y)) {
                            Event z = yz.getSecond();
                            if ((exec.isImplied(x, z) || exec.isImplied(y, z)) && !exec.areMutuallyExclusive(x, z)
                                    && k1.getMayOut(x).stream().noneMatch(t -> k0.may.contains(new Tuple(t.getSecond(), z)))) {
                                Tuple xz = new Tuple(x, z);
                                if (d0.add(xz)) {
                                    next.add(xz);
                                }
                            }
                        }
                        for (Tuple wx : k0.getMustIn(x)) {
                            Event w = wx.getFirst();
                            if ((exec.isImplied(x, w) || exec.isImplied(y, w)) && !exec.areMutuallyExclusive(w, y)
                                    && k1.getMayOut(w).stream().noneMatch(t -> k0.may.contains(new Tuple(t.getSecond(), y)))) {
                                Tuple wy = new Tuple(w, y);
                                if (d0.add(wy)) {
                                    next.add(wy);
                                }
                            }
                        }
                    }
                }
                for (Collection<Tuple> next = enabled; !next.isEmpty();) {
                    Collection<Tuple> current = next;
                    next = new ArrayList<>();
                    for (Tuple xy : current) {
                        Event x = xy.getFirst();
                        Event y = xy.getSecond();
                        boolean implied = exec.isImplied(y, x);
                        boolean implies = exec.isImplied(x, y);
                        for (Tuple yz : k0.getMustOut(y)) {
                            Event z = yz.getSecond();
                            if ((implied || exec.isImplied(z, x)) && !exec.areMutuallyExclusive(x, z)) {
                                Tuple xz = new Tuple(x, z);
                                if (e0.add(xz)) {
                                    next.add(xz);
                                }
                            }
                        }
                        for (Tuple wx : k0.getMustIn(x)) {
                            Event w = wx.getFirst();
                            if ((implies || exec.isImplied(w, y)) && !exec.areMutuallyExclusive(w, y)) {
                                Tuple wy = new Tuple(w, y);
                                if (e0.add(wy)) {
                                    next.add(wy);
                                }
                            }
                        }
                        for (Tuple yz : k0.getMayOut(y)) {
                            Event z = yz.getSecond();
                            if ((implied || exec.isImplied(z, x)) && !k0.may.contains(new Tuple(x, z))) {
                                d0.add(yz);
                            }
                        }
                        for (Tuple wx : k0.getMayIn(x)) {
                            Event w = wx.getFirst();
                            if ((implies || exec.isImplied(w, y)) && !k0.may.contains(new Tuple(w, y))) {
                                d0.add(wx);
                            }
                        }
                    }
                }
            }
            //NOTE sometimes enabled
            if (origin.equals(r0) || !d0.isEmpty()) {
                Collection<Tuple> next = d0.isEmpty() ? disabled : new HashSet<>(d0);
                if (!d0.isEmpty()) {
                    next.addAll(disabled);
                }
                while (!next.isEmpty()) {
                    Collection<Tuple> current = next;
                    next = new ArrayList<>();
                    for (Tuple xz : current) {
                        if (k1.may.contains(xz)) {
                            d1.add(xz);
                        }
                        Event x = xz.getFirst();
                        Event z = xz.getSecond();
                        boolean implied = exec.isImplied(z, x);
                        for (Tuple xy : k1.getMustOut(x)) {
                            Event y = xy.getSecond();
                            if (implied || exec.isImplied(y, x)) {
                                Tuple yz = new Tuple(y, z);
                                if (k0.may.contains(yz) && d0.add(yz)) {
                                    next.add(yz);
                                }
                            }
                        }
                        boolean implies = exec.isImplied(x, z);
                        for (Tuple yz : k0.getMustIn(z)) {
                            Event y = yz.getFirst();
                            if (implies || exec.isImplied(y, z)) {
                                Tuple xy = new Tuple(x, y);
                                if (k0.may.contains(xy) && d0.add(xy)) {
                                    next.add(xy);
                                }
                            }
                        }
                    }
                }
            }
            return Map.of(
                    r0, new ExtendedDelta(d0, e0),
                    r1, new ExtendedDelta(d1, Set.of()));
        }

        @Override
        public Map<Relation, ExtendedDelta> visitMemoryOrder(Relation co) {
            if (disabled.isEmpty()) {
                return Map.of();
            }
            //TODO use transitivity
            Set<Tuple> e = new HashSet<>();
            for (Tuple xy : disabled) {
                if (alias.mustAlias((MemEvent) xy.getFirst(), (MemEvent) xy.getSecond())) {
                    e.add(xy.getInverse());
                }
            }
            return Map.of(co, new ExtendedDelta(Set.of(), e));
        }
    }

    private static Set<Tuple> inverse(Set<Tuple> set) {
        Set<Tuple> r = new HashSet<>();
        for (Tuple t : set) {
            r.add(t.getInverse());
        }
        return r;
    }

    private static Map<Event, List<Event>> mapReverse(Set<Tuple> set) {
        Map<Event, List<Event>> map = new HashMap<>();
        for (Tuple t : set) {
            map.computeIfAbsent(t.getSecond(), x -> new ArrayList<>()).add(t.getFirst());
        }
        return map;
    }

    private static Map<Event, List<Event>> map(Set<Tuple> set) {
        Map<Event, List<Event>> map = new HashMap<>();
        update(map, set);
        return map;
    }

    private static void update(Map<Event, List<Event>> map, Collection<Tuple> set) {
        for (Tuple t : set) {
            map.computeIfAbsent(t.getFirst(), x -> new ArrayList<>()).add(t.getSecond());
        }
    }
}
