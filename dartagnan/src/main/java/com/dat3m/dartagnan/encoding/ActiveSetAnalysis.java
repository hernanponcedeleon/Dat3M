package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.Utils;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Constraint;
import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.axiom.Acyclicity;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.axiom.Emptiness;
import com.dat3m.dartagnan.wmm.axiom.Irreflexivity;
import com.dat3m.dartagnan.wmm.definition.*;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.mutable.MapEventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.mutable.MutableEventGraph;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.Maps;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.util.*;

import static com.dat3m.dartagnan.configuration.OptionNames.ENABLE_ACTIVE_SETS;
import static com.dat3m.dartagnan.configuration.OptionNames.REDUCE_ACYCLICITY_RELEVANT_SETS;

/*
    Computes active/relevant sets for all memory model constraints.

    The active set of a (relation) definition describes the subset of the definition
    that affects memory consistency and/or the satisfaction of other constraints.
    On the formula level, the active set can be understood as a "subset of clauses".

    The relevant set of a non-defining constraint (e.g. an axiom) describes the
    subset of relation members that are relevant to determine satisfaction of the constraint.
    On the formula level, the relevant set can be understood as a "subset of variables".
 */
@Options
public class ActiveSetAnalysis {

    private static final Logger logger = LoggerFactory.getLogger(ActiveSetAnalysis.class);

    // ==============================================================================================

    @Option(name = ENABLE_ACTIVE_SETS,
            description = "Compute subset of memory model definitions that affect memory model consistency.",
            secure = true)
    private boolean enableActiveSetComputation = true;

    @Option(name = REDUCE_ACYCLICITY_RELEVANT_SETS,
            description = "Reduce relevant sets of acyclicity axiom by removing transitively implied edges.",
            secure = true)
    private boolean reduceAcyclicityRelevantSets = true;

    // ==============================================================================================

    private final Wmm memoryModel;
    private final Context analysisContext;
    private final RelationAnalysis ra;

    private Map<Definition, EventGraph> definition2ActiveSets;
    // TODO: Can be generalized to any non-defining constraint (we have only axioms right now)
    //  It could also be generalized to defining constraints
    private Map<Axiom, EventGraph> axiom2RelevantSets;

    public EventGraph getActiveSet(Definition definition) {
        return definition2ActiveSets.get(definition);
    }

    public EventGraph getRelevantSet(Axiom axiom) {
        return axiom2RelevantSets.get(axiom);
    }

    // ==============================================================================================

    private ActiveSetAnalysis(Wmm memoryModel, Context analysisContext, Configuration config) throws InvalidConfigurationException {
        this.memoryModel = memoryModel;
        this.analysisContext = analysisContext;
        this.ra = analysisContext.requires(RelationAnalysis.class);

        config.inject(this);
        logConfig();

        final long t0 = System.currentTimeMillis();
        run();
        logStatistics(t0);
    }

    public static ActiveSetAnalysis newInstance(Wmm memoryModel, Context analysisContext, Configuration config) throws InvalidConfigurationException {
        return new ActiveSetAnalysis(memoryModel, analysisContext, config);
    }

    public static ActiveSetAnalysis newInstance(VerificationTask task, Context analysisContext) throws InvalidConfigurationException {
        return newInstance(task.getMemoryModel(), analysisContext, task.getConfig());
    }

    private void logConfig() {
        logger.info("{}: {}", ENABLE_ACTIVE_SETS, enableActiveSetComputation);
        logger.info("{}: {}", REDUCE_ACYCLICITY_RELEVANT_SETS, reduceAcyclicityRelevantSets);
    }

    private void logStatistics(long startTime) {
        if (!logger.isInfoEnabled()) {
            return;
        }

        logger.info("Computed active sets in {}", Utils.toTimeString(System.currentTimeMillis() - startTime));
        logger.info("#Unknown elements: {}", memoryModel.getRelations().stream()
                .map(ra::getKnowledge)
                .mapToLong(k -> EventGraph.difference(k.getMaySet(), k.getMustSet()).size())
                .sum());
        logger.info("#Active constraints: {}", definition2ActiveSets.values().stream()
                .mapToLong(EventGraph::size)
                .sum());
        logger.info("#Relevant edges for acyclicity: {}",
                memoryModel.getAxioms().stream()
                        .filter(Acyclicity.class::isInstance)
                        .mapToInt(a -> axiom2RelevantSets.get(a).size())
                        .sum());
    }

    // ==============================================================================================

    private void run() {
        logger.trace("Start");

        final Set<Relation> relations = memoryModel.getRelations();
        final List<Axiom> axioms = memoryModel.getAxioms();

        // ---- Compute relevant sets ----
        //  TODO: Do we consider this as part of the active set computation?
        //   Should we also do a "worst-case" here if active sets are disabled?
        final AxiomRelevantSets axiomRelevantSetsVisitor = new AxiomRelevantSets();
        axiom2RelevantSets = Maps.toMap(axioms, a -> a.accept(axiomRelevantSetsVisitor));

        if (!enableActiveSetComputation) {
            initToMaximalActiveSets();
            return;
        }

        // ---- Initialize active set propagation queue ----
        final Map<Relation, List<EventGraph>> propagationQueue = new HashMap<>();
        axioms.forEach(a -> {
            final EventGraph relevant = filterUnknowns(axiom2RelevantSets.get(a), a.getRelation());
            propagationQueue.computeIfAbsent(a.getRelation(), k -> new ArrayList<>()).add(
                    MutableEventGraph.from(relevant));
        });
        // FIXME: This method is the most expensive one to compute (80% of runtime)
        //  Bottom-up computation of NativeRA is just implemented inefficiently
        ra.collectDiscrepancies(relations, propagationQueue);

        // ---- Compute active sets----
        final ActiveSetPropagator propagator = new ActiveSetPropagator();
        final Map<Definition, MutableEventGraph> activeSets = new HashMap<>();
        relations.forEach(r -> activeSets.put(r.getDefinition(), new MapEventGraph()));

        while (!propagationQueue.isEmpty()) {
            final Relation r = propagationQueue.keySet().iterator().next();
            logger.trace("Update active set of '{}'", r);
            final MutableEventGraph active = activeSets.get(r.getDefinition());
            final MutableEventGraph update = new MapEventGraph();

            propagationQueue.remove(r).forEach(news -> news.filter(active::add).apply(update::add));
            propagator.propagateAndUpdateQueue(r.getDefinition(), update, propagationQueue);
        }

        this.definition2ActiveSets = ImmutableMap.copyOf(activeSets);

        logger.trace("End");
    }

    private void initToMaximalActiveSets() {
        final Set<Relation> relations = memoryModel.getRelations();

        final Map<Relation, List<EventGraph>> discrepancies = new HashMap<>();
        ra.collectDiscrepancies(relations, discrepancies);

        final Map<Definition, MutableEventGraph> activeSets = Maps.newHashMapWithExpectedSize(relations.size());
        for (Relation rel : relations) {
            final MutableEventGraph active = MapEventGraph.from(getUnknowns(rel));
            discrepancies.get(rel).forEach(active::addAll);

            activeSets.put(rel.getDefinition(), active);
        }

        this.definition2ActiveSets = ImmutableMap.copyOf(activeSets);
    }

    private EventGraph getUnknowns(Relation rel) {
        return EventGraph.difference(ra.getKnowledge(rel).getMaySet(), ra.getKnowledge(rel).getMustSet());
    }

    @SuppressWarnings("unchecked")
    private <T extends EventGraph> T filterUnknowns(T graph, Relation relation) {
        RelationAnalysis.Knowledge k = ra.getKnowledge(relation);
        EventGraph may = k.getMaySet();
        EventGraph must = k.getMustSet();
        // TODO: This returns a new graph, is this intended?
        return (T) graph.filter((e1, e2) -> may.contains(e1, e2) && !must.contains(e1, e2));
    }

    // ================================================================================================
    // Axiom relevant sets

    private final class AxiomRelevantSets implements Constraint.Visitor<EventGraph> {

        @Override
        public EventGraph visitConstraint(Constraint constraint) {
            throw new UnsupportedOperationException("Relevant set computation not supported for " + constraint.getClass().getSimpleName());
        }

        @Override
        public EventGraph visitEmptiness(Emptiness axiom) {
            return ra.getKnowledge(axiom.getRelation()).getMaySet();
        }

        @Override
        public EventGraph visitIrreflexivity(Irreflexivity axiom) {
            return ra.getKnowledge(axiom.getRelation()).getMaySet().filter(Tuple::isLoop);
        }

        @Override
        public EventGraph visitAcyclicity(Acyclicity axiom) {
            logger.info("Computing relevant set for {}", axiom);
            ExecutionAnalysis exec = analysisContext.get(ExecutionAnalysis.class);
            // ====== Construct [Event -> Successor] mapping ======
            final Relation rel = axiom.getRelation();
            EventGraph maySet = ra.getKnowledge(rel).getMaySet();
            Map<Event, Set<Event>> succMap = maySet.getOutMap();

            // ====== Compute SCCs ======
            DependencyGraph<Event> depGraph = DependencyGraph.from(succMap.keySet(), succMap);
            final MutableEventGraph result = new MapEventGraph();
            for (Set<DependencyGraph<Event>.Node> scc : depGraph.getSCCs()) {
                for (DependencyGraph<Event>.Node node1 : scc) {
                    for (DependencyGraph<Event>.Node node2 : scc) {
                        Event e1 = node1.getContent();
                        Event e2 = node2.getContent();
                        if (maySet.contains(e1, e2)) {
                            result.add(e1, e2);
                        }
                    }
                }
            }

            if (reduceAcyclicityRelevantSets) {
                final int originalSize = result.size();
                result.removeAll(transitivelyDerivableMustEdges(exec, ra.getKnowledge(rel)));
                final int reducedSize = result.size();
                logger.info("Relevant set size original/reduced: {} / {}", originalSize, reducedSize);
            } else {
                logger.info("Relevant set size: {} ", result.size());
            }

            return result;
        }

        // Under-approximates the must-set of (rel+ ; rel).
        // It is the smallest set that contains the binary composition of the must-set with itself with implied intermediates
        // and is closed under that operation with the must-set.
        // Basically, the clause {@code exec(x) and exec(z) implies before(x,z)} is obsolete,
        // if the clauses {@code exec(x) implies before(x,y)} and {@code exec(z) implies before(y,z)} exist.
        // NOTE: Assumes that the must-set of rel+ is acyclic.
        private static EventGraph transitivelyDerivableMustEdges(ExecutionAnalysis exec, RelationAnalysis.Knowledge k) {
            MutableEventGraph result = new MapEventGraph();
            Map<Event, Set<Event>> map = new HashMap<>();
            Map<Event, Set<Event>> mapInverse = new HashMap<>();
            EventGraph current = k.getMustSet();
            while (!current.isEmpty()) {
                MutableEventGraph next = new MapEventGraph();
                current.apply((x, y) -> {
                    map.computeIfAbsent(x, e -> new HashSet<>()).add(y);
                    mapInverse.computeIfAbsent(y, e -> new HashSet<>()).add(x);
                });
                current.apply((x, y) -> {
                    boolean implied = exec.isImplied(y, x);
                    boolean implies = exec.isImplied(x, y);
                    for (Event z : map.getOrDefault(y, Set.of())) {
                        if (!implies && !exec.isImplied(z, y) || exec.areMutuallyExclusive(x, z)) {
                            continue;
                        }
                        if (result.add(x, z)) {
                            next.add(x, z);
                        }
                    }
                    for (Event w : mapInverse.getOrDefault(x, Set.of())) {
                        if (!implied && !exec.isImplied(w, x) || exec.areMutuallyExclusive(w, y)) {
                            continue;
                        }
                        if (result.add(w, y)) {
                            next.add(w, y);
                        }
                    }
                });
                current = next;
            }
            return result;
        }
    }

    // ================================================================================================
    // Active sets

    private final class ActiveSetPropagator implements Constraint.Visitor<Map<Relation, EventGraph>> {

        private EventGraph news;

        public void propagateAndUpdateQueue(Definition def, EventGraph update, Map<Relation, List<EventGraph>> propagationQueue) {
            if (update.isEmpty()) {
                return;
            }

            this.news = update;
            def.accept(this).forEach((rel, value) ->
                    propagationQueue.computeIfAbsent(rel, k -> new ArrayList<>()).add(value)
            );
            this.news = null;
        }

        @Override
        public Map<Relation, EventGraph> visitDefinition(Definition def) {
            return Map.of();
        }

        @Override
        public Map<Relation, EventGraph> visitUnion(Union union) {
            final Map<Relation, EventGraph> m = new HashMap<>();
            for (Relation r : union.getOperands()) {
                m.merge(r, filterUnknowns(news, r), EventGraph::union);
            }
            return m;
        }

        @Override
        public Map<Relation, EventGraph> visitIntersection(Intersection inter) {
            final Map<Relation, EventGraph> m = new HashMap<>();
            for (Relation r : inter.getOperands()) {
                m.merge(r, filterUnknowns(news, r), EventGraph::union);
            }
            return m;
        }

        @Override
        public Map<Relation, EventGraph> visitDifference(Difference diff) {
            final Relation r1 = diff.getMinuend();
            final Relation r2 = diff.getSubtrahend();
            return map(r1, filterUnknowns(news, r1), r2, filterUnknowns(news, r2));
        }

        @Override
        public Map<Relation, EventGraph> visitComposition(Composition comp) {
            if (news.isEmpty()) {
                return Map.of();
            }

            final Relation r1 = comp.getLeftOperand();
            final Relation r2 = comp.getRightOperand();
            final MutableEventGraph set1 = new MapEventGraph();
            final MutableEventGraph set2 = new MapEventGraph();
            final RelationAnalysis.Knowledge k1 = ra.getKnowledge(r1);
            final RelationAnalysis.Knowledge k2 = ra.getKnowledge(r2);
            Map<Event, Set<Event>> out = ra.getKnowledge(r1).getMaySet().getOutMap();
            news.apply((e1, e2) -> {
                for (Event e : out.getOrDefault(e1, Set.of())) {
                    if (k2.getMaySet().contains(e, e2)) {
                        if (!k1.getMustSet().contains(e1, e)) {
                            set1.add(e1, e);
                        }
                        if (!k2.getMustSet().contains(e, e2)) {
                            set2.add(e, e2);
                        }
                    }
                }
            });
            return map(r1, set1, r2, set2);
        }

        @Override
        public Map<Relation, EventGraph> visitProjection(Projection projection) {
            final MutableEventGraph result = new MapEventGraph();
            final RelationAnalysis.Knowledge k1 = ra.getKnowledge(projection.getOperand());
            final EventGraph mayGraph = k1.getMaySet();
            final EventGraph mustGraph = k1.getMustSet();
            final boolean dom = projection.getDimension() == Projection.Dimension.DOMAIN;
            final Map<Event, Set<Event>> altMap = dom ? mayGraph.getOutMap() : mayGraph.getInMap();
            news.apply((e1, e2) -> {
                assert e1.equals(e2);
                for (Event alt : altMap.getOrDefault(e1, Set.of())) {
                    if (!mustGraph.contains(dom ? e1 : alt, dom ? alt : e1)) {
                        result.add(dom ? e1 : alt, dom ? alt : e1);
                    }
                }
            });
            return Map.of(projection.getOperand(), result);
        }

        @Override
        public Map<Relation, EventGraph> visitSetIdentity(SetIdentity id) {
            return Map.of(id.getDomain(), filterUnknowns(news, id.getDomain()));
        }

        @Override
        public Map<Relation, EventGraph> visitInverse(Inverse inv) {
            return Map.of(inv.getOperand(), filterUnknowns(news.inverse(), inv.getOperand()));
        }

        @Override
        public Map<Relation, EventGraph> visitProduct(CartesianProduct product) {
            final RelationAnalysis.Knowledge k1 = ra.getKnowledge(product.getDomain());
            final RelationAnalysis.Knowledge k2 = ra.getKnowledge(product.getRange());
            final MutableEventGraph set1 = new MapEventGraph();
            final MutableEventGraph set2 = new MapEventGraph();
            for (Event e1 : news.getDomain()) {
                if (k1.getMaySet().contains(e1, e1) && !k1.getMustSet().contains(e1, e1)) {
                    set1.add(e1, e1);
                }
                for (Event e2 : news.getRange(e1)) {
                    if (k2.getMaySet().contains(e2, e2) && !k2.getMustSet().contains(e2, e2)) {
                        set2.add(e2, e2);
                    }
                }
            }
            return map(product.getDomain(), set1, product.getRange(), set2);
        }

        @Override
        public Map<Relation, EventGraph> visitTransitiveClosure(TransitiveClosure trans) {
            final Relation rel = trans.getDefinedRelation();
            final Relation r1 = trans.getOperand();
            MutableEventGraph factors = new MapEventGraph();
            final RelationAnalysis.Knowledge k0 = ra.getKnowledge(rel);
            Map<Event, Set<Event>> out = k0.getMaySet().getOutMap();
            news.apply((e1, e2) -> {
                for (Event e : out.getOrDefault(e1, Set.of())) {
                    if (k0.getMaySet().contains(e, e2)) {
                        if (!k0.getMustSet().contains(e1, e)) {
                            factors.add(e1, e);
                        }
                        if (!k0.getMustSet().contains(e, e2)) {
                            factors.add(e, e2);
                        }
                    }
                }
            });
            return map(rel, factors, r1, filterUnknowns(news, r1));
        }

        @Override
        public Map<Relation, EventGraph> visitLinuxCriticalSections(LinuxCriticalSections rscs) {
            MutableEventGraph queue = new MapEventGraph();
            final RelationAnalysis.Knowledge k0 = ra.getKnowledge(rscs.getDefinedRelation());
            Map<Event, Set<Event>> in = k0.getMaySet().getInMap();
            Map<Event, Set<Event>> out = k0.getMaySet().getOutMap();
            news.apply((lock, unlock) -> {
                for (Event e : in.getOrDefault(unlock, Set.of())) {
                    if (lock.getGlobalId() < e.getGlobalId() && e.getGlobalId() < unlock.getGlobalId()) {
                        queue.add(e, unlock);
                    }
                }
                for (Event e : out.getOrDefault(lock, Set.of())) {
                    if (lock.getGlobalId() < e.getGlobalId() && e.getGlobalId() < unlock.getGlobalId()) {
                        queue.add(lock, e);
                    }
                }
            });
            return Map.of(rscs.getDefinedRelation(), queue);
        }

        private static Map<Relation, EventGraph> map(Relation r1, EventGraph s1, Relation r2, EventGraph s2) {
            return r1.equals(r2) ? Map.of(r1, EventGraph.union(s1, s2)) : Map.of(r1, s1, r2, s2);
        }
    }
}
