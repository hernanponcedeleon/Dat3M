package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.wmm.Constraint;
import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.definition.*;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.immutable.ImmutableMapEventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.mutable.MapEventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.mutable.MutableEventGraph;
import com.google.common.collect.Sets;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.*;
import java.util.stream.Collectors;

public class LazyEncodeSets implements Constraint.Visitor<Boolean> {

    private static final Logger logger = LogManager.getLogger(LazyEncodeSets.class);

    private final RelationAnalysis ra;
    private final Map<Relation, MutableEventGraph> data;
    private MutableEventGraph update;

    public LazyEncodeSets(RelationAnalysis ra, Map<Relation, MutableEventGraph> data) {
        this.ra = ra;
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
    public Boolean visitFree(Free definition) {
        return doUpdateSelf(definition);
    }

    @Override
    public Boolean visitProduct(CartesianProduct definition) {
        return doUpdateSelf(definition);
    }

    @Override
    public Boolean visitSetIdentity(SetIdentity definition) {
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
    public Boolean visitAllocPtr(AllocPtr definition) {
        return doUpdateSelf(definition);
    }

    @Override
    public Boolean visitAllocMem(AllocMem definition) {
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
    public Boolean visitDomainIdentity(DomainIdentity definition) {
        if (doUpdateSelf(definition)) {
            long start = System.currentTimeMillis();
            MutableEventGraph operandUpdate = new MapEventGraph();
            Map<Event, Set<Event>> outMap = ra.getKnowledge(definition.getOperand()).getMaySet().getOutMap();
            update.getDomain().forEach(e1 -> operandUpdate.addRange(e1, outMap.get(e1)));
            setUpdate(operandUpdate);
            operandTime(definition, start, System.currentTimeMillis());
            definition.getOperand().getDefinition().accept(this);
            return true;
        }
        return false;
    }

    @Override
    public Boolean visitRangeIdentity(RangeIdentity definition) {
        if (doUpdateSelf(definition)) {
            long start = System.currentTimeMillis();
            MutableEventGraph operandUpdate = new MapEventGraph();
            Map<Event, Set<Event>> inMap = ra.getKnowledge(definition.getOperand()).getMaySet().getInMap();
            update.getDomain().forEach(e2 -> inMap.get(e2).forEach(e1 -> operandUpdate.add(e1, e2)));
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
