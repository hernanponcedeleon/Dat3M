package com.dat3m.dartagnan.wmm.analysis;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Register.UsageType;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.BranchEquivalence;
import com.dat3m.dartagnan.program.analysis.Dependency;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.MemoryEvent;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.lang.svcomp.EndAtomic;
import com.dat3m.dartagnan.program.filter.Filter;
import com.dat3m.dartagnan.program.memory.VirtualMemoryObject;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.witness.graphml.WitnessGraph;
import com.dat3m.dartagnan.wmm.*;
import com.dat3m.dartagnan.wmm.axiom.Acyclicity;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.axiom.Emptiness;
import com.dat3m.dartagnan.wmm.axiom.Irreflexivity;
import com.dat3m.dartagnan.wmm.definition.*;
import com.dat3m.dartagnan.wmm.utils.EventGraph;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.configuration.Arch.RISCV;
import static com.dat3m.dartagnan.program.Register.UsageType.*;
import static com.dat3m.dartagnan.program.event.Tag.*;
import static com.dat3m.dartagnan.wmm.utils.EventGraph.difference;
import static com.dat3m.dartagnan.wmm.utils.EventGraph.intersection;
import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Preconditions.checkNotNull;
import static com.google.common.base.Verify.verify;
import static com.google.common.collect.Lists.reverse;
import static java.util.stream.Collectors.toList;
import static java.util.stream.Collectors.toSet;
import static java.util.stream.IntStream.iterate;

public class NativeRelationAnalysis implements RelationAnalysis {

    private static final Logger logger = LogManager.getLogger(NativeRelationAnalysis.class);

    protected final VerificationTask task;
    protected final Context analysisContext;
    protected final ExecutionAnalysis exec;
    protected final AliasAnalysis alias;
    protected final Dependency dep;
    protected final WmmAnalysis wmmAnalysis;
    protected final Map<Relation, Knowledge> knowledgeMap = new HashMap<>();
    protected final EventGraph mutex = new EventGraph();

    protected NativeRelationAnalysis(VerificationTask t, Context context, Configuration config) {
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
    public void populateQueue(Map<Relation, List<EventGraph>> queue, Set<Relation> relations) {
        Propagator p = new Propagator();
        for (Relation r : relations) {
            EventGraph may = new EventGraph();
            EventGraph must = new EventGraph();
            if (r.getDependencies().isEmpty()) {
                continue;
            }
            for (Relation c : r.getDependencies()) {
                p.setSource(c);
                p.setMay(getKnowledge(p.getSource()).getMaySet());
                p.setMust(getKnowledge(p.getSource()).getMustSet());
                Delta s = r.getDefinition().accept(p);
                may.addAll(s.may);
                must.addAll(s.must);
            }
            may.removeAll(getKnowledge(r).getMaySet());
            EventGraph must2 = difference(getKnowledge(r).getMustSet(), must);
            queue.computeIfAbsent(r, k -> new ArrayList<>()).add(EventGraph.union(may, must2));
        }
    }

    @Override
    public EventGraph findTransitivelyImpliedCo(Relation co) {
        final Knowledge k = getKnowledge(co);
        EventGraph transCo = new EventGraph();
        Map<Event, Set<Event>> mustIn = k.getMustSet().getInMap();
        Map<Event, Set<Event>> mustOut = k.getMustSet().getOutMap();
        k.getMaySet().apply((e1, e2) -> {
            final MemoryEvent x = (MemoryEvent) e1;
            final MemoryEvent z = (MemoryEvent) e2;
            boolean hasIntermediary = mustOut.getOrDefault(x, Set.of()).stream().anyMatch(y -> y != x && y != z &&
                    (exec.isImplied(x, y) || exec.isImplied(z, y)) &&
                    !k.getMaySet().contains(z, y))
                    || mustIn.getOrDefault(z, Set.of()).stream().anyMatch(y -> y != x && y != z &&
                    (exec.isImplied(x, y) || exec.isImplied(z, y)) &&
                    !k.getMaySet().contains(y, x));
            if (hasIntermediary) {
                transCo.add(e1, e2);
            }
        });
        return transCo;
    }

    @Override
    public void run() {
        logger.trace("Start");
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
            Knowledge k = r.getDefinition().accept(initializer);
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
            Delta toAdd = Delta.combine(qLocal.remove(relation));
            if (relation.getDefinition() instanceof Difference difference) {
                // Our propagated update may be "too large" so we reduce it.
                Knowledge k = knowledgeMap.get(difference.getSubtrahend());
                toAdd.may.removeAll(k.getMustSet());
                toAdd.must.removeAll(k.getMaySet());
            }

            Delta delta = joinSet(knowledgeMap.get(relation), List.of(toAdd));
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
                    c.accept(new InitialKnowledgeCloser(knowledgeMap, analysisContext)).entrySet()) {
                q.computeIfAbsent(e.getKey(), k -> new ArrayList<>()).add(e.getValue());
            }
        }
        ExtendedPropagator propagator = new ExtendedPropagator();
        // repeat until convergence
        while (!q.isEmpty()) {
            Relation relation = q.keySet().iterator().next();
            logger.trace("Extended knowledge update for '{}'", relation);
            Knowledge knowledge = knowledgeMap.get(relation);
            ExtendedDelta delta = join(knowledge, q.remove(relation));
            if (delta.disabled.isEmpty() && delta.enabled.isEmpty()) {
                continue;
            }
            mutex.addAll(difference(delta.enabled, knowledge.getMaySet()));
            mutex.addAll(intersection(delta.disabled, knowledge.getMustSet()));
            propagator.origin = relation;
            EventGraph disabled = propagator.disabled = delta.disabled;
            EventGraph enabled = propagator.enabled = delta.enabled;
            for (Constraint c : dependents.getOrDefault(relation, List.of())) {
                logger.trace("Extended propagation from '{}' to '{}'", relation, c);
                for (Map.Entry<Relation, ExtendedDelta> e :
                        c.accept(new IncrementalKnowledgeCloser(relation, disabled, enabled, knowledgeMap, analysisContext)).entrySet()) {
                    q.computeIfAbsent(e.getKey(), k -> new ArrayList<>()).add(e.getValue());
                }
                if (!(c instanceof Definition)) {
                    continue;
                }
                for (Map.Entry<Relation, ExtendedDelta> e : c.accept(propagator).entrySet()) {
                    q.computeIfAbsent(e.getKey(), k -> new ArrayList<>()).add(e.getValue());
                }
            }
        }
        logger.trace("End");
    }

    protected Initializer getInitializer() {
        return new Initializer();
    }

    private static Delta joinSet(Knowledge k, List<Delta> l) {
        verify(!l.isEmpty(), "empty update");
        EventGraph may = k.getMaySet();
        EventGraph must = k.getMustSet();
        // NOTE optimization due to initial deltas carrying references to knowledge sets
        EventGraph maySet = may.isEmpty() || l.get(0).may == may ? may : new EventGraph();
        EventGraph mustSet = must.isEmpty() || l.get(0).must == must ? must : new EventGraph();
        for (Delta d : l) {
            d.may.apply((e1, e2) -> {
                if (may.add(e1, e2)) {
                    maySet.add(e1, e2);
                }
            });
            d.must.apply((e1, e2) -> {
                if (must.add(e1, e2)) {
                    mustSet.add(e1, e2);
                }
            });
        }
        return new Delta(maySet, mustSet);
    }

    private static ExtendedDelta join(Knowledge k, List<ExtendedDelta> l) {
        verify(!l.isEmpty(), "empty update in extended analysis");
        EventGraph may = k.getMaySet();
        EventGraph must = k.getMustSet();
        EventGraph disableSet = new EventGraph();
        EventGraph enableSet = new EventGraph();
        l.stream().map(d -> d.disabled).map(EventGraph::new).forEach(e -> e.filter(may::remove).apply(disableSet::add));
        l.stream().map(d -> d.enabled).map(EventGraph::new).forEach(e -> e.filter(must::remove).apply(enableSet::add));
        return new ExtendedDelta(disableSet, enableSet);
    }

    private static final class InitialKnowledgeCloser implements Constraint.Visitor<Map<Relation, ExtendedDelta>> {
        private final Map<Relation, Knowledge> knowledgeMap;
        private final Context analysisContext;

        public InitialKnowledgeCloser(
                Map<Relation, Knowledge> knowledgeMap,
                Context analysisContext) {
            this.knowledgeMap = knowledgeMap;
            this.analysisContext = analysisContext;
        }

        @Override
        public Map<Relation, ExtendedDelta> visitConstraint(Constraint constraint) {
            return Map.of();
        }

        @Override
        public Map<Relation, ExtendedDelta> visitEmptiness(Emptiness axiom) {
            Relation rel = axiom.getRelation();
            return Map.of(rel, new ExtendedDelta(knowledgeMap.get(rel).getMaySet(), EventGraph.empty()));
        }

        @Override
        public Map<Relation, ExtendedDelta> visitIrreflexivity(Irreflexivity axiom) {
            Relation rel = axiom.getRelation();
            Knowledge k = knowledgeMap.get(rel);
            EventGraph d = k.getMaySet().filter(Tuple::isLoop);
            return Map.of(rel, new ExtendedDelta(d, EventGraph.empty()));
        }

        @Override
        public Map<Relation, ExtendedDelta> visitAcyclicity(Acyclicity axiom) {
            long t0 = System.currentTimeMillis();
            Relation rel = axiom.getRelation();
            ExecutionAnalysis exec = analysisContext.get(ExecutionAnalysis.class);
            Knowledge knowledge = knowledgeMap.get(rel);
            EventGraph may = knowledge.getMaySet();
            EventGraph must = knowledge.getMustSet();
            EventGraph newDisabled = new EventGraph();
            may.filter((e1, e2) -> Tuple.isLoop(e1, e2) || must.contains(e2, e1)).apply(newDisabled::add);
            Map<Event, List<Event>> mustOut = new HashMap<>();
            must.filter((e1, e2) -> !Tuple.isLoop(e1, e2)).apply((e1, e2) -> mustOut.computeIfAbsent(e1, x -> new ArrayList<>()).add(e2));
            EventGraph current = knowledge.getMustSet();
            do {
                EventGraph next = new EventGraph();
                current.filter(Tuple::isLoop).apply((x, y) -> {
                    boolean implied = exec.isImplied(x, y);
                    mustOut.getOrDefault(y, List.of()).stream()
                            .filter(z -> implied || exec.isImplied(z, y))
                            .filter(z -> !exec.areMutuallyExclusive(x, z))
                            .filter(z -> newDisabled.add(z, x))
                            .forEach(z -> next.add(x, z));
                });
                current = next;
            } while (!current.isEmpty());
            newDisabled.retainAll(knowledge.getMaySet());
            logger.debug("disabled {} edges in {}ms", newDisabled.size(), System.currentTimeMillis() - t0);
            return Map.of(rel, new ExtendedDelta(newDisabled, EventGraph.empty()));
        }

        @Override
        public Map<Relation, ExtendedDelta> visitAssumption(Assumption assume) {
            Relation rel = assume.getRelation();
            Knowledge k = knowledgeMap.get(rel);
            EventGraph d = difference(k.getMaySet(), assume.getMaySet());
            EventGraph e = difference(assume.getMustSet(), k.getMustSet());
            if (d.size() + e.size() != 0) {
                logger.info("Assumption disables {} and enables {} at {}", d.size(), e.size(), rel.getNameOrTerm());
            }
            return Map.of(rel, new ExtendedDelta(d, e));
        }
    }

    private static final class IncrementalKnowledgeCloser implements Constraint.Visitor<Map<Relation, ExtendedDelta>> {
        private final Relation changed;
        private final EventGraph disabled;
        private final EventGraph enabled;
        private final Map<Relation, Knowledge> knowledgeMap;
        private final Context analysisContext;

        public IncrementalKnowledgeCloser(
                Relation changed,
                EventGraph disabled,
                EventGraph enabled,
                Map<Relation, Knowledge> knowledgeMap,
                Context analysisContext) {
            this.changed = changed;
            this.disabled = disabled;
            this.enabled = enabled;
            this.knowledgeMap = knowledgeMap;
            this.analysisContext = analysisContext;
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
            ExecutionAnalysis exec = analysisContext.get(ExecutionAnalysis.class);
            Knowledge knowledge = knowledgeMap.get(rel);
            EventGraph may = knowledge.getMaySet();
            EventGraph newDisabled = new EventGraph();
            enabled.filter((e1, e2) -> may.contains(e2, e1)).apply((e1, e2) -> newDisabled.add(e2, e1));
            Map<Event, List<Event>> mustIn = new HashMap<>();
            Map<Event, List<Event>> mustOut = new HashMap<>();
            knowledge.getMustSet().filter((e1, e2) -> !Tuple.isLoop(e1, e2)).apply((e1, e2) -> {
                mustIn.computeIfAbsent(e2, x -> new ArrayList<>()).add(e1);
                mustOut.computeIfAbsent(e1, x -> new ArrayList<>()).add(e2);
            });

            EventGraph current = enabled;
            do {
                EventGraph next = new EventGraph();
                current.filter((x, y) -> !Tuple.isLoop(x, y)).apply((x, y) -> {
                    boolean implies = exec.isImplied(x, y);
                    boolean implied = exec.isImplied(y, x);
                    mustIn.getOrDefault(x, List.of()).stream()
                            .filter(w -> implied || exec.isImplied(w, x))
                            .filter(w -> !exec.areMutuallyExclusive(w, y))
                            .filter(w -> newDisabled.add(y, w))
                            .forEach(w -> next.add(w, y));
                    mustOut.getOrDefault(y, List.of()).stream()
                            .filter(z -> implies || exec.isImplied(z, y))
                            .filter(z -> !exec.areMutuallyExclusive(x, z))
                            .filter(z -> newDisabled.add(z, x))
                            .forEach(z -> next.add(x, z));
                });
                current = next;
            } while (!current.isEmpty());
            newDisabled.retainAll(knowledge.getMaySet());
            logger.debug("Disabled {} edges in {}ms", newDisabled.size(), System.currentTimeMillis() - t0);
            return Map.of(rel, new ExtendedDelta(newDisabled, EventGraph.empty()));
        }
    }

    protected class Initializer implements Definition.Visitor<Knowledge> {
        final Program program = task.getProgram();
        final WitnessGraph witness = task.getWitness();

        @Override
        public Knowledge visitDefinition(Definition def) {
            return new Knowledge(new EventGraph(), new EventGraph());
        }

        @Override
        public Knowledge visitFree(Free def) {
            final List<Event> visibleEvents = program.getThreadEventsWithAllTags(VISIBLE);
            EventGraph must = EventGraph.empty();
            EventGraph may = new EventGraph();

            for (Event e1 : visibleEvents) {
                for (Event e2 : visibleEvents) {
                    may.add(e1, e2);
                }
            }

            return new Knowledge(may, must);
        }

        @Override
        public Knowledge visitProduct(CartesianProduct prod) {
            final Filter domain = prod.getFirstFilter();
            final Filter range = prod.getSecondFilter();
            EventGraph must = new EventGraph();
            List<Event> l1 = program.getThreadEvents().stream().filter(domain::apply).toList();
            List<Event> l2 = program.getThreadEvents().stream().filter(range::apply).toList();
            for (Event e1 : l1) {
                Set<Event> rangeEvents = l2.stream()
                        .filter(e2 -> !exec.areMutuallyExclusive(e1, e2))
                        .collect(toSet());
                must.addRange(e1, rangeEvents);
            }
            return new Knowledge(must, new EventGraph(must));
        }

        @Override
        public Knowledge visitSetIdentity(SetIdentity id) {
            final Filter set = id.getFilter();
            EventGraph must = new EventGraph();
            program.getThreadEvents().stream().filter(set::apply).forEach(e -> must.add(e, e));
            return new Knowledge(must, new EventGraph(must));
        }

        @Override
        public Knowledge visitExternal(External ext) {
            EventGraph must = new EventGraph();
            List<Thread> threads = program.getThreads();
            for (int i = 0; i < threads.size(); i++) {
                Thread t1 = threads.get(i);
                List<Event> visible1 = visibleEvents(t1);
                for (int j = i + 1; j < threads.size(); j++) {
                    Thread t2 = threads.get(j);
                    for (Event e2 : visibleEvents(t2)) {
                        for (Event e1 : visible1) {
                            // No test for exec.areMutuallyExclusive, since that currently does not span across threads
                            must.add(e1, e2);
                            must.add(e2, e1);
                        }
                    }
                }
            }
            return new Knowledge(must, new EventGraph(must));
        }

        @Override
        public Knowledge visitInternal(Internal internal) {
            EventGraph must = new EventGraph();
            for (Thread t : program.getThreads()) {
                List<Event> events = visibleEvents(t);
                for (Event e1 : events) {
                    Set<Event> rangeEvents = events.stream()
                            .filter(e2 -> !exec.areMutuallyExclusive(e1, e2))
                            .collect(toSet());
                    must.addRange(e1, rangeEvents);
                }
            }
            return new Knowledge(must, new EventGraph(must));
        }

        @Override
        public Knowledge visitProgramOrder(ProgramOrder po) {
            final Filter type = po.getFilter();
            EventGraph must = new EventGraph();
            for (Thread t : program.getThreads()) {
                List<Event> events = t.getEvents().stream().filter(type::apply).toList();
                for (int i = 0; i < events.size(); i++) {
                    Event e1 = events.get(i);
                    for (int j = i + 1; j < events.size(); j++) {
                        Event e2 = events.get(j);
                        if (!exec.areMutuallyExclusive(e1, e2)) {
                            must.add(e1, e2);
                        }
                    }
                }
            }
            return new Knowledge(must, new EventGraph(must));
        }

        @Override
        public Knowledge visitControlDependency(DirectControlDependency ctrlDep) {
            //TODO: We can restrict the codomain to visible events as the only usage of this Relation is in
            // ctrl := idd^+;ctrlDirect & (R*V)
            EventGraph must = new EventGraph();
            for (Thread thread : program.getThreads()) {
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

                    for (Event e : ctrlDependentEvents) {
                        if (!exec.areMutuallyExclusive(jump, e)) {
                            must.add(jump, e);
                        }
                    }
                }
            }
            return new Knowledge(must, new EventGraph(must));
        }

        @Override
        public Knowledge visitAddressDependency(DirectAddressDependency addrDep) {
            return computeInternalDependencies(EnumSet.of(ADDR));
        }

        @Override
        public Knowledge visitInternalDataDependency(DirectDataDependency idd) {
            // FIXME: Our "internal data dependency" relation is quite odd an contains all but address dependencies.
            return computeInternalDependencies(EnumSet.of(DATA, CTRL, OTHER));
        }

        @Override
        public Knowledge visitFences(Fences fenceDef) {
            final Filter fence = fenceDef.getFilter();
            EventGraph may = new EventGraph();
            EventGraph must = new EventGraph();
            for (Thread t : program.getThreads()) {
                List<Event> events = visibleEvents(t);
                int end = events.size();
                for (int i = 0; i < end; i++) {
                    Event f = events.get(i);
                    if (!fence.apply(f)) {
                        continue;
                    }
                    for (Event x : events.subList(0, i)) {
                        if (exec.areMutuallyExclusive(x, f)) {
                            continue;
                        }
                        boolean implies = exec.isImplied(x, f);
                        for (Event y : events.subList(i + 1, end)) {
                            if (exec.areMutuallyExclusive(x, y) || exec.areMutuallyExclusive(f, y)) {
                                continue;
                            }
                            may.add(x, y);
                            if (implies || exec.isImplied(y, f)) {
                                must.add(x, y);
                            }
                        }
                    }
                }
            }
            return new Knowledge(may, must);
        }

        @Override
        public Knowledge visitCASDependency(CASDependency casDep) {
            EventGraph must = new EventGraph();
            for (Event e : program.getThreadEvents()) {
                if (e.hasTag(IMM.CASDEPORIGIN)) {
                    // The target of a CASDep is always the successor of the origin
                    must.add(e, e.getSuccessor());
                }
            }
            return new Knowledge(must, new EventGraph(must));
        }

        @Override
        public Knowledge visitLinuxCriticalSections(LinuxCriticalSections rscs) {
            EventGraph may = new EventGraph();
            EventGraph must = new EventGraph();
            //assume locks and unlocks are distinct
            Map<Event, Set<Event>> mayMap = new HashMap<>();
            Map<Event, Set<Event>> mustMap = new HashMap<>();
            for (Thread thread : program.getThreads()) {
                List<Event> locks = reverse(thread.getEvents().stream().filter(e -> e.hasTag(Linux.RCU_LOCK)).collect(toList()));
                for (Event unlock : thread.getEvents()) {
                    if (!unlock.hasTag(Linux.RCU_UNLOCK)) {
                        continue;
                    }
                    // iteration order assures that all intermediaries were already iterated
                    for (Event lock : locks) {
                        if (unlock.getGlobalId() < lock.getGlobalId() ||
                                exec.areMutuallyExclusive(lock, unlock) ||
                                Stream.concat(mustMap.getOrDefault(lock, Set.of()).stream(),
                                                mustMap.getOrDefault(unlock, Set.of()).stream())
                                        .anyMatch(e -> exec.isImplied(lock, e) || exec.isImplied(unlock, e))) {
                            continue;
                        }
                        boolean noIntermediary =
                                mayMap.getOrDefault(unlock, Set.of()).stream()
                                        .allMatch(e -> exec.areMutuallyExclusive(lock, e)) &&
                                        mayMap.getOrDefault(lock, Set.of()).stream()
                                                .allMatch(e -> exec.areMutuallyExclusive(e, unlock));
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
            return new Knowledge(may, must);
        }

        @Override
        public Knowledge visitReadModifyWrites(ReadModifyWrites rmw) {
            //NOTE: Changes to the semantics of this method may need to be reflected in RMWGraph for Refinement!
            // ----- Compute must set -----
            EventGraph must = new EventGraph();
            // RMWLoad -> RMWStore
            for (RMWStore store : program.getThreadEvents(RMWStore.class)) {
                must.add(store.getLoadEvent(), store);
            }

            // Atomics blocks: BeginAtomic -> EndAtomic
            for (EndAtomic end : program.getThreadEvents(EndAtomic.class)) {
                List<Event> block = end.getBlock().stream().filter(x -> x.hasTag(VISIBLE)).toList();
                for (int i = 0; i < block.size(); i++) {
                    Event e = block.get(i);
                    for (int j = i + 1; j < block.size(); j++) {
                        if (!exec.areMutuallyExclusive(e, block.get(j))) {
                            must.add(e, block.get(j));
                        }
                    }
                }
            }
            // ----- Compute may set -----
            EventGraph may = new EventGraph(must);
            // LoadExcl -> StoreExcl
            for (Thread thread : program.getThreads()) {
                List<Event> events = thread.getEvents().stream().filter(e -> e.hasTag(EXCL)).toList();
                // assume order by globalId
                // assume globalId describes a topological sorting over the control flow
                for (int end = 1; end < events.size(); end++) {
                    if (!(events.get(end) instanceof RMWStoreExclusive store)) {
                        continue;
                    }
                    int start = iterate(end - 1, i -> i >= 0, i -> i - 1)
                            .filter(i -> exec.isImplied(store, events.get(i)))
                            .findFirst().orElse(0);
                    List<Event> candidates = events.subList(start, end).stream()
                            .filter(e -> !exec.areMutuallyExclusive(e, store))
                            .toList();
                    int size = candidates.size();
                    for (int i = 0; i < size; i++) {
                        Event load = candidates.get(i);
                        List<Event> intermediaries = candidates.subList(i + 1, size);
                        if (!(load instanceof Load) || intermediaries.stream().anyMatch(e -> exec.isImplied(load, e))) {
                            continue;
                        }
                        may.add(load, store);
                        if (intermediaries.stream().allMatch(e -> exec.areMutuallyExclusive(load, e)) &&
                                (store.doesRequireMatchingAddresses() || alias.mustAlias((Load) load, store))) {
                            must.add(load, store);
                        }
                    }
                }
            }
            return new Knowledge(may, must);
        }

        @Override
        public Knowledge visitCoherence(Coherence co) {
            logger.trace("Computing knowledge about memory order");
            List<Store> allWrites = program.getThreadEvents(Store.class);
            List<Store> nonInitWrites = program.getThreadEvents(Store.class);
            nonInitWrites.removeIf(Init.class::isInstance);
            EventGraph may = new EventGraph();
            for (Store w1 : program.getThreadEvents(Store.class)) {
                // It is possible to have multiple initial writes
                // to the same memory location via different virtual memory aliases
                List<Store> writes = w1 instanceof Init ? allWrites : nonInitWrites;
                for (Store w2 : writes) {
                    if (w1.getGlobalId() != w2.getGlobalId() && !exec.areMutuallyExclusive(w1, w2)
                            && alias.mayAlias(w1, w2)) {
                        may.add(w1, w2);
                    }
                }
            }
            EventGraph must = new EventGraph();
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

            // Must-co from violation witness
            if (!witness.isEmpty()) {
                must.addAll(witness.getCoherenceKnowledge(program, alias));
            }

            logger.debug("Initial may set size for memory order: {}", may.size());
            return new Knowledge(may, must);
        }

        @Override
        public Knowledge visitReadFrom(ReadFrom rf) {
            logger.trace("Computing knowledge about read-from");
            final BranchEquivalence eq = analysisContext.requires(BranchEquivalence.class);
            EventGraph may = new EventGraph();
            EventGraph must = new EventGraph();
            List<Load> loadEvents = program.getThreadEvents(Load.class);
            for (Store e1 : program.getThreadEvents(Store.class)) {
                for (Load e2 : loadEvents) {
                    if (alias.mayAlias(e1, e2) && !exec.areMutuallyExclusive(e1, e2)) {
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
                EventGraph deletedEdges = new EventGraph();
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

            // Must-rf from violation witness
            if (!witness.isEmpty()) {
                EventGraph g = witness.getReadFromKnowledge(program, alias);
                must.addAll(g);
                for (Event r : g.getRange()) {
                    may.removeIf((e1, e2) -> e2 == r);
                }
            }

            logger.debug("Initial may set size for read-from: {}", may.size());
            return new Knowledge(may, must);
        }

        @Override
        public Knowledge visitSameLocation(SameLocation loc) {
            EventGraph may = new EventGraph();
            List<MemoryCoreEvent> events = program.getThreadEvents(MemoryCoreEvent.class);
            for (MemoryCoreEvent e1 : events) {
                for (MemoryCoreEvent e2 : events) {
                    if (alias.mayAlias(e1, e2) && !exec.areMutuallyExclusive(e1, e2)) {
                        may.add(e1, e2);
                    }
                }
            }
            EventGraph must = new EventGraph();
            may.apply((e1, e2) -> {
                if (alias.mustAlias((MemoryCoreEvent) e1, (MemoryCoreEvent) e2)) {
                    must.add(e1, e2);
                }
            });
            return new Knowledge(may, must);
        }

        private Knowledge computeInternalDependencies(Set<UsageType> usageTypes) {
            EventGraph may = new EventGraph();
            EventGraph must = new EventGraph();

            for (RegReader regReader : program.getThreadEvents(RegReader.class)) {
                for (Register.Read regRead : regReader.getRegisterReads()) {
                    if (!usageTypes.contains(regRead.usageType())) {
                        continue;
                    }
                    final Register register = regRead.register();
                    // Register x0 is hardwired to the constant 0 in RISCV
                    // https://en.wikichip.org/wiki/risc-v/registers,
                    // and thus it generates no dependency, see
                    // https://github.com/herd/herdtools7/issues/408
                    // TODO: Can't we just replace all reads of "x0" by 0 in RISC-specific preprocessing?
                    if (program.getArch().equals(RISCV) && register.getName().equals("x0")) {
                        continue;
                    }
                    Dependency.State r = dep.of(regReader, register);
                    for (Event regWriter : r.may) {
                        may.add(regWriter, regReader);
                    }
                    for (Event regWriter : r.must) {
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

            return new Knowledge(may, must);
        }

        @Override
        public Knowledge visitSameScope(SameScope sc) {
            final String specificScope = sc.getSpecificScope();
            EventGraph must = new EventGraph();
            List<Event> events = program.getThreadEvents().stream()
                    .filter(e -> e.hasTag(VISIBLE) && e.getThread().hasScope())
                    .toList();
            for (Event e1 : events) {
                for (Event e2 : events) {
                    if (exec.areMutuallyExclusive(e1, e2)) {
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
            return new Knowledge(must, new EventGraph(must));
        }

        @Override
        public Knowledge visitSyncBarrier(SyncBar syncBar) {
            EventGraph may = new EventGraph();
            EventGraph must = new EventGraph();
            List<ControlBarrier> barriers = program.getThreadEvents(ControlBarrier.class);
            for (ControlBarrier e1 : barriers) {
                for (ControlBarrier e2 : barriers) {
                    // “A bar.sync or bar.red or bar.arrive operation synchronizes with a bar.sync
                    // or bar.red operation executed on the same barrier.”
                    if (exec.areMutuallyExclusive(e1, e2) || e2.hasTag(PTX.ARRIVE)) {
                        continue;
                    }
                    may.add(e1, e2);
                    if (e1.getId().equals(e2.getId())) {
                        must.add(e1, e2);
                    }
                }
            }
            return new Knowledge(may, must);
        }

        @Override
        public Knowledge visitSyncFence(SyncFence syncFence) {
            EventGraph may = new EventGraph();
            EventGraph must = EventGraph.empty();
            List<Event> fenceEventsSC = program.getThreadEventsWithAllTags(VISIBLE, FENCE, PTX.SC);
            for (Event e1 : fenceEventsSC) {
                for (Event e2 : fenceEventsSC) {
                    if (!exec.areMutuallyExclusive(e1, e2)) {
                        may.add(e1, e2);
                    }
                }
            }
            return new Knowledge(may, must);
        }

        @Override
        public Knowledge visitSameVirtualLocation(SameVirtualLocation vloc) {
            EventGraph must = new EventGraph();
            EventGraph may = new EventGraph();
            Map<MemoryCoreEvent, VirtualMemoryObject> map = computeViltualAddressMap();
            map.forEach((e1, a1) -> map.forEach((e2, a2) -> {
                if (a1.equals(a2) && !exec.areMutuallyExclusive(e1, e2)) {
                    if (alias.mustAlias(e1, e2)) {
                        must.add(e1, e2);
                    }
                    if (alias.mayAlias(e1, e2)) {
                        may.add(e1, e2);
                    }
                }
            }));
            return new Knowledge(may, must);
        }

        private Map<MemoryCoreEvent, VirtualMemoryObject> computeViltualAddressMap() {
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
        public Knowledge visitSyncWith(SyncWith syncWith) {
            EventGraph must = new EventGraph();
            List<Event> events = new ArrayList<>(program.getThreadEventsWithAllTags(VISIBLE));
            events.removeIf(Init.class::isInstance);
            for (Event e1 : events) {
                for (Event e2 : events) {
                    Thread thread1 = e1.getThread();
                    Thread thread2 = e2.getThread();
                    if (thread1 == thread2 || !thread1.hasSyncSet()) {
                        continue;
                    }
                    if (thread1.getSyncSet().contains(thread2) && !exec.areMutuallyExclusive(e1, e2)) {
                        must.add(e1, e2);
                    }
                }
            }
            return new Knowledge(must, new EventGraph(must));
        }
    }

    private final class ExtendedPropagator implements Definition.Visitor<Map<Relation, ExtendedDelta>> {
        Relation origin;
        EventGraph disabled;
        EventGraph enabled;

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
                    map.put(o, new ExtendedDelta(disabled, EventGraph.empty()));
                }
            }
            if (operands.contains(origin)) {
                EventGraph d = new EventGraph();
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
                    EventGraph d = operands.stream()
                            .map(r -> o.equals(r) ? disabled : knowledgeMap.get(r).getMustSet())
                            .sorted(Comparator.comparingInt(EventGraph::size))
                            .reduce(EventGraph::intersection)
                            .orElseThrow();
                    map.putIfAbsent(o, new ExtendedDelta(d, enabled));
                }
            }
            if (operands.contains(origin)) {
                EventGraph e = operands.stream()
                        .map(r -> origin.equals(r) ? enabled : knowledgeMap.get(r).getMustSet())
                        .sorted(Comparator.comparingInt(EventGraph::size))
                        .reduce(EventGraph::intersection)
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
                map.put(r1, new ExtendedDelta(difference(disabled, knowledgeMap.get(r2).getMaySet()), enabled));
                //map.put(r2, new ExtendedDelta(EMPTY_SET, intersection(disabled, knowledgeMap.get(r1).getMustSet())));
            }
            if (origin.equals(r1)) {
                map.put(r0, new ExtendedDelta(disabled, difference(enabled, knowledgeMap.get(r2).getMaySet())));
            }
            if (origin.equals(r2)) {
                Knowledge k1 = knowledgeMap.get(r1);
                map.put(r0, new ExtendedDelta(intersection(enabled, k1.getMaySet()), intersection(disabled, k1.getMustSet())));
                map.put(r1, new ExtendedDelta(difference(disabled, knowledgeMap.get(r0).getMaySet()), EventGraph.empty()));
            }
            return map;
        }

        @Override
        public Map<Relation, ExtendedDelta> visitComposition(Composition comp) {
            final Relation r0 = comp.getDefinedRelation();
            final Relation r1 = comp.getLeftOperand();
            final Relation r2 = comp.getRightOperand();
            EventGraph d0 = new EventGraph();
            EventGraph e0 = new EventGraph();
            EventGraph d1 = new EventGraph();
            EventGraph d2 = new EventGraph();
            Knowledge k0 = knowledgeMap.get(r0);
            Knowledge k1 = knowledgeMap.get(r1);
            Knowledge k2 = knowledgeMap.get(r2);
            if (origin.equals(r0)) {
                Map<Event, Set<Event>> mustOut1 = k1.getMustSet().getOutMap();
                Map<Event, Set<Event>> mustIn2 = k2.getMustSet().getInMap();
                disabled.apply((x, z) -> {
                    boolean implies = exec.isImplied(x, z);
                    boolean implied = exec.isImplied(z, x);
                    for (Event y : mustOut1.getOrDefault(x, Set.of())) {
                        if ((implied || exec.isImplied(y, x)) && k2.getMaySet().contains(y, z)) {
                            d2.add(y, z);
                        }
                    }
                    for (Event y : mustIn2.getOrDefault(z, Set.of())) {
                        if ((implies || exec.isImplied(y, z)) && k1.getMaySet().contains(x, y)) {
                            d1.add(x, y);
                        }
                    }
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
            map.computeIfAbsent(r1, k -> new ExtendedDelta(d1, new EventGraph())).disabled.addAll(d1);
            map.computeIfAbsent(r2, k -> new ExtendedDelta(d2, new EventGraph())).disabled.addAll(d2);
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
            EventGraph result = new EventGraph();
            for (Event e1 : disOut1.getDomain()) {
                for (Event e : disOut1.getRange(e1)) {
                    Set<Event> e2Set = new HashSet<>(mayOut2.getRange(e));
                    e2Set.removeIf(e2 -> exec.areMutuallyExclusive(e1, e2));
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
                EventGraph enOut1,
                EventGraph mayOut2,
                EventGraph mustOut2,
                EventGraph mayOut0
        ) {
            EventGraph enOut0 = new EventGraph();
            EventGraph disOut2 = new EventGraph();
            for (Event e1 : enOut1.getDomain()) {
                for (Event e : enOut1.getRange(e1)) {
                    Set<Event> e2Set = new HashSet<>(mayOut2.getRange(e));
                    e2Set.removeIf(e2 -> exec.areMutuallyExclusive(e1, e2));
                    if (!e2Set.isEmpty()) {
                        Set<Event> e2SetCopy = new HashSet<>(e2Set);
                        e2Set.retainAll(mustOut2.getRange(e));
                        if (!exec.isImplied(e1, e)) {
                            e2Set.removeIf(e2 -> !exec.isImplied(e2, e));
                        }
                        enOut0.addRange(e1, e2Set);
                        e2SetCopy.removeAll(mayOut0.getRange(e1));
                        if (!exec.isImplied(e, e1)) {
                            e2SetCopy.removeIf(e2 -> !exec.isImplied(e2, e1));
                        }
                        disOut2.addRange(e, e2SetCopy);
                    }
                }
            }
            return List.of(enOut0, disOut2);
        }

        @Override
        public Map<Relation, ExtendedDelta> visitInverse(Inverse inv) {
            final Relation r0 = inv.getDefinedRelation();
            final Relation r1 = inv.getOperand();
            if (origin.equals(r0)) {
                return Map.of(r1, new ExtendedDelta(disabled.inverse(), EventGraph.empty()));
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
            EventGraph d0 = new EventGraph();
            EventGraph e0 = new EventGraph();
            EventGraph d1 = new EventGraph();
            Knowledge k0 = knowledgeMap.get(r0);
            Knowledge k1 = knowledgeMap.get(r1);
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
                        boolean implied = exec.isImplied(y, x);
                        boolean implies = exec.isImplied(x, y);
                        for (Event z : mayOut0.getOrDefault(y, Set.of())) {
                            if (exec.areMutuallyExclusive(x, z)) {
                                continue;
                            }
                            if ((implies || exec.isImplied(z, y)) && k0.getMustSet().contains(y, z)) {
                                e0.add(x, z);
                            }
                            if ((implied || exec.isImplied(z, x)) && !k0.getMaySet().contains(x, z)) {
                                d0.add(y, z);
                            }
                        }
                    }
                });
            }
            if (origin.equals(r0)) {
                Map<Event, Set<Event>> mustIn0 = k0.getMustSet().getInMap();
                Map<Event, Set<Event>> mayIn1 = k1.getMaySet().getInMap();
                Map<Event, Set<Event>> mustOut1 = k1.getMustSet().getOutMap();
                d1.addAll(intersection(disabled, k1.getMaySet()));
                disabled.apply((x, z) -> {
                    if (!Tuple.isLoop(x, z)) {
                        boolean implied = exec.isImplied(z, x);
                        boolean implies = exec.isImplied(x, z);
                        for (Event y : mustOut1.getOrDefault(x, Set.of())) {
                            if ((implied || exec.isImplied(y, x)) && k0.getMaySet().contains(y, z)) {
                                d0.add(y, z);
                            }
                        }
                        for (Event y : mustIn0.getOrDefault(z, Set.of())) {
                            if ((implies || exec.isImplied(y, z)) && k1.getMaySet().contains(x, y)) {
                                d1.add(x, y);
                            }
                        }
                    }
                });
                enabled.apply((y, z) -> {
                    if (!Tuple.isLoop(y, z)) {
                        boolean implied = exec.isImplied(z, y);
                        boolean implies = exec.isImplied(y, z);
                        for (Event x : mayIn1.getOrDefault(y, Set.of())) {
                            if (exec.areMutuallyExclusive(x, z)) {
                                continue;
                            }
                            if ((implied || exec.isImplied(x, y)) && k1.getMustSet().contains(x, y)) {
                                e0.add(x, z);
                            }
                            if ((implies || exec.isImplied(x, z)) && !k0.getMaySet().contains(x, z)) {
                                d1.add(x, y);
                            }
                        }
                    }
                });
            }
            return Map.of(
                    r0, new ExtendedDelta(d0, e0),
                    r1, new ExtendedDelta(d1, EventGraph.empty()));
        }

        @Override
        public Map<Relation, ExtendedDelta> visitCoherence(Coherence coDef) {
            if (disabled.isEmpty()) {
                return Map.of();
            }
            //TODO use transitivity
            EventGraph e = new EventGraph();
            disabled.apply((x, y) -> {
                if (alias.mustAlias((MemoryCoreEvent) x, (MemoryCoreEvent) y)) {
                    e.add(y, x);
                }
            });
            return Map.of(coDef.getDefinedRelation(), new ExtendedDelta(EventGraph.empty(), e));
        }
    }

    private static List<Event> visibleEvents(Thread t) {
        return t.getEvents().stream().filter(e -> e.hasTag(VISIBLE)).toList();
    }

    @Override
    public long countMaySet() {
        return knowledgeMap.values().stream().mapToLong(k -> k.getMaySet().size()).sum();
    }

    @Override
    public long countMustSet() {
        return knowledgeMap.values().stream().mapToLong(k -> k.getMustSet().size()).sum();
    }

    protected static final class Delta {
        public static final Delta EMPTY = new Delta(EventGraph.empty(), EventGraph.empty());

        public final EventGraph may;
        public final EventGraph must;

        public Delta(EventGraph maySet, EventGraph mustSet) {
            may = maySet;
            must = mustSet;
        }

        public static Delta combine(List<Delta> deltas) {
            if (deltas.size() == 1) {
                return deltas.get(0);
            }
            EventGraph mayDelta = new EventGraph();
            EventGraph mustDelta = new EventGraph();
            for (Delta d : deltas) {
                mayDelta.addAll(d.may);
                mustDelta.addAll(d.must);
            }
            return new Delta(mayDelta, mustDelta);
        }
    }

    //FIXME should be visible only to implementations of Constraint
    private static final class ExtendedDelta {
        final EventGraph disabled;
        final EventGraph enabled;

        public ExtendedDelta(EventGraph d, EventGraph e) {
            disabled = d;
            enabled = e;
        }
    }

    protected final class Propagator implements Definition.Visitor<Delta> {
        private Relation source;
        private EventGraph may;
        private EventGraph must;

        public Relation getSource() {
            return source;
        }

        public void setSource(Relation source) {
            this.source = source;
        }

        public EventGraph getMay() {
            return may;
        }

        public void setMay(EventGraph may) {
            this.may = may;
        }

        public EventGraph getMust() {
            return must;
        }

        public void setMust(EventGraph must) {
            this.must = must;
        }

        @Override
        public Delta visitUnion(Union union) {
            if (union.getOperands().contains(source)) {
                return new Delta(may, must);
            }
            return Delta.EMPTY;
        }

        @Override
        public Delta visitIntersection(Intersection inter) {
            final List<Relation> operands = inter.getOperands();
            if (operands.contains(source)) {
                EventGraph maySet = operands.stream()
                        .map(r -> source.equals(r) ? may : getKnowledge(r).getMaySet())
                        .sorted(Comparator.comparingInt(EventGraph::size))
                        .reduce(EventGraph::intersection)
                        .orElseThrow();
                EventGraph mustSet = operands.stream()
                        .map(r -> source.equals(r) ? must : getKnowledge(r).getMustSet())
                        .sorted(Comparator.comparingInt(EventGraph::size))
                        .reduce(EventGraph::intersection)
                        .orElseThrow();
                return new Delta(maySet, mustSet);
            }
            return Delta.EMPTY;
        }

        @Override
        public Delta visitDifference(Difference diff) {
            if (diff.getMinuend().equals(source)) {
                Knowledge k = getKnowledge(diff.getSubtrahend());
                return new Delta(difference(may, k.getMustSet()), difference(must, k.getMaySet()));
            }
            return Delta.EMPTY;
        }

        @Override
        public Delta visitComposition(Composition comp) {
            final Relation r1 = comp.getLeftOperand();
            final Relation r2 = comp.getRightOperand();
            EventGraph maySet = new EventGraph();
            EventGraph mustSet = new EventGraph();
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

        private void computeComposition(EventGraph result, EventGraph left, EventGraph right, final boolean isMay) {
            for (Event e1 : left.getDomain()) {
                Set<Event> update = new HashSet<>();
                for (Event e : left.getRange(e1)) {
                    if (isMay || exec.isImplied(e1, e)) {
                        update.addAll(right.getRange(e));
                    } else {
                        update.addAll(right.getRange(e).stream()
                                .filter(e2 -> exec.isImplied(e2, e)).toList());
                    }
                }
                update.removeIf(e -> exec.areMutuallyExclusive(e1, e));
                result.addRange(e1, update);
            }
        }

        @Override
        public Delta visitDomainIdentity(DomainIdentity domId) {
            if (domId.getOperand().equals(source)) {
                EventGraph maySet = new EventGraph();
                may.getDomain().forEach(e -> maySet.add(e, e));
                EventGraph mustSet = new EventGraph();
                must.apply((e1, e2) -> {
                    if (exec.isImplied(e1, e2)) {
                        mustSet.add(e1, e1);
                    }
                });
                return new Delta(maySet, mustSet);
            }
            return Delta.EMPTY;
        }

        @Override
        public Delta visitRangeIdentity(RangeIdentity rangeId) {
            if (rangeId.getOperand().equals(source)) {
                EventGraph maySet = new EventGraph();
                may.getRange().forEach(e -> maySet.add(e, e));
                EventGraph mustSet = new EventGraph();
                must.apply((e1, e2) -> {
                    if (exec.isImplied(e2, e1)) {
                        mustSet.add(e2, e2);
                    }
                });
                return new Delta(maySet, mustSet);
            }
            return Delta.EMPTY;
        }

        @Override
        public Delta visitInverse(Inverse inv) {
            if (inv.getOperand().equals(source)) {
                return new Delta(may.inverse(), must.inverse());
            }
            return Delta.EMPTY;
        }

        @Override
        public Delta visitTransitiveClosure(TransitiveClosure trans) {
            final Relation rel = trans.getDefinedRelation();
            if (trans.getOperand().equals(source)) {
                EventGraph maySet = computeTransitiveClosure(getKnowledge(rel).getMaySet(), may, true);
                EventGraph mustSet = computeTransitiveClosure(getKnowledge(rel).getMustSet(), must, false);
                return new Delta(maySet, mustSet);
            }
            return Delta.EMPTY;
        }

        private EventGraph computeTransitiveClosure(EventGraph oldOuter, EventGraph inner, boolean isMay) {
            EventGraph outer = new EventGraph(oldOuter);
            EventGraph update = inner.filter(outer::add);
            EventGraph updateComposition = new EventGraph();
            computeComposition(updateComposition, inner, oldOuter, isMay);
            update.addAll(updateComposition.filter(outer::add));
            while (!update.isEmpty()) {
                EventGraph t = new EventGraph();
                computeComposition(t, inner, update, isMay);
                update = t.filter(outer::add);
            }
            return outer;
        }
    }
}
