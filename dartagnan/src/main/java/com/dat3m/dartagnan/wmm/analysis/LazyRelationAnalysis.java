package com.dat3m.dartagnan.wmm.analysis;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.utils.collections.IndexedDomain;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.definition.*;
import com.dat3m.dartagnan.wmm.utils.Dimension;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.immutable.ImmutableEventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.immutable.LazyEventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.mutable.IndexedEventGraph;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.sosy_lab.common.configuration.Configuration;

import java.util.*;

import static java.util.stream.Collectors.toSet;

public class LazyRelationAnalysis extends NativeRelationAnalysis {

    private static final Logger logger = LoggerFactory.getLogger(LazyRelationAnalysis.class);

    private final Map<Relation, RelationAnalysis.Knowledge> lazyKnowledgeMap = new HashMap<>();
    private final LazyInitializer lazyInitializer;
    private final Initializer nativeInitializer;

    private LazyRelationAnalysis(VerificationTask task, Context context, Configuration config) {
        super(task, context, config);
        // TODO: Support for recursive relations
        if (task.getMemoryModel().getRelations().stream().anyMatch(Relation::isRecursive)) {
            throw new UnsupportedOperationException(
                    "LazyRelationAnalysis does not support recursive relations yet. " +
                            "Use another relation analysis method.");
        }
        this.lazyInitializer = new LazyInitializer();
        this.nativeInitializer = super.getInitializer();
    }

    public static LazyRelationAnalysis fromConfig(VerificationTask task, Context context, Configuration config) {
        return new LazyRelationAnalysis(task, context, config);
    }

    @Override
    public RelationAnalysis.Knowledge getKnowledge(Relation relation) {
        return lazyInitializer.getKnowledge(relation);
    }

    @Override
    public EventGraph getContradictions() {
        return ImmutableEventGraph.empty();
    }

    @Override
    public void run() {
        initializeEventDomain();
        for (Relation relation : task.getMemoryModel().getRelations()) {
            lazyKnowledgeMap.put(relation, lazyInitializer.getKnowledge(relation));
        }
    }

    @Override
    public void runExtended() {
        // TODO: Implementation
    }

    @Override
    public void collectDiscrepancies(Set<Relation> relations, Map<Relation, List<EventGraph>> discrepancies) {
        // Without XRA (runExtended() is currently no implemented), there are no discrepancies
    }

    private class LazyInitializer implements Definition.Visitor<RelationAnalysis.Knowledge> {

        public LazyInitializer() {}

        public RelationAnalysis.Knowledge getKnowledge(Relation relation) {
            if (!lazyKnowledgeMap.containsKey(relation)) {
                RelationAnalysis.Knowledge knowledge = relation.getDefinition().accept(this);
                lazyKnowledgeMap.put(relation, knowledge);
            }
            return lazyKnowledgeMap.get(relation);
        }

        @Override
        public RelationAnalysis.Knowledge visitDefinition(Definition definition) {
            if (definition.getConstrainedRelations().size() > 1) {
                throw new UnsupportedOperationException(
                        "Unsupported relation %s.".formatted(definition.getDefinedRelation().getNameOrTerm()));
            }
            final long start = System.currentTimeMillis();
            final RelationAnalysis.Knowledge base = definition.accept(nativeInitializer);
            final EventGraph may = ImmutableEventGraph.from(base.getMaySet());
            final EventGraph must = ImmutableEventGraph.from(base.getMustSet());
            time(definition, start, System.currentTimeMillis());
            return new RelationAnalysis.Knowledge(may, must);
        }

        @Override
        public RelationAnalysis.Knowledge visitFree(Free definition) {
            long start = System.currentTimeMillis();
            EventGraph may = new LazyEventGraph(allVisibleEvents, allVisibleEvents, (e1, e2) -> true);
            EventGraph must = ImmutableEventGraph.empty();
            time(definition, start, System.currentTimeMillis());
            return new RelationAnalysis.Knowledge(may, must);
        }

        @Override
        public RelationAnalysis.Knowledge visitProduct(CartesianProduct definition) {
            final RelationAnalysis.Knowledge domain = getKnowledge(definition.getDomain());
            final RelationAnalysis.Knowledge range = getKnowledge(definition.getRange());
            final EventGraph mayDomain = domain.getMaySet();
            final EventGraph mustDomain = domain.getMustSet();
            final EventGraph mayRange = range.getMaySet();
            final EventGraph mustRange = range.getMustSet();
            long start = System.currentTimeMillis();
            final EventGraph may = new LazyEventGraph(mayDomain.getDomain(), mayRange.getDomain(),
                    (e1, e2) -> mayDomain.contains(e1, e1) && mayRange.contains(e2, e2) &&
                            !exec.areMutuallyExclusive(e1, e2));
            final EventGraph must = new LazyEventGraph(mustDomain.getDomain(), mustRange.getDomain(),
                    (e1, e2) -> mustDomain.contains(e1, e1) && mustRange.contains(e2, e2) &&
                            !exec.areMutuallyExclusive(e1, e2));
            time(definition, start, System.currentTimeMillis());
            return new RelationAnalysis.Knowledge(may, must);
        }

        @Override
        public RelationAnalysis.Knowledge visitSetIdentity(SetIdentity definition) {
            final RelationAnalysis.Knowledge domain = getKnowledge(definition.getDomain());
            final EventGraph mayDomain = domain.getMaySet();
            final EventGraph mustDomain = domain.getMustSet();
            long start = System.currentTimeMillis();
            final EventGraph may = new LazyEventGraph(mayDomain.getDomain(), mayDomain.getDomain(),
                    (e1, e2) -> e1.equals(e2) && mayDomain.contains(e1, e2));
            final EventGraph must = new LazyEventGraph(mustDomain.getDomain(), mustDomain.getDomain(),
                    (e1, e2) -> e1.equals(e2) && mustDomain.contains(e1, e2));
            time(definition, start, System.currentTimeMillis());
            return new RelationAnalysis.Knowledge(may, must);
        }

        @Override
        public RelationAnalysis.Knowledge visitTagSet(TagSet definition) {
            final Set<Event> domain = Set.copyOf(task.getProgram().getThreadEventsWithAllTags(definition.getTag()));
            final EventGraph must = new LazyEventGraph(domain, domain, Object::equals);
            return new RelationAnalysis.Knowledge(must, must);
        }

        @Override
        public RelationAnalysis.Knowledge visitInternal(Internal definition) {
            long start = System.currentTimeMillis();
            EventGraph must = new LazyEventGraph(allVisibleEvents, allVisibleEvents,
                    (e1, e2) -> e1.getThread().equals(e2.getThread())
                            && !exec.areMutuallyExclusive(e1, e2));
            time(definition, start, System.currentTimeMillis());
            return new RelationAnalysis.Knowledge(must, must);
        }

        @Override
        public RelationAnalysis.Knowledge visitExternal(External definition) {
            long start = System.currentTimeMillis();
            EventGraph must = new LazyEventGraph(allVisibleEvents, allVisibleEvents,
                    (e1, e2) -> !e1.getThread().equals(e2.getThread()));
            time(definition, start, System.currentTimeMillis());
            return new RelationAnalysis.Knowledge(must, must);
        }

        @Override
        public RelationAnalysis.Knowledge visitProgramOrder(ProgramOrder definition) {
            long start = System.currentTimeMillis();
            Set<Event> domain = allVisibleEvents.stream().filter(e1 -> allVisibleEvents.stream()
                            .anyMatch(e2 -> e1.getThread().equals(e2.getThread())
                                    && e1.getGlobalId() < e2.getGlobalId()
                                    && !exec.areMutuallyExclusive(e1, e2)))
                    .collect(toSet());
            Set<Event> range = allVisibleEvents.stream().filter(e2 -> allVisibleEvents.stream()
                            .anyMatch(e1 -> e1.getThread().equals(e2.getThread())
                                    && e1.getGlobalId() < e2.getGlobalId()
                                    && !exec.areMutuallyExclusive(e1, e2)))
                    .collect(toSet());
            EventGraph must = new LazyEventGraph(domain, range,
                    (e1, e2) -> e1.getThread().equals(e2.getThread())
                            && e1.getGlobalId() < e2.getGlobalId()
                            && !exec.areMutuallyExclusive(e1, e2));
            time(definition, start, System.currentTimeMillis());
            return new RelationAnalysis.Knowledge(must, must);
        }

        @Override
        public RelationAnalysis.Knowledge visitInverse(Inverse definition) {
            RelationAnalysis.Knowledge knowledge = getKnowledge(definition.getOperand());
            long start = System.currentTimeMillis();
            EventGraph may = knowledge.getMaySet().inverse();
            EventGraph must = knowledge.getMustSet().inverse();
            time(definition, start, System.currentTimeMillis());
            return new RelationAnalysis.Knowledge(may, must);
        }

        @Override
        public RelationAnalysis.Knowledge visitUnion(Union definition) {
            List<RelationAnalysis.Knowledge> operands = definition.getOperands().stream()
                    .map(o -> getKnowledge(o.getDefinition().getDefinedRelation()))
                    .toList();
            long start = System.currentTimeMillis();
            EventGraph may = ImmutableEventGraph.union(operands.stream().map(RelationAnalysis.Knowledge::getMaySet).toArray(EventGraph[]::new));
            EventGraph must = ImmutableEventGraph.union(operands.stream().map(RelationAnalysis.Knowledge::getMustSet).toArray(EventGraph[]::new));
            time(definition, start, System.currentTimeMillis());
            return new RelationAnalysis.Knowledge(may, must);
        }

        @Override
        public RelationAnalysis.Knowledge visitIntersection(Intersection definition) {
            List<RelationAnalysis.Knowledge> operands = definition.getOperands().stream()
                    .map(o -> getKnowledge(o.getDefinition().getDefinedRelation()))
                    .toList();
            long start = System.currentTimeMillis();
            EventGraph may = ImmutableEventGraph.intersection(operands.stream().map(RelationAnalysis.Knowledge::getMaySet).toArray(EventGraph[]::new));
            EventGraph must = ImmutableEventGraph.intersection(operands.stream().map(RelationAnalysis.Knowledge::getMustSet).toArray(EventGraph[]::new));
            time(definition, start, System.currentTimeMillis());
            return new RelationAnalysis.Knowledge(may, must);
        }

        @Override
        public RelationAnalysis.Knowledge visitDifference(Difference definition) {
            RelationAnalysis.Knowledge knowledgeMinuend = getKnowledge(definition.getMinuend());
            RelationAnalysis.Knowledge knowledgeSubtrahend = getKnowledge(definition.getSubtrahend());
            long start = System.currentTimeMillis();
            EventGraph may = ImmutableEventGraph.difference(knowledgeMinuend.getMaySet(), knowledgeSubtrahend.getMustSet());
            EventGraph must = ImmutableEventGraph.difference(knowledgeMinuend.getMustSet(), knowledgeSubtrahend.getMaySet());
            time(definition, start, System.currentTimeMillis());
            return new RelationAnalysis.Knowledge(may, must);
        }

        @Override
        public RelationAnalysis.Knowledge visitComposition(Composition definition) {
            final RelationAnalysis.Knowledge left = getKnowledge(definition.getLeftOperand());
            final RelationAnalysis.Knowledge right = getKnowledge(definition.getRightOperand());
            final long start = System.currentTimeMillis();
            final EventGraph may = computeComposition(left.getMaySet(), right.getMaySet()).getMaySet();
            final EventGraph must = computeComposition(left.getMustSet(), right.getMustSet()).getMustSet();
            time(definition, start, System.currentTimeMillis());
            return new RelationAnalysis.Knowledge(may, must);
        }

        @Override
        public RelationAnalysis.Knowledge visitProjection(Projection definition) {
            final RelationAnalysis.Knowledge operand = getKnowledge(definition.getOperand());
            final long start = System.currentTimeMillis();
            final EventGraph may = computeProjection(operand.getMaySet(), definition.getDimension(), false);
            final var must = computeProjection(operand.getMustSet(), definition.getDimension(), true);
            time(definition, start, System.currentTimeMillis());
            return new RelationAnalysis.Knowledge(may, must);
        }

        @Override
        public RelationAnalysis.Knowledge visitTransitiveClosure(TransitiveClosure definition) {
            final Knowledge operand = getKnowledge(definition.getOperand());
            final long start = System.currentTimeMillis();
            final EventGraph maySet = computeTransitiveClosure(operand.getMaySet()).getMaySet();
            final EventGraph mustSet = computeTransitiveClosure(operand.getMustSet()).getMustSet();
            time(definition, start, System.currentTimeMillis());
            return new RelationAnalysis.Knowledge(maySet, mustSet);
        }

        private EventGraph computeProjection(EventGraph operand, Dimension dimension, boolean must) {
            final IndexedDomain<Event> eventDomain = eventDomain(operand, dimension);
            final EventGraph directed = switch (dimension) {
                case DOMAIN -> operand;
                case RANGE -> operand.inverse();
            };
            final var projection = new IndexedEventGraph(eventDomain);
            final IndexedEventGraph o = directed instanceof IndexedEventGraph g ? g
                    : new IndexedEventGraph(eventDomain, eventDomain, directed);
            for (Event e : o.getDomain()) {
                if (must ? o.getRange(e).stream().anyMatch(ee -> exec.isImplied(e, ee)) : !o.getRange(e).isEmpty()) {
                    projection.add(e, e);
                }
            }
            return projection.toUnmodifiableCopy();
        }

        private IndexedDomain<Event> eventDomain(EventGraph graph, Dimension dimension) {
            return graph instanceof IndexedEventGraph g ? g.eventDomain(dimension) : allEvents.domain();
        }

        private void time(Definition definition, long start, long end) {
            if (logger.isDebugEnabled()) {
                logger.debug(String.format("LRA initial knowledge %6s ms : %s", end - start,
                        definition.getDefinedRelation().getNameOrTerm()));
            }
        }
    }
}
