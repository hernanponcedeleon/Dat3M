package com.dat3m.dartagnan.wmm.analysis;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Register.UsageType;
import com.dat3m.dartagnan.program.ScopedThread.ScopedThread;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.BranchEquivalence;
import com.dat3m.dartagnan.program.analysis.Dependency;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.arch.ptx.PTXFenceWithId;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.rmw.RMWStore;
import com.dat3m.dartagnan.program.event.core.rmw.RMWStoreExclusive;
import com.dat3m.dartagnan.program.event.core.threading.ThreadStart;
import com.dat3m.dartagnan.program.event.core.utils.RegReader;
import com.dat3m.dartagnan.program.event.lang.svcomp.EndAtomic;
import com.dat3m.dartagnan.program.filter.Filter;
import com.dat3m.dartagnan.program.memory.VirtualMemoryObject;
import com.dat3m.dartagnan.utils.collections.SetUtil;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Constraint;
import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.google.common.collect.Comparators;
import com.google.common.collect.Sets;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.util.*;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.stream.IntStream;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.configuration.Arch.RISCV;
import static com.dat3m.dartagnan.configuration.OptionNames.*;
import static com.dat3m.dartagnan.program.Register.UsageType.*;
import static com.dat3m.dartagnan.program.event.Tag.*;
import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.CO;
import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.RF;
import static com.google.common.base.Preconditions.checkNotNull;
import static com.google.common.base.Preconditions.checkState;
import static com.google.common.base.Verify.verify;
import static com.google.common.collect.Lists.reverse;
import static com.google.common.collect.Sets.difference;
import static com.google.common.collect.Sets.intersection;
import static java.util.stream.Collectors.toList;
import static java.util.stream.Collectors.toSet;

@Options
public class RelationAnalysis {

    private static final Logger logger = LogManager.getLogger(RelationAnalysis.class);

    private static final Set<Tuple> EMPTY_SET = new HashSet<>();
    private static final Delta EMPTY = new Delta(EMPTY_SET, EMPTY_SET);

    private final VerificationTask task;
    private final Context analysisContext;
    private final ExecutionAnalysis exec;
    private final AliasAnalysis alias;
    private final Dependency dep;
    private final WmmAnalysis wmmAnalysis;
    private final Map<Relation, Knowledge> knowledgeMap = new HashMap<>();
    private final Set<Tuple> mutex = new HashSet<>();

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

        final StringBuilder configSummary = new StringBuilder().append("\n");
        configSummary.append("\t").append(ENABLE_RELATION_ANALYSIS).append(": ").append(a.enable).append("\n");
        configSummary.append("\t").append(ENABLE_MUST_SETS).append(": ").append(a.enableMustSets).append("\n");
        configSummary.append("\t").append(ENABLE_EXTENDED_RELATION_ANALYSIS).append(": ").append(a.enableExtended);
        logger.info(configSummary);

        if (a.enableMustSets && !a.enable) {
            logger.warn("{} implies {}", ENABLE_MUST_SETS, ENABLE_RELATION_ANALYSIS);
            a.enableMustSets = false;
        }
        if (a.enableExtended && !a.enable) {
            logger.warn("{} implies {}", ENABLE_EXTENDED_RELATION_ANALYSIS, ENABLE_RELATION_ANALYSIS);
            a.enableExtended = false;
        }

        long t0 = System.currentTimeMillis();
        a.run();
        long t1 = System.currentTimeMillis();
        logger.info("Finished regular analysis in {}ms", t1 - t0);

        final StringBuilder summary = new StringBuilder()
                .append("\n======== RelationAnalysis summary ======== \n");
        summary.append("\t#Relations: ").append(task.getMemoryModel().getRelations().size()).append("\n");
        summary.append("\t#Axioms: ").append(task.getMemoryModel().getAxioms().size()).append("\n");
        if (a.enableExtended) {
            long mayCount = a.countMaySet();
            long mustCount = a.countMustSet();
            a.runExtended();
            logger.info("Finished extended analysis in {}ms", System.currentTimeMillis() - t1);
            summary.append("\t#may-tuples removed (extended): ").append(mayCount - a.countMaySet()).append("\n");
            summary.append("\t#must-tuples added (extended): ").append(a.countMustSet() - mustCount).append("\n");
        }
        verify(a.enableMustSets || a.knowledgeMap.values().stream().allMatch(k -> k.must.isEmpty()));
        Knowledge rf = a.knowledgeMap.get(task.getMemoryModel().getRelation(RF));
        Knowledge co = a.knowledgeMap.get(task.getMemoryModel().getRelation(CO));
        summary.append("\ttotal #must|may|exclusive tuples: ")
                .append(a.countMustSet()).append("|").append(a.countMaySet()).append("|").append(a.mutex.size()).append("\n");
        summary.append("\t#must|may rf tuples: ").append(rf.must.size()).append("|").append(rf.may.size()).append("\n");
        summary.append("\t#must|may co tuples: ").append(co.must.size()).append("|").append(co.may.size()).append("\n");
        summary.append("===========================================");
        logger.info(summary);
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

    /**
     * Iterates those event pairs that, if both executed, violate some axiom of the memory model.
     */
    public Set<Tuple> getMutuallyExclusiveTuples() {
        //TODO return undirected pairs
        return Set.copyOf(mutex);
    }

    /*
        Returns a set of edges (e1, e2) (subset of may set) for ordered relations whose
        clock-constraints do not need to get encoded explicitly.
        e.g. for co relation: (e1 = w1, e2 = w2)
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
        final Function<Event, Collection<Tuple>> mustIn = k.getMustIn();
        final Function<Event, Collection<Tuple>> mustOut = k.getMustOut();
        for (final Tuple t : k.may) {
            final MemoryEvent x = (MemoryEvent) t.getFirst();
            final MemoryEvent z = (MemoryEvent) t.getSecond();
            final boolean hasIntermediary = mustOut.apply(x).stream().map(Tuple::getSecond)
                    .anyMatch(y -> y != x && y != z &&
                            (implies(y, x) || implies(y, z)) &&
                            !k.containsMay(new Tuple(z, y))) ||
                    mustIn.apply(z).stream().map(Tuple::getFirst)
                            .anyMatch(y -> y != x && y != z &&
                                    (implies(y, x) || implies(y, z)) &&
                                    !k.containsMay(new Tuple(y, x)));
            if (hasIntermediary) {
                transCo.add(t);
            }
        }
        return transCo;
    }

    private void run() {
        logger.trace("Start");
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
            logger.trace("Regular analysis for component {}", scc);
            Set<Relation> stratum = scc.stream().map(DependencyGraph.Node::getContent).collect(toSet());
            if (!enable && stratum.stream().noneMatch(Relation::isInternal)) {
                continue;
            }
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
                Delta delta = knowledgeMap.get(relation).joinSet(qLocal.remove(relation));
                if (delta.may.isEmpty() && delta.must.isEmpty()) {
                    continue;
                }
                propagator.source = relation;
                propagator.may = delta.may;
                propagator.must = delta.must;
                for (Definition c : dependents.getOrDefault(relation, List.of())) {
                    logger.trace("Regular propagation from '{}' to '{}'", relation, c);
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
        verify(!enable || qGlobal.isEmpty(), "knowledge buildup propagated downwards");
        logger.trace("End");
    }

    public static final class Knowledge {

        private final Set<Tuple> mayExplicit;
        private final Set<Tuple> mustExplicit;
        private final Set<Tuple> may;
        private final Set<Tuple> must;
        private final Function<Event, Collection<Event>> mayIn;
        private final Function<Event, Collection<Event>> mustIn;
        private final Function<Event, Collection<Event>> mayOut;
        private final Function<Event, Collection<Event>> mustOut;

        private Knowledge(Set<Tuple> maySet, Set<Tuple> mustSet) {
            may = mayExplicit = checkNotNull(maySet);
            must = mustExplicit = checkNotNull(mustSet);
            mayIn = mustIn = y -> Set.of();
            mayOut = mustOut = x -> Set.of();
        }

        private Knowledge(Set<Tuple> mayImplicit, Set<Tuple> mustImplicit,
                          Function<Event, Collection<Event>> mayIn, Function<Event, Collection<Event>> mayOut,
                          Function<Event, Collection<Event>> mustIn, Function<Event, Collection<Event>> mustOut) {
            this.mayExplicit = new HashSet<>();
            this.mustExplicit = new HashSet<>();
            this.may = SetUtil.groundedSet(this.mayExplicit, mayImplicit);
            this.must = SetUtil.groundedSet(this.mustExplicit, mustImplicit);
            this.mayIn = mayIn;
            this.mayOut = mayOut;
            this.mustIn = mustIn;
            this.mustOut = mustOut;
        }

        public Set<Tuple> getMaySet() {
            return may;
        }

        public boolean containsMay(Tuple t) {
            return may.contains(t);
        }

        public Function<Event, Collection<Tuple>> getMayIn() {
            return getIn(mayExplicit, mayIn);
        }

        public Function<Event, Collection<Tuple>> getMayOut() {
            return getOut(mayExplicit, mayOut);
        }

        public Set<Tuple> getMustSet() {
            return must;
        }

        public boolean containsMust(Tuple t) {
            return must.contains(t);
        }

        public Function<Event, Collection<Tuple>> getMustIn() {
            return getIn(mustExplicit, mustIn);
        }

        public Function<Event, Collection<Tuple>> getMustOut() {
            return getOut(mustExplicit, mustOut);
        }

        private static Function<Event, Collection<Tuple>> getIn(Set<Tuple> set, Function<Event, Collection<Event>> inFunction) {
            final var map = new HashMap<Event, Collection<Tuple>>();
            for (final Tuple t : set) {
                map.computeIfAbsent(t.getSecond(), k -> new ArrayList<>()).add(t);
            }
            return e -> new InOutSet(map.getOrDefault(e, List.of()), inFunction.apply(e), e, true);
        }

        private static Function<Event, Collection<Tuple>> getOut(Set<Tuple> set, Function<Event, Collection<Event>> outFunction) {
            final var map = new HashMap<Event, Collection<Tuple>>();
            for (final Tuple t : set) {
                map.computeIfAbsent(t.getFirst(), k -> new ArrayList<>()).add(t);
            }
            return e -> new InOutSet(map.getOrDefault(e, List.of()), outFunction.apply(e), e, false);
        }

        @Override
        public String toString() {
            if (may == must) {
                return "(may=must: " + must.size() + ")";
            }
            return "(may: " + may.size() + ", must:" + must.size() + ")";
        }

        private Delta joinSet(List<Delta> l) {
            verify(!l.isEmpty(), "empty update");
            // NOTE optimization due to initial deltas carrying references to knowledge sets
            Set<Tuple> maySet = may.isEmpty() || l.get(0).may == may ? may : new HashSet<>();
            Set<Tuple> mustSet = must.isEmpty() || l.get(0).must == must ? must : new HashSet<>();
            for (Delta d : l) {
                for (Tuple t : d.may) {
                    if (!mayImplicit.contains(t) && may.add(t)) {
                        maySet.add(t);
                    }
                }
                for (Tuple t : d.must) {
                    if (!mustImplicit.contains(t) && must.add(t)) {
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
                    try {
                        if (may.remove(t)) {
                            disableSet.add(t);
                        }
                    } catch (UnsupportedOperationException e) {
                        final String message = String.format("Contradiction with implicit knowledge about tuple %s", t);
                        throw new IllegalStateException(message, e);
                    }
                }
                for (Tuple t : Set.copyOf(d.enabled)) {
                    if (!mustImplicit.contains(t) && must.add(t)) {
                        enableSet.add(t);
                    }
                }
            }
            return new ExtendedDelta(disableSet, enableSet);
        }
    }

    private void runExtended() {
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
                    c.computeInitialKnowledgeClosure(knowledgeMap, analysisContext).entrySet()) {
                q.computeIfAbsent(e.getKey(), k -> new ArrayList<>()).add(e.getValue());
            }
        }
        ExtendedPropagator propagator = new ExtendedPropagator();
        // repeat until convergence
        while (!q.isEmpty()) {
            Relation relation = q.keySet().iterator().next();
            logger.trace("Extended knowledge update for '{}'", relation);
            Knowledge knowledge = knowledgeMap.get(relation);
            ExtendedDelta delta = knowledge.join(q.remove(relation));
            if (delta.disabled.isEmpty() && delta.enabled.isEmpty()) {
                continue;
            }
            mutex.addAll(difference(delta.enabled, knowledge.may));
            mutex.addAll(intersection(delta.disabled, knowledge.must));
            propagator.origin = relation;
            Set<Tuple> disabled = propagator.disabled = delta.disabled;
            Set<Tuple> enabled = propagator.enabled = delta.enabled;
            for (Constraint c : dependents.getOrDefault(relation, List.of())) {
                logger.trace("Extended propagation from '{}' to '{}'", relation, c);
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
        logger.trace("End");
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
                List<Event> events = program.getThreadEvents().stream().filter(e -> e.hasTag(VISIBLE)).toList();
                Set<Tuple> may = new AbstractSet<>() {
                    @Override
                    public Iterator<Tuple> iterator() {
                        return events.stream()
                                .flatMap(x -> events.stream()
                                        .map(y -> new Tuple(x, y)))
                                .iterator();
                    }
                    @Override
                    public int size() {
                        return events.size() * events.size();
                    }
                    @Override
                    public boolean contains(Object o) {
                        // Assume both events are in this program.
                        return o instanceof Tuple;
                    }
                };
                Function<Event, Collection<Event>> full = e -> events;
                Function<Event, Collection<Event>> empty = e -> Set.of();
                defaultKnowledge = new Knowledge(may, EMPTY_SET, full, full, empty, empty);
            }
        }

        @Override
        public Knowledge visitDefinition(Relation r, List<? extends Relation> d) {
            return defaultKnowledge != null && !r.isInternal() ? defaultKnowledge : new Knowledge(new HashSet<>(), new HashSet<>());
        }

        private final class ProductSet extends AbstractSet<Tuple> {

            private final Filter domain;
            private final Filter range;
            private final List<Event> domainEvents;
            private final List<Event> rangeEvents;

            private ProductSet(Filter d, Filter r, List<Event> domainEvents, List<Event> rangeEvents) {
                domain = d;
                range = r;
                this.domainEvents = domainEvents;
                this.rangeEvents = rangeEvents;
            }

            @Override
            public Iterator<Tuple> iterator() {
                return domainEvents.stream()
                        .flatMap(x -> rangeEvents.stream()
                                .filter(notExclusive(x))
                                .map(y -> new Tuple(x, y)))
                        .iterator();
            }

            @Override
            public int size() {
                return domainEvents.stream()
                        .mapToInt(x -> (int) rangeEvents.stream()
                                .filter(notExclusive(x))
                                .count())
                        .sum();
            }

            @Override
            public boolean contains(Object o) {
                return o instanceof Tuple tuple &&
                        domain.apply(tuple.getFirst()) &&
                        range.apply(tuple.getSecond()) &&
                        notExclusive(tuple);
            }
        }

        private List<Event> getIfNotExcluded(Event event, List<Event> range, Filter domain) {
            if (!domain.apply(event)) {
                return List.of();
            }
            return range.stream().filter(notExclusive(event)).collect(toList());
        }

        @Override
        public Knowledge visitProduct(Relation rel, Filter domain, Filter range) {
            List<Event> domainEvents = program.getThreadEvents().stream().filter(domain::apply).toList();
            List<Event> rangeEvents = program.getThreadEvents().stream().filter(range::apply).toList();
            Set<Tuple> set = new ProductSet(domain, range, domainEvents, rangeEvents);
            Function<Event, Collection<Event>> mayIn = e -> getIfNotExcluded(e, domainEvents, range);
            Function<Event, Collection<Event>> mayOut = e -> getIfNotExcluded(e, rangeEvents, domain);
            Function<Event, Collection<Event>> mustIn = enableMustSets ? mayIn : e -> List.of();
            Function<Event, Collection<Event>> mustOut = enableMustSets ? mayOut : e -> List.of();
            return new Knowledge(set, enableMustSets ? set : EMPTY_SET, mayIn, mayOut, mustIn, mustOut);
        }

        @Override
        public Knowledge visitIdentity(Relation rel, Filter set) {
            Set<Tuple> must = new HashSet<>();
            for (Event e : program.getThreadEvents()) {
                if (set.apply(e)) {
                    must.add(new Tuple(e, e));
                }
            }
            return new Knowledge(must, enableMustSets ? new HashSet<>(must) : EMPTY_SET);
        }

        private final class ExternalSet extends AbstractSet<Tuple> {

            @Override
            public Iterator<Tuple> iterator() {
                // No test for exec.areMutuallyExclusive, since that currently does not span across threads.
                // This stream-based approach might be more expensive than writing an own iterator.
                List<Thread> threads = program.getThreads();
                return threads.stream()
                        .flatMap(t1 -> threads.stream()
                                .filter(t2 -> !t1.equals(t2))
                                .flatMap(t2 -> visibleEvents(t2).stream()
                                        .flatMap(y -> visibleEvents(t1).stream()
                                                .map(x -> new Tuple(x, y)))))
                        .iterator();
            }

            @Override
            public int size() {
                int sum = 0;
                int excluded = 0;
                for (Thread thread : program.getThreads()) {
                    int size = visibleEvents(thread).size();
                    sum += size;
                    excluded += size * size;
                }
                return sum * sum - excluded;
            }

            @Override
            public boolean contains(Object o) {
                // Assume both events are in this program.
                return o instanceof Tuple tuple && tuple.isCrossThread();
            }
        }

        private final class ExternalOutSet extends AbstractCollection<Event> {

            private final Thread thread;

            private ExternalOutSet(Event e) {
                thread = e.getThread();
            }

            @Override
            public Iterator<Event> iterator() {
                // No test for exec.areMutuallyExclusive, since that currently does not span across threads.
                return program.getThreads().stream().filter(t -> !thread.equals(t))
                        .flatMap(t -> visibleEvents(t).stream())
                        .iterator();
            }

            @Override
            public int size() {
                return program.getThreads().stream()
                        .filter(t -> !thread.equals(t)).mapToInt(t -> visibleEvents(t).size())
                        .sum();
            }
        }

        @Override
        public Knowledge visitExternal(Relation rel) {
            Set<Tuple> view = new ExternalSet();
            Function<Event, Collection<Event>> mayInOut = ExternalOutSet::new;
            Function<Event, Collection<Event>> mustInOut = enableMustSets ? mayInOut : e -> Set.of();
            return new Knowledge(view, enableMustSets ? view : EMPTY_SET, mayInOut, mayInOut, mustInOut, mustInOut);
        }

        private final class InternalSet extends AbstractSet<Tuple> {

            @Override
            public Iterator<Tuple> iterator() {
                return program.getThreads().stream()
                        .map(RelationAnalysis::visibleEvents)
                        .flatMap(t -> t.stream()
                                .flatMap(x -> t.stream()
                                        .filter(notExclusive(x))
                                        .map(y -> new Tuple(x ,y))))
                        .iterator();
            }

            @Override
            public int size() {
                // Note that areMutuallyExclusive is symmetric
                int sum = 0;
                for (Thread thread : program.getThreads()) {
                    List<Event> events = visibleEvents(thread);
                    for (int i = 0; i < events.size(); i++) {
                        Event event = events.get(i);
                        long count = events.subList(0, i).stream().filter(notExclusive(event)).count();
                        sum += 1 + 2 * (int) count;
                    }
                }
                return sum;
            }

            @Override
            public boolean contains(Object o) {
                return o instanceof Tuple tuple && tuple.isSameThread() && notExclusive(tuple);
            }
        }

        private List<Event> getInternal(Event x) {
            if (!x.hasTag(VISIBLE)) {
                return List.of();
            }
            return x.getThread().getEvents().stream()
                    .filter(y -> y.hasTag(VISIBLE) && notExclusive(x, y))
                    .collect(toList());
        }

        @Override
        public Knowledge visitInternal(Relation rel) {
            Set<Tuple> view = new InternalSet();
            Function<Event, Collection<Event>> may = this::getInternal;
            Function<Event, Collection<Event>> must = enableMustSets ? may : e -> List.of();
            return new Knowledge(view, enableMustSets ? view : EMPTY_SET, may, may, must, must);
        }

        private final class ProgramOrderSet extends AbstractSet<Tuple> {

            private final Filter domain;

            private ProgramOrderSet(Filter d) {
                domain = d;
            }

            @Override
            public Iterator<Tuple> iterator() {
                return program.getThreads().stream()
                        .map(t -> t.getEvents().stream().filter(domain::apply).collect(toList()))
                        .flatMap(t -> IntStream.range(0, t.size())
                                .mapToObj(i -> t.subList(0, i).stream()
                                        .filter(notExclusive(t.get(i)))
                                        .map(x -> new Tuple(x, t.get(i))))
                                .flatMap(s -> s))
                        .iterator();
            }

            @Override
            public int size() {
                int sum = 0;
                for (Thread thread : program.getThreads()) {
                    List<Event> events = visibleEvents(thread).stream().filter(domain::apply).toList();
                    for (int i = 0; i < events.size(); i++) {
                        Event event = events.get(i);
                        sum += (int) events.subList(0, i).stream().filter(notExclusive(event)).count();
                    }
                }
                return sum;
            }

            @Override
            public boolean contains(Object o) {
                return o instanceof Tuple tuple &&
                        tuple.isForward() &&
                        domain.apply(tuple.getFirst()) &&
                        domain.apply(tuple.getSecond()) &&
                        notExclusive(tuple);
            }
        }

        private List<Event> getProgramOrderedBefore(Event event) {
            List<Event> events = event.getThread().getEvents();
            return events.subList(0, getThreadIndex(event, events)).stream()
                    .filter(notExclusive(event))
                    .collect(toList());
        }

        private List<Event> getProgramOrderedAfter(Event event) {
            List<Event> events = event.getThread().getEvents();
            return events.subList(getThreadIndex(event, events) + 1, events.size()).stream()
                    .filter(notExclusive(event))
                    .collect(toList());
        }

        @Override
        public Knowledge visitProgramOrder(Relation rel, Filter type) {
            Set<Tuple> view = new ProgramOrderSet(type);
            Function<Event, Collection<Event>> mayIn = this::getProgramOrderedBefore;
            Function<Event, Collection<Event>> mayOut = this::getProgramOrderedAfter;
            Function<Event, Collection<Event>> mustIn = enableMustSets ? mayIn : e -> List.of();
            Function<Event, Collection<Event>> mustOut = enableMustSets ? mayOut : e -> List.of();
            return new Knowledge(view, enableMustSets ? view : EMPTY_SET, mayIn, mayOut, mustIn, mustOut);
        }

        @Override
        public Knowledge visitControl(Relation rel) {
            //TODO: We can restrict the codomain to visible events as the only usage of this Relation is in
            // ctrl := idd^+;ctrlDirect & (R*V)
            Set<Tuple> must = new HashSet<>();
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
                        if (notExclusive(jump, e)) {
                            must.add(new Tuple(jump, e));
                        }
                    }
                }
            }
            return new Knowledge(must, enableMustSets ? new HashSet<>(must) : EMPTY_SET);
        }

        @Override
        public Knowledge visitAddressDependency(Relation rel) {
            return computeInternalDependencies(EnumSet.of(ADDR));
        }

        @Override
        public Knowledge visitInternalDataDependency(Relation rel) {
            // FIXME: Our "internal data dependency" relation is quite odd an contains all but address dependencies.
            return computeInternalDependencies(EnumSet.of(DATA, CTRL, OTHER));
        }

        @Override
        public Knowledge visitFences(Relation rel, Filter fence) {
            Set<Tuple> may = new HashSet<>();
            Set<Tuple> must = new HashSet<>();
            for (Thread t : program.getThreads()) {
                List<Event> events = visibleEvents(t);
                int end = events.size();
                for (int i = 0; i < end; i++) {
                    Event f = events.get(i);
                    if (!fence.apply(f)) {
                        continue;
                    }
                    for (Event x : events.subList(0, i)) {
                        if (notExclusive(x, f)) {
                            continue;
                        }
                        boolean implies = enableMustSets && implies(f, x);
                        for (Event y : events.subList(i + 1, end)) {
                            if (exclusive(x, y) || exclusive(f, y)) {
                                continue;
                            }
                            Tuple xy = new Tuple(x, y);
                            may.add(xy);
                            if (implies || enableMustSets && implies(f, y)) {
                                must.add(xy);
                            }
                        }
                    }
                }
            }
            return new Knowledge(may, enableMustSets ? must : EMPTY_SET);
        }

        @Override
        public Knowledge visitCompareAndSwapDependency(Relation rel) {
            Set<Tuple> must = new HashSet<>();
            for (Event e : program.getThreadEvents()) {
                if (e.hasTag(IMM.CASDEPORIGIN)) {
                    // The target of a CASDep is always the successor of the origin
                    must.add(new Tuple(e, e.getSuccessor()));
                }
            }
            return new Knowledge(must, enableMustSets ? new HashSet<>(must) : EMPTY_SET);
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
                List<Event> locks = reverse(thread.getEvents().stream().filter(e -> e.hasTag(Linux.RCU_LOCK)).collect(toList()));
                for (Event unlock : thread.getEvents()) {
                    if (!unlock.hasTag(Linux.RCU_UNLOCK)) {
                        continue;
                    }
                    // iteration order assures that all intermediaries were already iterated
                    for (Event lock : locks) {
                        if (unlock.getGlobalId() < lock.getGlobalId() ||
                                exclusive(lock, unlock) ||
                                Stream.concat(mustMap.getOrDefault(lock, Set.of()).stream(),
                                                mustMap.getOrDefault(unlock, Set.of()).stream())
                                        .anyMatch(e -> implies(e, lock) || implies(e, unlock))) {
                            continue;
                        }
                        boolean noIntermediary = enableMustSets &&
                                mayMap.getOrDefault(unlock, Set.of()).stream()
                                        .allMatch(e -> exclusive(lock, e)) &&
                                mayMap.getOrDefault(lock, Set.of()).stream()
                                        .allMatch(e -> exclusive(e, unlock));
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
            return new Knowledge(may, enableMustSets ? must : EMPTY_SET);
        }

        @Override
        public Knowledge visitReadModifyWrites(Relation rel) {
            //NOTE: Changes to the semantics of this method may need to be reflected in RMWGraph for Refinement!
            // ----- Compute must set -----
            Set<Tuple> must = new HashSet<>();
            // RMWLoad -> RMWStore
            for (RMWStore store : program.getThreadEvents(RMWStore.class)) {
                must.add(new Tuple(store.getLoadEvent(), store));
            }

            // Atomics blocks: BeginAtomic -> EndAtomic
            for (EndAtomic end : program.getThreadEvents(EndAtomic.class)) {
                List<Event> block = end.getBlock().stream().filter(x -> x.hasTag(VISIBLE)).toList();
                for (int i = 0; i < block.size(); i++) {
                    Event e = block.get(i);
                    for (int j = i + 1; j < block.size(); j++) {
                        if (notExclusive(e, block.get(j))) {
                            must.add(new Tuple(e, block.get(j)));
                        }
                    }
                }
            }
            // ----- Compute may set -----
            Set<Tuple> may = new HashSet<>(must);
            // LoadExcl -> StoreExcl
            for (Thread thread : program.getThreads()) {
                List<Event> events = thread.getEvents().stream().filter(e -> e.hasTag(EXCL)).toList();
                // assume order by globalId
                // assume globalId describes a topological sorting over the control flow
                for (int end = 1; end < events.size(); end++) {
                    if (!(events.get(end) instanceof RMWStoreExclusive store)) {
                        continue;
                    }
                    int start = IntStream.iterate(end - 1, i -> i >= 0, i -> i - 1)
                            .filter(i -> implies(events.get(i), store))
                            .findFirst().orElse(0);
                    List<Event> candidates = events.subList(start, end).stream()
                            .filter(notExclusive(store))
                            .collect(toList());
                    int size = candidates.size();
                    for (int i = 0; i < size; i++) {
                        Event load = candidates.get(i);
                        List<Event> intermediaries = candidates.subList(i + 1, size);
                        if (!(load instanceof Load) || intermediaries.stream().anyMatch(e -> implies(e, load))) {
                            continue;
                        }
                        Tuple tuple = new Tuple(load, store);
                        may.add(tuple);
                        if (enableMustSets &&
                                intermediaries.stream().allMatch(e -> exclusive(load, e)) &&
                                (store.doesRequireMatchingAddresses() || alias.mustAlias((Load) load, store))) {
                            must.add(tuple);
                        }
                    }
                }
            }
            return new Knowledge(may, enableMustSets ? must : EMPTY_SET);
        }

        @Override
        public Knowledge visitCoherence(Relation rel) {
            logger.trace("Computing knowledge about memory order");
            List<Store> nonInitWrites = program.getThreadEvents(Store.class);
            nonInitWrites.removeIf(Init.class::isInstance);
            Set<Tuple> may = new HashSet<>();
            for (Store w1 : program.getThreadEvents(Store.class)) {
                for (Store w2 : nonInitWrites) {
                    if (w1.getGlobalId() != w2.getGlobalId() && notExclusive(w1, w2)
                            && alias.mayAlias(w1, w2)) {
                        may.add(new Tuple(w1, w2));
                    }
                }
            }
            Set<Tuple> must = new HashSet<>();
            for (Tuple t : enableMustSets ? may : Set.<Tuple>of()) {
                MemoryCoreEvent w1 = (MemoryCoreEvent) t.getFirst();
                MemoryCoreEvent w2 = (MemoryCoreEvent) t.getSecond();
                if (!w2.hasTag(INIT) && alias.mustAlias(w1, w2) && w1.hasTag(INIT)) {
                    must.add(t);
                }
            }
            if (wmmAnalysis.isLocallyConsistent()) {
                may.removeIf(Tuple::isBackward);
                for (Tuple t : enableMustSets ? may : Set.<Tuple>of()) {
                    MemoryCoreEvent w1 = (MemoryCoreEvent) t.getFirst();
                    MemoryCoreEvent w2 = (MemoryCoreEvent) t.getSecond();
                    if (alias.mustAlias(w1, w2) && t.isForward()) {
                        must.add(t);
                    }
                }
            }
            logger.debug("Initial may set size for memory order: {}", may.size());
            return new Knowledge(may, enableMustSets ? must : EMPTY_SET);
        }

        @Override
        public Knowledge visitReadFrom(Relation rel) {
            logger.trace("Computing knowledge about read-from");
            final BranchEquivalence eq = analysisContext.requires(BranchEquivalence.class);
            Set<Tuple> may = new HashSet<>();
            Set<Tuple> must = new HashSet<>();
            List<Load> loadEvents = program.getThreadEvents(Load.class);
            for (Store e1 : program.getThreadEvents(Store.class)) {
                for (Load e2 : loadEvents) {
                    if (alias.mayAlias(e1, e2) && notExclusive(e1, e2)) {
                        may.add(new Tuple(e1, e2));
                    }
                }
            }

            // Here we add must-rf edges between loads/stores that synchronize threads.
            for (Thread thread : program.getThreads()) {
                final ThreadStart start = thread.getEntry();
                if (!start.isSpawned()) {
                    continue;
                }

                // Must-rf edge for thread spawning
                Event cur = start;
                while (!(cur instanceof Load startLoad)) { cur = cur.getSuccessor(); }
                cur = start.getCreator();
                while (!(cur instanceof Store startStore)) { cur = cur.getSuccessor(); }

                assert startStore.getAddress().equals(startLoad.getAddress());

                must.add(new Tuple(startStore, startLoad));
                if (eq.isImplied(startLoad, startStore)) {
                    may.removeIf(t -> t.getSecond() == startLoad && t.getFirst() != startStore);
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
                            if ((implies(w2, w1) || implies(w2, read))
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
                                        && implies(w, r) && alias.mustAlias(r, w));
                        if (hasImpliedWrites) {
                            may.removeIf(t -> t.getSecond() == r && t.isCrossThread());
                        }
                    }
                }
                logger.debug("Atomic block optimization eliminated {} reads", sizeBefore - may.size());
            }
            logger.debug("Initial may set size for read-from: {}", may.size());
            return new Knowledge(may, enableMustSets ? must : EMPTY_SET);
        }

        @Override
        public Knowledge visitSameAddress(Relation rel) {
            Set<Tuple> may = new HashSet<>();
            List<MemoryCoreEvent> events = program.getThreadEvents(MemoryCoreEvent.class);
            for (MemoryCoreEvent e1 : events) {
                for (MemoryCoreEvent e2 : events) {
                    if (alias.mayAlias(e1, e2) && notExclusive(e1, e2)) {
                        may.add(new Tuple(e1, e2));
                    }
                }
            }
            Set<Tuple> must = new HashSet<>();
            for (Tuple t : enableMustSets ? may : Set.<Tuple>of()) {
                if (alias.mustAlias((MemoryCoreEvent) t.getFirst(), (MemoryCoreEvent) t.getSecond())) {
                    must.add(t);
                }
            }
            return new Knowledge(may, enableMustSets ? must : EMPTY_SET);
        }

        private Knowledge computeInternalDependencies(Set<UsageType> usageTypes) {
            Set<Tuple> may = new HashSet<>();
            Set<Tuple> must = new HashSet<>();

            for (Event regReaderEvent : program.getThreadEvents()) {
                //TODO: Once "Event" is an interface and RegReader inherits from it,
                // we can use program.getEvents(RegReader.class) here.
                if (!(regReaderEvent instanceof RegReader regReader)) {
                    continue;
                }
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
                    Dependency.State r = dep.of(regReaderEvent, register);
                    for (Event regWriter : r.may) {
                        may.add(new Tuple(regWriter, regReaderEvent));
                    }
                    for (Event regWriter : enableMustSets ? r.must : List.<Event>of()) {
                        must.add(new Tuple(regWriter, regReaderEvent));
                    }
                }
            }

            // We need to track ExecutionStatus events separately, because they induce data-dependencies
            // without reading from a register.
            if (usageTypes.contains(DATA)) {
                for (ExecutionStatus execStatus : program.getThreadEvents(ExecutionStatus.class)) {
                    if (execStatus.doesTrackDep()) {
                        Tuple t = new Tuple(execStatus.getStatusEvent(), execStatus);
                        may.add(t);
                        must.add(t);
                    }
                }
            }

            return new Knowledge(may, enableMustSets ? must : EMPTY_SET);
        }

        @Override
        public Knowledge visitSameScope(Relation rel, String specificScope) {
            Set<Tuple> must = new HashSet<>();
            List<Event> events = new ArrayList<>();
            events.addAll(program.getThreadEvents(Load.class));
            events.addAll(program.getThreadEvents(Store.class));
            events.addAll(program.getThreadEvents(Fence.class));
            events.removeIf(e -> e instanceof Init);
            for (Event e1 : events) {
                for (Event e2 : events) {
                    ScopedThread thread1 = (ScopedThread) e1.getThread();
                    ScopedThread thread2 = (ScopedThread) e2.getThread();
                    if (specificScope != null) { // scope specified
                        if (thread1.sameAtHigherScope(thread2, specificScope) && !exec.areMutuallyExclusive(e1, e2)) {
                            must.add(new Tuple(e1, e2));
                        }
                    } else {
                        String scope1 = Tag.PTX.getScopeTag(e1);
                        String scope2 = Tag.PTX.getScopeTag(e2);
                        if (scope1.equals(scope2) && !scope1.isEmpty() && thread1.sameAtHigherScope(thread2, scope1)
                                && !exec.areMutuallyExclusive(e1, e2)) {
                            must.add(new Tuple(e1, e2));
                        }
                    }
                }
            }
            return new Knowledge(must, new HashSet<>(must));
        }

        @Override
        public Knowledge visitSyncBarrier(Relation sync_bar) {
            Set<Tuple> may = new HashSet<>();
            Set<Tuple> must = new HashSet<>();
            List<PTXFenceWithId> fenceEvents = program.getThreadEvents(PTXFenceWithId.class);
            for (PTXFenceWithId e1 : fenceEvents) {
                for (PTXFenceWithId e2 : fenceEvents) {
                    if(exec.areMutuallyExclusive(e1, e2)) {
                        continue;
                    }
                    may.add(new Tuple(e1, e2));
                    if (e1.getFenceID().equals(e2.getFenceID())) {
                        must.add(new Tuple(e1, e2));
                    }
                }
            }
            return new Knowledge(may, must);
        }

        @Override
        public Knowledge visitSyncFence(Relation sync_fen) {
            Set<Tuple> may = new HashSet<>();
            List<Fence> fenceEvents = program.getThreadEvents(Fence.class);
            for (Fence e1 : fenceEvents) {
                for (Fence e2 : fenceEvents) {
                    if (e1.hasTag(Tag.PTX.SC) && e2.hasTag(Tag.PTX.SC) && !exec.areMutuallyExclusive(e1, e2)) {
                        may.add(new Tuple(e1, e2));
                    }
                }
            }
            return new Knowledge(may, EMPTY_SET);
        }

        @Override
        public Knowledge visitVirtualLocation(Relation rel) {
            Set<Tuple> must = new HashSet<>();
            List<MemoryCoreEvent> events = program.getThreadEvents(MemoryCoreEvent.class);
            for (MemoryCoreEvent e1 : events) {
                for (MemoryCoreEvent e2 : events) {
                    if (alias.mayAlias(e1, e2) && sameGenericAddress(e1, e2) && !exec.areMutuallyExclusive(e1, e2)) {
                        must.add(new Tuple(e1, e2));
                    }
                }
            }
            return new Knowledge(must, new HashSet<>(must));
        }
    }

    public final class Propagator implements Definition.Visitor<Delta> {
        public Relation source;
        public Set<Tuple> may;
        public Set<Tuple> must;

        @Override
        public Delta visitUnion(Relation rel, Relation... operands) {
            if (Arrays.asList(operands).contains(source)) {
                return new Delta(may, enableMustSets ? must : EMPTY_SET);
            }
            return EMPTY;
        }

        @Override
        public Delta visitIntersection(Relation rel, Relation... operands) {
            if (!Arrays.asList(operands).contains(source)) {
                return EMPTY;
            }
            Set<Tuple> maySet = Arrays.stream(operands)
                    .map(r -> source.equals(r) ? may : knowledgeMap.get(r).may)
                    .sorted(Comparator.comparingInt(Set::size))
                    .reduce(Sets::intersection)
                    .orElseThrow();
            Set<Tuple> mustSet = Arrays.stream(operands)
                    .map(r -> source.equals(r) ? must : knowledgeMap.get(r).must)
                    .sorted(Comparator.comparingInt(Set::size))
                    .reduce(Sets::intersection)
                    .orElseThrow();
            return new Delta(
                    new HashSet<>(maySet),
                    enableMustSets ?
                            new HashSet<>(mustSet) :
                            EMPTY_SET);
        }

        @Override
        public Delta visitDifference(Relation rel, Relation r1, Relation r2) {
            if (r1.equals(source)) {
                Knowledge k = knowledgeMap.get(r2);
                return new Delta(
                        enableMustSets ? difference(may, k.must) : may,
                        enableMustSets ? difference(must, k.may) : EMPTY_SET);
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
                        if (notExclusive(e1, e2)) {
                            maySet.add(new Tuple(e1, e2));
                        }
                    }
                }
                Map<Event, List<Event>> mustMap = map(k.must);
                for (Tuple t : enableMustSets ? must : Set.<Tuple>of()) {
                    Event e1 = t.getFirst();
                    Event e = t.getSecond();
                    boolean implies = implies(e, e1);
                    for (Event e2 : mustMap.getOrDefault(e, List.of())) {
                        if ((implies || implies(e, e2)) && notExclusive(e1, e2)) {
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
                        if (notExclusive(e1, e2)) {
                            maySet.add(new Tuple(e1, e2));
                        }
                    }
                }
                Map<Event, List<Event>> mustMap = mapReverse(k.must);
                for (Tuple t : enableMustSets ? must : Set.<Tuple>of()) {
                    Event e2 = t.getSecond();
                    Event e = t.getFirst();
                    boolean implies = implies(e, e2);
                    for (Event e1 : mustMap.getOrDefault(e, List.of())) {
                        if ((implies || implies(e, e1)) && notExclusive(e1, e2)) {
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
                    if (implies(t.getSecond(), t.getFirst())) {
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
                    if (implies(t.getFirst(), t.getSecond())) {
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
                return new Delta(inverse(may), enableMustSets ? inverse(must) : EMPTY_SET);
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
                            if (!k.containsMay(t) && !maySet.contains(t) && notExclusive(e1, e2)) {
                                next.add(t);
                            }
                        }
                    }
                    maySet.addAll(next);
                    current = next;
                }
                if (!enableMustSets) {
                    return new Delta(maySet, EMPTY_SET);
                }
                Set<Tuple> mustSet = new HashSet<>(must);
                Map<Event, List<Event>> mustMap = map(k.must);
                for (Collection<Tuple> current = must; !current.isEmpty(); ) {
                    update(mustMap, current);
                    Collection<Tuple> next = new HashSet<>();
                    for (Tuple tuple : current) {
                        Event e1 = tuple.getFirst();
                        Event e = tuple.getSecond();
                        boolean implies = implies(e, e1);
                        for (Event e2 : mustMap.getOrDefault(e, List.of())) {
                            Tuple t = new Tuple(e1, e2);
                            if (!k.containsMust(t) && !mustSet.contains(t) && (implies || implies(e, e2)) && notExclusive(e1, e2)) {
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
                    map.put(o, new ExtendedDelta(disabled, EMPTY_SET));
                }
            }
            if (List.of(operands).contains(origin)) {
                Set<Tuple> d = new HashSet<>();
                for (Tuple t : disabled) {
                    if (Arrays.stream(operands).noneMatch(o -> knowledgeMap.get(o).containsMay(t))) {
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
                    Set<Tuple> d = Arrays.stream(operands)
                            .map(r -> o.equals(r) ? disabled : knowledgeMap.get(r).must)
                            .sorted(Comparator.comparingInt(Set::size))
                            .reduce(Sets::intersection)
                            .orElseThrow();
                    map.putIfAbsent(o, new ExtendedDelta(new HashSet<>(d), enabled));
                }
            }
            if (List.of(operands).contains(origin)) {
                Set<Tuple> e = Arrays.stream(operands)
                        .map(r -> origin.equals(r) ? enabled : knowledgeMap.get(r).must)
                        .sorted(Comparator.comparingInt(Set::size))
                        .reduce(Sets::intersection)
                        .orElseThrow();
                map.put(rel, new ExtendedDelta(disabled, new HashSet<>(e)));
            }
            return map;
        }

        @Override
        public Map<Relation, ExtendedDelta> visitDifference(Relation r0, Relation r1, Relation r2) {
            Map<Relation, ExtendedDelta> map = new HashMap<>();
            if (origin.equals(r0)) {
                map.put(r1, new ExtendedDelta(difference(disabled, knowledgeMap.get(r2).may), enabled));
                //map.put(r2, new ExtendedDelta(EMPTY_SET, intersection(disabled, knowledgeMap.get(r1).getMustSet())));
            }
            if (origin.equals(r1)) {
                map.put(r0, new ExtendedDelta(disabled, difference(enabled, knowledgeMap.get(r2).may)));
            }
            if (origin.equals(r2)) {
                Knowledge k1 = knowledgeMap.get(r1);
                map.put(r0, new ExtendedDelta(intersection(enabled, k1.may), intersection(disabled, k1.must)));
                map.put(r1, new ExtendedDelta(difference(disabled, knowledgeMap.get(r0).may), EMPTY_SET));
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
            Relation origin = this.origin;
            Map<Event, List<Event>> mayOut1 = (origin.equals(r1) || origin.equals(r2)) && !disabled.isEmpty() ? map(k1.may) : Map.of();
            if (origin.equals(r0)) {
                Map<Event, List<Event>> mustOut1 = disabled.isEmpty() ? Map.of() : map(k1.must);
                Map<Event, List<Event>> mustIn2 = disabled.isEmpty() ? Map.of() : mapReverse(k2.must);
                for (Tuple xz : disabled) {
                    Event x = xz.getFirst();
                    Event z = xz.getSecond();
                    boolean implies = implies(z, x);
                    boolean implied = implies(x, z);
                    for (Event y : mustOut1.getOrDefault(x, List.of())) {
                        if (implied || implies(x, y)) {
                            Tuple yz = new Tuple(y, z);
                            if (k2.containsMay(yz)) {
                                d2.add(yz);
                            }
                        }
                    }
                    for (Event y : mustIn2.getOrDefault(z, List.of())) {
                        if (implies || implies(z, y)) {
                            Tuple xy = new Tuple(x, y);
                            if (k1.containsMay(xy)) {
                                d1.add(xy);
                            }
                        }
                    }
                }
            }
            if (origin.equals(r1)) {
                Map<Event, List<Event>> mayOut2 = map(k2.may);
                Map<Event, List<Event>> mayIn2 = disabled.isEmpty() ? Map.of() : mapReverse(k2.may);
                Map<Event, Set<Event>> alternativesMap = new HashMap<>();
                Function<Event, Set<Event>> newAlternatives = x -> new HashSet<>(mayOut1.getOrDefault(x, List.of()));
                for (Tuple xy : disabled) {
                    Event x = xy.getFirst();
                    Event y = xy.getSecond();
                    Set<Event> alternatives = alternativesMap.computeIfAbsent(x, newAlternatives);
                    for (Event z : mayOut2.getOrDefault(y, List.of())) {
                        if (notExclusive(x, z)
                                && Collections.disjoint(alternatives, mayIn2.getOrDefault(z, List.of()))) {
                            d0.add(new Tuple(x, z));
                        }
                    }
                }
                for (Tuple xy : enabled) {
                    Event x = xy.getFirst();
                    Event y = xy.getSecond();
                    boolean implied = implies(x, y);
                    boolean implies = implies(y, x);
                    for (Event z : mayOut2.getOrDefault(y, List.of())) {
                        if (exclusive(x, z)) {
                            continue;
                        }
                        Tuple xz = new Tuple(x, z);
                        Tuple yz = new Tuple(y, z);
                        if ((implies || implies(y, z)) && k2.containsMust(yz)) {
                            e0.add(xz);
                        }
                        if ((implied || implies(x, z)) && !k0.containsMay(xz)) {
                            d2.add(yz);
                        }
                    }
                }
            }
            if (origin.equals(r2)) {
                Map<Event, List<Event>> mayIn1 = mapReverse(k1.may);
                Map<Event, List<Event>> mayIn2 = disabled.isEmpty() ? Map.of() : mapReverse(k2.may);
                Map<Event, Set<Event>> alternativesMap = new HashMap<>();
                Function<Event, Set<Event>> newAlternatives = y -> new HashSet<>(mayIn2.getOrDefault(y, List.of()));
                for (Tuple xy : disabled) {
                    Event x = xy.getFirst();
                    Event y = xy.getSecond();
                    Set<Event> alternatives = alternativesMap.computeIfAbsent(y, newAlternatives);
                    for (Event w : mayIn1.getOrDefault(x, List.of())) {
                        if (notExclusive(w, y)
                                && Collections.disjoint(alternatives, mayOut1.getOrDefault(w, List.of()))) {
                            d0.add(new Tuple(w, y));
                        }
                    }
                }
                for (Tuple xy : enabled) {
                    Event x = xy.getFirst();
                    Event y = xy.getSecond();
                    boolean implied = implies(x, y);
                    boolean implies = implies(y, x);
                    for (Event w : mayIn1.getOrDefault(x, List.of())) {
                        if (exclusive(w, y)) {
                            continue;
                        }
                        Tuple wx = new Tuple(w, x);
                        Tuple wy = new Tuple(w, y);
                        if ((implied || implies(x, w)) && k1.containsMust(wx)) {
                            e0.add(wy);
                        }
                        if ((implies || implies(y, w)) && !k0.containsMay(wy)) {
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
                return Map.of(r1, new ExtendedDelta(inverse(disabled), EMPTY_SET));
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
                Map<Event, List<Event>> mayOut0 = map(k0.may);
                Map<Event, List<Event>> mayOut1 = disabled.isEmpty() ? Map.of() : map(k1.may);
                Map<Event, List<Event>> mayIn0 = disabled.isEmpty() ? Map.of() : mapReverse(k0.may);
                Map<Event, Set<Event>> alternativesMap = new HashMap<>();
                Function<Event, Set<Event>> newAlternatives = x -> new HashSet<>(mayOut1.getOrDefault(x, List.of()));
                for (Tuple xy : disabled) {
                    Event x = xy.getFirst();
                    Event y = xy.getSecond();
                    Set<Event> alternatives = alternativesMap.computeIfAbsent(x, newAlternatives);
                    if (k0.containsMay(xy)
                            && Collections.disjoint(alternatives, mayIn0.getOrDefault(y, List.of()))) {
                        d0.add(xy);
                    }
                    if (xy.isLoop()) {
                        continue;
                    }
                    for (Event z : mayOut0.getOrDefault(y, List.of())) {
                        Tuple xz = new Tuple(x, z);
                        if (k0.containsMay(xz)
                                && !alternatives.contains(z)
                                && Collections.disjoint(alternatives, mayIn0.getOrDefault(z, List.of()))) {
                            d0.add(xz);
                        }
                    }
                }
                e0.addAll(enabled);
                for (Tuple xy : enabled) {
                    if (xy.isLoop()) {
                        continue;
                    }
                    Event x = xy.getFirst();
                    Event y = xy.getSecond();
                    boolean implied = implies(x, y);
                    boolean implies = implies(y, x);
                    for (Event z : mayOut0.getOrDefault(y, List.of())) {
                        if (exclusive(x, z)) {
                            continue;
                        }
                        Tuple xz = new Tuple(x, z);
                        Tuple yz = new Tuple(y, z);
                        if ((implies || implies(y, z)) && k0.containsMust(yz)) {
                            e0.add(xz);
                        }
                        if ((implied || implies(x, z)) && !k0.containsMay(xz)) {
                            d0.add(yz);
                        }
                    }
                }
            }
            if (origin.equals(r0)) {
                Map<Event, List<Event>> mustIn0 = disabled.isEmpty() ? Map.of() : mapReverse(k0.must);
                Map<Event, List<Event>> mayIn1 = enabled.isEmpty() ? Map.of() : mapReverse(k1.may);
                Map<Event, List<Event>> mustOut1 = disabled.isEmpty() ? Map.of() : map(k1.must);
                d1.addAll(intersection(disabled, k1.may));
                for (Tuple xz : disabled) {
                    if (xz.isLoop()) {
                        continue;
                    }
                    Event x = xz.getFirst();
                    Event z = xz.getSecond();
                    boolean implied = implies(x, z);
                    boolean implies = implies(z, x);
                    for (Event y : mustOut1.getOrDefault(x, List.of())) {
                        if (implied || implies(x, y)) {
                            Tuple yz = new Tuple(y, z);
                            if (k0.containsMay(yz)) {
                                d0.add(yz);
                            }
                        }
                    }
                    for (Event y : mustIn0.getOrDefault(z, List.of())) {
                        if (implies || implies(z, y)) {
                            Tuple xy = new Tuple(x, y);
                            if (k1.containsMay(xy)) {
                                d1.add(xy);
                            }
                        }
                    }
                }
                for (Tuple yz : enabled) {
                    if (yz.isLoop()) {
                        continue;
                    }
                    Event y = yz.getFirst();
                    Event z = yz.getSecond();
                    boolean implied = implies(y, z);
                    boolean implies = implies(z, y);
                    for (Event x : mayIn1.getOrDefault(y, List.of())) {
                        if (exclusive(x, z)) {
                            continue;
                        }
                        Tuple xy = new Tuple(x, y);
                        Tuple xz = new Tuple(x, z);
                        if ((implied || implies(y, x)) && k1.containsMust(xy)) {
                            e0.add(xz);
                        }
                        if ((implies || implies(z, x)) && !k0.containsMay(xz)) {
                            d1.add(xy);
                        }
                    }
                }
            }
            return Map.of(
                    r0, new ExtendedDelta(d0, e0),
                    r1, new ExtendedDelta(d1, EMPTY_SET));
        }

        @Override
        public Map<Relation, ExtendedDelta> visitCoherence(Relation co) {
            if (disabled.isEmpty()) {
                return Map.of();
            }
            //TODO use transitivity
            Set<Tuple> e = new HashSet<>();
            for (Tuple xy : disabled) {
                if (alias.mustAlias((MemoryCoreEvent) xy.getFirst(), (MemoryCoreEvent) xy.getSecond())) {
                    e.add(xy.getInverse());
                }
            }
            return Map.of(co, new ExtendedDelta(EMPTY_SET, e));
        }
    }

    private static List<Event> visibleEvents(Thread t) {
        return t.getEvents().stream().filter(e -> e.hasTag(VISIBLE)).collect(toList());
    }

    private static int getThreadIndex(Event event, List<Event> thread) {
        checkState(Comparators.isInStrictOrder(thread, Comparator.naturalOrder()),
                "Unordered thread %s" ,event.getThread().getId());
        return Collections.binarySearch(thread, event);
    }

    private static final class InOutSet extends AbstractCollection<Tuple> {
        private final Collection<Tuple> explicits;
        private final Collection<Event> set;
        private final Event event;
        private final boolean in;

        private InOutSet(Collection<Tuple> explicits, Collection<Event> set, Event event, boolean in) {
            this.explicits = explicits;
            this.set = set;
            this.event = event;
            this.in = in;
        }

        @Override
        public Iterator<Tuple> iterator() {
            Iterator<Tuple> explicitIterator = explicits.iterator();
            Iterator<Event> innerIterator = set.iterator();
            return new Iterator<>() {
                @Override
                public boolean hasNext() {
                    return explicitIterator.hasNext() || innerIterator.hasNext();
                }
                @Override
                public Tuple next() {
                    if (explicitIterator.hasNext()) {
                        return explicitIterator.next();
                    }
                    Event other = innerIterator.next();
                    return in ? new Tuple(other, event) : new Tuple(event, other);
                }
            };
        }

        @Override
        public int size() {
            return explicits.size() + set.size();
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

    private boolean implies(Event y, Event z) {
        return exec.isImplied(z, y);
    }

    private boolean exclusive(Event first, Event second) {
        return exec.areMutuallyExclusive(first, second);
    }

    private boolean notExclusive(Event first, Event second) {
        return !exec.areMutuallyExclusive(first, second);
    }

    private boolean notExclusive(Tuple tuple) {
        return !exec.areMutuallyExclusive(tuple.getFirst(), tuple.getSecond());
    }

    private Predicate<Event> notExclusive(Event first) {
        return second -> !exec.areMutuallyExclusive(first, second);
    }

    private long countMaySet() {
        return knowledgeMap.values().stream().mapToLong(k -> k.may.size()).sum();
    }

    private long countMustSet() {
        return knowledgeMap.values().stream().mapToLong(k -> k.must.size()).sum();
    }

    // GPU memory models make use of virtual addresses.
    // This models same_alias_r from the PTX Alloy model
    // Checking address1 and address2 hold the same generic address
    private boolean sameGenericAddress(MemoryCoreEvent e1, MemoryCoreEvent e2) {
        // TODO: Add support for pointers, i.e. if `x` and `y` virtually alias,
        // then `x + offset` and `y + offset` should too
        if (!(e1.getAddress() instanceof VirtualMemoryObject addr1)
                || !(e2.getAddress() instanceof VirtualMemoryObject addr2)) {
            return false;
        }
        return addr1.getGenericAddress() == addr2.getGenericAddress();
    }
}
