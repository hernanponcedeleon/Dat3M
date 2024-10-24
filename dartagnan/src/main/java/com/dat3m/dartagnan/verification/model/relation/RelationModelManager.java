package com.dat3m.dartagnan.verification.model.relation;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.verification.model.ExecutionModel;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.verification.model.relation.RelationModel.EdgeModel;
import com.dat3m.dartagnan.wmm.Constraint.Visitor;
import com.dat3m.dartagnan.wmm.definition.*;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;

import com.google.common.collect.Sets;
import com.google.common.collect.Lists;
import org.sosy_lab.java_smt.api.BooleanFormula;

import java.math.BigInteger;
import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.wmm.RelationNameRepository.*;
import static com.google.common.base.Preconditions.checkNotNull;

public class RelationModelManager {
    private final ExecutionModel executionModel;
    private final RelationModelBuilder builder;

    private RelationModelManager(ExecutionModel m) {
        executionModel = m;
        builder = new RelationModelBuilder();
    }

    public static RelationModelManager newRMManager(ExecutionModel m) {
        return new RelationModelManager(m);
    }

    public void extractRelations(List<String> relationNames) {
        for (String name : relationNames) {
            Relation r = checkNotNull(executionModel.getMemoryModelForWitness().getRelation(name),
                                      String.format("Relation with the name %s does not exist", name));
            extractRelation(r, Optional.of(name));
        }
    }

    private void extractRelation(Relation r, Optional<String> name) {
        if (executionModel.containsRelation(r)) { return; }
        RelationModel rm;
        // TODO: Treat DATA, ADDR, CTRL as derived.
        if (name.isPresent() && name.get().equals(DATA)) {
            rm = builder.buildDataDependency(r);
        } else if (name.isPresent() && name.get().equals(ADDR)) {
            rm = builder.buildAddressDependency(r);
        } else if (name.isPresent() && name.get().equals(CTRL)) {
            rm = builder.buildControlDependency(r);
        } else {
            List<Relation> deps = r.getDependencies();
            for (Relation dep : deps) {
                extractRelation(dep, dep.getName());
            }
            rm = r.getDefinition().accept(builder);
            if (name.isPresent()) {
                rm.setName(name.get());
            }
        }
        executionModel.addRelation(r, rm);
    }

    private RelationModel newModel(Relation r) {
        return new RelationModel(r);
    }

    private RelationModel newModel(Relation r, String relationName) {
        RelationModel m = newModel(r);
        m.setName(relationName);
        return m;
    }

    private void addEdgeToRelation(RelationModel r, EventData p, EventData s) {
        // We do this check because we want only PO edges to connect Local or Assert events.
        if (!r.isDefined() || (r.isDefined() && !r.getName().equals(PO))) {
            if (!p.hasTag(Tag.VISIBLE) || !s.hasTag(Tag.VISIBLE)) { return; }
        }
        String identifier = p.getId() + " -> " + s.getId();
        EdgeModel edge = executionModel.getEdge(identifier);
        if (edge == null) {
            executionModel.addEdge(r.newEdge(p, s));
        }
        else {
            r.addEdge(edge);
        }
    }

    private RelationModel computeInverse(Relation r, RelationModel rm) {
        RelationModel result = newModel(r);
        for (EdgeModel edge : rm.getEdges()) {
            addEdgeToRelation(result, edge.getSuccessor(), edge.getPredecessor());
        }
        return result;
    }

    private RelationModel computeComposition(Relation r, RelationModel first, RelationModel second) {
        RelationModel result = newModel(r);
        for (EdgeModel f : first.getEdges()) {
            for (EdgeModel s : second.getEdges()) {
                if (f.getSuccessor() == s.getPredecessor()) {
                    addEdgeToRelation(result, f.getPredecessor(), s.getSuccessor());
                }
            }
        }
        return result;
    }

    private RelationModel computeDifference(Relation r, RelationModel minuend, RelationModel subtrahend) {
        RelationModel result = newModel(r);
        for (EdgeModel m : minuend.getEdges()) {
            boolean found = false;
            for (EdgeModel s : subtrahend.getEdges()) {
                if (m == s) {
                    found = true;
                    break;
                }
            }
            if (!found) {
                result.addEdge(m);
            }
        }
        return result;
    }

    private RelationModel computeUnion(Relation r, List<RelationModel> relations) {
        RelationModel result = newModel(r);
        for (RelationModel rm : relations) {
            result.addEdges(rm.getEdges());
        }
        return result;
    }

    private RelationModel computeIntersection(Relation r, List<RelationModel> relations) {
        RelationModel result = newModel(r);
        if (relations.size() == 1) {
            result.addEdges(relations.get(0).getEdges());
        } else {
            if (relations.size() == 2) {
                Set<EdgeModel> edges = Sets.intersection(relations.get(0).getEdges(), relations.get(1).getEdges());
                if (relations.size() > 2) {
                    for (int i = 2; i < relations.size(); i++) {
                        edges = Sets.intersection(edges, relations.get(i).getEdges());
                    }
                }
                result.addEdges(edges);
            }
        }
        return result;
    }

    private RelationModel computeTransitiveClosure(Relation r, RelationModel rm) {
        RelationModel result = newModel(r);
        final Map<EventData, Set<EventData>> reachMap = new HashMap<>();
        for (EdgeModel edge : rm.getEdges()) {
            reachMap.computeIfAbsent(edge.getPredecessor(), k -> new HashSet<>()).add(edge.getSuccessor());
        }
        for (EventData p : reachMap.keySet()) {
            final Set<EventData> reachables = new HashSet<>();
            depthFirstSearch(p, reachMap, reachables);
            for (EventData s : reachables) {
                if (p != s) { addEdgeToRelation(result, p, s); }
            }
        }
        return result;
    }

    private void depthFirstSearch(EventData p, Map<EventData, Set<EventData>> reachMap, Set<EventData> visited) {
        if (visited.contains(p)) { return; }
        visited.add(p);
        if (reachMap.containsKey(p)) {
            for (EventData s : reachMap.get(p)) {
                depthFirstSearch(s, reachMap, visited);
            }
        }
    }

    private RelationModel removeSelfLoopToShow(RelationModel rm) {
        for (EdgeModel e : rm.getEdges()) {
            if (e.getPredecessor() == e.getSuccessor()) {
                rm.removeEdgeToShow(e);
            }
        }
        return rm;
    }

    // We do NOT show transitive edges in base relations.
    private RelationModel removeTransitiveEdgesToShow(RelationModel rm) {
        rm = removeSelfLoopToShow(rm);
        for (EdgeModel e1 : rm.getEdges()) {
            for (EdgeModel e2 : rm.getEdges()) {
                if (e1.getSuccessor() == e2.getPredecessor()) {
                    rm.removeEdgeToShow(new EdgeModel(e1.getPredecessor(), e2.getSuccessor()));
                }
            }
        }
        return rm;
    }


    private final class RelationModelBuilder implements Visitor<RelationModel> {
        public RelationModelBuilder() {}

        @Override
        public RelationModel visitInverse(Inverse invs) {
            Relation inversed = invs.getDefinedRelation();
            RelationModel toInverse = executionModel.getRelationModel(invs.getOperand());
            return computeInverse(inversed, toInverse);
        }

        @Override
        public RelationModel visitComposition(Composition comp) {
            Relation compR = comp.getDefinedRelation();
            RelationModel left = executionModel.getRelationModel(comp.getLeftOperand());
            RelationModel right = executionModel.getRelationModel(comp.getRightOperand());
            return computeComposition(compR, left, right);
        }

        @Override
        public RelationModel visitDifference(Difference diff) {
            Relation diffR = diff.getDefinedRelation();
            RelationModel minuend = executionModel.getRelationModel(diff.getMinuend());
            RelationModel subtrahend = executionModel.getRelationModel(diff.getSubtrahend());
            return computeDifference(diffR, minuend, subtrahend);
        }

        @Override
        public RelationModel visitUnion(Union u) {
            Relation uR = u.getDefinedRelation();
            List<RelationModel> operandModels = u.getOperands().stream().map(r -> executionModel.getRelationModel(r)).collect(Collectors.toList());
            return computeUnion(uR, operandModels);
        }

        @Override
        public RelationModel visitIntersection(Intersection intsc) {
            Relation intscR = intsc.getDefinedRelation();
            List<RelationModel> operandModels = intsc.getOperands().stream().map(r -> executionModel.getRelationModel(r)).collect(Collectors.toList());
            return computeIntersection(intscR, operandModels);
        }

        @Override
        public RelationModel visitTransitiveClosure(TransitiveClosure tscl) {
            Relation tsclR = tscl.getDefinedRelation();
            RelationModel operand = executionModel.getRelationModel(tscl.getOperand());
            return computeTransitiveClosure(tsclR, operand);
        }

        @Override
        public RelationModel visitProgramOrder(ProgramOrder po) {
            Relation r = po.getDefinedRelation();
            RelationModel rm = newModel(r, PO);
            for (Thread t : executionModel.getThreads()) {
                List<EventData> events = executionModel.getThreadEventsMap().get(t).stream()
                                                       .filter(e -> e.hasTag(Tag.VISIBLE)
                                                               || e.isLocal()
                                                               || e.isAssert())
                                                       .toList();
                if (events.size() <= 1) { continue; }
                for (int i = 1; i < events.size(); i++) {
                    EventData e1 = events.get(i - 1);
                    EventData e2 = events.get(i);
                    addEdgeToRelation(rm, e1, e2);
                }
                // Add PO edge also between visible events.
                List<EventData> visibles = getVisibleEvents(t);
                for (int i = 1; i < visibles.size(); i++) {
                    EventData e1 = visibles.get(i - 1);
                    EventData e2 = visibles.get(i);
                    addEdgeToRelation(rm, e1, e2);
                }
            }
            return removeTransitiveEdgesToShow(rm);
        }

        @Override
        public RelationModel visitReadFrom(ReadFrom rf) {
            Relation r = rf.getDefinedRelation();
            RelationModel rm = newModel(r, RF);
            EncodingContext.EdgeEncoder rfEncoder = executionModel.getContextForWitness().edge(r);
            for (Map.Entry<BigInteger, Set<EventData>> reads : executionModel.getAddressReadsMap().entrySet()) {
                BigInteger address = reads.getKey();
                for (EventData read : reads.getValue()) {
                    for (EventData write : executionModel.getAddressWritesMap().get(address)) {
                        BooleanFormula rfExpr = rfEncoder.encode(write.getEvent(), read.getEvent());
                        if (isTrue(rfExpr)) {
                            addEdgeToRelation(rm, write, read);
                            break;
                        }
                    }
                }
            }
            return removeTransitiveEdgesToShow(rm);
        }

        @Override
        public RelationModel visitCoherence(Coherence co) {
            Relation r = co.getDefinedRelation();
            RelationModel rm = newModel(r, CO);
            EncodingContext.EdgeEncoder coEncoder = executionModel.getContextForWitness().edge(r);
            for (Map.Entry<BigInteger, Set<EventData>> writes : executionModel.getAddressWritesMap().entrySet()) {
                BigInteger address = writes.getKey();
                Set<EventData> writeEvents = writes.getValue();
                List<EventData> sortedWrites;
                if (executionModel.getContext().usesSATEncoding()) {
                    Map<EventData, List<EventData>> edges = new HashMap<>();
                    for (EventData w1 : writeEvents) {
                        edges.put(w1, new ArrayList<>());
                        for (EventData w2 : writeEvents) {
                            if (isTrue(coEncoder.encode(w1.getEvent(), w2.getEvent()))) {
                                edges.get(w1).add(w2);
                            }
                        }
                    }
                    DependencyGraph<EventData> depGraph = DependencyGraph.from(writeEvents, edges);
                    sortedWrites = new ArrayList<>(Lists.reverse(depGraph.getNodeContents()));
                } else {
                    Map<EventData, BigInteger> writeClockMap = new HashMap<>(writeEvents.size() * 4 / 3, 0.75f);
                    for (EventData w : writeEvents) {
                        writeClockMap.put(w, executionModel.getModel().evaluate(executionModel.getContext().memoryOrderClock(w.getEvent())));
                    }
                    sortedWrites = writeEvents.stream().sorted(Comparator.comparing(writeClockMap::get)).collect(Collectors.toList());
                }

                int index = 0;
                for (EventData w : sortedWrites) {
                    w.setCoherenceIndex(index++);
                }
                for (int i = 2; i < sortedWrites.size(); i ++) {
                    EventData w1 = sortedWrites.get(i - 1);
                    EventData w2 = sortedWrites.get(i);
                    addEdgeToRelation(rm, w1, w2);
                }
            }
            return removeTransitiveEdgesToShow(rm);
        }

        @Override
        public RelationModel visitSameLocation(SameLocation loc) {
            Relation r = loc.getDefinedRelation();
            RelationModel rm = newModel(r, LOC);
            EncodingContext.EdgeEncoder locEncoder = executionModel.getContextForWitness().edge(r);
            Map<BigInteger, Set<EventData>> memoryAccesses = Stream.concat(executionModel.getAddressReadsMap().entrySet().stream(),
                                                                           executionModel.getAddressWritesMap().entrySet().stream())
                                                                   .collect(Collectors.toMap(
                                                                            Map.Entry::getKey,
                                                                            Map.Entry::getValue,
                                                                            (set1, set2) -> {
                                                                                Set<EventData> merged = new HashSet<>(set1);
                                                                                merged.addAll(set2);
                                                                                return merged;
                                                                            }
                                                             ));
            for (Map.Entry<BigInteger, Set<EventData>> sameLocAccesses : memoryAccesses.entrySet()) {
                BigInteger addr = sameLocAccesses.getKey();
                List<EventData> asList = new ArrayList<>(sameLocAccesses.getValue());
                for (int i = 0; i < asList.size(); i++) {
                    for (int j = i + 1; j < asList.size(); j++) {
                        EventData e1 = asList.get(i);
                        EventData e2 = asList.get(j);
                        BooleanFormula locExpr1 = locEncoder.encode(e1.getEvent(), e2.getEvent());
                        if (isTrue(locExpr1)) {
                            addEdgeToRelation(rm, e1, e2);
                        }
                        BooleanFormula locExpr2 = locEncoder.encode(e2.getEvent(), e1.getEvent());
                        if (isTrue(locExpr2)) {
                            addEdgeToRelation(rm, e2, e1);
                        }
                    }
                }
            }
            return rm;
        }

        @Override
        public RelationModel visitInternal(Internal in) {
            Relation r = in.getDefinedRelation();
            RelationModel rm = newModel(r, INT);
            EncodingContext.EdgeEncoder intEncoder = executionModel.getContextForWitness().edge(r);
            for (Thread t : executionModel.getThreads()) {
                List<EventData> events = getVisibleEvents(t);
                if (events.size() <= 1) { continue; }
                for (int i = 0; i < events.size(); i++) {
                    for (int j = i + 1; j < events.size(); j++) {
                        EventData e1 = events.get(i);
                        EventData e2 = events.get(j);
                        BooleanFormula intExpr1 = intEncoder.encode(e1.getEvent(), e2.getEvent());
                        if (isTrue(intExpr1)) {
                            addEdgeToRelation(rm, e1, e2);
                        }
                        BooleanFormula intExpr2 = intEncoder.encode(e2.getEvent(), e1.getEvent());
                        if (isTrue(intExpr2)) {
                            addEdgeToRelation(rm, e2, e1);
                        }
                    }
                }
            }
            return rm;
        }

        @Override
        public RelationModel visitExternal(External ext) {
            Relation r = ext.getDefinedRelation();
            RelationModel rm = newModel(r, EXT);
            EncodingContext.EdgeEncoder extEncoder = executionModel.getContextForWitness().edge(r);
            List<Thread> threads = executionModel.getThreads();
            for (int i = 0; i < threads.size(); i++) {
                List<EventData> eventList1 = getVisibleEvents(threads.get(i));
                if (eventList1.size() <= 1) { continue; }
                for (int j = i + 1; j < threads.size(); j++) {
                    List<EventData> eventList2 = getVisibleEvents(threads.get(j));
                    if (eventList2.size() <= 1) { continue; }
                    for (EventData e1 : eventList1) {
                        for (EventData e2 : eventList2) {
                            BooleanFormula extExpr1 = extEncoder.encode(e1.getEvent(), e2.getEvent());
                            if (isTrue(extExpr1)) {
                                addEdgeToRelation(rm, e1, e2);
                            }
                            BooleanFormula extExpr2 = extEncoder.encode(e2.getEvent(), e1.getEvent());
                            if (isTrue(extExpr2)) {
                                addEdgeToRelation(rm, e2, e1);
                            }
                        }
                    }
                }
            }
            return rm;
        }

        @Override
        public RelationModel visitReadModifyWrites(ReadModifyWrites rmw) {
            Relation r = rmw.getDefinedRelation();
            RelationModel rm = newModel(r, RMW);
            EncodingContext.EdgeEncoder rmwEncoder = executionModel.getContextForWitness().edge(r);
            for (Map.Entry<BigInteger, Set<EventData>> addressReads : executionModel.getAddressReadsMap().entrySet()) {
                BigInteger addr = addressReads.getKey();
                for (EventData read : addressReads.getValue()) {
                    for (EventData write : executionModel.getAddressWritesMap().get(addr)) {
                        if (read.getThread() == write.getThread()
                            && read.isRMW() && write.isRMW()) {
                            BooleanFormula rmwExpr = rmwEncoder.encode(read.getEvent(), write.getEvent());
                            if (isTrue(rmwExpr)) {
                                addEdgeToRelation(rm, read, write);
                            }
                        }
                    }
                }
            }
            return removeTransitiveEdgesToShow(rm);
        }

        @Override
        public RelationModel visitProduct(CartesianProduct prod) {
            Relation r = prod.getDefinedRelation();
            RelationModel rm = newModel(r);
            List<EventData> eList1 = executionModel.getEventList().stream()
                                                   .filter(e -> prod.getFirstFilter().apply(e.getEvent()))
                                                   .toList();
            List<EventData> eList2 = executionModel.getEventList().stream()
                                                   .filter(e -> prod.getSecondFilter().apply(e.getEvent()))
                                                   .toList();
            for (EventData p : eList1) {
                for (EventData s : eList2) {
                    if (p != s) {
                        addEdgeToRelation(rm, p, s);
                    }
                }
            }
            return rm;
        }

        @Override
        public RelationModel visitSetIdentity(SetIdentity set) {
            Relation r = set.getDefinedRelation();
            RelationModel rm = newModel(r);
            List<EventData> eList = executionModel.getEventList().stream()
                                                  .filter(e -> set.getFilter().apply(e.getEvent()))
                                                  .toList();
            eList.stream().forEach(e -> addEdgeToRelation(rm, e, e));
            return rm;
        }

        @Override
        public RelationModel visitRangeIdentity(RangeIdentity range) {
            Relation r = range.getDefinedRelation();
            RelationModel rm = newModel(r);
            Set<EventData> successors = new HashSet<>();
            executionModel.getRelationModel(range.getOperand()).getEdges()
                          .stream().forEach(e -> successors.add(e.getSuccessor()));
            successors.stream().forEach(s -> addEdgeToRelation(rm, s, s));
            return rm;
        }

        @Override
        public RelationModel visitDomainIdentity(DomainIdentity domain) {
            Relation r = domain.getDefinedRelation();
            RelationModel rm = newModel(r);
            Set<EventData> predecessors = new HashSet<>();
            executionModel.getRelationModel(domain.getOperand()).getEdges()
                          .stream().forEach(e -> predecessors.add(e.getPredecessor()));
            predecessors.stream().forEach(p -> addEdgeToRelation(rm, p, p));
            return rm;
        }

        @Override
        public RelationModel visitFree(Free f) {
            Relation r = f.getDefinedRelation();
            RelationModel rm = newModel(r);
            for (Thread t : executionModel.getThreads()) {
                List<EventData> events = getVisibleEvents(t);
                if (events.size() <= 1) { continue; }
                for (EventData e1 : events) {
                    for (EventData e2 : events) {
                        addEdgeToRelation(rm, e1, e2);
                    }
                }
            }
            return rm;
        }

        public RelationModel buildDataDependency(Relation dataDep) {
            RelationModel rm = newModel(dataDep, DATA);
            for (Map.Entry<EventData, Set<EventData>> deps : executionModel.getDataDepMap().entrySet()) {
                EventData e = deps.getKey();
                for (EventData dep : deps.getValue()) {
                    addEdgeToRelation(rm, e, dep);
                }
            }
            return rm;
        }

        public RelationModel buildAddressDependency(Relation addrDep) {
            RelationModel rm = newModel(addrDep, ADDR);
            for (Map.Entry<EventData, Set<EventData>> deps : executionModel.getAddrDepMap().entrySet()) {
                EventData e = deps.getKey();
                for (EventData dep : deps.getValue()) {
                    addEdgeToRelation(rm, e, dep);
                }
            }
            return rm;
        }
        
        public RelationModel buildControlDependency(Relation ctrlDep) {
            RelationModel rm = newModel(ctrlDep, CTRL);
            for (Map.Entry<EventData, Set<EventData>> deps : executionModel.getCtrlDepMap().entrySet()) {
                EventData e = deps.getKey();
                for (EventData dep : deps.getValue()) {
                    addEdgeToRelation(rm, e, dep);
                }
            }
            return rm;
        }

        private boolean isTrue(BooleanFormula formula) {
            return Boolean.TRUE.equals(executionModel.getModel().evaluate(formula));
        }

        private List<EventData> getVisibleEvents(Thread t) {
            return executionModel.getThreadEventsMap().get(t).stream()
                                 .filter(e -> e.hasTag(Tag.VISIBLE))
                                 .toList();
        }
    }
}
