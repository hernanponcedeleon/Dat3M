package com.dat3m.dartagnan.wmm.analysis;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.ScopeHierarchy;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.analysis.ReachingDefinitionsAnalysis;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.filter.Filter;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.definition.*;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.immutable.ImmutableEventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.immutable.ImmutableMapEventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.immutable.LazyEventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.mutable.MutableEventGraph;
import com.google.common.collect.ImmutableSet;
import com.google.common.collect.Sets;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.program.Register.UsageType.*;
import static com.dat3m.dartagnan.program.event.Tag.FENCE;
import static com.dat3m.dartagnan.program.event.Tag.VISIBLE;
import static java.util.stream.Collectors.toSet;

public class LazyRelationAnalysis extends NativeRelationAnalysis {

    private static final Logger logger = LogManager.getLogger(LazyRelationAnalysis.class);

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
        this.lazyInitializer = new LazyInitializer(task, context);
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
        for (Relation relation : task.getMemoryModel().getRelations()) {
            lazyKnowledgeMap.put(relation, lazyInitializer.getKnowledge(relation));
        }
    }

    @Override
    public void runExtended() {
        // TODO: Implementation
    }

    @Override
    public long countMaySet() {
        return lazyKnowledgeMap.values().stream().mapToLong(k -> k.getMaySet().size()).sum();
    }

    @Override
    public long countMustSet() {
        return lazyKnowledgeMap.values().stream().mapToLong(k -> k.getMustSet().size()).sum();
    }

    private class LazyInitializer implements Definition.Visitor<RelationAnalysis.Knowledge> {
        private final Program program;
        private final ExecutionAnalysis exec;
        private final AliasAnalysis alias;
        private final ReachingDefinitionsAnalysis definitions;
        private final Set<Event> visibleEvents;

        public LazyInitializer(VerificationTask task, Context context) {
            this.program = task.getProgram();
            this.exec = context.requires(ExecutionAnalysis.class);
            this.alias = context.requires(AliasAnalysis.class);
            this.definitions = context.requires(ReachingDefinitionsAnalysis.class);
            this.visibleEvents = new HashSet<>(program.getThreadEventsWithAllTags(VISIBLE));
        }

        public RelationAnalysis.Knowledge getKnowledge(Relation relation) {
            if (!lazyKnowledgeMap.containsKey(relation)) {
                RelationAnalysis.Knowledge knowledge = relation.getDefinition().accept(this);
                lazyKnowledgeMap.put(relation, knowledge);
            }
            return lazyKnowledgeMap.get(relation);
        }

        @Override
        public RelationAnalysis.Knowledge visitDefinition(Definition def) {
            throw new UnsupportedOperationException("Unsupported relation " + def.getDefinedRelation().getNameOrTerm());
        }

        @Override
        public RelationAnalysis.Knowledge visitFree(Free definition) {
            long start = System.currentTimeMillis();
            EventGraph may = new LazyEventGraph(visibleEvents, visibleEvents, (e1, e2) -> true);
            EventGraph must = ImmutableEventGraph.empty();
            time(definition, start, System.currentTimeMillis());
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
            time(definition, start, System.currentTimeMillis());
            return new RelationAnalysis.Knowledge(must, must);
        }

        @Override
        public RelationAnalysis.Knowledge visitSetIdentity(SetIdentity definition) {
            Filter filter = definition.getFilter();
            long start = System.currentTimeMillis();
            Map<Event, Set<Event>> data = program.getThreadEvents().stream()
                    .filter(filter::apply)
                    .collect(Collectors.toMap(e -> e, ImmutableSet::of));
            EventGraph must = new ImmutableMapEventGraph(data);
            time(definition, start, System.currentTimeMillis());
            return new RelationAnalysis.Knowledge(must, must);
        }

        @Override
        public RelationAnalysis.Knowledge visitInternal(Internal definition) {
            long start = System.currentTimeMillis();
            EventGraph must = new LazyEventGraph(visibleEvents, visibleEvents,
                    (e1, e2) -> e1.getThread().equals(e2.getThread())
                            && !exec.areMutuallyExclusive(e1, e2));
            time(definition, start, System.currentTimeMillis());
            return new RelationAnalysis.Knowledge(must, must);
        }

        @Override
        public RelationAnalysis.Knowledge visitExternal(External definition) {
            long start = System.currentTimeMillis();
            EventGraph must = new LazyEventGraph(visibleEvents, visibleEvents,
                    (e1, e2) -> !e1.getThread().equals(e2.getThread()));
            time(definition, start, System.currentTimeMillis());
            return new RelationAnalysis.Knowledge(must, must);
        }

        @Override
        public RelationAnalysis.Knowledge visitProgramOrder(ProgramOrder definition) {
            long start = System.currentTimeMillis();
            Set<Event> domain = visibleEvents.stream().filter(e1 -> visibleEvents.stream()
                            .anyMatch(e2 -> e1.getThread().equals(e2.getThread())
                                    && e1.getGlobalId() < e2.getGlobalId()
                                    && !exec.areMutuallyExclusive(e1, e2)))
                    .collect(toSet());
            Set<Event> range = visibleEvents.stream().filter(e2 -> visibleEvents.stream()
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
        public RelationAnalysis.Knowledge visitSameInstruction(SameInstruction definition) {
            long start = System.currentTimeMillis();
            final Map<Event, Set<Event>> siClasses = new HashMap<>();
            for (InstructionBoundary end : program.getThreadEvents(InstructionBoundary.class)) {
                final Set<Event> siClass = end.getInstructionEvents().stream()
                        .filter(e -> e.hasTag(VISIBLE))
                        .collect(ImmutableSet.toImmutableSet());
                siClass.forEach(e -> siClasses.put(e, siClass));
            }
            for (Event e : program.getThreadEventsWithAllTags(VISIBLE)) {
                siClasses.putIfAbsent(e, ImmutableSet.of(e));
            }
            final EventGraph must = new ImmutableMapEventGraph(siClasses);
            time(definition, start, System.currentTimeMillis());
            return new RelationAnalysis.Knowledge(must, must);
        }

        @Override
        public RelationAnalysis.Knowledge visitControlDependency(DirectControlDependency definition) {
            long start = System.currentTimeMillis();
            Map<Event, Set<Event>> data = new HashMap<>();
            program.getThreads().forEach(t -> t.getEvents(CondJump.class).forEach(j -> {
                if (!j.isGoto() && !j.isDead()) {
                    data.put(j, ((j instanceof IfAsJump ifJump)
                            ? ifJump.getBranchesEvents()
                            : j.getSuccessor().getSuccessors()).stream()
                            .filter(e -> !exec.areMutuallyExclusive(j, e))
                            .collect(ImmutableSet.toImmutableSet()));
                }
            }));
            ImmutableEventGraph must = new ImmutableMapEventGraph(data);
            time(definition, start, System.currentTimeMillis());
            return new RelationAnalysis.Knowledge(must, must);
        }

        @Override
        public RelationAnalysis.Knowledge visitAddressDependency(DirectAddressDependency definition) {
            long start = System.currentTimeMillis();
            RelationAnalysis.Knowledge know = computeInternalDependencies(EnumSet.of(ADDR));
            time(definition, start, System.currentTimeMillis());
            return know;
        }

        @Override
        public RelationAnalysis.Knowledge visitInternalDataDependency(DirectDataDependency definition) {
            long start = System.currentTimeMillis();
            // FIXME: Our "internal data dependency" relation is quite odd an contains all but address dependencies.
            RelationAnalysis.Knowledge know = computeInternalDependencies(EnumSet.of(DATA, CTRL, OTHER));
            time(definition, start, System.currentTimeMillis());
            return know;
        }

        private RelationAnalysis.Knowledge computeInternalDependencies(Set<Register.UsageType> usageTypes) {
            Map<Event, Set<Event>> may = new HashMap<>();
            Map<Event, Set<Event>> must = new HashMap<>();
            program.getThreadEvents(RegReader.class).forEach(reader -> {
                ReachingDefinitionsAnalysis.Writers state = definitions.getWriters(reader);
                reader.getRegisterReads().forEach(read -> {
                    if (usageTypes.contains(read.usageType())) {
                        Register register = read.register();
                        state.ofRegister(register).getMayWriters()
                                .forEach(writer -> may.computeIfAbsent(writer, x -> new HashSet<>()).add(reader));
                        state.ofRegister(register).getMustWriters()
                                .forEach(writer -> must.computeIfAbsent(writer, x -> new HashSet<>()).add(reader));
                    }
                });
            });
            if (usageTypes.contains(DATA)) {
                program.getThreadEvents(ExecutionStatus.class).forEach(execStatus -> {
                    if (execStatus.doesTrackDep()) {
                        may.computeIfAbsent(execStatus.getStatusEvent(), x -> new HashSet<>()).add(execStatus);
                    }
                });
            }
            return new RelationAnalysis.Knowledge(
                    new ImmutableMapEventGraph(may),
                    new ImmutableMapEventGraph(must)
            );
        }

        @Override
        public RelationAnalysis.Knowledge visitCASDependency(CASDependency definition) {
            long start = System.currentTimeMillis();
            Map<Event, Set<Event>> data = program.getThreadEvents().stream()
                    .filter(e1 -> e1.hasTag(Tag.IMM.CASDEPORIGIN))
                    .collect(Collectors.toMap(e1 -> e1, e1 -> Set.of(e1.getSuccessor())));
            ImmutableEventGraph must = new ImmutableMapEventGraph(data);
            time(definition, start, System.currentTimeMillis());
            return new RelationAnalysis.Knowledge(must, must);
        }

        @Override
        public RelationAnalysis.Knowledge visitAllocPtr(AllocPtr definition) {
            long start = System.currentTimeMillis();
            RelationAnalysis.Knowledge base = nativeInitializer.visitAllocPtr(definition);
            EventGraph may = ImmutableMapEventGraph.from(base.getMaySet());
            EventGraph must = ImmutableMapEventGraph.from(base.getMustSet());
            time(definition, start, System.currentTimeMillis());
            return new RelationAnalysis.Knowledge(may, must);
        }

        @Override
        // TODO: May and must sets of AllocMem can become very large for some programs.
        //  Consider using a more efficient representation. A LazyEventGraph can be a good option
        //  if alias analysis for alloc will be thread-safe.
        public RelationAnalysis.Knowledge visitAllocMem(AllocMem definition) {
            long start = System.currentTimeMillis();
            RelationAnalysis.Knowledge base = nativeInitializer.visitAllocMem(definition);
            EventGraph may = ImmutableMapEventGraph.from(base.getMaySet());
            EventGraph must = ImmutableMapEventGraph.from(base.getMustSet());
            time(definition, start, System.currentTimeMillis());
            return new RelationAnalysis.Knowledge(may, must);
        }

        @Override
        public RelationAnalysis.Knowledge visitLinuxCriticalSections(LinuxCriticalSections definition) {
            long start = System.currentTimeMillis();
            RelationAnalysis.Knowledge base = nativeInitializer.visitLinuxCriticalSections(definition);
            EventGraph may = ImmutableMapEventGraph.from(base.getMaySet());
            EventGraph must = ImmutableMapEventGraph.from(base.getMustSet());
            time(definition, start, System.currentTimeMillis());
            return new RelationAnalysis.Knowledge(may, must);
        }

        @Override
        public RelationAnalysis.Knowledge visitAMOPairs(AMOPairs definition) {
            long start = System.currentTimeMillis();
            RelationAnalysis.Knowledge base = nativeInitializer.visitAMOPairs(definition);
            EventGraph may = ImmutableMapEventGraph.from(base.getMaySet());
            EventGraph must = ImmutableMapEventGraph.from(base.getMustSet());
            time(definition, start, System.currentTimeMillis());
            return new RelationAnalysis.Knowledge(may, must);
        }

        @Override
        public RelationAnalysis.Knowledge visitLXSXPairs(LXSXPairs definition) {
            long start = System.currentTimeMillis();
            RelationAnalysis.Knowledge base = nativeInitializer.visitLXSXPairs(definition);
            EventGraph may = ImmutableMapEventGraph.from(base.getMaySet());
            EventGraph must = ImmutableMapEventGraph.from(base.getMustSet());
            time(definition, start, System.currentTimeMillis());
            return new RelationAnalysis.Knowledge(may, must);
        }

        @Override
        public RelationAnalysis.Knowledge visitCoherence(Coherence definition) {
            long start = System.currentTimeMillis();
            RelationAnalysis.Knowledge base = nativeInitializer.visitCoherence(definition);
            EventGraph may = ImmutableMapEventGraph.from(base.getMaySet());
            EventGraph must = ImmutableMapEventGraph.from(base.getMustSet());
            time(definition, start, System.currentTimeMillis());
            return new RelationAnalysis.Knowledge(may, must);
        }

        @Override
        public RelationAnalysis.Knowledge visitReadFrom(ReadFrom definition) {
            long start = System.currentTimeMillis();
            RelationAnalysis.Knowledge base = nativeInitializer.visitReadFrom(definition);
            EventGraph may = ImmutableMapEventGraph.from(base.getMaySet());
            EventGraph must = ImmutableMapEventGraph.from(base.getMustSet());
            time(definition, start, System.currentTimeMillis());
            return new RelationAnalysis.Knowledge(may, must);
        }

        @Override
        public RelationAnalysis.Knowledge visitSameLocation(SameLocation definition) {
            long start = System.currentTimeMillis();
            List<MemoryCoreEvent> memoryEvents = program.getThreadEvents(MemoryCoreEvent.class);
            Map<Event, Set<Event>> mayData = new HashMap<>();
            Map<Event, Set<Event>> mustData = new HashMap<>();
            for (int i = 0; i < memoryEvents.size(); i++) {
                MemoryCoreEvent e1 = memoryEvents.get(i);
                for (int j = i; j < memoryEvents.size(); j++) {
                    MemoryCoreEvent e2 = memoryEvents.get(j);
                    if (!exec.areMutuallyExclusive(e1, e2) && alias.mayAlias(e1, e2)) {
                        mayData.computeIfAbsent(e1, x -> new HashSet<>()).add(e2);
                        mayData.computeIfAbsent(e2, x -> new HashSet<>()).add(e1);
                        if (alias.mustAlias(e1, e2)) {
                            mustData.computeIfAbsent(e1, x -> new HashSet<>()).add(e2);
                            mustData.computeIfAbsent(e2, x -> new HashSet<>()).add(e1);
                        }
                    }
                }
            }
            // Cannot be a LazyEventGraph because AliasAnalysis is not thread safe
            EventGraph may = new ImmutableMapEventGraph(mayData);
            EventGraph must = new ImmutableMapEventGraph(mustData);
            time(definition, start, System.currentTimeMillis());
            return new RelationAnalysis.Knowledge(may, must);
        }

        @Override
        public RelationAnalysis.Knowledge visitSameScope(SameScope definition) {
            long start = System.currentTimeMillis();
            String scope = definition.getSpecificScope();
            Arch arch = program.getArch();
            Map<Event, Set<Event>> data = new HashMap<>();
            List<Event> events = program.getThreads().stream()
                    .filter(Thread::hasScope)
                    .flatMap(t -> t.getEventsWithAllTags(VISIBLE).stream())
                    .toList();
            events.forEach(e1 -> {
                ScopeHierarchy e1Scope = e1.getThread().getScopeHierarchy();
                ImmutableSet<Event> range = events.stream()
                        .filter(e2 -> !exec.areMutuallyExclusive(e1, e2))
                        .filter(e2 -> {
                            ScopeHierarchy e2Scope = e2.getThread().getScopeHierarchy();
                            if (scope != null) {
                                return e1Scope.canSyncAtScope(e2Scope, scope);
                            }
                            String scope1 = Tag.getScopeTag(e1, arch);
                            String scope2 = Tag.getScopeTag(e2, arch);
                            return !scope1.isEmpty() && !scope2.isEmpty()
                                    && e1Scope.canSyncAtScope(e2Scope, scope1)
                                    && e2Scope.canSyncAtScope(e1Scope, scope2);
                        }).collect(ImmutableSet.toImmutableSet());
                if (!range.isEmpty()) {
                    data.put(e1, range);
                }
            });
            EventGraph must = new ImmutableMapEventGraph(data);
            time(definition, start, System.currentTimeMillis());
            return new RelationAnalysis.Knowledge(must, must);
        }

        @Override
        public RelationAnalysis.Knowledge visitSyncBarrier(SyncBar definition) {
            long start = System.currentTimeMillis();
            RelationAnalysis.Knowledge base = nativeInitializer.visitSyncBarrier(definition);
            EventGraph may = ImmutableMapEventGraph.from(base.getMaySet());
            EventGraph must = ImmutableMapEventGraph.from(base.getMustSet());
            time(definition, start, System.currentTimeMillis());
            return new RelationAnalysis.Knowledge(may, must);
        }

        @Override
        public RelationAnalysis.Knowledge visitSyncFence(SyncFence definition) {
            long start = System.currentTimeMillis();
            Map<Event, Set<Event>> data = new HashMap<>();
            List<Event> events = program.getThreadEventsWithAllTags(VISIBLE, FENCE, Tag.PTX.SC);
            events.forEach(e1 -> data.put(e1, events.stream()
                    .filter(e2 -> !exec.areMutuallyExclusive(e1, e2))
                    .collect(ImmutableSet.toImmutableSet())));
            EventGraph may = new ImmutableMapEventGraph(data);
            EventGraph must = ImmutableEventGraph.empty();
            time(definition, start, System.currentTimeMillis());
            return new RelationAnalysis.Knowledge(may, must);
        }

        @Override
        public RelationAnalysis.Knowledge visitSameVirtualLocation(SameVirtualLocation definition) {
            long start = System.currentTimeMillis();
            RelationAnalysis.Knowledge base = nativeInitializer.visitSameVirtualLocation(definition);
            EventGraph may = ImmutableMapEventGraph.from(base.getMaySet());
            EventGraph must = ImmutableMapEventGraph.from(base.getMustSet());
            time(definition, start, System.currentTimeMillis());
            return new RelationAnalysis.Knowledge(may, must);
        }

        @Override
        public RelationAnalysis.Knowledge visitSyncWith(SyncWith definition) {
            long start = System.currentTimeMillis();
            Map<Event, Set<Event>> data = new HashMap<>();
            List<Event> events = new ArrayList<>(visibleEvents);
            events.removeIf(Init.class::isInstance);
            for (Event e1 : events) {
                Thread thread1 = e1.getThread();
                if (thread1.hasSyncSet()) {
                    Set<Thread> syncSet = thread1.getSyncSet();
                    data.put(e1, events.stream()
                            .filter(e2 -> thread1 != e2.getThread()
                                    && syncSet.contains(e2.getThread())
                                    && !exec.areMutuallyExclusive(e1, e2))
                            .collect(ImmutableSet.toImmutableSet()));
                }
            }
            EventGraph must = new ImmutableMapEventGraph(data);
            time(definition, start, System.currentTimeMillis());
            return new RelationAnalysis.Knowledge(must, must);
        }

        @Override
        public RelationAnalysis.Knowledge visitDomainIdentity(DomainIdentity definition) {
            RelationAnalysis.Knowledge knowledge = getKnowledge(definition.getOperand());
            long start = System.currentTimeMillis();
            Map<Event, Set<Event>> mayMap = knowledge.getMaySet().getDomain().stream()
                    .collect(Collectors.toMap(e -> e, ImmutableSet::of));
            EventGraph may = new ImmutableMapEventGraph(mayMap);
            Map<Event, Set<Event>> mustMap = knowledge.getMustSet()
                    .filter(exec::isImplied).getDomain().stream()
                    .collect(Collectors.toMap(e -> e, ImmutableSet::of));
            EventGraph must = new ImmutableMapEventGraph(mustMap);
            time(definition, start, System.currentTimeMillis());
            return new RelationAnalysis.Knowledge(may, must);
        }

        @Override
        public RelationAnalysis.Knowledge visitRangeIdentity(RangeIdentity definition) {
            RelationAnalysis.Knowledge knowledge = getKnowledge(definition.getOperand());
            long start = System.currentTimeMillis();
            Map<Event, Set<Event>> mayMap = knowledge.getMaySet().getRange().stream()
                    .collect(Collectors.toMap(e -> e, ImmutableSet::of));
            EventGraph may = new ImmutableMapEventGraph(mayMap);
            Map<Event, Set<Event>> mustMap = knowledge.getMustSet()
                    .filter((e1, e2) -> exec.isImplied(e2, e1)).getRange().stream()
                    .collect(Collectors.toMap(e -> e, ImmutableSet::of));
            EventGraph must = new ImmutableMapEventGraph(mustMap);
            time(definition, start, System.currentTimeMillis());
            return new RelationAnalysis.Knowledge(may, must);
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
        public RelationAnalysis.Knowledge visitTransitiveClosure(TransitiveClosure definition) {
            EventGraph may = getKnowledge(definition.getOperand()).getMaySet();
            EventGraph must = getKnowledge(definition.getOperand()).getMustSet();
            long start = System.currentTimeMillis();
            EventGraph maySet = computeTransitiveClosureMay(may);
            EventGraph mustSet = computeTransitiveClosureMust(must);
            time(definition, start, System.currentTimeMillis());
            return new RelationAnalysis.Knowledge(maySet, mustSet);
        }

        private EventGraph computeTransitiveClosureMay(EventGraph inner) {
            MutableEventGraph outer = MutableEventGraph.from(inner);
            Map<Event, Set<Event>> innerOut = inner.getOutMap();
            Map<Event, Set<Event>> update = new HashMap<>(inner.getOutMap());
            while (!update.isEmpty()) {
                Map<Event, Set<Event>> next = new ConcurrentHashMap<>();
                Map<Event, Set<Event>> current = update;
                innerOut.keySet().stream().unordered().parallel().forEach(e1 -> {
                    Set<Event> known = outer.getRange(e1);
                    Set<Event> range = innerOut.get(e1).stream()
                            .flatMap(e -> current.getOrDefault(e, Set.of()).stream())
                            .collect(Collectors.toSet()).stream()
                            .filter(e -> !known.contains(e))
                            .filter(e -> !exec.areMutuallyExclusive(e1, e))
                            .collect(Collectors.toSet());
                    if (!range.isEmpty()) {
                        next.put(e1, range);
                    }
                });
                next.forEach(outer::addRange);
                update = next;
            }
            return ImmutableMapEventGraph.from(outer);
        }

        private EventGraph computeTransitiveClosureMust(EventGraph inner) {
            MutableEventGraph outer = MutableEventGraph.from(inner);
            Map<Event, Set<Event>> innerOut = inner.getOutMap();
            Map<Event, Set<Event>> update = new HashMap<>(inner.getOutMap());
            while (!update.isEmpty()) {
                Map<Event, Set<Event>> next = new ConcurrentHashMap<>();
                Map<Event, Set<Event>> current = update;
                innerOut.keySet().stream().unordered().parallel().forEach(e1 -> {
                    Set<Event> known = outer.getRange(e1);
                    Set<Event> range = innerOut.get(e1).stream()
                            .flatMap(e -> {
                                if (exec.isImplied(e1, e)) {
                                    return current.getOrDefault(e, Set.of()).stream();
                                }
                                return current.getOrDefault(e, Set.of()).stream()
                                        .filter(e2 -> exec.isImplied(e2, e));
                            })
                            .collect(Collectors.toSet()).stream()
                            .filter(e -> !known.contains(e))
                            .filter(e -> !exec.areMutuallyExclusive(e1, e))
                            .collect(Collectors.toSet());
                    if (!range.isEmpty()) {
                        next.put(e1, range);
                    }
                });
                next.forEach(outer::addRange);
                update = next;
            }
            return ImmutableMapEventGraph.from(outer);
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
            RelationAnalysis.Knowledge left = getKnowledge(definition.getLeftOperand());
            RelationAnalysis.Knowledge right = getKnowledge(definition.getRightOperand());
            long start = System.currentTimeMillis();
            EventGraph may = computeCompositionMay(left.getMaySet(), right.getMaySet());
            EventGraph must = computeCompositionMust(left.getMustSet(), right.getMustSet());
            time(definition, start, System.currentTimeMillis());
            return new RelationAnalysis.Knowledge(may, must);
        }

        private EventGraph computeCompositionMay(EventGraph left, EventGraph right) {
            if (left.isEmpty() || right.isEmpty()) {
                return ImmutableEventGraph.empty();
            }
            Map<Event, Set<Event>> result = new ConcurrentHashMap<>();
            Map<Event, Set<Event>> leftOut = left.getOutMap();
            Map<Event, Set<Event>> rightOut = right.getOutMap();
            Set<Event> middle = Sets.intersection(left.getRange(), rightOut.keySet());
            leftOut.keySet().stream().unordered().parallel()
                    .forEach(e1 -> result.put(e1, leftOut.get(e1).stream()
                            .filter(middle::contains)
                            .flatMap(e -> rightOut.getOrDefault(e, Set.of()).stream())
                            .collect(toSet()).stream()
                            .filter(e2 -> !exec.areMutuallyExclusive(e1, e2))
                            .collect(ImmutableSet.toImmutableSet())));
            return new ImmutableMapEventGraph(result);
        }

        private EventGraph computeCompositionMust(EventGraph left, EventGraph right) {
            if (left.isEmpty() || right.isEmpty()) {
                return ImmutableEventGraph.empty();
            }
            Map<Event, Set<Event>> result = new ConcurrentHashMap<>();
            Map<Event, Set<Event>> leftOut = left.getOutMap();
            Map<Event, Set<Event>> rightOut = right.getOutMap();
            Set<Event> middle = Sets.intersection(left.getRange(), rightOut.keySet());
            leftOut.keySet().stream().unordered().parallel()
                    .forEach(e1 -> result.put(e1, leftOut.get(e1).stream()
                            .filter(middle::contains)
                            .flatMap(e -> {
                                if (exec.isImplied(e1, e)) {
                                    return rightOut.getOrDefault(e, Set.of()).stream();
                                }
                                return rightOut.getOrDefault(e, Set.of()).stream()
                                        .filter(e2 -> exec.isImplied(e2, e));
                            })
                            .collect(toSet()).stream()
                            .filter(e2 -> !exec.areMutuallyExclusive(e1, e2))
                            .collect(ImmutableSet.toImmutableSet())));
            return new ImmutableMapEventGraph(result);
        }

        private void time(Definition definition, long start, long end) {
            if (logger.isDebugEnabled()) {
                logger.debug(String.format("LRA initial knowledge %6s ms : %s", end - start,
                        definition.getDefinedRelation().getNameOrTerm()));
            }
        }
    }
}
