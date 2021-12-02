package com.dat3m.dartagnan.solver.caat4wmm.coreReasoning;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.caat.reasoning.CAATLiteral;
import com.dat3m.dartagnan.solver.caat.reasoning.EdgeLiteral;
import com.dat3m.dartagnan.solver.caat.reasoning.ElementLiteral;
import com.dat3m.dartagnan.solver.caat4wmm.EventDomain;
import com.dat3m.dartagnan.solver.caat4wmm.ExecutionGraph;
import com.dat3m.dartagnan.solver.caat4wmm.basePredicates.FenceGraph;
import com.dat3m.dartagnan.utils.equivalence.BranchEquivalence;
import com.dat3m.dartagnan.utils.logic.Conjunction;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.relation.base.stat.RelFencerel;
import com.dat3m.dartagnan.wmm.utils.RelationRepository;
import com.dat3m.dartagnan.wmm.utils.Tuple;

import java.util.ArrayList;
import java.util.List;

import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.*;

// The CoreReasoner transforms base reasons of the CAATSolver to core reason of the WMMSolver
public class CoreReasoner {

    private final VerificationTask task;
    private final ExecutionGraph executionGraph;
    private final Wmm memoryModel;
    private final BranchEquivalence eq;

    public CoreReasoner(VerificationTask task, ExecutionGraph executionGraph) {
        this.task = task;
        this.executionGraph = executionGraph;
        this.memoryModel = task.getMemoryModel();
        this.eq = task.getBranchEquivalence();
    }


    public Conjunction<CoreLiteral> toCoreReason(Conjunction<CAATLiteral> baseReason) {

        RelationRepository repo = memoryModel.getRelationRepository();
        EventDomain domain = executionGraph.getDomain();

        List<CoreLiteral> coreReason = new ArrayList<>(baseReason.getSize());
        for (CAATLiteral lit : baseReason.getLiterals()) {
            if (lit instanceof ElementLiteral) {
                Event e = domain.getObjectById(((ElementLiteral) lit).getElement().getId()).getEvent();
                // We only have static tags, so all of them reduce to execution literals
                coreReason.add(new ExecLiteral(e, lit.isNegative()));
            } else {

                EdgeLiteral edgeLit = (EdgeLiteral) lit;
                Edge edge = edgeLit.getEdge();
                Event e1 = domain.getObjectById(edge.getFirst()).getEvent();
                Event e2 = domain.getObjectById(edge.getSecond()).getEvent();
                Tuple tuple = new Tuple(e1, e2);
                Relation rel = repo.getRelation(lit.getName());

                if (lit.isPositive() && rel.getMinTupleSet().contains(tuple)) {
                    // Statically present edges
                    addExecReason(tuple, coreReason);
                } else if (lit.isNegative() && !rel.getMaxTupleSet().contains(tuple)) {
                    // Statically absent edges
                } else {
                    if (rel instanceof RelFencerel) {
                        // This is a special case since "fencerel(F) = po;[F];po".
                        // We should do this transformation directly on the Wmm to avoid this special reasoning
                        if (lit.isNegative()) {
                            throw new UnsupportedOperationException(String.format("FenceRel %s is not allowed on the rhs of differences.", rel));
                        }
                        addFenceReason(rel, edge, coreReason);
                    } else if (rel.getName().equals(LOC)) {
                        coreReason.add(new AddressLiteral(tuple, lit.isNegative()));
                    } else if (rel.getName().equals(RF) || rel.getName().equals(CO)) {
                        coreReason.add(new RelLiteral(rel.getName(), tuple, lit.isNegative()));
                    } else {
                        //TODO: Right now, we assume many relations like Data, Ctrl and Addr to be
                        // static.
                        addExecReason(tuple, coreReason);
                    }
                }
            }
        }

        minimize(coreReason);
        return new Conjunction<>(coreReason);
    }

    private void minimize(List<CoreLiteral> reason) {
        reason.removeIf( lit -> {
            if (!(lit instanceof ExecLiteral)) {
                return false;
            }
            Event ev = ((ExecLiteral) lit).getData();
            return reason.stream().filter(e -> e instanceof RelLiteral)
                    .map(RelLiteral.class::cast)
                    .anyMatch(e -> eq.isImplied(e.getData().getFirst(), ev)
                            || eq.isImplied(e.getData().getSecond(), ev));

        });
    }

    private void addExecReason(Tuple edge, List<CoreLiteral> coreReasons) {
        Event e1 = edge.getFirst();
        Event e2 = edge.getSecond();

        if (e1.getCId() > e2.getCId()) {
            // Normalize edge direction
            Event temp = e1;
            e1 = e2;
            e2 = temp;
        }

        if (!e1.cfImpliesExec() || !e2.cfImpliesExec()) {
            coreReasons.add(new ExecLiteral(e1));
            coreReasons.add(new ExecLiteral(e2));
        } else if (eq.isImplied(e1, e2)) {
            coreReasons.add(new ExecLiteral(e1));
        } else if (eq.isImplied(e2, e1)) {
            coreReasons.add(new ExecLiteral(e2));
        } else {
            coreReasons.add(new ExecLiteral(e1));
            coreReasons.add(new ExecLiteral(e2));
        }
    }

    private void addFenceReason(Relation rel, Edge edge, List<CoreLiteral> coreReasons) {
        FenceGraph fenceGraph = (FenceGraph) executionGraph.getRelationGraph(rel);
        EventDomain domain = executionGraph.getDomain();
        EventData e1 = domain.getObjectById(edge.getFirst());
        EventData e2 = domain.getObjectById(edge.getSecond());
        EventData f = fenceGraph.getNextFence(e1);

        coreReasons.add(new ExecLiteral(f.getEvent()));
        if (!eq.isImplied(f.getEvent(), e1.getEvent())) {
            coreReasons.add(new ExecLiteral(e1.getEvent()));
        }
        if (!eq.isImplied(f.getEvent(), e2.getEvent())) {
            coreReasons.add(new ExecLiteral(e2.getEvent()));
        }
    }
}
