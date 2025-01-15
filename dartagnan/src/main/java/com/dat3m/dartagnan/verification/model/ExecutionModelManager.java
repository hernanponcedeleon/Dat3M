package com.dat3m.dartagnan.verification.model;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.event.*;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.filter.Filter;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.solver.caat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.caat.predicates.PredicateHierarchy;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.base.SimpleGraph;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.derived.*;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.RelationGraph;
import com.dat3m.dartagnan.solver.caat4wmm.EventDomainNext;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.verification.model.event.*;
import com.dat3m.dartagnan.verification.model.RelationModel.EdgeModel;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.Constraint.Visitor;
import com.dat3m.dartagnan.wmm.definition.*;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.google.common.collect.BiMap;
import com.google.common.collect.HashBiMap;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.Formula;
import org.sosy_lab.java_smt.api.Model;

import java.math.BigInteger;
import java.util.*;

import static com.dat3m.dartagnan.wmm.RelationNameRepository.*;
import static com.google.common.base.Preconditions.checkNotNull;


public class ExecutionModelManager {
    private final RelationGraphBuilder graphBuilder;
    private final RelationGraphPopulator graphPopulator;

    private final Map<Relation, RelationModel> relModelCache;
    private final BiMap<Relation, RelationGraph> relGraphCache;
    private final Map<Edge, EdgeModel> edgeModelCache;

    private ExecutionModelNext executionModel;
    private EncodingContext context;
    private Model model;
    private Wmm wmm;
    private EventDomainNext domain;

    public ExecutionModelManager(){
        graphBuilder = new RelationGraphBuilder();
        graphPopulator = new RelationGraphPopulator();
        relModelCache = new HashMap<>();
        relGraphCache = HashBiMap.create();
        edgeModelCache = new HashMap<>();
    }

    public ExecutionModelNext buildExecutionModel(EncodingContext context, Model model) {
        executionModel = new ExecutionModelNext();

        this.context = context;
        this.model = model;
        this.wmm = context.getTask().getMemoryModel();
        this.domain = new EventDomainNext(executionModel);

        extractEvents();
        extractMemoryLayout();

        relModelCache.clear();
        relGraphCache.clear();
        edgeModelCache.clear();
        extractRelations();

        this.context = null;
        this.model = null;
        this.wmm = null;
        this.domain = null;

        return executionModel;
    }

    private void extractEvents() {
        int id = 0;
        List<Thread> threadList = new ArrayList<>(context.getTask().getProgram().getThreads());

        for (Thread t : threadList) {
            ThreadModel tm = new ThreadModel(t);
            int eventNum = 0;
            Event e = t.getEntry();

            do {
                if (!isTrue(context.execution(e))) {
                    e = e.getSuccessor();
                    continue;
                }

                if (toExtract(e)) {
                    extractEvent(e, tm, id++);
                    eventNum++;
                }

                if (e instanceof CondJump jump
                    && isTrue(context.jumpCondition(jump))) {
                    e = jump.getLabel();
                } else {
                    e = e.getSuccessor();
                }

            } while (e != null);

            if (eventNum > 0) { executionModel.addThread(tm); }
        }
    }

    private void extractEvent(Event e, ThreadModel tm, int id) {
        EventModel em;
        if (e instanceof MemoryEvent memEvent) {
            ValueModel address = new ValueModel(evaluateByModel(context.address(memEvent)));
            ValueModel value = new ValueModel(evaluateByModel(context.value(memEvent)));

            if (memEvent instanceof Load load) {
                em = new LoadModel(load, tm, id, address, value);
                executionModel.addAddressRead(address, (LoadModel) em);
            } else if (memEvent instanceof Store store) {
                em = new StoreModel(store, tm, id, address, value);
                executionModel.addAddressWrite(address, (StoreModel) em);
            } else {
                // Should never happen.
                throw new IllegalArgumentException(String.format(
                    "Event %s is memory event but neither read nor write", memEvent
                ));
            }

        } else if (e instanceof GenericVisibleEvent visible) {
            em = new GenericVisibleEventModel(visible, tm, id);
        } else if (e instanceof Assert assrt) {
            em = new AssertModel(
                assrt, tm, id, isTrue(context.encodeExpressionAsBooleanAt(assrt.getExpression(), assrt))
            );
        } else if (e instanceof Local local) {
            ValueModel value = new ValueModel(evaluateByModel(context.result(local)));
            em = new LocalModel(local, tm, id, value);
        } else if (e instanceof CondJump cj) {
            em = new CondJumpModel(cj, tm, id);
        } else {
            // Should never happen.
            throw new IllegalArgumentException(String.format("Event %s should not be extracted", e));
        }

        executionModel.addEvent(e, em);
    }

    private boolean toExtract(Event e) {
        // We extract visible events, Locals and Asserts to show them in the witness,
        // and extract also CondJumps for tracking internal dependencies.
        return e instanceof MemoryEvent
               || e instanceof GenericVisibleEvent
               || e instanceof Local
               || e instanceof Assert
               || e instanceof CondJump;
    }

    private void extractMemoryLayout() {
        for (MemoryObject obj : context.getTask().getProgram().getMemory().getObjects()) {
            boolean isAllocated = obj.isStaticallyAllocated()
                                  || isTrue(context.execution(obj.getAllocationSite()));
            if (isAllocated) {
                // Currently, addresses of memory objects are guaranteed to be integer and assigned.
                ValueModel address = new ValueModel(evaluateByModel(context.address(obj)));
                BigInteger size = (BigInteger) evaluateByModel(context.size(obj));
                executionModel.addMemoryObject(obj, new MemoryObjectModel(obj, address, size));
            }
        }
    }

    private void extractRelations() {
        Set<Relation> relsToExtract = new HashSet<>(wmm.getRelations());
        for (Relation r : relsToExtract) { createModel(r); }

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
                // Populate graph of relations unsupported by the visitor using default relation analysis.
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

    private void createModel(Relation r) {
        if (relModelCache.containsKey(r)) { return; }
        relModelCache.put(r, new RelationModel(r));
    }

    private RelationGraph createGraph(Relation r) {
        RelationGraph rg = r.getDependencies().size() == 0 ? new SimpleGraph() : r.getDefinition().accept(graphBuilder);
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
        if (edgeModelCache.containsKey(e)) {
            return edgeModelCache.get(e);
        }
        EdgeModel em = new EdgeModel(executionModel.getEventModelById(e.getFirst()),
                                     executionModel.getEventModelById(e.getSecond()));
        edgeModelCache.put(e, em);
        return em;
    }

    private boolean isTrue(BooleanFormula formula) {
        return Boolean.TRUE.equals(model.evaluate(formula));
    }

    private Object evaluateByModel(Formula formula) {
        return model.evaluate(formula);
    }


    // Usage: Populate graph of the base relations with instances of the Edge class
    // based on the information from ExecutionModelNext.
    private final class RelationGraphPopulator implements Visitor<Void> {

        @Override
        public Void visitProgramOrder(ProgramOrder po) {
            SimpleGraph rg = (SimpleGraph) relGraphCache.get(po.getDefinedRelation());
            for (ThreadModel tm : executionModel.getThreadModels()) {
                List<EventModel> eventList = tm.getVisibleEventModels();
                if (eventList.size() <= 1) { continue; }
                for (int i = 1; i < eventList.size(); i++) {
                    EventModel e1 = eventList.get(i);
                    for (int j = i + 1; j < eventList.size(); j++) {
                        EventModel e2 = eventList.get(j);
                        rg.add(new Edge(e1.getId(), e2.getId()));
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

            for (Map.Entry<ValueModel, Set<LoadModel>> reads : executionModel.getAddressReadsMap().entrySet()) {
                ValueModel address = reads.getKey();
                if (!executionModel.getAddressWritesMap().containsKey(address)) { continue; }
                for (LoadModel read : reads.getValue()) {
                    for (StoreModel write : executionModel.getAddressWritesMap().get(address)) {
                        if (isTrue(rf.encode(write.getEvent(), read.getEvent()))) {
                            rg.add(new Edge(write.getId(), read.getId()));
                        }
                    }
                }
            }
            return null;
        }

        @Override
        public Void visitCoherence(Coherence coherence) {
            Relation relation = coherence.getDefinedRelation();
            SimpleGraph rg = (SimpleGraph) relGraphCache.get(relation);
            EncodingContext.EdgeEncoder co = context.edge(relation);

            for (Set<StoreModel> writes : executionModel.getAddressWritesMap().values()) {
                for (StoreModel w1 : writes) {
                    for (StoreModel w2 : writes) {
                        if (isTrue(co.encode(w1.getEvent(), w2.getEvent()))) {
                            rg.add(new Edge(w1.getId(), w2.getId()));
                        }
                    }
                }
            }
            return null;
        }

        @Override
        public Void visitReadModifyWrites(ReadModifyWrites rmw) {
            Relation relation = rmw.getDefinedRelation();
            SimpleGraph rg = (SimpleGraph) relGraphCache.get(relation);
            EncodingContext.EdgeEncoder edge = context.edge(relation);

            for (Map.Entry<ValueModel, Set<LoadModel>> reads : executionModel.getAddressReadsMap().entrySet()) {
                ValueModel address = reads.getKey();
                if (!executionModel.getAddressWritesMap().containsKey(address)) { continue; }
                for (LoadModel read : reads.getValue()) {
                    for (StoreModel write : executionModel.getAddressWritesMap().get(address)) {
                        if (isTrue(edge.encode(read.getEvent(), write.getEvent()))) {
                            rg.add(new Edge(read.getId(), write.getId()));
                        }
                    }
                }
            }
            return null;
        }

        @Override
        public Void visitSameLocation(SameLocation loc) {
            SimpleGraph rg = (SimpleGraph) relGraphCache.get(loc.getDefinedRelation());
            final Map<ValueModel, Set<MemoryEventModel>> addressAccesses = new HashMap<>();

            for (Map.Entry<ValueModel, Set<LoadModel>> reads : executionModel.getAddressReadsMap().entrySet()) {
                ValueModel address = reads.getKey();
                addressAccesses.putIfAbsent(address, new HashSet<>());
                for (LoadModel read : reads.getValue()) {
                    addressAccesses.get(address).add(read);
                }
            }

            for (Map.Entry<ValueModel, Set<StoreModel>> writes : executionModel.getAddressWritesMap().entrySet()) {
                ValueModel address = writes.getKey();
                addressAccesses.putIfAbsent(address, new HashSet<>());
                for (StoreModel write : writes.getValue()) {
                    addressAccesses.get(address).add(write);
                }
            }

            for (Set<MemoryEventModel> sameLocAccesses : addressAccesses.values()) {
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
            for (ThreadModel tm : executionModel.getThreadModels()) {
                List<EventModel> eventList = tm.getVisibleEventModels();
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
            List<ThreadModel> threadList = executionModel.getThreadModels();
            for (int i = 0; i < threadList.size(); i ++) {
                for (int j = i + 1; j < threadList.size(); j ++) {
                    for (EventModel e1 : threadList.get(i).getVisibleEventModels()) {
                        for (EventModel e2 : threadList.get(j).getVisibleEventModels()) {
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
            executionModel.getEventModelsByFilter(si.getFilter())
                          .stream().forEach(e -> rg.add(new Edge(e.getId(), e.getId())));
            return null;
        }

        @Override
        public Void visitProduct(CartesianProduct cp) {
            SimpleGraph rg = (SimpleGraph) relGraphCache.get(cp.getDefinedRelation());
            List<EventModel> first = executionModel.getEventModelsByFilter(cp.getFirstFilter());
            List<EventModel> second = executionModel.getEventModelsByFilter(cp.getSecondFilter());
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
            for (ThreadModel tm : executionModel.getThreadModels()) {
                for (EventModel em : tm.getEventModels()) {
                    if (em instanceof CondJumpModel cjm) {
                        for (EventModel dep : cjm.getDependentEvents(executionModel)) {
                            rg.add(new Edge(cjm.getId(), dep.getId()));
                        }
                    }
                }
            }
            return null;
        }

        @Override
        public Void visitAddressDependency(DirectAddressDependency addrDirect) {
            SimpleGraph rg = (SimpleGraph) relGraphCache.get(addrDirect.getDefinedRelation());
            for (ThreadModel tm : executionModel.getThreadModels()) {
                Set<RegWriterModel> writes = new HashSet<>();
                for (EventModel em : tm.getEventModels()) {
                    if (em instanceof RegWriterModel rwm) {
                        writes.add(rwm);
                        continue;
                    }
                    if (em instanceof RegReaderModel rrm) {
                        for (RegWriterModel write : writes) {
                            for (Register.Read read : rrm.getRegisterReads()) {
                                if (read.register() == write.getResultRegister()
                                    && read.usageType() == Register.UsageType.ADDR) {
                                    rg.add(new Edge(write.getId(), rrm.getId()));
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
            for (ThreadModel tm : executionModel.getThreadModels()) {
                Set<RegWriterModel> writes = new HashSet<>();
                for (EventModel em : tm.getEventModels()) {
                    if (em instanceof RegWriterModel rwm) {
                        writes.add(rwm);
                        continue;
                    }
                    if (em instanceof RegReaderModel rrm) {
                        for (RegWriterModel write : writes) {
                            for (Register.Read read : rrm.getRegisterReads()) {
                                if (read.register() == write.getResultRegister()
                                    && read.usageType() == Register.UsageType.DATA) {
                                    rg.add(new Edge(write.getId(), rrm.getId()));
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
                        if (isTrue(edge.encode(e1, e2))) {
                            rg.add(new Edge(em1.getId(), em2.getId()));
                        }
                    }
                });
            } else {
                for (EventModel em1 : executionModel.getEventModels()) {
                    for (EventModel em2 : executionModel.getEventModels()) {
                        if (isTrue(edge.encode(em1.getEvent(), em2.getEvent()))) {
                            rg.add(new Edge(em1.getId(), em2.getId()));
                        }
                    }
                }
            }
        }

    }


    // Create a the specific graph for derived relations, so that edges of them
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
