package com.dat3m.dartagnan.wmm.analysis;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.MemoryEvent;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.filter.Filter;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Constraint;
import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.definition.*;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.immutable.ImmutableEventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.immutable.ImmutableMapEventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.immutable.LazyEventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.mutable.MapEventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.mutable.MutableEventGraph;
import com.google.common.collect.Sets;
import org.sosy_lab.common.configuration.Configuration;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

import static com.dat3m.dartagnan.program.event.Tag.*;
import static java.util.stream.Collectors.toSet;

// TODO: Support for missing relations + recursive relations
public class LazyRelationAnalysis implements RelationAnalysis, Constraint.Visitor<RelationAnalysis.Knowledge> {

    private final VerificationTask task;
    private final Program program;
    private final ExecutionAnalysis exec;
    private final AliasAnalysis alias;
    public final Set<Event> allEvents;
    private final Set<Event> visibleEvents;
    private final Set<Event> memoryEvents;
    private final Map<Relation, RelationAnalysis.Knowledge> knowledgeMap = new HashMap<>();
    private final NativeRelationAnalysis.Initializer initializer;

    // TODO: A proper way to pass encode sets from WmmEncoder
    public Map<Relation, MutableEventGraph> encodeSets;

    public LazyRelationAnalysis(VerificationTask task, Context context) {
        this.task = task;
        this.program = task.getProgram();
        this.exec = context.requires(ExecutionAnalysis.class);
        this.alias = context.requires(AliasAnalysis.class);
        this.allEvents = new HashSet<>(program.getThreadEvents());
        this.visibleEvents = new HashSet<>(program.getThreadEventsWithAllTags(VISIBLE));
        this.memoryEvents = new HashSet<>(program.getThreadEvents(MemoryCoreEvent.class));
        this.initializer = new NativeRelationAnalysis.Initializer(task, context);
    }

    public static LazyRelationAnalysis fromConfig(VerificationTask task, Context context, Configuration config) {
        return new LazyRelationAnalysis(task, context);
    }

    @Override
    public RelationAnalysis.Knowledge getKnowledge(Relation relation) {
        if (!knowledgeMap.containsKey(relation)) {
            RelationAnalysis.Knowledge knowledge = relation.getDefinition().accept(this);
            knowledgeMap.put(relation, knowledge);
        }
        return knowledgeMap.get(relation);
    }

    public MutableEventGraph getEncodeKnowledge(Relation relation) {
        return encodeSets.computeIfAbsent(relation, x -> new MapEventGraph());
    }

    @Override
    public EventGraph getContradictions() {
        return EventGraph.empty();
    }

    @Override
    // TODO: A generic implementation that doesn't duplicate NativeRelationAnalysis
    public EventGraph findTransitivelyImpliedCo(Relation co) {
        RelationAnalysis.Knowledge k = getKnowledge(co);
        MapEventGraph transCo = new MapEventGraph();
        Map<Event, Set<Event>> mustIn = k.getMustSet().getInMap();
        Map<Event, Set<Event>> mustOut = k.getMustSet().getOutMap();
        k.getMaySet().apply((e1, e2) -> {
            MemoryEvent x = (MemoryEvent) e1;
            MemoryEvent z = (MemoryEvent) e2;
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
        task.getMemoryModel().getRelations().stream()
                .sorted(Comparator.comparing(Relation::getNameOrTerm))
                .forEach(this::getKnowledge);
    }

    @Override
    public void runExtended() {
        // TODO: Implementation
    }

    @Override
    public long countMaySet() {
        return knowledgeMap.values().stream().mapToLong(k -> k.getMaySet().size()).sum();
    }

    @Override
    public long countMustSet() {
        return knowledgeMap.values().stream().mapToLong(k -> k.getMustSet().size()).sum();
    }

    @Override
    public void populateQueue(Map<Relation, List<MutableEventGraph>> queue, Set<Relation> relations) {
        EncodeSetVisitor visitor = new EncodeSetVisitor();
        for (Map.Entry<Relation, List<MutableEventGraph>> entry : queue.entrySet()) {
            Relation relation = entry.getKey();
            List<MutableEventGraph> data = entry.getValue();
            if (!data.isEmpty()) {
                MapEventGraph encode = (MapEventGraph)data.get(0);
                for (int i = 1; i < data.size(); i++) {
                    encode.addAll(data.get(i));
                }
                encode.retainAll(getKnowledge(relation).getMaySet());
                visitor.setUpdate(encode);
                relation.getDefinition().accept(visitor);
            }
        }
        queue.clear();
    }

    @Override
    public RelationAnalysis.Knowledge visitDefinition(Definition def) {
        throw new UnsupportedOperationException("Unsupported relation " + def.getDefinedRelation().getNameOrTerm());
    }

    @Override
    public RelationAnalysis.Knowledge visitFree(Free definition) {
        long start = System.currentTimeMillis();
        EventGraph may = new LazyEventGraph(visibleEvents, visibleEvents, (e1, e2) -> true);
        EventGraph must = EventGraph.empty();
        logTime(definition, start, System.currentTimeMillis());
        return new RelationAnalysis.Knowledge(may, must);
    }

    @Override
    public RelationAnalysis.Knowledge visitProduct(CartesianProduct definition) {
        Filter domainFilter = definition.getFirstFilter();
        Filter rangeFilter = definition.getSecondFilter();
        long start = System.currentTimeMillis();
        Set<Event> domain = program.getThreadEvents().stream().filter(domainFilter::apply).collect(toSet());
        Set<Event> range = program.getThreadEvents().stream().filter(rangeFilter::apply).collect(toSet());
        EventGraph must = new LazyEventGraph(domain, range, (e1, e2) -> !exec.areMutuallyExclusive(e1, e2));
        logTime(definition, start, System.currentTimeMillis());
        return new RelationAnalysis.Knowledge(must, must);
    }

    @Override
    public RelationAnalysis.Knowledge visitSetIdentity(SetIdentity definition) {
        Filter filter = definition.getFilter();
        long start = System.currentTimeMillis();
        Set<Event> events = program.getThreadEvents().stream().filter(filter::apply).collect(toSet());
        EventGraph must = new LazyEventGraph(events, events, Object::equals);
        logTime(definition, start, System.currentTimeMillis());
        return new RelationAnalysis.Knowledge(must, must);
    }

    @Override
    public RelationAnalysis.Knowledge visitExternal(External definition) {
        long start = System.currentTimeMillis();
        EventGraph must = new LazyEventGraph(visibleEvents, visibleEvents,
                (e1, e2) -> !e1.getThread().equals(e2.getThread()));
        logTime(definition, start, System.currentTimeMillis());
        return new RelationAnalysis.Knowledge(must, must);
    }

    @Override
    public RelationAnalysis.Knowledge visitInternal(Internal definition) {
        long start = System.currentTimeMillis();
        EventGraph must = new LazyEventGraph(visibleEvents, visibleEvents,
                (e1, e2) -> e1.getThread().equals(e2.getThread())
                        && !exec.areMutuallyExclusive(e1, e2));
        logTime(definition, start, System.currentTimeMillis());
        return new RelationAnalysis.Knowledge(must, must);
    }

    @Override
    public RelationAnalysis.Knowledge visitProgramOrder(ProgramOrder definition) {
        long start = System.currentTimeMillis();
        EventGraph must = new LazyEventGraph(visibleEvents, visibleEvents,
                (e1, e2) -> e1.getThread().equals(e2.getThread())
                        && e1.getGlobalId() < e2.getGlobalId()
                        && !exec.areMutuallyExclusive(e1, e2));
        logTime(definition, start, System.currentTimeMillis());
        return new RelationAnalysis.Knowledge(must, must);
    }

    @Override
    public RelationAnalysis.Knowledge visitControlDependency(DirectControlDependency definition) {
        long start = System.currentTimeMillis();
        NativeRelationAnalysis.MutableKnowledge mutable = initializer.visitControlDependency(definition);
        EventGraph may = ImmutableMapEventGraph.from(mutable.getMaySet());
        EventGraph must = ImmutableMapEventGraph.from(mutable.getMustSet());
        logTime(definition, start, System.currentTimeMillis());
        return new RelationAnalysis.Knowledge(may, must);
    }

    @Override
    public RelationAnalysis.Knowledge visitAddressDependency(DirectAddressDependency definition) {
        long start = System.currentTimeMillis();
        NativeRelationAnalysis.MutableKnowledge mutable = initializer.visitAddressDependency(definition);
        EventGraph may = ImmutableMapEventGraph.from(mutable.getMaySet());
        EventGraph must = ImmutableMapEventGraph.from(mutable.getMustSet());
        logTime(definition, start, System.currentTimeMillis());
        return new RelationAnalysis.Knowledge(may, must);
    }

    @Override
    public RelationAnalysis.Knowledge visitInternalDataDependency(DirectDataDependency definition) {
        long start = System.currentTimeMillis();
        NativeRelationAnalysis.MutableKnowledge mutable = initializer.visitInternalDataDependency(definition);
        EventGraph may = ImmutableMapEventGraph.from(mutable.getMaySet());
        EventGraph must = ImmutableMapEventGraph.from(mutable.getMustSet());
        logTime(definition, start, System.currentTimeMillis());
        return new RelationAnalysis.Knowledge(may, must);
    }

    @Override
    public RelationAnalysis.Knowledge visitFences(Fences definition) {
        long start = System.currentTimeMillis();
        NativeRelationAnalysis.MutableKnowledge mutable = initializer.visitFences(definition);
        EventGraph may = ImmutableMapEventGraph.from(mutable.getMaySet());
        EventGraph must = ImmutableMapEventGraph.from(mutable.getMustSet());
        logTime(definition, start, System.currentTimeMillis());
        return new RelationAnalysis.Knowledge(may, must);
    }

    @Override
    public RelationAnalysis.Knowledge visitCASDependency(CASDependency definition) {
        long start = System.currentTimeMillis();
        NativeRelationAnalysis.MutableKnowledge mutable = initializer.visitCASDependency(definition);
        EventGraph may = ImmutableMapEventGraph.from(mutable.getMaySet());
        EventGraph must = ImmutableMapEventGraph.from(mutable.getMustSet());
        logTime(definition, start, System.currentTimeMillis());
        return new RelationAnalysis.Knowledge(may, must);
    }

    @Override
    public RelationAnalysis.Knowledge visitLinuxCriticalSections(LinuxCriticalSections definition) {
        long start = System.currentTimeMillis();
        NativeRelationAnalysis.MutableKnowledge mutable = initializer.visitLinuxCriticalSections(definition);
        EventGraph may = ImmutableMapEventGraph.from(mutable.getMaySet());
        EventGraph must = ImmutableMapEventGraph.from(mutable.getMustSet());
        logTime(definition, start, System.currentTimeMillis());
        return new RelationAnalysis.Knowledge(may, must);
    }

    @Override
    public RelationAnalysis.Knowledge visitReadModifyWrites(ReadModifyWrites definition) {
        long start = System.currentTimeMillis();
        NativeRelationAnalysis.MutableKnowledge mutable = initializer.visitReadModifyWrites(definition);
        EventGraph may = ImmutableMapEventGraph.from(mutable.getMaySet());
        EventGraph must = ImmutableMapEventGraph.from(mutable.getMustSet());
        logTime(definition, start, System.currentTimeMillis());
        return new RelationAnalysis.Knowledge(may, must);
    }

    @Override
    public RelationAnalysis.Knowledge visitCoherence(Coherence definition) {
        long start = System.currentTimeMillis();
        NativeRelationAnalysis.MutableKnowledge mutable = initializer.visitCoherence(definition);
        EventGraph may = ImmutableMapEventGraph.from(mutable.getMaySet());
        EventGraph must = ImmutableMapEventGraph.from(mutable.getMustSet());
        logTime(definition, start, System.currentTimeMillis());
        return new RelationAnalysis.Knowledge(may, must);
    }

    @Override
    public RelationAnalysis.Knowledge visitReadFrom(ReadFrom definition) {
        long start = System.currentTimeMillis();
        NativeRelationAnalysis.MutableKnowledge mutable = initializer.visitReadFrom(definition);
        EventGraph may = ImmutableMapEventGraph.from(mutable.getMaySet());
        EventGraph must = ImmutableMapEventGraph.from(mutable.getMustSet());
        logTime(definition, start, System.currentTimeMillis());
        return new RelationAnalysis.Knowledge(may, must);
    }

    @Override
    public RelationAnalysis.Knowledge visitSameLocation(SameLocation definition) {
        long start = System.currentTimeMillis();
        EventGraph may = new LazyEventGraph(memoryEvents, memoryEvents,
                (e1, e2) -> alias.mayAlias((MemoryCoreEvent)e1, (MemoryCoreEvent)e2) && !exec.areMutuallyExclusive(e1, e2));
        EventGraph must = new LazyEventGraph(memoryEvents, memoryEvents,
                (e1, e2) -> alias.mustAlias((MemoryCoreEvent)e1, (MemoryCoreEvent)e2) && !exec.areMutuallyExclusive(e1, e2));
        logTime(definition, start, System.currentTimeMillis());
        return new RelationAnalysis.Knowledge(may, must);
    }

    @Override
    public RelationAnalysis.Knowledge visitSameScope(SameScope definition) {
        long start = System.currentTimeMillis();
        NativeRelationAnalysis.MutableKnowledge mutable = initializer.visitSameScope(definition);
        EventGraph may = ImmutableMapEventGraph.from(mutable.getMaySet());
        EventGraph must = ImmutableMapEventGraph.from(mutable.getMustSet());
        logTime(definition, start, System.currentTimeMillis());
        return new RelationAnalysis.Knowledge(may, must);
    }

    @Override
    public RelationAnalysis.Knowledge visitSyncBarrier(SyncBar definition) {
        long start = System.currentTimeMillis();
        NativeRelationAnalysis.MutableKnowledge mutable = initializer.visitSyncBarrier(definition);
        EventGraph may = ImmutableMapEventGraph.from(mutable.getMaySet());
        EventGraph must = ImmutableMapEventGraph.from(mutable.getMustSet());
        logTime(definition, start, System.currentTimeMillis());
        return new RelationAnalysis.Knowledge(may, must);
    }

    @Override
    public RelationAnalysis.Knowledge visitSyncFence(SyncFence definition) {
        long start = System.currentTimeMillis();
        NativeRelationAnalysis.MutableKnowledge mutable = initializer.visitSyncFence(definition);
        EventGraph may = ImmutableMapEventGraph.from(mutable.getMaySet());
        EventGraph must = ImmutableMapEventGraph.from(mutable.getMustSet());
        logTime(definition, start, System.currentTimeMillis());
        return new RelationAnalysis.Knowledge(may, must);
    }

    @Override
    public RelationAnalysis.Knowledge visitSameVirtualLocation(SameVirtualLocation definition) {
        long start = System.currentTimeMillis();
        NativeRelationAnalysis.MutableKnowledge mutable = initializer.visitSameVirtualLocation(definition);
        EventGraph may = ImmutableMapEventGraph.from(mutable.getMaySet());
        EventGraph must = ImmutableMapEventGraph.from(mutable.getMustSet());
        logTime(definition, start, System.currentTimeMillis());
        return new RelationAnalysis.Knowledge(may, must);
    }

    @Override
    public RelationAnalysis.Knowledge visitSyncWith(SyncWith definition) {
        long start = System.currentTimeMillis();
        NativeRelationAnalysis.MutableKnowledge mutable = initializer.visitSyncWith(definition);
        EventGraph may = ImmutableMapEventGraph.from(mutable.getMaySet());
        EventGraph must = ImmutableMapEventGraph.from(mutable.getMustSet());
        logTime(definition, start, System.currentTimeMillis());
        return new RelationAnalysis.Knowledge(may, must);
    }

    @Override
    public RelationAnalysis.Knowledge visitDomainIdentity(DomainIdentity definition) {
        RelationAnalysis.Knowledge knowledge = getKnowledge(definition.getOperand());
        long start = System.currentTimeMillis();
        Set<Event> maySet = knowledge.getMaySet().getDomain();
        Set<Event> mustSet = knowledge.getMustSet().filter(exec::isImplied).getDomain();
        EventGraph may = new LazyEventGraph(maySet, maySet, Object::equals);
        EventGraph must = new LazyEventGraph(mustSet, mustSet, Object::equals);
        logTime(definition, start, System.currentTimeMillis());
        return new RelationAnalysis.Knowledge(may, must);
    }

    @Override
    public RelationAnalysis.Knowledge visitRangeIdentity(RangeIdentity definition) {
        RelationAnalysis.Knowledge knowledge = getKnowledge(definition.getOperand());
        long start = System.currentTimeMillis();
        Set<Event> maySet = knowledge.getMaySet().getRange();
        Set<Event> mustSet = knowledge.getMustSet().filter((e1, e2) -> exec.isImplied(e2, e1)).getRange();
        EventGraph may = new LazyEventGraph(maySet, maySet, Object::equals);
        EventGraph must = new LazyEventGraph(mustSet, mustSet, Object::equals);
        logTime(definition, start, System.currentTimeMillis());
        return new RelationAnalysis.Knowledge(may, must);
    }

    @Override
    public RelationAnalysis.Knowledge visitInverse(Inverse definition) {
        RelationAnalysis.Knowledge knowledge = getKnowledge(definition.getOperand());
        long start = System.currentTimeMillis();
        EventGraph may = knowledge.getMaySet().inverse();
        EventGraph must = knowledge.getMustSet().inverse();
        logTime(definition, start, System.currentTimeMillis());
        return new RelationAnalysis.Knowledge(may, must);
    }

    @Override
    public RelationAnalysis.Knowledge visitTransitiveClosure(TransitiveClosure definition) {
        RelationAnalysis.Knowledge knowledge = getKnowledge(definition.getOperand());
        long start = System.currentTimeMillis();
        EventGraph may = computeTransitiveClosure(knowledge.getMaySet(), true);
        EventGraph must = computeTransitiveClosure(knowledge.getMustSet(), false);
        logTime(definition, start, System.currentTimeMillis());
        return new RelationAnalysis.Knowledge(may, must);
    }

    private EventGraph computeTransitiveClosure(EventGraph inner, boolean isMay) {
        Map<Event, Set<Event>> current = inner.getOutMap();
        Map<Event, Set<Event>> outer = new HashMap<>();
        current.forEach((k, v) -> outer.put(k, new HashSet<>(v)));
        while (!current.isEmpty()) {
            Map<Event, Set<Event>> next = new ConcurrentHashMap<>();
            current.entrySet().stream().unordered().parallel().forEach(entry -> {
                Event e1 = entry.getKey();
                Set<Event> update = new HashSet<>();
                for (Event e2 : entry.getValue()) {
                    if (isMay) {
                        update.addAll(outer.getOrDefault(e2, Set.of()));
                    } else {
                        boolean implies = exec.isImplied(e1, e2);
                        update.addAll(outer.getOrDefault(e2, Set.of()).stream()
                                .filter(e -> implies || exec.isImplied(e, e2))
                                .toList());
                    }
                }
                Set<Event> known = outer.getOrDefault(e1, Set.of());
                update.removeIf(e -> known.contains(e) || exec.areMutuallyExclusive(e1, e));
                if (!update.isEmpty()) {
                    next.put(e1, update);
                }
            });
            next.forEach((k, v) -> outer.computeIfAbsent(k, x -> new HashSet<>()).addAll(v));
            current = next;
        }
        return new ImmutableMapEventGraph(outer);
    }

    @Override
    public RelationAnalysis.Knowledge visitUnion(Union definition) {
        List<Knowledge> knowledges = definition.getOperands().stream()
                .map(o -> getKnowledge(o.getDefinition().getDefinedRelation()))
                .toList();
        long start = System.currentTimeMillis();
        EventGraph may = ImmutableEventGraph.union(knowledges.stream().map(Knowledge::getMaySet).toArray(EventGraph[]::new));
        EventGraph must = ImmutableEventGraph.union(knowledges.stream().map(Knowledge::getMustSet).toArray(EventGraph[]::new));
        logTime(definition, start, System.currentTimeMillis());
        return new Knowledge(may, must);
    }

    @Override
    public RelationAnalysis.Knowledge visitIntersection(Intersection definition) {
        List<Knowledge> knowledges = definition.getOperands().stream()
                .map(o -> getKnowledge(o.getDefinition().getDefinedRelation()))
                .toList();
        long start = System.currentTimeMillis();
        EventGraph may = ImmutableEventGraph.intersection(knowledges.stream().map(Knowledge::getMaySet).toArray(EventGraph[]::new));
        EventGraph must = ImmutableEventGraph.intersection(knowledges.stream().map(Knowledge::getMustSet).toArray(EventGraph[]::new));
        logTime(definition, start, System.currentTimeMillis());
        return new Knowledge(may, must);
    }

    @Override
    public RelationAnalysis.Knowledge visitDifference(Difference definition) {
        Knowledge km = getKnowledge(definition.getMinuend());
        Knowledge ks = getKnowledge(definition.getSubtrahend());
        long start = System.currentTimeMillis();
        EventGraph may = ImmutableEventGraph.difference(km.getMaySet(), ks.getMustSet());
        EventGraph must = ImmutableEventGraph.difference(km.getMustSet(), ks.getMaySet());
        logTime(definition, start, System.currentTimeMillis());
        return new Knowledge(may, must);
    }

    @Override
    public RelationAnalysis.Knowledge visitComposition(Composition definition) {
        RelationAnalysis.Knowledge left = getKnowledge(definition.getLeftOperand());
        RelationAnalysis.Knowledge right = getKnowledge(definition.getRightOperand());
        long start = System.currentTimeMillis();
        EventGraph may = computeComposition(left.getMaySet(), right.getMaySet(), true);
        EventGraph must = computeComposition(left.getMustSet(), right.getMustSet(), false);
        logTime(definition, start, System.currentTimeMillis());
        return new RelationAnalysis.Knowledge(may, must);
    }

    private EventGraph computeComposition(EventGraph leftGraph, EventGraph rightGraph, boolean isMay) {
        if (leftGraph.isEmpty() || rightGraph.isEmpty()) {
            return ImmutableEventGraph.empty();
        }
        Map<Event, Set<Event>> left = leftGraph.getOutMap();
        Map<Event, Set<Event>> right = rightGraph.getOutMap();
        Map<Event, Set<Event>> result = new ConcurrentHashMap<>();
        Set<Event> middle = Sets.intersection(leftGraph.getRange(), right.keySet());
        left.entrySet().stream().unordered().parallel().forEach(entry -> {
            Event e1 = entry.getKey();
            Set<Event> update = new HashSet<>();
            for (Event e : entry.getValue()) {
                if (middle.contains(e)) {
                    if (isMay || exec.isImplied(e1, e)) {
                        update.addAll(right.getOrDefault(e, Set.of()));
                    } else {
                        update.addAll(right.getOrDefault(e, Set.of()).stream()
                                .filter(e2 -> exec.isImplied(e2, e)).toList());
                    }
                }
            }
            update.removeIf(e -> exec.areMutuallyExclusive(e1, e));
            if (!update.isEmpty()) {
                result.put(e1, update);
            }
        });
        return new ImmutableMapEventGraph(result);
    }

    class EncodeSetVisitor implements Constraint.Visitor<Boolean> {

        private MapEventGraph update;

        public void setUpdate(MapEventGraph update) {
            this.update = update;
        }

        @Override
        public Boolean visitUnion(Union definition) {
            if (doUpdateSelf(definition)) {
                // TODO: Skip copying event graph for the last operand
                MapEventGraph origUpdate = MapEventGraph.from(update);
                for (Relation child : definition.getOperands()) {
                    setUpdate(MapEventGraph.from(origUpdate));
                    child.getDefinition().accept(this);
                }
                return true;
            }
            return false;
        }

        @Override
        public Boolean visitIntersection(Intersection definition) {
            if (doUpdateSelf(definition)) {
                // TODO: Skip copying event graph for the last operand
                MapEventGraph origUpdate = MapEventGraph.from(update);
                for (Relation child : definition.getOperands()) {
                    setUpdate(MapEventGraph.from(origUpdate));
                    child.getDefinition().accept(this);
                }
                return true;
            }
            return false;
        }

        @Override
        public Boolean visitDifference(Difference definition) {
            if (doUpdateSelf(definition)) {
                // TODO: Skip copying event graph for the last operand
                MapEventGraph origUpdate = MapEventGraph.from(update);
                for (Relation child : List.of(definition.getMinuend(), definition.getSubtrahend())) {
                    setUpdate(MapEventGraph.from(origUpdate));
                    child.getDefinition().accept(this);
                }
                return true;
            }
            return false;
        }

        @Override
        // TODO: Refactor and optimize
        public Boolean visitComposition(Composition definition) {
            if (doUpdateSelf(definition)) {
                long start = System.currentTimeMillis();
                MapEventGraph left = new MapEventGraph();
                MapEventGraph right = new MapEventGraph();
                EventGraph mayLeft = getKnowledge(definition.getLeftOperand()).getMaySet();
                EventGraph mayRight = getKnowledge(definition.getRightOperand()).getMaySet();
                Map<Event, Set<Event>> inMap = mayRight.getInMap();
                for (Event e1 : update.getDomain()) {
                    for (Event e2 : update.getRange(e1)) {
                        for (Event e : Sets.intersection(mayLeft.getRange(e1), inMap.get(e2))) {
                            left.add(e1, e);
                            right.add(e, e2);
                        }
                    }
                }
                logEncodeChildTime(definition, start, System.currentTimeMillis());
                setUpdate(left);
                definition.getLeftOperand().getDefinition().accept(this);
                setUpdate(right);
                definition.getRightOperand().getDefinition().accept(this);
                return true;
            }
            return false;
        }

        @Override
        public Boolean visitDomainIdentity(DomainIdentity definition) {
            if (doUpdateSelf(definition)) {
                MapEventGraph childUpdate = new MapEventGraph();
                RelationAnalysis.Knowledge knowledge = getKnowledge(definition.getOperand());
                for (Event e1 : update.getRange()) {
                    childUpdate.addRange(e1, knowledge.getMaySet().getRange(e1));
                }
                setUpdate(childUpdate);
                definition.getOperand().getDefinition().accept(this);
                return true;
            }
            return false;
        }

        @Override
        public Boolean visitRangeIdentity(RangeIdentity definition) {
            if (doUpdateSelf(definition)) {
                MapEventGraph childUpdate = new MapEventGraph();
                Map<Event, Set<Event>> inMap = getKnowledge(definition.getOperand()).getMaySet().getInMap();
                for (Event e2 : update.getRange()) {
                    for (Event e1 : inMap.get(e2)) {
                        childUpdate.add(e1, e2);
                    }
                }
                setUpdate(childUpdate);
                definition.getOperand().getDefinition().accept(this);
                return true;
            }
            return false;
        }

        @Override
        public Boolean visitInverse(Inverse definition) {
            if (doUpdateSelf(definition)) {
                MapEventGraph childUpdate = update.inverse();
                setUpdate(childUpdate);
                definition.getOperand().getDefinition().accept(this);
                return true;
            }
            return false;
        }

        @Override
        // TODO: Refactor and optimize
        public Boolean visitTransitiveClosure(TransitiveClosure definition) {
            if (doUpdateSelf(definition)) {
                long start = System.currentTimeMillis();
                MapEventGraph childUpdate = new MapEventGraph();
                EventGraph parent = getKnowledge(definition.getDefinedRelation()).getMaySet();
                EventGraph child = getKnowledge(definition.getOperand()).getMaySet();

                MapEventGraph current = MapEventGraph.from(update);
                MapEventGraph next = new MapEventGraph();
                MapEventGraph addToChild = new MapEventGraph();
                int i = 0;

                while (!current.isEmpty() && i < 3) {
                    i++;
                    for (Event e1 : current.getDomain()) {
                        Set<Event> wantToReachFromE1 = current.getRange(e1);
                        for (Event e : child.getRange(e1)) {
                            if (wantToReachFromE1.contains(e)) {
                                addToChild.add(e1, e);
                                continue;
                            }
                            Set<Event> reachableFromE1ViaE = parent.getRange(e);
                            if (!Sets.intersection(wantToReachFromE1, reachableFromE1ViaE).isEmpty()) {
                                addToChild.add(e1, e);
                                addToChild.addRange(e, Sets.intersection(wantToReachFromE1, reachableFromE1ViaE));
                                next.addRange(e, Sets.intersection(wantToReachFromE1, reachableFromE1ViaE));
                            }
                        }
                    }
                    next.removeAll(current);
                    next.removeAll(childUpdate);
                    childUpdate.addAll(addToChild);
                    current = next;
                    next = new MapEventGraph();
                }

                // TODO: Currently, encoding a transitive relation
                //  requires all its child edges in the encode set
                getEncodeKnowledge(definition.getDefinedRelation()).addAll(childUpdate);

                logEncodeChildTime(definition, start, System.currentTimeMillis());
                setUpdate(childUpdate);
                definition.getOperand().getDefinition().accept(this);
                return true;
            }
            return false;
        }

        @Override
        public Boolean visitFree(Free definition) {
            return doUpdateSelf(definition);
        }

        @Override
        public Boolean visitSetIdentity(SetIdentity definition) {
            return doUpdateSelf(definition);
        }

        @Override
        public Boolean visitProduct(CartesianProduct definition) {
            return doUpdateSelf(definition);
        }

        @Override
        public Boolean visitProgramOrder(ProgramOrder definition) {
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
        public Boolean visitReadModifyWrites(ReadModifyWrites definition) {
            return doUpdateSelf(definition);
        }

        @Override
        public Boolean visitCoherence(Coherence definition) {
            return doUpdateSelf(definition);
        }

        @Override
        public Boolean visitSameLocation(SameLocation definition) {
            return doUpdateSelf(definition);
        }

        @Override
        public Boolean visitReadFrom(ReadFrom definition) {
            return doUpdateSelf(definition);
        }

        @Override
        public Boolean visitControlDependency(DirectControlDependency definition) {
            return doUpdateSelf(definition);
        }

        @Override
        public Boolean visitAddressDependency(DirectAddressDependency  definition) {
            return doUpdateSelf(definition);
        }

        @Override
        public Boolean visitInternalDataDependency(DirectDataDependency  definition) {
            return doUpdateSelf(definition);
        }

        @Override
        public Boolean visitFences(Fences definition) {
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
        public Boolean visitDefinition(Definition definition) {
            throw new UnsupportedOperationException("Unsupported definition "
                    + definition.getDefinedRelation().getNameOrTerm() + " " + definition.getClass().getSimpleName());
        }

        private boolean doUpdateSelf(Definition definition) {
            long start = System.currentTimeMillis();
            Relation relation = definition.getDefinedRelation();
            MutableEventGraph encode = getEncodeKnowledge(relation);
            update.retainAll(getKnowledge(relation).getMaySet());
            update.removeAll(encode);
            boolean result = encode.addAll(update);
            logEncodeSetTime(definition, start, System.currentTimeMillis(), update.size());
            return result;
        }
    }

    // TODO: Cleanup logging
    private static void logTime(Definition definition, long start, long end) {
        if (logger.isInfoEnabled()) {
            String paddedTime = String.format("%1$9s", end - start);
            logger.info(String.format("%s ms : %s", paddedTime, definition.getDefinedRelation().getNameOrTerm()));
        }
    }

    private static void logEncodeSetTime(Definition definition, long start, long end, int size) {
        if (logger.isInfoEnabled()) {
            String paddedTime = String.format("%1$9s", end - start);
            String paddedSize = String.format("%1$10s", size);
            logger.info(String.format("%s ms : %s edges : %s", paddedTime, paddedSize, definition.getDefinedRelation().getNameOrTerm()));
        }
    }

    private static void logEncodeChildTime(Definition definition, long start, long end) {
        if (logger.isInfoEnabled()) {
            String paddedTime = String.format("%1$9s", end - start);
            logger.info(String.format("%s ms : %s", paddedTime, definition.getDefinedRelation().getNameOrTerm()));
        }
    }
}
