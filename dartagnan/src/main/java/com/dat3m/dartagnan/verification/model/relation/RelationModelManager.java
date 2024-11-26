package com.dat3m.dartagnan.verification.model.relation;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.RMWStore;
import com.dat3m.dartagnan.program.filter.Filter;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.solver.caat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.caat.predicates.PredicateHierarchy;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.base.SimpleGraph;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.derived.*;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.RelationGraph;
import com.dat3m.dartagnan.solver.caat4wmm.EventDomainNext;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.verification.model.ExecutionModelManager;
import com.dat3m.dartagnan.verification.model.ExecutionModelNext;
import com.dat3m.dartagnan.verification.model.event.*;
import com.dat3m.dartagnan.verification.model.relation.RelationModel.EdgeModel;
import com.dat3m.dartagnan.verification.model.ThreadModel;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.Constraint.Visitor;
import com.dat3m.dartagnan.wmm.definition.*;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import org.apache.logging.log4j.Logger;
import org.apache.logging.log4j.LogManager;
import com.google.common.collect.BiMap;
import com.google.common.collect.HashBiMap;
import com.google.common.collect.Lists;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.math.BigInteger;
import java.util.*;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.configuration.OptionNames.WITNESS_RELATIONS_TO_SHOW;
import static com.dat3m.dartagnan.wmm.RelationNameRepository.*;

@Options
public class RelationModelManager {

    private static final Logger logger = LogManager.getLogger(RelationModelManager.class);

    private final ExecutionModelManager manager;
    private final RelationGraphBuilder graphBuilder;
    private final RelationGraphPopulator graphPopulator;

    private final Map<Relation, RelationModel> relModelCache;
    private final BiMap<Relation, RelationGraph> relGraphCache;
    private final Map<String, EdgeModel> edgeModelCache;

    private EncodingContext context;
    private Wmm wmm;
    private ExecutionModelNext executionModel;
    private EventDomainNext domain;

    @Option(name=WITNESS_RELATIONS_TO_SHOW,
            description="Names of relations to show in the witness graph.",
            secure=true)
    private String relToShowStr = "default";

    public RelationModelManager(ExecutionModelManager manager) {
        this.manager = manager;
        graphBuilder = new RelationGraphBuilder();
        graphPopulator = new RelationGraphPopulator();
        relModelCache = new HashMap<>();
        relGraphCache = HashBiMap.create();
        edgeModelCache = new HashMap<>();
    }

    public void buildRelationModels(ExecutionModelNext executionModel, EncodingContext context, boolean buildAsConfig)
        throws InvalidConfigurationException
    {
        this.executionModel = executionModel;
        this.context = context;
        this.wmm = context.getTask().getMemoryModel();
        this.domain = new EventDomainNext(executionModel);
        relModelCache.clear();
        relGraphCache.clear();
        edgeModelCache.clear();
        final List<String> relationNames = buildAsConfig ? getRelationsToShow() : List.of(PO, RF, CO);
        extractRelations(relationNames);
    }

    public void extractRelations(List<String> relationNames) {
        Set<Relation> relsToExtract = new HashSet<>();
        for (String name : relationNames) {
            Relation r = wmm.getRelation(name);
            if (r == null) {
                logger.warn("Relation with the name {} does not exist", name);
                continue;
            }
            relsToExtract.add(r);
            createModel(r, name);
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

        // Populate graphs of base relations.
        for (CAATPredicate basePred : hierarchy.getBasePredicates()) {
            Relation r = relGraphCache.inverse().get((RelationGraph) basePred);
            try {
                r.getDefinition().accept(graphPopulator);
            } catch (UnsupportedOperationException e) {
                graphPopulator.populateDynamicDefaultGraph(r);
            }
        }

        // Do the computation.
        hierarchy.populate();

        for (CAATPredicate pred : hierarchy.getPredicateList()) {
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

    private List<String> getRelationsToShow() throws InvalidConfigurationException {
        context.getTask().getConfig().inject(this);
        if (relToShowStr.equals("default")) {
            return List.of(PO, RF, CO, "fr");
        }
        else {
            return Arrays.asList(relToShowStr.split(",\\s*"));
        }
    }

    private void createModel(Relation r, String name) {
        if (relModelCache.containsKey(r)) {
            relModelCache.get(r).addName(name);
        } else {
            relModelCache.put(r, new RelationModel(r, name));
        }
    }

    private RelationGraph createGraph(Relation r) {
        RelationGraph rg;
        try {
            rg = r.getDefinition().accept(graphBuilder);
        } catch (UnsupportedOperationException e) {
            rg = new SimpleGraph();
        }
        rg.setName(r.getNameOrTerm());
        if (!r.isRecursive()) {
            relGraphCache.put(r, rg);
        }
        return rg;
    }

    private RelationGraph getOrCreateGraph(Relation r) {
        if (relGraphCache.containsKey(r)) {
            return relGraphCache.get(r);
        }
        return createGraph(r);
    }

    private EdgeModel getOrCreateEdgeModel(Edge e) {
        String identifier = e.getFirst() + " -> " + e.getSecond();
        if (edgeModelCache.containsKey(identifier)) {
            return edgeModelCache.get(identifier);
        }
        EdgeModel em = new EdgeModel(executionModel.getEventModelById(e.getFirst()),
                                     executionModel.getEventModelById(e.getSecond()));
        edgeModelCache.put(identifier, em);
        return em;
    }


    // Usage: Populate graph of the base relations with instances of the Edge class
    // based on the information from ExecutionModelNext.
    private final class RelationGraphPopulator implements Visitor<Void> {

        @Override
        public Void visitProgramOrder(ProgramOrder po) {
            SimpleGraph rg = (SimpleGraph) relGraphCache.get(po.getDefinedRelation());
            for (ThreadModel tm : executionModel.getThreadList()) {
                List<EventModel> eventList = tm.getVisibleEventList();
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
            Relation relation = coherence.getDefinedRelation();
            SimpleGraph rg = (SimpleGraph) relGraphCache.get(relation);
            EncodingContext.EdgeEncoder co = context.edge(relation);

            for (Map.Entry<BigInteger, Set<StoreModel>> entry : executionModel.getAddressWritesMap()
                                                                              .entrySet()) {
                BigInteger address = entry.getKey();
                Set<StoreModel> writes = entry.getValue();
                List<StoreModel> coSortedWrites;
                if (context.usesSATEncoding()) {
                    Map<StoreModel, List<StoreModel>> coEdges = new HashMap<>();
                    for (StoreModel w1 : writes) {
                        coEdges.put(w1, new ArrayList<>());
                        for (StoreModel w2 : writes) {
                            if (manager.isTrue(co.encode(w1.getEvent(), w2.getEvent()))) {
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
                        writeClockMap.put(w, (BigInteger) manager.evaluateByModel(
                            context.memoryOrderClock(w.getEvent())
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
            }
            return null;
        }

        @Override
        public Void visitReadFrom(ReadFrom readFrom) {
            Relation relation = readFrom.getDefinedRelation();
            SimpleGraph rg = (SimpleGraph) relGraphCache.get(relation);
            EncodingContext.EdgeEncoder rf = context.edge(relation);

            for (Map.Entry<BigInteger, Set<LoadModel>> reads : executionModel.getAddressReadsMap()
                                                                             .entrySet()) {
                BigInteger address = reads.getKey();
                for (LoadModel read : reads.getValue()) {
                    for (StoreModel write : executionModel.getAddressWritesMap().get(address)) {
                        if (manager.isTrue(rf.encode(write.getEvent(), read.getEvent()))) {
                            rg.add(new Edge(write.getId(), read.getId()));
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
            
            for (ThreadModel tm : executionModel.getThreadList()) {
                List<EventModel> eventList = tm.getVisibleEventList();
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
                        rg.add(new Edge(e1.getId(), e2.getId()));
                    }
                }
            }
            return null;
        }

        @Override
        public Void visitInternal(Internal in) {
            SimpleGraph rg = (SimpleGraph) relGraphCache.get(in.getDefinedRelation());
            for (ThreadModel tm : executionModel.getThreadList()) {
                List<EventModel> eventList = tm.getVisibleEventList();
                for (EventModel e1 : eventList) {
                    for (EventModel e2 : eventList) {
                        rg.add(new Edge(e1.getId(), e2.getId()));
                    }
                }
            }
            return null;
        }

        @Override
        public Void visitExternal(External ext) {
            SimpleGraph rg = (SimpleGraph) relGraphCache.get(ext.getDefinedRelation());
            List<ThreadModel> threadList = executionModel.getThreadList();
            for (int i = 0; i < threadList.size(); i ++) {
                for (int j = i + 1; j < threadList.size(); j ++) {
                    for (EventModel e1 : threadList.get(i).getVisibleEventList()) {
                        for (EventModel e2 : threadList.get(j).getVisibleEventList()) {
                            rg.add(new Edge(e1.getId(), e2.getId()));
                            rg.add(new Edge(e2.getId(), e1.getId()));
                        }
                    }
                }
            }
            return null;
        }

        @Override
        public Void visitSetIdentity(SetIdentity si) {
            SimpleGraph rg = (SimpleGraph) relGraphCache.get(si.getDefinedRelation());
            executionModel.getEventsByFilter(si.getFilter())
                          .stream().forEach(e -> rg.add(new Edge(e.getId(), e.getId())));
            return null;
        }

        @Override
        public Void visitProduct(CartesianProduct cp) {
            SimpleGraph rg = (SimpleGraph) relGraphCache.get(cp.getDefinedRelation());
            List<EventModel> first = executionModel.getEventsByFilter(cp.getFirstFilter());
            List<EventModel> second = executionModel.getEventsByFilter(cp.getSecondFilter());
            for (EventModel e1 : first) {
                for (EventModel e2 : second) {
                    rg.add(new Edge(e1.getId(), e2.getId()));
                }
            }
            return null;
        }

        @Override
        public Void visitControlDependency(DirectControlDependency ctrlDirect) {
            SimpleGraph rg = (SimpleGraph) relGraphCache.get(ctrlDirect.getDefinedRelation());
            for (ThreadModel tm : executionModel.getThreadList()) {
                for (EventModel em : tm.getEventList()) {
                    if (em.isJump()) {
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
            for (ThreadModel tm : executionModel.getThreadList()) {
                Set<RegWriterModel> writes = new HashSet<>();
                for (EventModel em : tm.getEventList()) {
                    if (em.isRegWriter()) {
                        writes.add((RegWriterModel) em);
                        continue;
                    }
                    if (em.isRegReader()) {
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
            for (ThreadModel tm : executionModel.getThreadList()) {
                Set<RegWriterModel> writes = new HashSet<>();
                for (EventModel em : tm.getEventList()) {
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
        public Void visitEmpty(Empty empty) {
            return null;
        }

        public void populateDynamicDefaultGraph(Relation r) {
            SimpleGraph rg = (SimpleGraph) relGraphCache.get(r);
            EncodingContext.EdgeEncoder edge = context.edge(r);
            RelationAnalysis.Knowledge k = context.getAnalysisContext()
                                                  .get(RelationAnalysis.class)
                                                  .getKnowledge(r);
            
            if (k.getMaySet().size() < domain.size() * domain.size()) {
                k.getMaySet().apply((e1, e2) -> {
                    EventModel em1 = executionModel.getEventModelByEvent(e1);
                    EventModel em2 = executionModel.getEventModelByEvent(e2);
                    if (em1 != null && em2 != null) {
                        if (manager.isTrue(edge.encode(e1, e2))) {
                            rg.add(new Edge(em1.getId(), em2.getId()));
                        }
                    }
                });
            } else {
                for (EventModel em1 : executionModel.getEventList()) {
                    for (EventModel em2 : executionModel.getEventList()) {
                        if (manager.isTrue(edge.encode(em1.getEvent(), em2.getEvent()))) {
                            rg.add(new Edge(em1.getId(), em2.getId()));
                        }
                    }
                }
            }
        }

    }


    // Create a the specific graph for derived ones, so that edges of derived relations
    // can be computed automatically by PredicateHierarchy. 
    private final class RelationGraphBuilder implements Visitor<RelationGraph> {

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
            return new ProjectionIdentityGraph(
                getOrCreateGraph(ri.getOperand()),
                ProjectionIdentityGraph.Dimension.RANGE
            );
        }

        @Override
        public RelationGraph visitDomainIdentity(DomainIdentity di) {
            return new ProjectionIdentityGraph(
                getOrCreateGraph(di.getOperand()),
                ProjectionIdentityGraph.Dimension.DOMAIN
            );
        }

    }
}