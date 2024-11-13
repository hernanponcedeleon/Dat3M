package com.dat3m.dartagnan.verification.model.relation;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.RMWStore;
import com.dat3m.dartagnan.program.filter.Filter;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.solver.caat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.caat.predicates.PredicateHierarchy;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.RelationGraph;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.base.SimpleGraph;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.derived.*;
import com.dat3m.dartagnan.solver.caat.predicates.sets.SetPredicate;
import com.dat3m.dartagnan.solver.caat4wmm.EventDomain;
import com.dat3m.dartagnan.solver.caat4wmm.basePredicates.StaticWMMSet;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.verification.model.ExecutionModel;
import com.dat3m.dartagnan.verification.model.ExecutionModelNext;
import com.dat3m.dartagnan.verification.model.event.*;
import com.dat3m.dartagnan.verification.model.relation.RelationModel.EdgeModel;
import com.dat3m.dartagnan.wmm.Constraint.Visitor;
import com.dat3m.dartagnan.wmm.definition.*;
import com.dat3m.dartagnan.wmm.Relation;
import com.google.common.collect.BiMap;
import com.google.common.collect.HashBiMap;
import com.google.common.collect.Lists;
import org.apache.logging.log4j.Logger;
import org.apache.logging.log4j.LogManager;
import org.sosy_lab.java_smt.api.BooleanFormula;

import java.math.BigInteger;
import java.util.*;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.wmm.RelationNameRepository.*;

public class RelationModelManager {

    private static final Logger logger = LogManager.getLogger(RelationModelManager.class);

    private final ExecutionModelNext executionModel;
    private final BaseRelationGraphBuilder baseBuilder;
    private final DerivedRelationGraphBuilder derivedBuilder;

    private final Map<Relation, RelationModel> relModelCache;
    private final BiMap<Relation, RelationGraph> relGraphCache;
    private final Map<Filter, SetPredicate> setCache;
    private final Map<String, EdgeModel> edgeModelCache;

    private final ExecutionModel oldModel; // old one for CAAT use
    private final EventDomain domain;

    private RelationModelManager(ExecutionModelNext m, ExecutionModel old) {
        executionModel = m;
        baseBuilder = new BaseRelationGraphBuilder();
        derivedBuilder = new DerivedRelationGraphBuilder();
        relModelCache = new HashMap<>();
        relGraphCache = HashBiMap.create();
        setCache = new HashMap<>();
        edgeModelCache = new HashMap<>();

        oldModel = old;
        domain = new EventDomain(old);
    }

    public static RelationModelManager newRMManager(
        ExecutionModelNext m, ExecutionModel old
    ) {
        return new RelationModelManager(m, old);
    }

    public void initialize() {
        relModelCache.clear();
        relGraphCache.clear();
        setCache.clear();
        edgeModelCache.clear();
        extractRelations(List.of(PO, RF, CO));
    }

    public void extractRelations(List<String> relationNames) {
        Set<Relation> relsToExtract = new HashSet<>();
        for (String name : relationNames) {
            Relation r = executionModel.getFullMemoryModel().getRelation(name);
            if (r == null) {
                logger.warn("Relation with the name {} does not exist", name);
                continue;
            }
            relsToExtract.add(r);
            createModel(r);
        }

        Set<RelationGraph> relGraphs = new HashSet<>();
        DependencyGraph<Relation> dependencyGraph = DependencyGraph.from(relsToExtract);

        for (Set<DependencyGraph<Relation>.Node> component : dependencyGraph.getSCCs()) {
            for (DependencyGraph<Relation>.Node node : component) {
                Relation r = node.getContent();
                if (r.isRecursive()) {
                    RecursiveGraph recGraph = new RecursiveGraph();
                    recGraph.setName(r.getNameOrTerm() + "_rec");
                    relGraphs.add(recGraph);
                    relGraphCache.put(r, recGraph);
                }
            }
            for (DependencyGraph<Relation>.Node node : component) {
                Relation r = node.getContent();
                RelationGraph rg = createGraph(r);
                if (r.isRecursive()) {
                    RecursiveGraph recGraph = (RecursiveGraph) relGraphCache.get(r);
                    recGraph.setConcreteGraph(rg);
                } else {
                    relGraphs.add(rg);
                }
            }
        }


        Set<CAATPredicate> predicates = new HashSet<>(relGraphs);
        PredicateHierarchy hierarchy = new PredicateHierarchy(predicates);
        hierarchy.initializeToDomain(domain);

        for (CAATPredicate basePred : hierarchy.getBasePredicates()) {
            if (basePred.getClass() == StaticWMMSet.class) { continue; }
            Relation r = relGraphCache.inverse().get((RelationGraph) basePred);
            r.getDefinition().accept(baseBuilder);
        }

        hierarchy.populate();

        for (CAATPredicate pred : hierarchy.getPredicateList()) {
            if (pred.getClass() == StaticWMMSet.class) { continue; }
            Relation r = relGraphCache.inverse().get((RelationGraph) pred);
            if (relModelCache.containsKey(r)) {
                RelationModel rm = relModelCache.get(r);
                ((RelationGraph) pred).edgeStream()
                    .forEach(e -> rm.addEdgeModel(getOrCreateEdgeModel(e)));
           }
        }

        for (Relation r : relsToExtract) {
            executionModel.addRelation(r, relModelCache.get(r));
        }
    }

    private void createModel(Relation r) {
        if (relModelCache.containsKey(r)) { return; }
        relModelCache.put(r, new RelationModel(r, r.getNameOrTerm()));
    }

    private RelationGraph createGraph(Relation r) {
        RelationGraph rg;
        if (r.getDependencies().size() > 0
            || r.getDefinition().getClass() == SetIdentity.class
            || r.getDefinition().getClass() == CartesianProduct.class
        ) {
            rg = r.getDefinition().accept(derivedBuilder);
        } else {
            rg = new SimpleGraph();
        }
        rg.setName(r.getNameOrTerm());
        relGraphCache.put(r, rg);
        return rg;
    }

    private RelationGraph getOrCreateGraph(Relation r) {
        if (relGraphCache.containsKey(r)) {
            return relGraphCache.get(r);
        }
        RelationGraph rg = createGraph(r);
        return rg;
    }
    
    private SetPredicate getOrCreateSetFromFilter(Filter filter) {
        if (setCache.containsKey(filter)) {
            return setCache.get(filter);
        }
        SetPredicate set = new StaticWMMSet(filter);
        set.setName(filter.toString());
        setCache.put(filter, set);
        return set;
    }

    private EdgeModel getOrCreateEdgeModel(Edge e) {
        String identifier = e.getFirst() + " -> " + e.getSecond();
        if (edgeModelCache.containsKey(identifier)) {
            return edgeModelCache.get(identifier);
        }
        final List<EventModel> eventList = executionModel.getEventList();
        EdgeModel em = new EdgeModel(eventList.get(e.getFirst()), eventList.get(e.getSecond()));
        edgeModelCache.put(identifier, em);
        return em;
    }

    private EncodingContext getContextWithFullWmm() {
        return executionModel.getContextWithFullWmm();
    }

    private List<EventModel> getVisibleEvents(Thread t) {
        return executionModel.getThreadEventsMap().get(t).stream()
                             .filter(e -> e.hasTag(Tag.VISIBLE))
                             .toList();
    }


    private final class BaseRelationGraphBuilder implements Visitor<Void> {

        @Override
        public Void visitProgramOrder(ProgramOrder po) {
            SimpleGraph rg = (SimpleGraph) relGraphCache.get(po.getDefinedRelation());
            for (Thread t : executionModel.getThreads()) {
                List<EventModel> eventList = getVisibleEvents(t);
                if (eventList.size() <= 1) { continue; }
                for (int i = 1; i < eventList.size(); i++) {
                    rg.add(new Edge(eventList.get(i - 1).getId(),
                                    eventList.get(i).getId()));
                }
            }
            return null;
        }

        @Override
        public Void visitCoherence(Coherence coherence) {
            SimpleGraph rg = (SimpleGraph) relGraphCache.get(coherence.getDefinedRelation());
            EncodingContext.EdgeEncoder co = getContextWithFullWmm().edge(
                executionModel.getFullMemoryModel().getRelation(CO)
            );

            for (Map.Entry<BigInteger, Set<StoreModel>> entry : executionModel.getAddressWritesMap()
                                                                              .entrySet()) {
                BigInteger address = entry.getKey();
                Set<StoreModel> writes = entry.getValue();
                List<StoreModel> coSortedWrites;
                if (getContextWithFullWmm().usesSATEncoding()) {
                    Map<StoreModel, List<StoreModel>> coEdges = new HashMap<>();
                    for (StoreModel w1 : writes) {
                        coEdges.put(w1, new ArrayList<>());
                        for (StoreModel w2 : writes) {
                            if (executionModel.isTrue(co.encode(w1.getEvent(), w2.getEvent()))) {
                                coEdges.get(w1).add(w2);
                            }
                        }
                    }
                    DependencyGraph<StoreModel> depGraph = DependencyGraph.from(writes, coEdges);
                    coSortedWrites = new ArrayList<>(Lists.reverse(depGraph.getNodeContents()));
                } else {
                    Map<StoreModel, BigInteger> writeClockMap = new HashMap<>(
                        writes.size() * 4 / 3, 0.75f
                    );
                    for (StoreModel w : writes) {
                        writeClockMap.put(w, (BigInteger) executionModel.evaluateByModel(
                            getContextWithFullWmm().memoryOrderClock(w.getEvent())
                        ));
                    }
                    coSortedWrites = writes.stream()
                                           .sorted(Comparator.comparing(writeClockMap::get))
                                           .collect(Collectors.toList());
                }
                for (int i = 0; i < coSortedWrites.size(); i++) {
                    coSortedWrites.get(i).setCoherenceIndex(i);
                    if (i >= 1) {
                        rg.add(new Edge(coSortedWrites.get(i - 1).getId(),
                                        coSortedWrites.get(i).getId()));
                    }
                }
                executionModel.addCoherenceWrites(
                    address, Collections.unmodifiableList(coSortedWrites)
                );
            }
            return null;
        }

        @Override
        public Void visitReadFrom(ReadFrom readFrom) {
            SimpleGraph rg = (SimpleGraph) relGraphCache.get(readFrom.getDefinedRelation());
            EncodingContext.EdgeEncoder rf = getContextWithFullWmm().edge(
                executionModel.getFullMemoryModel().getRelation(RF)
            );

            for (Map.Entry<BigInteger, Set<LoadModel>> reads : executionModel.getAddressReadsMap()
                                                                             .entrySet()) {
                BigInteger address = reads.getKey();
                for (LoadModel read : reads.getValue()) {
                    for (StoreModel write : executionModel.getAddressWritesMap().get(address)) {
                        BooleanFormula isRF = rf.encode(write.getEvent(), read.getEvent());
                        if (executionModel.isTrue(isRF)) {
                            rg.add(new Edge(write.getId(), read.getId()));
                            executionModel.addReadWrite(read, write);
                            executionModel.addWriteRead(write, read);
                            read.setReadFrom(write);
                        }
                    }
                }
            }
            return null;
        }

        @Override
        public Void visitReadModifyWrites(ReadModifyWrites rmw) {
            SimpleGraph rg = (SimpleGraph) relGraphCache.get(rmw.getDefinedRelation());
            executionModel.getAtomicBlocksMap()
                          .values().stream().flatMap(Collection::stream)
                          .forEach(
                                block -> {
                                    for (int i = 0; i < block.size(); i++) {
                                        for (int j = i + 1; j < block.size(); j++) {
                                            rg.add(new Edge(block.get(i).getId(),
                                                            block.get(j).getId()));
                                        }
                                    }
                                });
            
            for (Thread t : executionModel.getThreads()) {
                List<EventModel> eventList = getVisibleEvents(t);
                if (eventList.size() <= 1) { continue; }
                LoadModel lastExclLoad = null;
                for (EventModel e : eventList) {
                    if (e.isRead()) {
                        if (e.isExclusive()) {
                            lastExclLoad = (LoadModel) e;
                        }
                    } else if (e.isWrite()) {
                        if (e.isExclusive()) {
                            if (lastExclLoad == null) {
                                throw new IllegalStateException(
                                    "Exclusive store was executed without preceding exclusive load."
                                );
                            }
                            rg.add(new Edge(lastExclLoad.getId(), e.getId()));
                            lastExclLoad = null;
                        } else if (e.getEvent() instanceof RMWStore rmwStore) {
                            LoadModel load = (LoadModel) executionModel.getEventModelByEvent(
                                rmwStore.getLoadEvent()
                            );
                            rg.add(new Edge(load.getId(), e.getId()));
                        }
                    }
                }
            }
            return null;
        }

        @Override
        public Void visitSameLocation(SameLocation loc) {
            SimpleGraph rg = (SimpleGraph) relGraphCache.get(loc.getDefinedRelation());
            for (Set<MemoryEventModel> sameLocAccesses : executionModel.getAddressAccessesMap().values()) {
                for (MemoryEventModel e1 : sameLocAccesses) {
                    for (MemoryEventModel e2 : sameLocAccesses) {
                        if (e1 == e2) { continue; }
                        rg.add(new Edge(e1.getId(), e2.getId()));
                    }
                }
            }
            return null;
        }

        @Override
        public Void visitInternal(Internal in) {
            SimpleGraph rg = (SimpleGraph) relGraphCache.get(in.getDefinedRelation());
            for (Thread t : executionModel.getThreads()) {
                List<EventModel> eventList = getVisibleEvents(t);
                if (eventList.size() <= 1) { continue; }
                for (EventModel e1 : eventList) {
                    for (EventModel e2 : eventList) {
                        if (e1 == e2) { continue; }
                        rg.add(new Edge(e1.getId(), e2.getId()));
                    }
                }
            }
            return null;
        }

        @Override
        public Void visitExternal(External ext) {
            SimpleGraph rg = (SimpleGraph) relGraphCache.get(ext.getDefinedRelation());
            List<Thread> threadList = executionModel.getThreads();
            for (int i = 0; i < threadList.size(); i ++) {
                List<EventModel> eventList1 = getVisibleEvents(threadList.get(i));
                if (eventList1.size() <= 1) { continue; }
                for (int j = i + 1; j < threadList.size(); j ++) {
                    List<EventModel> eventList2 = getVisibleEvents(threadList.get(j));
                    if (eventList2.size() <= 1) { continue; }
                    for (EventModel e1 : eventList1) {
                        for (EventModel e2 : eventList2) {
                            rg.add(new Edge(e1.getId(), e2.getId()));
                            rg.add(new Edge(e2.getId(), e1.getId()));
                        }
                    }
                }
            }
            return null;
        }

        @Override
        public Void visitControlDependency(DirectControlDependency ctrlDirect) {
            SimpleGraph rg = (SimpleGraph) relGraphCache.get(ctrlDirect.getDefinedRelation());
            for (List<EventModel> eventList : executionModel.getThreadEventsMap().values()) {
                for (EventModel em : eventList) {
                    if (em.isJump()) {
                        if (((CondJumpModel) em).isGoto() || ((CondJumpModel) em).isDead()) {
                            continue;
                        }
                        for (Event e : ((CondJumpModel) em).getDependentEvents()) {
                            EventModel dep = executionModel.getEventModelByEvent(e);
                            if (dep == null) { continue; }
                            rg.add(new Edge(em.getId(), dep.getId()));
                        }
                    }
                }
            }
            return null;
        }

        @Override
        public Void visitAddressDependency(DirectAddressDependency addrDirect) {
            SimpleGraph rg = (SimpleGraph) relGraphCache.get(addrDirect.getDefinedRelation());
            for (List<EventModel> eventList : executionModel.getThreadEventsMap().values()) {
                Set<RegWriterModel> writes = new HashSet<>();
                for (EventModel em : eventList) {
                    if (em.isRegWriter()) {
                        writes.add((RegWriterModel) em);
                        continue;
                    }
                    if (em.isWrite()) {
                        for (RegWriterModel write : writes) {
                            for (Register.Read read : ((RegReaderModel) em).getRegisterReads()) {
                                if (read.register() == write.getResultRegister()
                                    && read.usageType() == Register.UsageType.ADDR) {
                                    rg.add(new Edge(write.getId(), em.getId()));
                                }
                            }
                        }
                    }
                }
            }
            return null;
        }

        @Override
        public Void visitInternalDataDependency(DirectDataDependency idd) {
            SimpleGraph rg = (SimpleGraph) relGraphCache.get(idd.getDefinedRelation());
            for (List<EventModel> eventList : executionModel.getThreadEventsMap().values()) {
                Set<RegWriterModel> writes = new HashSet<>();
                for (EventModel em : eventList) {
                    if (em.isRegWriter()) {
                        writes.add((RegWriterModel) em);
                        continue;
                    }
                    if (em.isRegReader()) {
                        for (RegWriterModel write : writes) {
                            for (Register.Read read : ((RegReaderModel) em).getRegisterReads()) {
                                if (read.register() == write.getResultRegister()
                                    && read.usageType() == Register.UsageType.DATA) {
                                    rg.add(new Edge(write.getId(), em.getId()));
                                }
                            }
                        }
                    }
                }
            }
            return null;
        }

        @Override
        public Void visitFree(Free f) {
            SimpleGraph rg = (SimpleGraph) relGraphCache.get(f.getDefinedRelation());
            for (Thread t : executionModel.getThreads()) {
                List<EventModel> events = getVisibleEvents(t);
                if (events.size() <= 1) { continue; }
                for (EventModel e1 : events) {
                    for (EventModel e2 : events) {
                        rg.add(new Edge(e1.getId(), e2.getId()));
                    }
                }
            }
            return null;
        }

    }


    private final class DerivedRelationGraphBuilder implements Visitor<RelationGraph> {

        @Override
        public RelationGraph visitInverse(Inverse inv) {
            return new InverseGraph(getOrCreateGraph(inv.getOperand()));
        }

        @Override
        public RelationGraph visitComposition(Composition comp) {
            return new CompositionGraph(getOrCreateGraph(comp.getLeftOperand()),
                                        getOrCreateGraph(comp.getRightOperand()));
        }

        @Override
        public RelationGraph visitDifference(Difference diff) {
            return new DifferenceGraph(getOrCreateGraph(diff.getMinuend()),
                                       getOrCreateGraph(diff.getSubtrahend()));
        }

        @Override
        public RelationGraph visitUnion(Union un) {
            List<Relation> ops = un.getOperands();
            RelationGraph[] rgs = new RelationGraph[ops.size()];
            for (int i = 0; i < rgs.length; i++) {
                rgs[i] = getOrCreateGraph(ops.get(i));
            }
            return new UnionGraph(rgs);
        }

        @Override
        public RelationGraph visitIntersection(Intersection inter) {
            List<Relation> ops = inter.getOperands();
            RelationGraph[] rgs = new RelationGraph[ops.size()];
            for (int i = 0; i < rgs.length; i++) {
                rgs[i] = getOrCreateGraph(ops.get(i));
            }
            return new IntersectionGraph(rgs);
        }

        @Override
        public RelationGraph visitTransitiveClosure(TransitiveClosure trans) {
            return new TransitiveGraph(getOrCreateGraph(trans.getOperand()));
        }

        @Override
        public RelationGraph visitRangeIdentity(RangeIdentity ri) {
            return new RangeIdentityGraph(getOrCreateGraph(ri.getOperand()));
        }

        @Override
        public RelationGraph visitSetIdentity(SetIdentity si) {
            SetPredicate set = getOrCreateSetFromFilter(si.getFilter());
            return new SetIdentityGraph(set);
        }

        @Override
        public RelationGraph visitProduct(CartesianProduct prod) {
            SetPredicate lhs = getOrCreateSetFromFilter(prod.getFirstFilter());
            SetPredicate rhs = getOrCreateSetFromFilter(prod.getSecondFilter());
            return new CartesianGraph(lhs, rhs);
        }

    }
}