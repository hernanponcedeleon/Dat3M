package com.dat3m.dartagnan.wmm.analysis;

import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Register.UsageType;
import com.dat3m.dartagnan.program.ScopeHierarchy;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.BranchEquivalence;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.analysis.ReachingDefinitionsAnalysis;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.lang.svcomp.EndAtomic;
import com.dat3m.dartagnan.program.filter.Filter;
import com.dat3m.dartagnan.program.memory.VirtualMemoryObject;
import com.dat3m.dartagnan.utils.collections.IndexedDomain;
import com.dat3m.dartagnan.utils.collections.IndexedSet;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.*;
import com.dat3m.dartagnan.wmm.axiom.Acyclicity;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.axiom.Emptiness;
import com.dat3m.dartagnan.wmm.axiom.Irreflexivity;
import com.dat3m.dartagnan.wmm.definition.*;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.mutable.IndexedEventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.mutable.MutableEventGraph;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.program.Register.UsageType.*;
import static com.dat3m.dartagnan.program.event.Tag.*;
import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Preconditions.checkNotNull;
import static com.google.common.base.Verify.verify;
import static com.google.common.collect.Lists.reverse;
import static java.util.stream.Collectors.toList;
import static java.util.stream.Collectors.toSet;
import static java.util.stream.IntStream.iterate;

public class NativeRelationAnalysis implements RelationAnalysis {

    private static final Logger logger = LoggerFactory.getLogger(NativeRelationAnalysis.class);

    protected final VerificationTask task;
    protected final Context analysisContext;
    protected final ExecutionAnalysis exec;
    protected final ReachingDefinitionsAnalysis definitions;
    protected final AliasAnalysis alias;
    protected final WmmAnalysis wmmAnalysis;
    protected final VisibilityAnalysis visibility;
    protected final Map<Relation, MutableKnowledge> knowledgeMap = new HashMap<>();
    protected final IndexedSet<Event> allEvents;
    protected final IndexedSet<Event> allVisibleEvents;
    protected final Map<Thread, Set<Event>> threadVisibleEvents = new HashMap<>();//TODO remove
    protected final Delta EMPTY;
    protected final MutableEventGraph mutex;

    protected NativeRelationAnalysis(VerificationTask t, Context context, Configuration config) {
        task = checkNotNull(t);
        analysisContext = context;
        exec = context.requires(ExecutionAnalysis.class);
        definitions = context.requires(ReachingDefinitionsAnalysis.class);
        alias = context.requires(AliasAnalysis.class);
        wmmAnalysis = context.requires(WmmAnalysis.class);
        visibility = VisibilityAnalysis.newInstance(task.getMemoryModel());
        allEvents = new IndexedSet<>(exec.eventDomain());
        allVisibleEvents = new IndexedSet<>(new IndexedDomain<>(task.getProgram().getThreadEventsWithAllTags(VISIBLE)));
        EMPTY = new Delta(new IndexedEventGraph(exec.eventDomain()), new IndexedEventGraph(exec.eventDomain()));
        mutex = new IndexedEventGraph(exec.eventDomain());
    }

    /**
     * Performs a static analysis on the relationships that may occur in an execution.
     *
     * @param task    Program, target memory model and property to check.
     * @param context Collection of static analyses already performed on {@code task} with respect to {@code memoryModel}.
     *                Should at least include the following elements:
     *                <ul>
     *                    <li>{@link ExecutionAnalysis}
     *                    <li>{@link ReachingDefinitionsAnalysis}
     *                    <li>{@link AliasAnalysis}
     *                    <li>{@link WmmAnalysis}
     *                </ul>
     * @param config  User-defined options to further specify the behavior.
     */
    public static NativeRelationAnalysis fromConfig(VerificationTask task, Context context, Configuration config) throws InvalidConfigurationException {
        return new NativeRelationAnalysis(task, context, config);
    }

    @Override
    public Knowledge getKnowledge(Relation relation) {
        return knowledgeMap.get(relation);
    }

    @Override
    public EventGraph getContradictions() {
        //TODO return undirected pairs
        return mutex;
    }

    @Override
    public void collectDiscrepancies(Set<Relation> relations, Map<Relation, List<EventGraph>> discrepancies) {
        Propagator p = new Propagator();
        Initializer init = getInitializer();
        for (Relation r : relations) {
            final boolean mayInvisible = visibility.mayHaveInvisibleEvents(r);
            MutableEventGraph may = mayInvisible ? new IndexedEventGraph(allEvents.domain()) : newGraph();
            MutableEventGraph must = mayInvisible ? new IndexedEventGraph(allEvents.domain()) : newGraph();
            if (r.getDependencies().isEmpty()) {
                final Knowledge k = r.getDefinition().accept(init);
                may.addAll(k.getMaySet());
                must.addAll(k.getMustSet());
            } else {
                for (Relation c : r.getDependencies()) {
                    p.setSource(c);
                    p.setMay(getMutableKnowledge(p.getSource()).getMaySet());
                    p.setMust(getMutableKnowledge(p.getSource()).getMustSet());
                    Delta s = r.getDefinition().accept(p);
                    may.addAll(s.may);
                    must.addAll(s.must);
                }
            }
            // We can do a destructive update because we do not need <may> anymore
            may.removeAll(getKnowledge(r).getMaySet());
            MutableEventGraph mayDiff = may;
            MutableEventGraph mustDiff = MutableEventGraph.difference(getKnowledge(r).getMustSet(), must);
            discrepancies.computeIfAbsent(r, k -> new ArrayList<>()).add(MutableEventGraph.union(mayDiff, mustDiff));
        }
    }

    @Override
    public void run() {
        logger.trace("Start");
        initializeEventDomain();
        final Wmm memoryModel = task.getMemoryModel();
        final Map<Relation, List<Definition>> dependents = new HashMap<>();
        for (Relation r : memoryModel.getRelations()) {
            for (Relation d : r.getDependencies()) {
                dependents.computeIfAbsent(d, k -> new ArrayList<>()).add(r.getDefinition());
            }
        }
        // ------------------------------------------------
        final Initializer initializer = getInitializer();
        final Map<Relation, List<Delta>> qGlobal = new HashMap<>();
        for (Relation r : memoryModel.getRelations()) {
            MutableKnowledge k = r.getDefinition().accept(initializer);
            knowledgeMap.put(r, k);
            if (!k.getMaySet().isEmpty() || !k.getMustSet().isEmpty()) {
                qGlobal.computeIfAbsent(r, x -> new ArrayList<>(1))
                        .add(new Delta(k.getMaySet(), k.getMustSet()));
            }
        }
        // ------------------------------------------------
        final Propagator propagator = new Propagator();
        DependencyGraph.from(memoryModel.getRelations()).getSCCs().forEach(scc -> processSCC(propagator, scc, qGlobal, dependents));
        checkAfterRun(qGlobal);
        logger.trace("End");
    }

    protected MutableKnowledge getMutableKnowledge(Relation relation) {
        return knowledgeMap.get(relation);
    }

    protected void checkAfterRun(Map<Relation, List<Delta>> qGlobal) {
        verify(qGlobal.isEmpty(), "knowledge buildup propagated downwards");
    }

    protected void processSCC(Propagator propagator, Set<DependencyGraph<Relation>.Node> scc, Map<Relation, List<Delta>> qGlobal, Map<Relation, List<Definition>> dependents) {
        logger.trace("Regular analysis for component {}", scc);
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
            logger.trace("Regular knowledge update for '{}'", relation);

            //  A fix for https://github.com/hernanponcedeleon/Dat3M/issues/523
            //  In our current propagation approach, whenever a relation r gets updated,
            //  we compute for each dependent relation "r' = r op x" an update U(r, x, r') that needs to get applied.
            //  When r' gets processed, the update U(r, x, r') is applied as is to r'.
            //  However, depending on whether x is before or after r in the stratification, the computed update
            //  may be different. In particular, we compute updates to r' before all its dependencies were computed
            //  and thus our computation does not strictly follow the stratification.
            //  This does not matter if the update function U(r, x, r') is monotonic in r/x but if it is not,
            //  an early computed update may be too large!
            //  We fix this problem by reducing the potentially too large update U(r, x, r') before applying it to r'.
            // TODO: The necessity of the fix suggests that our propagation algorithm is flawed.
            //  We should reconsider our algorithm.
            final var ddd = qLocal.remove(relation);
            Delta toAdd = combine(ddd);
            if (relation.getDefinition() instanceof Difference difference) {
                // Our propagated update may be "too large" so we reduce it.
                MutableKnowledge k = knowledgeMap.get(difference.getSubtrahend());
                toAdd.may.removeAll(k.getMustSet());
                toAdd.must.removeAll(k.getMaySet());
            }

            Delta delta = joinSet(knowledgeMap.get(relation), toAdd);
            if (delta.may.isEmpty() && delta.must.isEmpty()) {
                continue;
            }

            propagator.setSource(relation);
            propagator.setMay(delta.may);
            propagator.setMust(delta.must);
            for (Definition c : dependents.getOrDefault(relation, List.of())) {
                logger.trace("Regular propagation from '{}' to '{}'", relation, c);
                Relation r = c.getDefinedRelation();
                Delta d = c.accept(propagator);
                (stratum.contains(r) ? qLocal : qGlobal)
                        .computeIfAbsent(r, k -> new ArrayList<>())
                        .add(d);
            }
        }
    }

    private Delta combine(List<Delta> deltas) {
        if (deltas.size() == 1) {
            return deltas.get(0);
        }
        final var mayDelta = new EventGraph[deltas.size()];
        final var mustDelta = new EventGraph[deltas.size()];
        for (int i = 0; i < deltas.size(); i++) {
            mayDelta[i] = deltas.get(i).may;
            mustDelta[i] = deltas.get(i).must;
        }
        return new Delta(MutableEventGraph.union(mayDelta), MutableEventGraph.union(mustDelta));
    }

    @Override
    public void runExtended() {
        logger.trace("Start");
        Wmm memoryModel = task.getMemoryModel();
        Map<Relation, List<Constraint>> dependents = new HashMap<>();
        Map<Relation, List<ExtendedDelta>> q = new LinkedHashMap<>();
        for (Constraint c : memoryModel.getConstraints()) {
            if (c instanceof Axiom axiom && axiom.isFlagged()) {
                continue;
            }
            for (Relation r : c.getConstrainedRelations()) {
                dependents.computeIfAbsent(r, k -> new ArrayList<>()).add(c);
            }
            for (Map.Entry<Relation, ExtendedDelta> e :
                    c.accept(new InitialKnowledgeCloser()).entrySet()) {
                q.computeIfAbsent(e.getKey(), k -> new ArrayList<>()).add(e.getValue());
            }
        }
        // repeat until convergence
        while (!q.isEmpty()) {
            Relation relation = q.keySet().iterator().next();
            logger.trace("Extended knowledge update for '{}'", relation);
            MutableKnowledge knowledge = knowledgeMap.get(relation);
            ExtendedDelta delta = join(knowledge, q.remove(relation));
            if (delta.disabled.isEmpty() && delta.enabled.isEmpty()) {
                continue;
            }
            mutex.addAll(MutableEventGraph.difference(delta.enabled, knowledge.getMaySet()));
            mutex.addAll(MutableEventGraph.intersection(delta.disabled, knowledge.getMustSet()));
            for (Constraint c : dependents.getOrDefault(relation, List.of())) {
                logger.trace("Extended propagation from '{}' to '{}'", relation, c);
                for (Map.Entry<Relation, ExtendedDelta> e :
                        c.accept(new IncrementalKnowledgeCloser(relation, delta.enabled)).entrySet()) {
                    q.computeIfAbsent(e.getKey(), k -> new ArrayList<>()).add(e.getValue());
                }
                if (!(c instanceof Definition)) {
                    continue;
                }
                for (Map.Entry<Relation, ExtendedDelta> e :
                        c.accept(new ExtendedPropagator(relation, delta.disabled, delta.enabled)).entrySet()) {
                    q.computeIfAbsent(e.getKey(), k -> new ArrayList<>()).add(e.getValue());
                }
            }
        }
        logger.trace("End");
    }

    protected Initializer getInitializer() {
        return new Initializer();
    }

    private Delta joinSet(MutableKnowledge k, Delta d) {
        return new Delta(addAllAndDiff(k.getMaySet(), d.may), addAllAndDiff(k.getMustSet(), d.must));
    }

    private MutableEventGraph addAllAndDiff(MutableEventGraph graph, EventGraph delta) {
        // NOTE optimization due to initial deltas carrying references to knowledge sets
        if (graph.isEmpty()) {
            graph.addAll(delta);
            return graph;
        } else if (delta == graph) {
            return graph;
        }
        final MutableEventGraph diff = newGraphWithDomain(delta);
        diff.addAll(delta);
        diff.removeAll(graph);
        graph.addAll(diff);
        return diff;
    }

    private ExtendedDelta join(MutableKnowledge k, List<ExtendedDelta> l) {
        verify(!l.isEmpty(), "empty update in extended analysis");
        MutableEventGraph may = k.getMaySet();
        MutableEventGraph must = k.getMustSet();
        MutableEventGraph disableSet = newGraph();
        MutableEventGraph enableSet = newGraph();
        l.stream().map(d -> d.disabled).map(this::newGraph).forEach(e -> e.filter(may::remove).apply(disableSet::add));
        l.stream().map(d -> d.enabled).map(this::newGraph).forEach(e -> e.filter(must::add).apply(enableSet::add));
        return new ExtendedDelta(disableSet, enableSet);
    }

    private Set<Event> newSet() {
        return new IndexedSet<>(allVisibleEvents.domain());
    }

    private Set<Event> newSet(Collection<Event> copy) {
        if (copy instanceof IndexedSet<Event> c) {
            final var set = new IndexedSet<>(c.domain());
            set.addAll(c);
            return set;
        }
        return new HashSet<>(copy);
    }

    private MutableEventGraph newGraph() {
        return new IndexedEventGraph(allVisibleEvents.domain());
    }

    private MutableEventGraph newGraph(EventGraph other) {
        return MutableEventGraph.from(other);
    }

    private MutableEventGraph newGraphWithDomain(EventGraph other) {
        return new IndexedEventGraph(((IndexedEventGraph) other).eventDomain());
    }

    private void initializeEventDomain() {
        for (Thread thread : task.getProgram().getThreads()) {
            final Set<Event> events = new IndexedSet<>(exec.eventDomain());
            events.addAll(thread.getEvents());
            allEvents.addAll(events);
            final Set<Event> visibleEvents = newSet(thread.getEventsWithAllTags(VISIBLE));
            threadVisibleEvents.put(thread, visibleEvents);
            allVisibleEvents.addAll(visibleEvents);
        }
    }

    private void retainImplyWith(Set<Event> set, Event implied, Event with) {
        final Set<Event> impliesImplied = execImplying(implied);
        if (!impliesImplied.contains(with)) {
            set.retainAll(impliesImplied);
        }
    }

    private final class InitialKnowledgeCloser implements Constraint.Visitor<Map<Relation, ExtendedDelta>> {

        private InitialKnowledgeCloser() {}

        @Override
        public Map<Relation, ExtendedDelta> visitConstraint(Constraint constraint) {
            return Map.of();
        }

        @Override
        public Map<Relation, ExtendedDelta> visitEmptiness(Emptiness axiom) {
            if (axiom.isNegated() || axiom.isFlagged()) {
                return Map.of();
            }
            Relation rel = axiom.getRelation();
            return Map.of(rel, new ExtendedDelta(knowledgeMap.get(rel).getMaySet(), newGraph()));
        }

        @Override
        public Map<Relation, ExtendedDelta> visitIrreflexivity(Irreflexivity axiom) {
            if (axiom.isNegated() || axiom.isFlagged()) {
                return Map.of();
            }
            Relation rel = axiom.getRelation();
            MutableKnowledge k = knowledgeMap.get(rel);
            MutableEventGraph d = k.getMaySet().filter(Tuple::isLoop);
            return Map.of(rel, new ExtendedDelta(d, newGraph()));
        }

        @Override
        public Map<Relation, ExtendedDelta> visitAcyclicity(Acyclicity axiom) {
            if (axiom.isNegated() || axiom.isFlagged()) {
                return Map.of();
            }
            long t0 = System.currentTimeMillis();
            Relation rel = axiom.getRelation();
            MutableKnowledge knowledge = knowledgeMap.get(rel);
            EventGraph may = knowledge.getMaySet();
            EventGraph must = knowledge.getMustSet();
            MutableEventGraph newDisabled = newGraph();
            may.filter((e1, e2) -> Tuple.isLoop(e1, e2) || must.contains(e2, e1)).apply(newDisabled::add);
            Map<Event, Set<Event>> mustOut = new HashMap<>();
            must.filter((e1, e2) -> !Tuple.isLoop(e1, e2)).apply((e1, e2) -> mustOut.computeIfAbsent(e1, x -> newSet()).add(e2));
            EventGraph current = knowledge.getMustSet();
            do {
                MutableEventGraph next = newGraph();
                for (Event e : current.getDomain()) {
                    if (current.getRange(e).contains(e)) {
                        final Set<Event> range = newSet(mustOut.getOrDefault(e, Set.of()));
                        range.removeAll(execExcluding(e));
                        range.removeIf(z -> !newDisabled.add(z, e));
                        next.addRange(e, range);
                    }
                }
                current = next;
            } while (!current.isEmpty());
            newDisabled.retainAll(knowledge.getMaySet());
            logger.debug("disabled {} edges in {}ms", newDisabled.size(), System.currentTimeMillis() - t0);
            return Map.of(rel, new ExtendedDelta(newDisabled, newGraph()));
        }

        @Override
        public Map<Relation, ExtendedDelta> visitAssumption(Assumption assume) {
            Relation rel = assume.getRelation();
            MutableKnowledge k = knowledgeMap.get(rel);
            MutableEventGraph d = MutableEventGraph.difference(k.getMaySet(), assume.getMaySet());
            MutableEventGraph e = MutableEventGraph.difference(assume.getMustSet(), k.getMustSet());
            if (d.size() + e.size() != 0) {
                logger.info("Assumption disables {} and enables {} at {}", d.size(), e.size(), rel.getNameOrTerm());
            }
            return Map.of(rel, new ExtendedDelta(d, e));
        }
    }

    private final class IncrementalKnowledgeCloser implements Constraint.Visitor<Map<Relation, ExtendedDelta>> {
        private final Relation changed;
        private final EventGraph enabled;

        private IncrementalKnowledgeCloser(Relation changed, EventGraph enabled) {
            this.changed = changed;
            this.enabled = enabled;
        }

        @Override
        public Map<Relation, ExtendedDelta> visitConstraint(Constraint constraint) {
            return Map.of();
        }

        @Override
        public Map<Relation, ExtendedDelta> visitAcyclicity(Acyclicity axiom) {
            Relation rel = axiom.getRelation();
            checkArgument(changed == rel,
                    "misdirected knowledge propagation from relation %s to %s", changed, this);
            long t0 = System.currentTimeMillis();
            MutableKnowledge knowledge = knowledgeMap.get(rel);
            EventGraph may = knowledge.getMaySet();
            MutableEventGraph newDisabled = newGraph();
            enabled.filter((e1, e2) -> may.contains(e2, e1)).apply((e1, e2) -> newDisabled.add(e2, e1));
            Map<Event, Set<Event>> mustIn = new HashMap<>();
            Map<Event, Set<Event>> mustOut = new HashMap<>();
            knowledge.getMustSet().filter((e1, e2) -> !Tuple.isLoop(e1, e2)).apply((e1, e2) -> {
                mustIn.computeIfAbsent(e2, x -> newSet()).add(e1);
                mustOut.computeIfAbsent(e1, x -> newSet()).add(e2);
            });

            EventGraph current = enabled;
            do {
                MutableEventGraph next = newGraph();
                current.filter((x, y) -> !Tuple.isLoop(x, y)).apply((x, y) -> {
                    final Set<Event> nextY = newSet(mustIn.getOrDefault(x, Set.of()));
                    retainImplyWith(nextY, x, y);
                    nextY.removeAll(execExcluding(y));
                    nextY.removeIf(w -> !newDisabled.add(y, w));
                    nextY.forEach(w -> next.add(w, y));
                    final Set<Event> nextX = newSet(mustOut.getOrDefault(y, Set.of()));
                    retainImplyWith(nextX, y, x);
                    nextX.removeAll(execExcluding(x));
                    nextX.removeIf(z -> !newDisabled.add(z, x));
                    next.addRange(x, nextX);
                });
                current = next;
            } while (!current.isEmpty());
            newDisabled.retainAll(knowledge.getMaySet());
            logger.debug("Disabled {} edges in {}ms", newDisabled.size(), System.currentTimeMillis() - t0);
            return Map.of(rel, new ExtendedDelta(newDisabled, newGraph()));
        }
    }

    protected class Initializer implements Definition.Visitor<MutableKnowledge> {
        final Program program = task.getProgram();

        @Override
        public MutableKnowledge visitDefinition(Definition def) {
            if (visibility.mayHaveInvisibleEvents(def.getDefinedRelation())) {
                return new MutableKnowledge(new IndexedEventGraph(allEvents.domain()), new IndexedEventGraph(allEvents.domain()));
            }
            return new MutableKnowledge(newGraph(), newGraph());
        }

        @Override
        public MutableKnowledge visitFree(Free def) {
            MutableEventGraph must = newGraph();
            MutableEventGraph may = newGraph();

            final Set<Event> full = newSet(allVisibleEvents);
            for (Event e1 : full) {
                if (def.getDefinedRelation().isSet()) {
                    may.add(e1, e1);
                } else {
                    may.addRange(e1, full);
                }
            }

            return new MutableKnowledge(may, must);
        }

        @Override
        public MutableKnowledge visitExternal(External ext) {
            MutableEventGraph must = newGraph();
            List<Thread> threads = program.getThreads();
            for (Thread thread : threads) {
                Set<Event> thisThread = threadVisibleEvents.get(thread);
                Set<Event> otherThread = newSet(allVisibleEvents);
                otherThread.removeAll(thisThread);
                // No test for `execMutuallyExclusive`, since that currently does not span across threads
                for (Event e1 : thisThread) {
                    must.addRange(e1, otherThread);
                }
            }
            return new MutableKnowledge(must, newGraph(must));
        }

        @Override
        public MutableKnowledge visitInternal(Internal internal) {
            MutableEventGraph must = newGraph();
            for (Thread t : program.getThreads()) {
                Set<Event> events = threadVisibleEvents.get(t);
                for (Event e1 : events) {
                    final Set<Event> e1Mutex = execExcluding(e1);
                    final Set<Event> rangeEvents = events.stream()
                            .filter(e2 -> !e1Mutex.contains(e2))
                            .collect(toSet());
                    must.addRange(e1, rangeEvents);
                }
            }
            return new MutableKnowledge(must, newGraph(must));
        }

        @Override
        public MutableKnowledge visitTagSet(TagSet tagSet) {
            final MutableEventGraph must = newGraph();
            program.getThreadEventsWithAllTags(tagSet.getTag()).forEach(e -> must.add(e, e));
            return new MutableKnowledge(must, newGraph(must));
        }

        @Override
        public MutableKnowledge visitProgramOrder(ProgramOrder po) {
            final Filter type = po.getFilter();
            MutableEventGraph must = newGraph();
            for (Thread t : program.getThreads()) {
                final List<Event> events = t.getEvents().stream().filter(type::apply).toList();
                final Set<Event> remainingEvents = newSet(events);
                for (final Event e1 : events) {
                    remainingEvents.remove(e1);
                    final Set<Event> range = newSet(remainingEvents);
                    range.removeAll(execExcluding(e1));
                    must.addRange(e1, range);
                }
                // Events of the same instruction are not program-ordered
                for (InstructionBoundary end : t.getEvents(InstructionBoundary.class)) {
                    List<Event> transactionEvents = end.getInstructionEvents().stream().filter(type::apply).toList();
                    for (int i = 0; i < transactionEvents.size(); i++) {
                        Event e2 = transactionEvents.get(i);
                        for (Event e1 : transactionEvents.subList(0, i)) {
                            must.remove(e1, e2);
                        }
                    }
                }
            }
            return new MutableKnowledge(must, newGraph(must));
        }

        @Override
        public MutableKnowledge visitControlDependency(DirectControlDependency ctrlDep) {
            //TODO: We can restrict the codomain to visible events as the only usage of this Relation is in
            // ctrl := idd^+;ctrlDirect & (R*V)
            MutableEventGraph must = new IndexedEventGraph(allEvents.domain());
            for (Thread thread : program.getThreads()) {
                final Set<Event> events = threadVisibleEvents.get(thread);
                for (CondJump jump : thread.getEvents(CondJump.class)) {
                    if (jump.isGoto() || jump.isDead()) {
                        continue; // There is no point in ctrl-edges from unconditional jumps.
                    }

                    final List<Event> ctrlDependentEvents;
                    if (jump instanceof IfAsJump ifJump) {
                        // Ctrl dependencies of Ifs (under Linux) only extend up until the merge point of both
                        // branches.
                        ctrlDependentEvents = ifJump.getBranchesEvents();
                    } else {
                        // Regular jumps give dependencies to all successors.
                        ctrlDependentEvents = jump.getSuccessor().getSuccessors();
                    }

                    ctrlDependentEvents.stream()
                            .filter(e -> !exec.areMutuallyExclusive(jump, e))
                            .forEach(e -> must.add(jump, e));
                }
            }
            return new MutableKnowledge(must, newGraph(must));
        }

        @Override
        public MutableKnowledge visitAddressDependency(DirectAddressDependency addrDep) {
            return computeInternalDependencies(EnumSet.of(ADDR));
        }

        @Override
        public MutableKnowledge visitInternalDataDependency(DirectDataDependency idd) {
            // FIXME: Our "internal data dependency" relation is quite odd an contains all but address dependencies.
            return computeInternalDependencies(EnumSet.of(DATA, CTRL, OTHER));
        }

        @Override
        public MutableKnowledge visitCASDependency(CASDependency casDep) {
            MutableEventGraph must = newGraph();
            for (Event e : program.getThreadEvents()) {
                if (e.hasTag(IMM.CASDEPORIGIN)) {
                    // The target of a CASDep is always the successor of the origin
                    must.add(e, e.getSuccessor());
                }
            }
            return new MutableKnowledge(must, newGraph(must));
        }

        @Override
        public MutableKnowledge visitSameInstruction(SameInstruction si) {
            MutableEventGraph must = newGraph();
            for (InstructionBoundary end : program.getThreadEvents(InstructionBoundary.class)) {
                List<Event> events = end.getInstructionEvents().stream().filter(e -> e.hasTag(VISIBLE)).toList();
                for (int i = 0; i < events.size(); i++) {
                    Event e2 = events.get(i);
                    for (Event e1 : events.subList(0, i)) {
                        must.add(e1, e2);
                        must.add(e2, e1);
                    }
                }
            }
            for (Event e : program.getThreadEventsWithAllTags(VISIBLE)) {
                must.add(e, e);
            }
            return new MutableKnowledge(must, newGraph(must));
        }

        @Override
        public MutableKnowledge visitLinuxCriticalSections(LinuxCriticalSections rscs) {
            MutableEventGraph may = newGraph();
            MutableEventGraph must = newGraph();
            //assume locks and unlocks are distinct
            Map<Event, Set<Event>> mayMap = new HashMap<>();
            Map<Event, Set<Event>> mustMap = new HashMap<>();
            for (Thread thread : program.getThreads()) {
                List<Event> locks = reverse(thread.getEvents().stream().filter(e -> e.hasTag(Linux.RCU_LOCK)).collect(toList()));
                for (Event unlock : thread.getEvents()) {
                    if (!unlock.hasTag(Linux.RCU_UNLOCK)) {
                        continue;
                    }
                    final Set<Event> unlockMutex = execExcluding(unlock);
                    // iteration order assures that all intermediaries were already iterated
                    for (Event lock : locks) {
                        if (unlock.getGlobalId() < lock.getGlobalId() ||
                                unlockMutex.contains(lock) ||
                                Stream.concat(mustMap.getOrDefault(lock, Set.of()).stream(),
                                                mustMap.getOrDefault(unlock, Set.of()).stream())
                                        .anyMatch(e -> exec.isImplied(lock, e) || exec.isImplied(unlock, e))) {
                            continue;
                        }
                        final Set<Event> lockMutex = execExcluding(lock);
                        boolean noIntermediary =
                                lockMutex.containsAll(mayMap.getOrDefault(unlock, Set.of())) &&
                                        unlockMutex.containsAll(mayMap.getOrDefault(lock, Set.of()));
                        may.add(lock, unlock);
                        mayMap.computeIfAbsent(lock, x -> new HashSet<>()).add(unlock);
                        mayMap.computeIfAbsent(unlock, x -> new HashSet<>()).add(lock);
                        if (noIntermediary) {
                            must.add(lock, unlock);
                            mustMap.computeIfAbsent(lock, x -> new HashSet<>()).add(unlock);
                            mustMap.computeIfAbsent(unlock, x -> new HashSet<>()).add(lock);
                        }
                    }
                }
            }
            return new MutableKnowledge(may, must);
        }

        @Override
        public MutableKnowledge visitAMOPairs(AMOPairs amo) {
            // ----- Compute must set -----
            MutableEventGraph must = newGraph();
            // RMWLoad -> RMWStore
            for (RMWStore store : program.getThreadEvents(RMWStore.class)) {
                must.add(store.getLoadEvent(), store);
            }
            // Atomics blocks: BeginAtomic -> EndAtomic
            for (EndAtomic end : program.getThreadEvents(EndAtomic.class)) {
                List<Event> block = end.getBlock().stream().filter(x -> x.hasTag(VISIBLE)).toList();
                for (int i = 0; i < block.size(); i++) {
                    final Event e = block.get(i);
                    final Set<Event> eMutex = execExcluding(e);
                    for (int j = i + 1; j < block.size(); j++) {
                        if (!eMutex.contains(block.get(j))) {
                            must.add(e, block.get(j));
                        }
                    }
                }
            }
            return new MutableKnowledge(must, newGraph(must));
        }

        @Override
        public MutableKnowledge visitLXSXPairs(LXSXPairs lxsx) {
            final MutableEventGraph must = newGraph();
            final MutableEventGraph may = newGraph();
            // LoadExcl -> StoreExcl
            for (Thread thread : program.getThreads()) {
                // Currently likely empty, because mixed-size accesses are the only cause
                var transactionMap = new HashMap<Event, List<Event>>();
                for (InstructionBoundary end : thread.getEvents(InstructionBoundary.class)) {
                    List<Event> transaction = end.getInstructionEvents();
                    for (Event event : transaction) {
                        if (event.hasTag(EXCL)) {
                            transactionMap.put(event, transaction);
                        }
                    }
                }
                List<Event> events = thread.getEvents().stream().filter(e -> e.hasTag(EXCL)).toList();
                // assume order by globalId
                // assume globalId describes a topological sorting over the control flow
                for (int end = 1; end < events.size(); end++) {
                    if (!(events.get(end) instanceof RMWStoreExclusive store)) {
                        continue;
                    }
                    final List<Event> stores = transactionMap.getOrDefault(store, List.of(store));
                    // If Tearing was performed, only iterate the last load and the first store of an instruction.
                    if (!stores.get(0).equals(store)) {
                        continue;
                    }
                    final boolean requiresMatchingAddresses = store.doesRequireMatchingAddresses();
                    final int start = iterate(end - 1, i -> i >= 0, i -> i - 1)
                            .filter(i -> exec.isImplied(store, events.get(i)))
                            .findFirst().orElse(0);
                    final Set<Event> storeMutex = execExcluding(store);
                    final List<Event> candidates = events.subList(start, end).stream()
                            .filter(e -> !storeMutex.contains(e))
                            .toList();
                    final int size = candidates.size();
                    for (int i = 0; i < size; i++) {
                        final Event load = candidates.get(i);
                        final List<Event> intermediaries = candidates.subList(i + 1, size);
                        if (!(load instanceof Load) || intermediaries.stream().anyMatch(e -> exec.isImplied(load, e))) {
                            continue;
                        }
                        final List<Event> loads = transactionMap.getOrDefault(load, List.of(load));
                        // Only match with the last load of an instruction.
                        if (loads.get(loads.size() - 1).equals(load)) {
                            final Set<Event> loadMutex = execExcluding(load);
                            final boolean noIntermediaries = loadMutex.containsAll(intermediaries);
                            addLXSX(may, must, loads, stores, noIntermediaries, requiresMatchingAddresses);
                        }
                    }
                }
            }
            return new MutableKnowledge(may, must);
        }

        private void addLXSX(MutableEventGraph may, MutableEventGraph must, List<Event> loads, List<Event> stores,
                boolean noIntermediaries, boolean requiresMatchingAddresses) {
            final boolean sameType = sameType(loads, stores);
            for (int i = 0; i < loads.size(); i++) {
                final MemoryCoreEvent ld = (MemoryCoreEvent) loads.get(i);
                final MemoryCoreEvent st = (MemoryCoreEvent) stores.get(i);
                if (sameType && requiresMatchingAddresses) {
                    may.add(ld, st);
                } else {
                    // In worst case, compute the complete bipartite graph between both transactions.
                    may.addRange(ld, Set.copyOf(stores));
                }
                if (noIntermediaries && sameType && (requiresMatchingAddresses || alias.mustAlias(ld, st))) {
                    must.add(ld, st);
                }
            }
        }

        private boolean sameType(List<Event> loads, List<Event> stores) {
            if (loads.size() != stores.size()) {
                return false;
            }
            for (int i = 0; i < loads.size(); i++) {
                if (loads.get(i) instanceof MemoryCoreEvent ld && stores.get(i) instanceof MemoryCoreEvent st &&
                        ld.getAccessType().equals(st.getAccessType())) {
                    return false;
                }
            }
            return true;
        }

        @Override
        public MutableKnowledge visitCoherence(Coherence co) {
            logger.trace("Computing knowledge about memory order");
            List<Store> allWrites = program.getThreadEvents(Store.class);
            List<Store> nonInitWrites = program.getThreadEvents(Store.class);
            nonInitWrites.removeIf(Init.class::isInstance);
            MutableEventGraph may = newGraph();
            for (Store w1 : program.getThreadEvents(Store.class)) {
                // It is possible to have multiple initial writes
                // to the same memory location via different virtual memory aliases
                final List<Store> writes = w1 instanceof Init ? allWrites : nonInitWrites;
                final Set<Event> w1Mutex = execExcluding(w1);
                for (Store w2 : writes) {
                    if (w1.getGlobalId() != w2.getGlobalId() && !w1Mutex.contains(w2) && alias.mayAlias(w1, w2)) {
                        may.add(w1, w2);
                    }
                }
            }
            MutableEventGraph must = newGraph();
            may.apply((e1, e2) -> {
                MemoryCoreEvent w1 = (MemoryCoreEvent) e1;
                MemoryCoreEvent w2 = (MemoryCoreEvent) e2;
                if (!w2.hasTag(INIT) && alias.mustAlias(w1, w2) && w1.hasTag(INIT)) {
                    must.add(w1, w2);
                }
            });
            if (wmmAnalysis.isLocallyConsistent()) {
                may.removeIf(Tuple::isBackward);
                may.apply((e1, e2) -> {
                    MemoryCoreEvent w1 = (MemoryCoreEvent) e1;
                    MemoryCoreEvent w2 = (MemoryCoreEvent) e2;
                    if (alias.mustAlias(w1, w2) && Tuple.isForward(e1, e2)) {
                        must.add(w1, w2);
                    }
                });
            }

            logger.debug("Initial may set size for memory order: {}", may.size());
            return new MutableKnowledge(may, must);
        }

        @Override
        public MutableKnowledge visitReadFrom(ReadFrom rf) {
            logger.trace("Computing knowledge about read-from");
            final BranchEquivalence eq = analysisContext.requires(BranchEquivalence.class);
            MutableEventGraph may = newGraph();
            MutableEventGraph must = newGraph();
            List<Load> loadEvents = program.getThreadEvents(Load.class);
            for (Store e1 : program.getThreadEvents(Store.class)) {
                final Set<Event> e1Mutex = execExcluding(e1);
                for (Load e2 : loadEvents) {
                    if (alias.mayAlias(e1, e2) && !e1Mutex.contains(e2)) {
                        may.add(e1, e2);
                    }
                }
            }

            // Here we add must-rf edges between loads/stores that synchronize threads.
            for (Thread thread : program.getThreads()) {
                List<MemoryCoreEvent> spawned = thread.getSpawningEvents();
                if (spawned.size() == 2) {
                    MemoryCoreEvent startLoad = spawned.get(0);
                    MemoryCoreEvent startStore = spawned.get(1);
                    must.add(startStore, startLoad);
                    if (eq.isImplied(startLoad, startStore)) {
                        may.removeIf((e1, e2) -> e2 == startLoad && e1 != startStore);
                    }
                }
            }

            if (wmmAnalysis.isLocallyConsistent()) {
                // Remove future reads
                may.removeIf(Tuple::isBackward);
                // Remove past reads
                MutableEventGraph deletedEdges = newGraph();
                Map<Event, List<Event>> writesByRead = new HashMap<>();
                may.apply((e1, e2) -> writesByRead.computeIfAbsent(e2, x -> new ArrayList<>()).add(e1));
                for (Load read : program.getThreadEvents(Load.class)) {
                    // The set of same-thread writes as well as init writes that could be read from (all before the read)
                    // sorted by order (init events first)
                    List<MemoryCoreEvent> possibleWrites = writesByRead.getOrDefault(read, List.of()).stream()
                            .filter(e -> (e.getThread() == read.getThread() || e.hasTag(INIT)))
                            .map(x -> (MemoryCoreEvent) x)
                            .sorted((o1, o2) -> o1.hasTag(INIT) == o2.hasTag(INIT) ? (o1.getGlobalId() - o2.getGlobalId()) : o1.hasTag(INIT) ? -1 : 1)
                            .toList();
                    // The set of writes that won't be readable due getting overwritten.
                    Set<MemoryCoreEvent> deletedWrites = new HashSet<>();
                    // A rf-edge (w1, r) is impossible, if there exists a write w2 such that
                    // - w2 is exec-implied by w1 or r (i.e. cf-implied + w2.cfImpliesExec)
                    // - w2 must alias with either w1 or r.
                    for (int i = 0; i < possibleWrites.size(); i++) {
                        MemoryCoreEvent w1 = possibleWrites.get(i);
                        for (MemoryCoreEvent w2 : possibleWrites.subList(i + 1, possibleWrites.size())) {
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
                        deletedEdges.add(w, read);
                    }
                }
                may.removeAll(deletedEdges);
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
                for (EndAtomic endAtomic : program.getThreadEvents(EndAtomic.class)) {
                    // Collect memEvents of the atomic block
                    List<Store> writes = new ArrayList<>();
                    List<Load> reads = new ArrayList<>();
                    for (Event b : endAtomic.getBlock()) {
                        if (b instanceof Load load) {
                            reads.add(load);
                        } else if (b instanceof Store store) {
                            writes.add(store);
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
                            may.removeIf((e1, e2) -> e2 == r && Tuple.isCrossThread(e1, e2));
                        }
                    }
                }
                logger.debug("Atomic block optimization eliminated {} reads", sizeBefore - may.size());
            }

            logger.debug("Initial may set size for read-from: {}", may.size());
            return new MutableKnowledge(may, must);
        }

        @Override
        public MutableKnowledge visitSameLocation(SameLocation loc) {
            MutableEventGraph may = newGraph();
            List<MemoryCoreEvent> events = program.getThreadEvents(MemoryCoreEvent.class);
            for (MemoryCoreEvent e1 : events) {
                final Set<Event> e1Mutex = execExcluding(e1);
                for (MemoryCoreEvent e2 : events) {
                    if (alias.mayAlias(e1, e2) && !e1Mutex.contains(e2)) {
                        may.add(e1, e2);
                    }
                }
            }
            MutableEventGraph must = newGraph();
            may.apply((e1, e2) -> {
                if (alias.mustAlias((MemoryCoreEvent) e1, (MemoryCoreEvent) e2)) {
                    must.add(e1, e2);
                }
            });
            return new MutableKnowledge(may, must);
        }

        private MutableKnowledge computeInternalDependencies(Set<UsageType> usageTypes) {
            MutableEventGraph may = new IndexedEventGraph(allEvents.domain());
            MutableEventGraph must = new IndexedEventGraph(allEvents.domain());

            for (RegReader regReader : program.getThreadEvents(RegReader.class)) {
                final ReachingDefinitionsAnalysis.Writers state = definitions.getWriters(regReader);
                for (Register.Read regRead : regReader.getRegisterReads()) {
                    if (!usageTypes.contains(regRead.usageType())) {
                        continue;
                    }
                    final var reachDef = state.ofRegister(regRead.register());
                    for (Event regWriter : reachDef.getMayWriters()) {
                        may.add(regWriter, regReader);
                    }
                    for (Event regWriter : reachDef.getMustWriters()) {
                        must.add(regWriter, regReader);
                    }
                }
            }

            // We need to track ExecutionStatus events separately, because they induce data-dependencies
            // without reading from a register.
            if (usageTypes.contains(DATA)) {
                for (ExecutionStatus execStatus : program.getThreadEvents(ExecutionStatus.class)) {
                    if (execStatus.doesTrackDep()) {
                        may.add(execStatus.getStatusEvent(), execStatus);
                        must.add(execStatus.getStatusEvent(), execStatus);
                    }
                }
            }

            return new MutableKnowledge(may, must);
        }

        @Override
        public MutableKnowledge visitSameScope(SameScope sc) {
            final String specificScope = sc.getSpecificScope();
            MutableEventGraph must = newGraph();
            List<Event> events = program.getThreadEvents().stream()
                    .filter(e -> e.hasTag(VISIBLE) && e.getThread().hasScope())
                    .toList();
            for (Event e1 : events) {
                final Set<Event> e1Mutex = execExcluding(e1);
                for (Event e2 : events) {
                    if (e1Mutex.contains(e2)) {
                        continue;
                    }
                    Thread thread1 = e1.getThread();
                    Thread thread2 = e2.getThread();
                    if (specificScope != null) {
                        if (thread1.getScopeHierarchy().canSyncAtScope(thread2.getScopeHierarchy(), specificScope)) {
                            must.add(e1, e2);
                        }
                    } else {
                        String scope1 = Tag.getScopeTag(e1, program.getArch());
                        String scope2 = Tag.getScopeTag(e2, program.getArch());
                        if (!scope1.isEmpty() && !scope2.isEmpty() && thread1.getScopeHierarchy().canSyncAtScope(thread2.getScopeHierarchy(), scope1)
                                && thread2.getScopeHierarchy().canSyncAtScope(thread1.getScopeHierarchy(), scope2)) {
                            must.add(e1, e2);
                        }
                    }
                }
            }
            return new MutableKnowledge(must, newGraph(must));
        }

        @Override
        public MutableKnowledge visitSyncBarrier(SyncBar syncBar) {
            MutableEventGraph must = newGraph();
            List<ControlBarrier> barriers = program.getThreadEvents(ControlBarrier.class).stream()
                    .filter(e -> !(e instanceof NamedBarrier))
                    .toList();
            for (ControlBarrier e1 : barriers) {
                String id = e1.getInstanceId();
                String scope = e1.getExecScope();
                ScopeHierarchy hierarchy = e1.getThread().getScopeHierarchy();
                final Set<Event> e1Mutex = execExcluding(e1);
                barriers.stream()
                        .filter(e2 -> id.equals(e2.getInstanceId()))
                        .filter(e2 -> hierarchy.canSyncAtScope(e2.getThread().getScopeHierarchy(), scope))
                        .filter(e2 -> !e1Mutex.contains(e2))
                        .filter(e2 -> !e2.hasTag(PTX.ARRIVE))
                        .forEach(e2 -> must.add(e1, e2));
            }

            MutableEventGraph may = newGraph(must);
            List<NamedBarrier> namedBarriers = program.getThreadEvents(NamedBarrier.class);
            for (NamedBarrier e1 : namedBarriers) {
                String id = e1.getInstanceId();
                String scope = e1.getExecScope();
                ScopeHierarchy hierarchy = e1.getThread().getScopeHierarchy();
                final Set<Event> e1Mutex = execExcluding(e1);
                namedBarriers.stream()
                        .filter(e2 -> id.equals(e2.getInstanceId()))
                        .filter(e2 -> hierarchy.canSyncAtScope(e2.getThread().getScopeHierarchy(), scope))
                        .filter(e2 -> !e1Mutex.contains(e2))
                        .filter(e2 -> !e2.hasTag(PTX.ARRIVE))
                        .forEach(e2 -> {
                            if (e1.getResourceId().equals(e2.getResourceId())) {
                                may.add(e1, e2);
                                if (e1.getQuorum() == null) {
                                    must.add(e1, e2);
                                }
                            } else if (!(e1.getResourceId() instanceof IntLiteral) || !(e2.getResourceId() instanceof IntLiteral)) {
                                may.add(e1, e2);
                            }
                        });
            }
            return new MutableKnowledge(may, must);
        }

        @Override
        public MutableKnowledge visitSyncFence(SyncFence syncFence) {
            MutableEventGraph may = newGraph();
            MutableEventGraph must = newGraph();
            List<Event> fenceEventsSC = program.getThreadEventsWithAllTags(VISIBLE, FENCE, Tag.PTX.SC);
            for (Event e1 : fenceEventsSC) {
                final Set<Event> e1Mutex = execExcluding(e1);
                for (Event e2 : fenceEventsSC) {
                    if (!e1Mutex.contains(e2)) {
                        may.add(e1, e2);
                    }
                }
            }
            return new MutableKnowledge(may, must);
        }

        @Override
        public MutableKnowledge visitSameVirtualLocation(SameVirtualLocation vloc) {
            MutableEventGraph must = newGraph();
            MutableEventGraph may = newGraph();
            Map<MemoryCoreEvent, VirtualMemoryObject> map = computeVirtualAddressMap();
            map.forEach((e1, a1) -> {
                final Set<Event> e1Mutex = execExcluding(e1);
                map.forEach((e2, a2) -> {
                    if (a1.equals(a2) && !e1Mutex.contains(e2)) {
                        if (alias.mustAlias(e1, e2)) {
                            must.add(e1, e2);
                        }
                        if (alias.mayAlias(e1, e2)) {
                            may.add(e1, e2);
                        }
                    }
                });
            });
            return new MutableKnowledge(may, must);
        }

        private Map<MemoryCoreEvent, VirtualMemoryObject> computeVirtualAddressMap() {
            Map<MemoryCoreEvent, VirtualMemoryObject> map = new HashMap<>();
            program.getThreadEvents(MemoryCoreEvent.class).forEach(e -> {
                Set<VirtualMemoryObject> s = e.getAddress().getMemoryObjects().stream()
                        .filter(VirtualMemoryObject.class::isInstance)
                        .map(o -> (VirtualMemoryObject) o)
                        .collect(Collectors.toSet());
                if (s.size() > 1) {
                    throw new UnsupportedOperationException(
                            "Expressions with multiple virtual addresses are not supported");
                }
                if (!s.isEmpty()) {
                    VirtualMemoryObject a = s.stream().findFirst().orElseThrow().getGenericAddress();
                    map.put(e, a);
                }
            });
            return map;
        }

        @Override
        public MutableKnowledge visitSyncWith(SyncWith syncWith) {
            MutableEventGraph must = newGraph();
            List<Event> events = new ArrayList<>(program.getThreadEventsWithAllTags(VISIBLE));
            events.removeIf(Init.class::isInstance);
            for (Event e1 : events) {
                final Set<Event> e1Mutex = execExcluding(e1);
                for (Event e2 : events) {
                    Thread thread1 = e1.getThread();
                    Thread thread2 = e2.getThread();
                    if (thread1 == thread2 || !thread1.hasSyncSet()) {
                        continue;
                    }
                    if (thread1.getSyncSet().contains(thread2) && !e1Mutex.contains(e2)) {
                        must.add(e1, e2);
                    }
                }
            }
            return new MutableKnowledge(must, newGraph(must));
        }
    }

    private final class ExtendedPropagator implements Definition.Visitor<Map<Relation, ExtendedDelta>> {
        Relation origin;
        MutableEventGraph disabled;
        MutableEventGraph enabled;

        private ExtendedPropagator(Relation r, MutableEventGraph d, MutableEventGraph e) {
            origin = r;
            disabled = d;
            enabled = e;
        }

        @Override
        public Map<Relation, ExtendedDelta> visitDefinition(Definition def) {
            return Map.of();
        }

        @Override
        public Map<Relation, ExtendedDelta> visitUnion(Union union) {
            final Relation rel = union.getDefinedRelation();
            final List<Relation> operands = union.getOperands();
            Map<Relation, ExtendedDelta> map = new HashMap<>();
            if (origin.equals(rel)) {
                for (Relation o : operands) {
                    map.put(o, new ExtendedDelta(disabled, newGraph()));
                }
            }
            if (operands.contains(origin)) {
                MutableEventGraph d = newGraph();
                disabled.apply((e1, e2) -> {
                    if (operands.stream().noneMatch(o -> knowledgeMap.get(o).getMaySet().contains(e1, e2))) {
                        d.add(e1, e2);
                    }
                });
                map.put(rel, new ExtendedDelta(d, enabled));
            }
            return map;
        }

        @Override
        public Map<Relation, ExtendedDelta> visitIntersection(Intersection inter) {
            final Relation rel = inter.getDefinedRelation();
            final List<Relation> operands = inter.getOperands();
            Map<Relation, ExtendedDelta> map = new HashMap<>();
            if (origin.equals(rel)) {
                for (Relation o : operands) {
                    MutableEventGraph d = operands.stream()
                            .map(r -> o.equals(r) ? disabled : knowledgeMap.get(r).getMustSet())
                            .sorted(Comparator.comparingInt(EventGraph::size))
                            .reduce(MutableEventGraph::intersection)
                            .orElseThrow();
                    map.putIfAbsent(o, new ExtendedDelta(d, enabled));
                }
            }
            if (operands.contains(origin)) {
                MutableEventGraph e = operands.stream()
                        .map(r -> origin.equals(r) ? enabled : knowledgeMap.get(r).getMustSet())
                        .sorted(Comparator.comparingInt(EventGraph::size))
                        .reduce(MutableEventGraph::intersection)
                        .orElseThrow();
                map.put(rel, new ExtendedDelta(disabled, e));
            }
            return map;
        }

        @Override
        public Map<Relation, ExtendedDelta> visitDifference(Difference diff) {
            final Relation r0 = diff.getDefinedRelation();
            final Relation r1 = diff.getMinuend();
            final Relation r2 = diff.getSubtrahend();
            Map<Relation, ExtendedDelta> map = new HashMap<>();
            if (origin.equals(r0)) {
                map.put(r1, new ExtendedDelta(MutableEventGraph.difference(disabled, knowledgeMap.get(r2).getMaySet()), enabled));
            }
            if (origin.equals(r1)) {
                map.put(r0, new ExtendedDelta(disabled, MutableEventGraph.difference(enabled, knowledgeMap.get(r2).getMaySet())));
            }
            if (origin.equals(r2)) {
                MutableKnowledge k1 = knowledgeMap.get(r1);
                map.put(r0, new ExtendedDelta(MutableEventGraph.intersection(enabled, k1.getMaySet()), MutableEventGraph.intersection(disabled, k1.getMustSet())));
                map.put(r1, new ExtendedDelta(MutableEventGraph.difference(disabled, knowledgeMap.get(r0).getMaySet()), newGraph()));
            }
            return map;
        }

        @Override
        public Map<Relation, ExtendedDelta> visitComposition(Composition comp) {
            final Relation r0 = comp.getDefinedRelation();
            final Relation r1 = comp.getLeftOperand();
            final Relation r2 = comp.getRightOperand();
            MutableEventGraph d0 = newGraph();
            MutableEventGraph e0 = newGraph();
            MutableEventGraph d1 = newGraph();
            MutableEventGraph d2 = newGraph();
            MutableKnowledge k0 = knowledgeMap.get(r0);
            MutableKnowledge k1 = knowledgeMap.get(r1);
            MutableKnowledge k2 = knowledgeMap.get(r2);
            if (origin.equals(r0)) {
                Map<Event, Set<Event>> mustOut1 = k1.getMustSet().getOutMap();
                Map<Event, Set<Event>> mustIn2 = k2.getMustSet().getInMap();
                Map<Event, Set<Event>> mayIn2 = k2.getMaySet().getInMap();
                disabled.apply((x, z) -> {
                    final Set<Event> disableZ = newSet(mustOut1.getOrDefault(x, Set.of()));
                    retainImplyWith(disableZ, x, z);
                    disableZ.retainAll(mayIn2.getOrDefault(z, Set.of()));
                    disableZ.forEach(y -> d2.add(y, z));
                    final Set<Event> disableX = newSet(mustIn2.getOrDefault(z, Set.of()));
                    retainImplyWith(disableX, z, x);
                    disableX.retainAll(k1.getMaySet().getRange(x));
                    d1.addRange(x, disableX);
                });
            }

            if (origin.equals(r1)) {
                List<EventGraph> result = handleCompositionChild(disabled, enabled,
                        k0.getMaySet(), k1.getMaySet(), k2.getMaySet(), k2.getMustSet());
                result.get(0).getOutMap().forEach((e1, value) -> value.forEach(e2 -> d0.add(e1, e2)));
                result.get(1).getOutMap().forEach((e1, value) -> value.forEach(e2 -> e0.add(e1, e2)));
                result.get(2).getOutMap().forEach((e1, value) -> value.forEach(e2 -> d2.add(e1, e2)));
            }

            if (origin.equals(r2)) {
                List<EventGraph> result = handleCompositionChild(disabled.inverse(), enabled.inverse(),
                        k0.getMaySet().inverse(), k2.getMaySet().inverse(), k1.getMaySet().inverse(), k1.getMustSet().inverse());
                result.get(0).getOutMap().forEach((e2, value) -> value.forEach(e1 -> d0.add(e1, e2)));
                result.get(1).getOutMap().forEach((e2, value) -> value.forEach(e1 -> e0.add(e1, e2)));
                result.get(2).getOutMap().forEach((e2, value) -> value.forEach(e1 -> d1.add(e1, e2)));
            }

            Map<Relation, ExtendedDelta> map = new HashMap<>();
            map.put(r0, new ExtendedDelta(d0, e0));
            map.computeIfAbsent(r1, k -> new ExtendedDelta(d1, newGraph())).disabled.addAll(d1);
            map.computeIfAbsent(r2, k -> new ExtendedDelta(d2, newGraph())).disabled.addAll(d2);
            return map;
        }

        private List<EventGraph> handleCompositionChild(
                EventGraph disOut1,
                EventGraph enOut1,
                EventGraph mayOut0,
                EventGraph mayOut1,
                EventGraph mayOut2,
                EventGraph mustOut2
        ) {
            List<EventGraph> result = handleCompositionEnabledSet(enOut1, mayOut2, mustOut2, mayOut0);
            EventGraph disOut0 = handleCompositionDisabledSet(disOut1, mayOut1, mayOut2);
            EventGraph enOut0 = result.get(0);
            EventGraph disOut2 = result.get(1);
            return List.of(disOut0, enOut0, disOut2);
        }

        private EventGraph handleCompositionDisabledSet(
                EventGraph disOut1,
                EventGraph mayOut1,
                EventGraph mayOut2
        ) {
            MutableEventGraph result = newGraph();
            for (Event e1 : disOut1.getDomain()) {
                final Set<Event> e1Mutex = execExcluding(e1);
                for (Event e : disOut1.getRange(e1)) {
                    final Set<Event> e2Set = newSet(mayOut2.getRange(e));
                    e2Set.removeAll(e1Mutex);
                    e2Set.removeAll(result.getRange(e1));
                    if (!e2Set.isEmpty()) {
                        for (Event eAlt : mayOut1.getRange(e1)) {
                            e2Set.removeAll(mayOut2.getRange(eAlt));
                            if (e2Set.isEmpty()) {
                                break;
                            }
                        }
                    }
                    result.addRange(e1, e2Set);
                }
            }
            return result;
        }

        private List<EventGraph> handleCompositionEnabledSet(
                EventGraph enable1,
                EventGraph may2,
                EventGraph must2,
                EventGraph may0
        ) {
            MutableEventGraph e0 = newGraph();
            MutableEventGraph d2 = newGraph();
            for (Event x : enable1.getDomain()) {
                final Set<Event> mutexX = execExcluding(x);
                for (Event y : enable1.getRange(x)) {
                    final Set<Event> enableX = newSet(may2.getRange(y));
                    enableX.removeAll(mutexX);
                    if (!enableX.isEmpty()) {
                        final Set<Event> disableY = newSet(enableX);
                        enableX.retainAll(must2.getRange(y));
                        retainImplyWith(enableX, y, x);
                        e0.addRange(x, enableX);
                        disableY.removeAll(may0.getRange(x));
                        retainImplyWith(disableY, x, y);
                        d2.addRange(y, disableY);
                    }
                }
            }
            return List.of(e0, d2);
        }

        @Override
        public Map<Relation, ExtendedDelta> visitInverse(Inverse inv) {
            final Relation r0 = inv.getDefinedRelation();
            final Relation r1 = inv.getOperand();
            if (origin.equals(r0)) {
                return Map.of(r1, new ExtendedDelta(disabled.inverse(), newGraph()));
            }
            if (origin.equals(r1)) {
                return Map.of(r0, new ExtendedDelta(disabled.inverse(), enabled.inverse()));
            }
            return Map.of();
        }

        @Override
        public Map<Relation, ExtendedDelta> visitTransitiveClosure(TransitiveClosure trans) {
            final Relation r0 = trans.getDefinedRelation();
            final Relation r1 = trans.getOperand();
            MutableEventGraph d0 = newGraph();
            MutableEventGraph e0 = newGraph();
            MutableEventGraph d1 = newGraph();
            MutableKnowledge k0 = knowledgeMap.get(r0);
            MutableKnowledge k1 = knowledgeMap.get(r1);
            if (origin.equals(r1)) {
                Map<Event, Set<Event>> mayOut0 = k0.getMaySet().getOutMap();
                Map<Event, Set<Event>> mayIn0 = k0.getMaySet().getInMap();
                disabled.apply((x, y) -> {
                    Set<Event> alternatives = k1.getMaySet().getRange(x);
                    if (k0.getMaySet().contains(x, y)
                            && Collections.disjoint(alternatives, mayIn0.getOrDefault(y, Set.of()))) {
                        d0.add(x, y);
                    }
                    if (!Tuple.isLoop(x, y)) {
                        for (Event z : mayOut0.getOrDefault(y, Set.of())) {
                            if (k0.getMaySet().contains(x, z)
                                    && !alternatives.contains(z)
                                    && Collections.disjoint(alternatives, mayIn0.getOrDefault(z, Set.of()))) {
                                d0.add(x, z);
                            }
                        }
                    }
                });
                e0.addAll(enabled);
                enabled.apply((x, y) -> {
                    if (!Tuple.isLoop(x, y)) {
                        final Set<Event> enableX = newSet(mayOut0.getOrDefault(y, Set.of()));
                        enableX.removeAll(execExcluding(x));
                        final Set<Event> disableY = newSet(enableX);
                        retainImplyWith(enableX, y, x);
                        enableX.retainAll(k0.getMustSet().getRange(y));
                        e0.addRange(x, enableX);
                        retainImplyWith(disableY, x, y);
                        disableY.removeAll(k0.getMaySet().getRange(x));
                        d0.addRange(y, disableY);
                    }
                });
            }
            if (origin.equals(r0)) {
                final Map<Event, Set<Event>> mustIn0 = k0.getMustSet().getInMap();
                final Map<Event, Set<Event>> mustIn1 = k1.getMustSet().getInMap();
                final Map<Event, Set<Event>> mayIn0 = k0.getMaySet().getInMap();
                final Map<Event, Set<Event>> mayIn1 = k1.getMaySet().getInMap();
                d1.addAll(EventGraph.intersection(disabled, k1.getMaySet()));
                disabled.apply((x, z) -> {
                    if (!Tuple.isLoop(x, z)) {
                        final Set<Event> disableZ = newSet(k1.getMustSet().getRange(x));
                        retainImplyWith(disableZ, x, z);
                        disableZ.retainAll(mayIn0.getOrDefault(z, Set.of()));
                        disableZ.forEach(y -> d0.add(y, z));
                        final Set<Event> disableX = newSet(mustIn0.getOrDefault(z, Set.of()));
                        retainImplyWith(disableX, z, x);
                        disableX.retainAll(k1.getMaySet().getRange(x));
                        d1.addRange(x, disableX);
                    }
                });
                enabled.apply((y, z) -> {
                    if (!Tuple.isLoop(y, z)) {
                        final Set<Event> enableZ = newSet(mayIn1.getOrDefault(y, Set.of()));
                        enableZ.removeAll(execExcluding(z));
                        final Set<Event> disableY = newSet(enableZ);
                        retainImplyWith(enableZ, y, z);
                        enableZ.retainAll(mustIn1.getOrDefault(y, Set.of()));
                        enableZ.forEach(x -> e0.add(x, z));
                        retainImplyWith(disableY, z, y);
                        disableY.removeAll(mayIn0.getOrDefault(z, Set.of()));
                        disableY.forEach(x -> d1.add(x, y));
                    }
                });
            }
            return Map.of(
                    r0, new ExtendedDelta(d0, e0),
                    r1, new ExtendedDelta(d1, newGraph()));
        }

        @Override
        public Map<Relation, ExtendedDelta> visitCoherence(Coherence coDef) {
            if (disabled.isEmpty()) {
                return Map.of();
            }
            //TODO use transitivity
            MutableEventGraph e = newGraph();
            disabled.apply((x, y) -> {
                if (alias.mustAlias((MemoryCoreEvent) x, (MemoryCoreEvent) y)) {
                    e.add(y, x);
                }
            });
            return Map.of(coDef.getDefinedRelation(), new ExtendedDelta(newGraph(), e));
        }
    }

    protected static final class Delta {

        public final MutableEventGraph may;
        public final MutableEventGraph must;

        public Delta(MutableEventGraph maySet, MutableEventGraph mustSet) {
            may = maySet;
            must = mustSet;
        }
    }

    private static final class ExtendedDelta {
        final MutableEventGraph disabled;
        final MutableEventGraph enabled;

        public ExtendedDelta(MutableEventGraph d, MutableEventGraph e) {
            disabled = d;
            enabled = e;
        }
    }

    protected final class Propagator implements Definition.Visitor<Delta> {
        private Relation source;
        private MutableEventGraph may;
        private MutableEventGraph must;

        public Relation getSource() {
            return source;
        }

        public void setSource(Relation source) {
            this.source = source;
        }

        public EventGraph getMay() {
            return may;
        }

        public void setMay(MutableEventGraph may) {
            this.may = may;
        }

        public EventGraph getMust() {
            return must;
        }

        public void setMust(MutableEventGraph must) {
            this.must = must;
        }

        @Override
        public Delta visitUnion(Union union) {
            if (union.getOperands().contains(source)) {
                return new Delta(may, must);
            }
            return EMPTY;
        }

        @Override
        public Delta visitIntersection(Intersection inter) {
            final List<Relation> operands = inter.getOperands();
            if (operands.contains(source)) {
                MutableEventGraph maySet = operands.stream()
                        .map(r -> source.equals(r) ? may : getMutableKnowledge(r).getMaySet())
                        .sorted(Comparator.comparingInt(MutableEventGraph::size))
                        .reduce(MutableEventGraph::intersection)
                        .orElseThrow();
                MutableEventGraph mustSet = operands.stream()
                        .map(r -> source.equals(r) ? must : getMutableKnowledge(r).getMustSet())
                        .sorted(Comparator.comparingInt(MutableEventGraph::size))
                        .reduce(MutableEventGraph::intersection)
                        .orElseThrow();
                return new Delta(maySet, mustSet);
            }
            return EMPTY;
        }

        @Override
        public Delta visitDifference(Difference diff) {
            if (diff.getMinuend().equals(source)) {
                Knowledge k = getKnowledge(diff.getSubtrahend());
                return new Delta(MutableEventGraph.difference(may, k.getMustSet()), MutableEventGraph.difference(must, k.getMaySet()));
            }
            return EMPTY;
        }

        @Override
        public Delta visitComposition(Composition comp) {
            final Relation r1 = comp.getLeftOperand();
            final Relation r2 = comp.getRightOperand();
            MutableEventGraph maySet = newGraphWithDomain(getKnowledge(comp.getDefinedRelation()).getMaySet());
            MutableEventGraph mustSet = newGraphWithDomain(getKnowledge(comp.getDefinedRelation()).getMustSet());
            if (r1.equals(source)) {
                computeComposition(maySet, may, getKnowledge(r2).getMaySet(), true);
                computeComposition(mustSet, must, getKnowledge(r2).getMustSet(), false);
            }
            if (r2.equals(source)) {
                computeComposition(maySet, getKnowledge(r1).getMaySet(), may, true);
                computeComposition(mustSet, getKnowledge(r1).getMustSet(), must, false);
            }
            return new Delta(maySet, mustSet);
        }

        private void computeComposition(MutableEventGraph result, EventGraph left, EventGraph right, boolean isMay) {
            final IndexedDomain<Event> eventDomain = ((IndexedEventGraph) result).eventDomain();
            for (Event e1 : left.getDomain()) {
                final Set<Event> update = new IndexedSet<>(eventDomain);
                for (Event e : left.getRange(e1)) {
                    final Set<Event> impliesE = execImplying(e);
                    final Set<Event> rightRange = right.getRange(e);
                    if (isMay || impliesE.contains(e1)) {
                        update.addAll(rightRange);
                    } else {
                        final Set<Event> range = newSet(rightRange);
                        range.retainAll(impliesE);
                        update.addAll(range);
                    }
                }
                update.removeAll(execExcluding(e1));
                result.addRange(e1, update);
            }
        }

        @Override
        public Delta visitProjection(Projection projection) {
            if (projection.getOperand().equals(source)) {
                final boolean dom = projection.getDimension() == Projection.Dimension.DOMAIN;
                final MutableEventGraph maySet = newGraph();
                (dom ? may.getDomain() : may.getRange()).forEach(e -> maySet.add(e, e));
                final MutableEventGraph mustSet = newGraph();
                must.apply((e1, e2) -> {
                    final Event e = dom ? e1 : e2;
                    if (exec.isImplied(e, dom ? e2 : e1)) {
                        mustSet.add(e, e);
                    }
                });
                return new Delta(maySet, mustSet);
            }
            return EMPTY;
        }

        @Override
        public Delta visitProduct(CartesianProduct product) {
            final boolean isDomain = product.getDomain().equals(source);
            final boolean isRange = product.getRange().equals(source);
            if (!isDomain && !isRange) {
                return EMPTY;
            }
            final Knowledge domain = knowledgeMap.get(product.getDomain());
            final Knowledge range = knowledgeMap.get(product.getRange());
            final MutableEventGraph maySet = newGraph();
            final MutableEventGraph mustSet = newGraph();
            if (isRange) {
                computeCartesianProduct(maySet, domain.getMaySet(), may);
                computeCartesianProduct(mustSet, domain.getMustSet(), must);
            }
            if (isDomain) {
                computeCartesianProduct(maySet, may, range.getMaySet());
                computeCartesianProduct(mustSet, must, range.getMustSet());
            }
            return new Delta(maySet, mustSet);
        }

        private void computeCartesianProduct(MutableEventGraph target, EventGraph domain, EventGraph range) {
            final Set<Event> newRange = newSet(range.getDomain());
            newRange.removeIf(x -> !range.contains(x, x));

            for (Event e1 : domain.getDomain()) {
                if (domain.contains(e1, e1)) {
                    final Set<Event> e1Range = newSet(newRange);
                    e1Range.removeAll(execExcluding(e1));
                    target.addRange(e1, e1Range);
                }
            }
        }

        @Override
        public Delta visitSetIdentity(SetIdentity id) {
            if (!id.getDomain().equals(source)) {
                return EMPTY;
            }
            return new Delta(newGraph(may), newGraph(must));
        }

        @Override
        public Delta visitInverse(Inverse inv) {
            if (inv.getOperand().equals(source)) {
                return new Delta(may.inverse(), must.inverse());
            }
            return EMPTY;
        }

        @Override
        public Delta visitTransitiveClosure(TransitiveClosure trans) {
            final Relation rel = trans.getDefinedRelation();
            if (trans.getOperand().equals(source)) {
                MutableEventGraph maySet = computeTransitiveClosure(getKnowledge(rel).getMaySet(), may, true);
                MutableEventGraph mustSet = computeTransitiveClosure(getKnowledge(rel).getMustSet(), must, false);
                return new Delta(maySet, mustSet);
            }
            return EMPTY;
        }

        private MutableEventGraph computeTransitiveClosure(EventGraph oldOuter, MutableEventGraph inner, boolean isMay) {
            MutableEventGraph outer = newGraph(oldOuter);
            MutableEventGraph update = inner.filter(outer::add);
            MutableEventGraph updateComposition = newGraphWithDomain(oldOuter);
            computeComposition(updateComposition, inner, oldOuter, isMay);
            update.addAll(updateComposition.filter(outer::add));
            while (!update.isEmpty()) {
                MutableEventGraph t = newGraphWithDomain(oldOuter);
                computeComposition(t, inner, update, isMay);
                update = t.filter(outer::add);
            }
            return outer;
        }
    }

    protected static class MutableKnowledge extends Knowledge {

        protected MutableKnowledge(MutableEventGraph maySet, MutableEventGraph mustSet) {
            super(maySet, mustSet);
        }

        @Override
        public MutableEventGraph getMaySet() {
            return (MutableEventGraph) may;
        }

        @Override
        public MutableEventGraph getMustSet() {
            return (MutableEventGraph) must;
        }
    }

    private Set<Event> execImplying(Event event) {
        return exec.implyingEvents(event);
    }

    private Set<Event> execExcluding(Event event) {
        return exec.excludingEvents(event);
    }
}
