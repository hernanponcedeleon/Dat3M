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
import org.apache.logging.log4j.Logger;
import org.apache.logging.log4j.LogManager;
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

    private static final Logger logger = LogManager.getLogger(ExecutionModelManager.class);

    private final RelationGraphBuilder graphBuilder;
    private final RelationGraphPopulator graphPopulator;

    private final Map<Relation, RelationModel> relModelCache;
    private final BiMap<Relation, RelationGraph> relGraphCache;
    private final Map<String, EdgeModel> edgeModelCache;

    private ExecutionModelNext executionModel;
    private EncodingContext context;
    private Model model;
    private Wmm wmm;
    private EventDomainNext domain;

    private List<String> relsToExtract = List.of(PO, CO, RF);

    public ExecutionModelManager(){
        graphBuilder = new RelationGraphBuilder();
        graphPopulator = new RelationGraphPopulator();
        relModelCache = new HashMap<>();
        relGraphCache = HashBiMap.create();
        edgeModelCache = new HashMap<>();
    }

    public ExecutionModelManager setRelationsToExtract(List<String> relationNames) {
        relsToExtract = relationNames;
        return this;
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
        extractRelations(relsToExtract);

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
                    && isTrue(context.jumpCondition(jump))
                ) {
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
        if (e.hasTag(Tag.MEMORY)) {
            Object addressObj = checkNotNull(
                evaluateByModel(context.address((MemoryEvent) e))
            );
            final BigInteger address = new BigInteger(addressObj.toString());
            
            String valueString = String.valueOf(
                evaluateByModel(context.value((MemoryCoreEvent) e))
            );
            final BigInteger value = switch(valueString) {
                // NULL case can happen if the solver optimized away a variable.
                // This should only happen if the value is irrelevant, so we will just pick 0.
                case "false", "null" -> BigInteger.ZERO;
                case "true" -> BigInteger.ONE;
                default -> new BigInteger(valueString);
            };

            if (e.hasTag(Tag.READ)) {
                em = new LoadModel(e, tm, id, address, value);
                executionModel.addAddressRead(address, (LoadModel) em);
            } else if (e.hasTag(Tag.WRITE)) {
                em = new StoreModel(e, tm, id, address, value);
                executionModel.addAddressWrite(address, (StoreModel) em);
            } else {
                // Should never happen.
                logger.warn("Event {} has Tag MEMORY but no READ or WRITE", e);
                em = new MemoryEventModel(e, tm, id, address, value);
            }

        } else if (e.hasTag(Tag.FENCE)) {
            final String name = ((GenericVisibleEvent) e).getName();
            em = new FenceModel(e, tm, id, name);
        } else if (e instanceof Assert assrt) {
            em = new AssertModel(assrt, tm, id);
        } else if (e instanceof Local local) {
            em = new LocalModel(local, tm, id);
        } else if (e instanceof CondJump cj) {
            em = new CondJumpModel(cj, tm, id);
        } else {
            // Should never happen.
            logger.warn("Extracting the event {} that should not be extracted", e);
            em = new DefaultEventModel(e, tm, id);
        }

        executionModel.addEvent(e, em);
    }

    private boolean toExtract(Event e) {
        // We extract visible events, Locals and Asserts to show them in the witness,
        // and extract also CondJumps for tracking internal dependencies.
        return e.hasTag(Tag.VISIBLE)
               || e instanceof Local
               || e instanceof Assert
               || e instanceof CondJump;
    }

    private void extractMemoryLayout() {
        for (MemoryObject obj : context.getTask().getProgram().getMemory().getObjects()) {
            boolean isAllocated = obj.isStaticallyAllocated()
                                        || isTrue(context.execution(obj.getAllocationSite()));
            if (isAllocated) {
                BigInteger address = (BigInteger) evaluateByModel(context.address(obj));
                BigInteger size = (BigInteger) evaluateByModel(context.size(obj));
                executionModel.addMemoryObject(obj, new MemoryObjectModel(obj, address, size));
            }
        }
    }

    // Getting the correct relation to extract is tricky.
    // In the case of redefinition, we have to find the latest defined one which we care about only.
    // If there is no redefinition the original one will be returned simply.
    private Relation getRelationWithName(String name) {
        // First check if the original definition is asked.
        if (name.endsWith("#0")) {
            String originalName = name.substring(0, name.lastIndexOf("#"));
            Relation r = wmm.getRelation(originalName);
            if (r != null) { return r; }
        }

        int maxId = -1;
        for (Relation r : wmm.getRelations()) {
            final int defIndex = r.getNames().stream().filter(s -> s.startsWith(name + "#"))
                                  .map(s -> {
                                    try {
                                        return Integer.parseInt(s.substring(s.lastIndexOf("#") + 1));
                                    } catch (NumberFormatException e) {
                                        return Integer.MIN_VALUE;
                                    }
                                  })
                                  .filter(i -> i != Integer.MIN_VALUE)
                                  .max(Comparator.naturalOrder()).orElse(0);
            if (defIndex != 0 && defIndex > maxId) {
                maxId = defIndex;
            }
        }
        return maxId != -1 ? wmm.getRelation(name + "#" + maxId) : wmm.getRelation(name);
    }

    private void extractRelations(List<String> relationNames) {
        Set<Relation> relsToExtract = new HashSet<>();
        for (String name : relationNames) {
            Relation r = getRelationWithName(name);
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
        RelationGraph rg;
        try {
            rg = r.getDefinition().accept(graphBuilder);
        } catch (UnsupportedOperationException e) {
            // Generate a SimpleGraph for base relations that can be populated manually.
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
                        rg.add(new Edge(e1.getId(), eventList.get(j).getId()));
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

            for (Map.Entry<BigInteger, Set<LoadModel>> reads : executionModel.getAddressReadsMap().entrySet()) {
                BigInteger address = reads.getKey();
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
            final Map<BigInteger, Set<MemoryEventModel>> addressAccesses = new HashMap<>();

            for (Map.Entry<BigInteger, Set<LoadModel>> reads : executionModel.getAddressReadsMap().entrySet()) {
                BigInteger address = reads.getKey();
                addressAccesses.putIfAbsent(address, new HashSet<>());
                for (LoadModel read : reads.getValue()) {
                    addressAccesses.get(address).add(read);
                }
            }

            for (Map.Entry<BigInteger, Set<StoreModel>> writes : executionModel.getAddressWritesMap().entrySet()) {
                BigInteger address = writes.getKey();
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
                    if (em.isJump()) {
                        for (EventModel dep : ((CondJumpModel) em).getDependentEvents(executionModel)) {
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
            for (ThreadModel tm : executionModel.getThreadModels()) {
                Set<RegWriterModel> writes = new HashSet<>();
                for (EventModel em : tm.getEventModels()) {
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
            for (ThreadModel tm : executionModel.getThreadModels()) {
                Set<RegWriterModel> writes = new HashSet<>();
                for (EventModel em : tm.getEventModels()) {
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