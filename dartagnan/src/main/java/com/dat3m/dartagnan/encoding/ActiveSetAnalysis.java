package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.program.analysis.EventDomainRepository;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.Utils;
import com.dat3m.dartagnan.utils.collections.SetUtil;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Constraint;
import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.analysis.RelationEventDomains;
import com.dat3m.dartagnan.wmm.axiom.Acyclicity;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.axiom.Emptiness;
import com.dat3m.dartagnan.wmm.axiom.Irreflexivity;
import com.dat3m.dartagnan.wmm.definition.*;
import com.dat3m.dartagnan.wmm.utils.Dimension;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.mutable.IndexedEventGraph;
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
import static com.dat3m.dartagnan.program.analysis.EventDomainRepository.DomainBound.*;

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
    private final RelationEventDomains eventDomains;
    private final RelationAnalysis ra;

    private Map<Definition, IndexedEventGraph> definition2ActiveSets;
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
        this.eventDomains = analysisContext.requires(RelationEventDomains.class);
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
        // FIXME: This method is the most expensive one to compute (40% of runtime)
        //  Bottom-up computation of NativeRA is just implemented inefficiently
        ra.collectDiscrepancies(relations, propagationQueue);

        // ---- Compute active sets----
        final ActiveSetPropagator propagator = new ActiveSetPropagator();
        final Map<Definition, IndexedEventGraph> activeSets = new HashMap<>();
        relations.forEach(r -> activeSets.put(r.getDefinition(), newGraph(r)));

        while (!propagationQueue.isEmpty()) {
            final Relation r = propagationQueue.keySet().iterator().next();
            logger.trace("Update active set of '{}'", r);
            final MutableEventGraph active = activeSets.get(r.getDefinition());
            final IndexedEventGraph update = newGraph(r);

            propagationQueue.remove(r).forEach(news -> update.addAll(news.filter(active::add)));
            propagator.propagateAndUpdateQueue(r.getDefinition(), update, propagationQueue);
        }

        this.definition2ActiveSets = ImmutableMap.copyOf(activeSets);

        logger.trace("End");
    }

    private void initToMaximalActiveSets() {
        final Set<Relation> relations = memoryModel.getRelations();

        final Map<Relation, List<EventGraph>> discrepancies = new HashMap<>();
        ra.collectDiscrepancies(relations, discrepancies);

        final Map<Definition, IndexedEventGraph> activeSets = Maps.newHashMapWithExpectedSize(relations.size());
        for (Relation rel : relations) {
            final IndexedEventGraph active = newGraph(rel);
            active.addAll(getUnknowns(rel));
            discrepancies.get(rel).forEach(active::addAll);

            activeSets.put(rel.getDefinition(), active);
        }

        this.definition2ActiveSets = ImmutableMap.copyOf(activeSets);
    }

    private EventGraph getUnknowns(Relation rel) {
        return EventGraph.difference(ra.getKnowledge(rel).getMaySet(), ra.getKnowledge(rel).getMustSet());
    }

    private MutableEventGraph filterUnknowns(EventGraph graph, Relation relation) {
        final RelationAnalysis.Knowledge k = ra.getKnowledge(relation);
        final MutableEventGraph result = MutableEventGraph.intersection(graph, k.getMaySet());
        result.removeAll(k.getMustSet());
        return result;
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
            // ====== Construct [Event -> Successor] mapping ======
            final Relation rel = axiom.getRelation();
            final RelationAnalysis.Knowledge knowledge = ra.getKnowledge(rel);
            final EventGraph maySet = knowledge.getMaySet();
            final Map<Event, Set<Event>> succMap = maySet.getOutMap();

            // ====== Compute SCCs ======
            final DependencyGraph<Event> depGraph = DependencyGraph.from(succMap.keySet(), succMap);
            final IndexedEventGraph result = newGraph(rel);
            for (Set<DependencyGraph<Event>.Node> scc : depGraph.getSCCs()) {
                final Set<Event> sccEvents = result.eventDomain(Dimension.RANGE).newSet();
                scc.forEach(n -> sccEvents.add(n.getContent()));
                sccEvents.forEach(e1 -> result.addRange(e1, SetUtil.intersection(sccEvents, maySet.getRange(e1))));
            }

            if (reduceAcyclicityRelevantSets) {
                final int originalSize = result.size();
                result.removeAll(transitivelyDerivableMustEdges(rel));
                final int reducedSize = result.size();
                logger.info("Relevant set size original/reduced: {} / {}", originalSize, reducedSize);
            } else {
                logger.info("Relevant set size: {} ", result.size());
            }

            return result;
        }

        // Computes the transitively-derivable must edges via `must(relation+ ; relation+)`.
        // Basically, `exec(x) and exec(z) implies relation(x,z)` is obsolete,
        // if `exec(x) implies relation(x,y)` and `exec(z) implies relation(y,z)` exist.
        // NOTE: Assumes that `must(relation)` is acyclic.
        private EventGraph transitivelyDerivableMustEdges(Relation relation) {
            final RelationAnalysis.Knowledge k = ra.getKnowledge(relation);
            final EventGraph transitiveClosure = ra.computeTransitiveClosure(k.getMustSet()).getMustSet();
            return ra.computeComposition(transitiveClosure, transitiveClosure).getMustSet();
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
            final MutableEventGraph set1 = newGraph(r1);
            final MutableEventGraph set2Inverse = newGraph(r2).inverse();
            final RelationAnalysis.Knowledge k1 = ra.getKnowledge(r1);
            final RelationAnalysis.Knowledge k2 = ra.getKnowledge(r2);
            final EventGraph may2Inverse = k2.getMaySet().inverse();
            for (Event e1 : news.getDomain()) {
                final Set<Event> e1may1 = k1.getMaySet().getRange(e1);
                for (Event e3 : news.getRange(e1)) {
                    final Set<Event> e2Set = SetUtil.intersection(e1may1, may2Inverse.getRange(e3));
                    set1.addRange(e1, e2Set);
                    set2Inverse.addRange(e3, e2Set);
                }
            }
            final MutableEventGraph set2 = set2Inverse.inverse();
            set1.removeAll(k1.getMustSet());
            set2.removeAll(k2.getMustSet());
            return map(r1, set1, r2, set2);
        }

        @Override
        public Map<Relation, EventGraph> visitProjection(Projection projection) {
            final MutableEventGraph result = newGraph(projection.getDefinedRelation());
            final RelationAnalysis.Knowledge k1 = ra.getKnowledge(projection.getOperand());
            final EventGraph mayGraph = k1.getMaySet();
            final EventGraph mustGraph = k1.getMustSet();
            final boolean dom = projection.getDimension() == Dimension.DOMAIN;
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
            final MutableEventGraph set1 = newGraph(product.getDomain());
            final MutableEventGraph set2 = newGraph(product.getRange());
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
            final IndexedEventGraph factors = newGraph(rel);
            final IndexedEventGraph factorsInverse = newGraph(rel);
            final RelationAnalysis.Knowledge k0 = ra.getKnowledge(rel);
            final EventGraph k0MayIn = k0.getMaySet().inverse();
            for (Event e1 : news.getDomain()) {
                final Set<Event> e1k0May = k0.getMaySet().getRange(e1);
                for (Event e3 : news.getRange(e1)) {
                    // Compute { e2 | e1 -may(r0)> e2 -may(r0)> e3 }.
                    final Set<Event> e2Set = SetUtil.intersection(e1k0May, k0MayIn.getRange(e3));
                    factors.addRange(e1, e2Set);
                    factorsInverse.addRange(e3, e2Set);
                }
            }
            factors.addAll(factorsInverse.inverse());
            factors.removeAll(k0.getMustSet());
            return map(rel, factors, r1, filterUnknowns(news, r1));
        }

        @Override
        public Map<Relation, EventGraph> visitLinuxCriticalSections(LinuxCriticalSections rscs) {
            final EventDomainRepository eventRepository = analysisContext.requires(EventDomainRepository.class);
            MutableEventGraph queue = new IndexedEventGraph(eventRepository.getDomain(VISIBLE));
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

    private IndexedEventGraph newGraph(Relation relation) {
        return eventDomains.newGraph(relation);
    }
}
