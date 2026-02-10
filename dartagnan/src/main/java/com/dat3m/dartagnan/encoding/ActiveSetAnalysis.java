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
import com.dat3m.dartagnan.wmm.analysis.LazyRelationAnalysis;
import com.dat3m.dartagnan.wmm.analysis.NativeRelationAnalysis;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.axiom.Acyclicity;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.axiom.Emptiness;
import com.dat3m.dartagnan.wmm.axiom.Irreflexivity;
import com.dat3m.dartagnan.wmm.definition.*;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.immutable.ImmutableMapEventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.mutable.MapEventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.mutable.MutableEventGraph;
import com.google.common.collect.Sets;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.util.*;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.configuration.OptionNames.ENABLE_ACTIVE_SETS;
import static com.dat3m.dartagnan.configuration.OptionNames.REDUCE_ACYCLICITY_ACTIVE_SETS;

/*
    Computes active sets for all memory model constraints and relations.
    The active set describes what relation members are relevant to determine
    satisfaction of axioms and/or memory model consistency as a whole.
 */
@Options
public class ActiveSetAnalysis {

    private static final Logger logger = LoggerFactory.getLogger(ActiveSetAnalysis.class);

    // ==============================================================================================

    @Option(name = ENABLE_ACTIVE_SETS,
            description = "Propagate active sets from memory model constraints downwards to restrict" +
                    "encoding only to consistency-relevant relations members.",
            secure = true)
    private boolean enableActiveSetPropagation = true;

    @Option(name = REDUCE_ACYCLICITY_ACTIVE_SETS,
            description = "Reduce active sets of acyclicity axiom by removing transitively implied edges.",
            secure = true)
    private boolean reduceAcyclicityActiveSets = true;

    // ==============================================================================================

    private final Wmm memoryModel;
    private final Context analysisContext;
    private final RelationAnalysis ra;

    // The subset of relation members whose values are relevant for consistency checking or similar.
    // If a member value is statically known, this set may or may not contain it (independent of relevancy).
    private Map<Relation, EventGraph> relation2ActiveSets;

    // The subset of relation members that are relevant to determine satisfaction of an axiom.
    // TODO: Can be generalized to any non-defining constraint (we have only axioms right now)
    private Map<Axiom, EventGraph> axiom2ActiveSets;

    public EventGraph getActiveSet(Constraint constraint) {
        if (constraint instanceof Definition def) {
            return relation2ActiveSets.get(def.getDefinedRelation());
        } else if (constraint instanceof Axiom axiom) {
            return axiom2ActiveSets.get(axiom);
        }

        throw new IllegalArgumentException("Unknown constraint type: " + constraint.getClass());
    }

    public EventGraph getActiveSet(Relation relation) {
        return relation2ActiveSets.get(relation);
    }

    // ==============================================================================================

    private ActiveSetAnalysis(Wmm memoryModel, Context analysisContext, Configuration config) throws InvalidConfigurationException {
        this.memoryModel = memoryModel;
        this.analysisContext = analysisContext;
        this.ra = analysisContext.requires(RelationAnalysis.class);

        config.inject(this);
        logConfig();

        final long t0 = System.currentTimeMillis();
        runAnalysis();
        logStatistics(t0);
    }

    public static ActiveSetAnalysis newInstance(Wmm memoryModel, Context analysisContext, Configuration config) throws InvalidConfigurationException {
        return new ActiveSetAnalysis(memoryModel, analysisContext, config);
    }

    public static ActiveSetAnalysis newInstance(VerificationTask task, Context analysisContext) throws InvalidConfigurationException {
        return newInstance(task.getMemoryModel(), analysisContext, task.getConfig());
    }

    private void logConfig() {
        logger.info("{}: {}", ENABLE_ACTIVE_SETS, enableActiveSetPropagation);
    }

    private void logStatistics(long startTime) {
        if (!logger.isInfoEnabled()) {
            return;
        }

        logger.info("Finished active sets in {}", Utils.toTimeString(System.currentTimeMillis() - startTime));
        logger.info("Number of unknown edges: {}", memoryModel.getRelations().stream()
                .filter(r -> !r.isInternal())
                .map(ra::getKnowledge)
                .mapToLong(k -> EventGraph.difference(k.getMaySet(), k.getMustSet()).size())
                .sum());
        logger.info("Number of active edges: {}", relation2ActiveSets.entrySet().stream()
                .filter(e -> !e.getKey().isInternal())
                .mapToLong(e -> e.getValue().size())
                .sum());
        logger.info("Number of active edges for acyclicity: {}",
                memoryModel.getAxioms().stream()
                        .filter(Acyclicity.class::isInstance)
                        .mapToInt(a -> axiom2ActiveSets.get(a).size())
                        .sum());
    }

    // ==============================================================================================

    private void runAnalysis() {
        logger.trace("Start");

        final AxiomActiveSets axiomActiveSetsVisitor = new AxiomActiveSets();
        axiom2ActiveSets = new HashMap<>();
        for (Axiom axiom : memoryModel.getAxioms()) {
            axiom2ActiveSets.put(axiom, axiom.accept(axiomActiveSetsVisitor));
        }

        if (!enableActiveSetPropagation) {
            this.relation2ActiveSets = memoryModel.getRelations().stream()
                    .collect(Collectors.toMap(r -> r, r -> ra.getKnowledge(r).getMaySet()));
        } else if (ra instanceof LazyRelationAnalysis) {
            runLazy();
        } else if (ra instanceof NativeRelationAnalysis nra) {
            runNative(nra);
        } else {
            throw new UnsupportedOperationException("Active set computation is not supported by "
                    + ra.getClass().getSimpleName());
        }

        logger.trace("End");
    }

    // ================================================================================================
    // Axiom active sets

    private final class AxiomActiveSets implements Constraint.Visitor<EventGraph> {

        @Override
        public EventGraph visitConstraint(Constraint constraint) {
            throw new UnsupportedOperationException("Active Set computation not supported for " + constraint.getClass().getSimpleName());
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
            logger.info("Computing active set for {}", axiom);
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

            final int originalSize = result.size();
            if (reduceAcyclicityActiveSets) {
                EventGraph obsolete = transitivelyDerivableMustEdges(exec, ra.getKnowledge(rel));
                result.removeAll(obsolete);
                final int reducedSize = result.size();

                logger.info("Active set size original/reduced: {} / {}", originalSize, reducedSize);
            } else {
                logger.info("Active set size: {} ", originalSize);
            }

            EventGraph mustSet = ra.getKnowledge(axiom.getRelation()).getMustSet();
            return MutableEventGraph.difference(result, mustSet);
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

    // ===============================================================================================
    // For lazy RA

    private void runLazy() {
        final Set<Relation> relations = memoryModel.getRelations();
        final List<Axiom> axioms = memoryModel.getAxioms();

        final Map<Relation, MutableEventGraph> mutableSets = new HashMap<>();
        final LazyEncodeSets visitor = new LazyEncodeSets(mutableSets);
        axioms.forEach(a -> {
            Relation r = a.getRelation();
            EventGraph eg = axiom2ActiveSets.get(a);
            MutableEventGraph copy = new MapEventGraph(eg.getOutMap());
            copy.retainAll(ra.getKnowledge(r).getMaySet());
            visitor.add(r, copy);
            // Force adding must edges to match the result of native analysis
            // TODO: Is it really necessary? Method getEventGraph appends them anyway
            mutableSets.get(r).addAll(eg);
        });

        this.relation2ActiveSets = relations.stream()
                .collect(Collectors.toMap(r -> r, r -> mutableSets.containsKey(r)
                ? mutableSets.get(r) : EventGraph.empty()));
    }

    private final class LazyEncodeSets implements Constraint.Visitor<Boolean> {

        private final Map<Relation, MutableEventGraph> data;
        private MutableEventGraph update;

        public LazyEncodeSets(Map<Relation, MutableEventGraph> data) {
            this.data = data;
        }

        public void add(Relation relation, MutableEventGraph eventGraph) {
            setUpdate(eventGraph);
            relation.getDefinition().accept(this);
        }

        @Override
        public Boolean visitDefinition(Definition definition) {
            throw new UnsupportedOperationException("Unsupported definition "
                    + definition.getDefinedRelation().getNameOrTerm() + " " + definition.getClass().getSimpleName());
        }

        @Override
        public Boolean visitTagSet(TagSet definition) {
            return doUpdateSelf(definition);
        }

        @Override
        public Boolean visitFree(Free definition) {
            return doUpdateSelf(definition);
        }

        @Override
        public Boolean visitExternal(External definition) {
            return doUpdateSelf(definition);
        }

        @Override
        public Boolean visitInternal(Internal definition) {
            return doUpdateSelf(definition);
        }

        @Override
        public Boolean visitProgramOrder(ProgramOrder definition) {
            return doUpdateSelf(definition);
        }

        @Override
        public Boolean visitSameInstruction(SameInstruction definition) {
            return doUpdateSelf(definition);
        }

        @Override
        public Boolean visitControlDependency(DirectControlDependency definition) {
            return doUpdateSelf(definition);
        }

        @Override
        public Boolean visitAddressDependency(DirectAddressDependency definition) {
            return doUpdateSelf(definition);
        }

        @Override
        public Boolean visitInternalDataDependency(DirectDataDependency definition) {
            return doUpdateSelf(definition);
        }

        @Override
        public Boolean visitCASDependency(CASDependency definition) {
            return doUpdateSelf(definition);
        }

        @Override
        public Boolean visitLinuxCriticalSections(LinuxCriticalSections definition) {
            return doUpdateSelf(definition);
        }

        @Override
        public Boolean visitAMOPairs(AMOPairs definition) {
            return doUpdateSelf(definition);
        }

        @Override
        public Boolean visitLXSXPairs(LXSXPairs definition) {
            return doUpdateSelf(definition);
        }

        @Override
        public Boolean visitCoherence(Coherence definition) {
            return doUpdateSelf(definition);
        }

        @Override
        public Boolean visitReadFrom(ReadFrom definition) {
            return doUpdateSelf(definition);
        }

        @Override
        public Boolean visitSameLocation(SameLocation definition) {
            return doUpdateSelf(definition);
        }

        @Override
        public Boolean visitSameScope(SameScope definition) {
            return doUpdateSelf(definition);
        }

        @Override
        public Boolean visitSyncBarrier(SyncBar definition) {
            return doUpdateSelf(definition);
        }

        @Override
        public Boolean visitSyncFence(SyncFence definition) {
            return doUpdateSelf(definition);
        }

        @Override
        public Boolean visitSameVirtualLocation(SameVirtualLocation definition) {
            return doUpdateSelf(definition);
        }

        @Override
        public Boolean visitSyncWith(SyncWith definition) {
            return doUpdateSelf(definition);
        }

        @Override
        public Boolean visitProduct(CartesianProduct definition) {
            if (doUpdateSelf(definition)) {
                long start = System.currentTimeMillis();
                MutableEventGraph domainUpdate = new MapEventGraph();
                MutableEventGraph rangeUpdate = new MapEventGraph();
                update.getDomain().forEach(e1 -> domainUpdate.add(e1, e1));
                update.getRange().forEach(e2 -> rangeUpdate.add(e2, e2));
                operandTime(definition, start, System.currentTimeMillis());
                setUpdate(domainUpdate);
                definition.getDomain().getDefinition().accept(this);
                setUpdate(rangeUpdate);
                definition.getRange().getDefinition().accept(this);
                return true;
            }
            return false;
        }

        @Override
        public Boolean visitSetIdentity(SetIdentity definition) {
            if (doUpdateSelf(definition)) {
                long start = System.currentTimeMillis();
                MutableEventGraph domainUpdate = new MapEventGraph();
                update.apply((e1, e2) -> domainUpdate.add(e1, e1));
                operandTime(definition, start, System.currentTimeMillis());
                setUpdate(domainUpdate);
                definition.getDomain().getDefinition().accept(this);
                return true;
            }
            return false;
        }

        @Override
        public Boolean visitProjection(Projection definition) {
            if (doUpdateSelf(definition)) {
                final long start = System.currentTimeMillis();
                final MutableEventGraph operandUpdate = new MapEventGraph();
                final boolean dom = definition.getDimension() == Projection.Dimension.DOMAIN;
                final EventGraph maySet = ra.getKnowledge(definition.getOperand()).getMaySet();
                final Map<Event, Set<Event>> altMap = dom ? maySet.getOutMap() : maySet.getInMap();
                if (dom) {
                    update.getDomain().forEach(e1 -> operandUpdate.addRange(e1, altMap.get(e1)));
                } else {
                    update.getDomain().forEach(e2 -> altMap.get(e2).forEach(e1 -> operandUpdate.add(e1, e2)));
                }
                setUpdate(operandUpdate);
                operandTime(definition, start, System.currentTimeMillis());
                definition.getOperand().getDefinition().accept(this);
                return true;
            }
            return false;
        }

        @Override
        public Boolean visitInverse(Inverse definition) {
            if (doUpdateSelf(definition)) {
                long start = System.currentTimeMillis();
                setUpdate(update.inverse());
                operandTime(definition, start, System.currentTimeMillis());
                definition.getOperand().getDefinition().accept(this);
                return true;
            }
            return false;
        }

        @Override
        public Boolean visitTransitiveClosure(TransitiveClosure definition) {
            if (doUpdateSelf(definition)) {
                long start = System.currentTimeMillis();
                MutableEventGraph operandUpdate = new MapEventGraph();
                RelationAnalysis.Knowledge knowledge = ra.getKnowledge(definition.getDefinedRelation());
                EventGraph may = ImmutableMapEventGraph.from(knowledge.getMaySet());
                EventGraph must = ImmutableMapEventGraph.from(knowledge.getMustSet());
                EventGraph mayInv = may.inverse();
                while (!update.isEmpty()) {
                    Map<Event, Set<Event>> next = new HashMap<>();
                    Map<Event, Set<Event>> nextInverse = new HashMap<>();
                    EventGraph updateInverse = update.inverse();
                    update.getDomain().forEach(e1 -> {
                        Set<Event> range = update.getRange(e1);
                        next.put(e1, may.getRange(e1).stream()
                                .filter(e -> may.getRange(e).stream().anyMatch(range::contains))
                                .collect(Collectors.toSet()));
                    });
                    updateInverse.getDomain().forEach(e2 -> {
                        Set<Event> range = updateInverse.getRange(e2);
                        nextInverse.put(e2, mayInv.getRange(e2).stream()
                                .filter(e -> mayInv.getRange(e).stream().anyMatch(range::contains))
                                .collect(Collectors.toSet()));
                    });
                    nextInverse.forEach((e2, range) -> range.forEach(e1 -> next.computeIfAbsent(e1, x -> new HashSet<>()).add(e2)));
                    operandUpdate.addAll(update);
                    update = new MapEventGraph(next);
                    update.removeAll(operandUpdate);
                    update.removeAll(must);
                }
                getEncodeKnowledge(definition.getDefinedRelation()).addAll(operandUpdate);
                operandUpdate.retainAll(ra.getKnowledge(definition.getOperand().getDefinition().getDefinedRelation()).getMaySet());
                setUpdate(operandUpdate);
                operandTime(definition, start, System.currentTimeMillis());
                definition.getOperand().getDefinition().accept(this);
                return true;
            }
            return false;
        }

        @Override
        public Boolean visitUnion(Union definition) {
            if (doUpdateSelf(definition)) {
                long totalTime = 0;
                List<Relation> operands = definition.getOperands();
                MutableEventGraph origUpdate = update;
                for (int i = 0; i < operands.size() - 1; i++) {
                    long start = System.currentTimeMillis();
                    Relation operand = operands.get(i);
                    MutableEventGraph newUpdate = MapEventGraph.from(origUpdate);
                    newUpdate.retainAll(ra.getKnowledge(operand.getDefinition().getDefinedRelation()).getMaySet());
                    setUpdate(newUpdate);
                    totalTime += System.currentTimeMillis() - start;
                    operand.getDefinition().accept(this);
                }
                long start = System.currentTimeMillis();
                Relation operand = operands.get(operands.size() - 1);
                origUpdate.retainAll(ra.getKnowledge(operand.getDefinition().getDefinedRelation()).getMaySet());
                setUpdate(origUpdate);
                operandTime(definition, start, totalTime + System.currentTimeMillis());
                operand.getDefinition().accept(this);
                return true;
            }
            return false;
        }

        @Override
        public Boolean visitIntersection(Intersection definition) {
            if (doUpdateSelf(definition)) {
                long totalTime = 0;
                List<Relation> operands = definition.getOperands();
                MutableEventGraph origUpdate = update;
                for (int i = 0; i < operands.size() - 1; i++) {
                    long start = System.currentTimeMillis();
                    Relation operand = operands.get(i);
                    MutableEventGraph newUpdate = MapEventGraph.from(origUpdate);
                    setUpdate(newUpdate);
                    totalTime += System.currentTimeMillis() - start;
                    operand.getDefinition().accept(this);
                }
                long start = System.currentTimeMillis();
                Relation operand = operands.get(operands.size() - 1);
                setUpdate(origUpdate);
                operandTime(definition, start, totalTime + System.currentTimeMillis());
                operand.getDefinition().accept(this);
                return true;
            }
            return false;
        }

        @Override
        public Boolean visitDifference(Difference definition) {
            if (doUpdateSelf(definition)) {
                long totalTime = 0;
                long start = System.currentTimeMillis();
                MutableEventGraph origUpdate = update;
                MutableEventGraph newUpdate = MapEventGraph.from(origUpdate);
                setUpdate(newUpdate);
                totalTime += System.currentTimeMillis() - start;
                definition.getMinuend().getDefinition().accept(this);
                start = System.currentTimeMillis();
                Relation subtrahend = definition.getSubtrahend().getDefinition().getDefinedRelation();
                origUpdate.retainAll(ra.getKnowledge(subtrahend).getMaySet());
                setUpdate(origUpdate);
                operandTime(definition, start, totalTime + System.currentTimeMillis());
                definition.getSubtrahend().getDefinition().accept(this);
                return true;
            }
            return false;
        }

        @Override
        public Boolean visitComposition(Composition definition) {
            if (doUpdateSelf(definition)) {
                long start = System.currentTimeMillis();
                MapEventGraph leftUpdate = new MapEventGraph();
                MapEventGraph rightUpdate = new MapEventGraph();
                RelationAnalysis.Knowledge leftKnowledge = ra.getKnowledge(definition.getLeftOperand());
                RelationAnalysis.Knowledge rightKnowledge = ra.getKnowledge(definition.getRightOperand());
                EventGraph mayLeft = ImmutableMapEventGraph.from(leftKnowledge.getMaySet());
                EventGraph mayRightInverse = ImmutableMapEventGraph.from(rightKnowledge.getMaySet()).inverse();
                for (Event e1 : update.getDomain()) {
                    for (Event e2 : update.getRange(e1)) {
                        Set<Event> intermediate = Sets.intersection(mayLeft.getRange(e1), mayRightInverse.getRange(e2));
                        for (Event e : intermediate) {
                            leftUpdate.add(e1, e);
                            rightUpdate.add(e, e2);
                        }
                    }
                }
                operandTime(definition, start, System.currentTimeMillis());
                setUpdate(leftUpdate);
                definition.getLeftOperand().getDefinition().accept(this);
                setUpdate(rightUpdate);
                definition.getRightOperand().getDefinition().accept(this);
                return true;
            }
            return false;
        }

        private boolean doUpdateSelf(Definition definition) {
            long start = System.currentTimeMillis();
            Relation relation = definition.getDefinedRelation();
            MutableEventGraph encode = getEncodeKnowledge(relation);
            update.removeAll(ra.getKnowledge(relation).getMustSet());
            update.removeAll(encode);
            boolean result = encode.addAll(update);
            time(definition, start, System.currentTimeMillis(), update.size());
            return result;
        }

        private MutableEventGraph getEncodeKnowledge(Relation relation) {
            return data.computeIfAbsent(relation, x -> new MapEventGraph());
        }

        private void setUpdate(MutableEventGraph update) {
            this.update = update;
        }

        private void time(Definition definition, long start, long end, int size) {
            if (logger.isDebugEnabled()) {
                logger.debug(String.format("%6s ms : %6s edges : %s", end - start, size,
                        definition.getDefinedRelation().getNameOrTerm()));
            }
        }

        private void operandTime(Definition definition, long start, long end) {
            if (logger.isDebugEnabled()) {
                logger.debug(String.format("%6s ms : %s", end - start,
                        definition.getDefinedRelation().getNameOrTerm()));
            }
        }
    }

    // ===============================================================================================
    // For standard RA

    private void runNative(NativeRelationAnalysis nra) {
        final Set<Relation> relations = memoryModel.getRelations();
        final List<Axiom> axioms = memoryModel.getAxioms();

        final Map<Relation, MutableEventGraph> mutableSets = new HashMap<>();
        relations.forEach(r -> mutableSets.put(r, new MapEventGraph()));

        final Map<Relation, List<EventGraph>> queue = new HashMap<>();
        axioms.forEach(a -> {
            if (!(axiom2ActiveSets.get(a) instanceof MutableEventGraph mutable)) {
                throw new IllegalArgumentException("Unexpected immutable event graph in " + nra.getClass().getSimpleName());
            }
            queue.computeIfAbsent(a.getRelation(), k -> new ArrayList<>()).add(mutable);
        });
        nra.populateQueue(queue, relations);

        final NativeEncodeSets visitor = new NativeEncodeSets();
        while (!queue.isEmpty()) {
            Relation r = queue.keySet().iterator().next();
            logger.trace("Update encode set of '{}'", r);
            MutableEventGraph s = mutableSets.get(r);
            MutableEventGraph c = new MapEventGraph();
            queue.remove(r).forEach(news -> news.filter(s::add).apply(c::add));
            if (!c.isEmpty()) {
                visitor.news = c;
                r.getDefinition().accept(visitor)
                        .forEach((key, value) -> queue.computeIfAbsent(key, k -> new ArrayList<>()).add(value));
            }
        }

        this.relation2ActiveSets = relations.stream().collect(Collectors.toMap(r -> r, mutableSets::get));
    }

    private final class NativeEncodeSets implements Constraint.Visitor<Map<Relation, EventGraph>> {

        EventGraph news;

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

        private EventGraph filterUnknowns(EventGraph news, Relation relation) {
            RelationAnalysis.Knowledge k = ra.getKnowledge(relation);
            EventGraph may = k.getMaySet();
            EventGraph must = k.getMustSet();
            return news.filter((e1, e2) -> may.contains(e1, e2) && !must.contains(e1, e2));
        }

        private static Map<Relation, EventGraph> map(Relation r1, EventGraph s1, Relation r2, EventGraph s2) {
            return r1.equals(r2) ? Map.of(r1, EventGraph.union(s1, s2)) : Map.of(r1, s1, r2, s2);
        }
    }
}
