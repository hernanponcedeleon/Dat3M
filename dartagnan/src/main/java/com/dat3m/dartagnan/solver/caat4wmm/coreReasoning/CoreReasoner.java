package com.dat3m.dartagnan.solver.caat4wmm.coreReasoning;

import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.caat.reasoning.CAATLiteral;
import com.dat3m.dartagnan.solver.caat.reasoning.EdgeLiteral;
import com.dat3m.dartagnan.solver.caat.reasoning.ElementLiteral;
import com.dat3m.dartagnan.solver.caat4wmm.EventDomain;
import com.dat3m.dartagnan.solver.caat4wmm.ExecutionGraph;
import com.dat3m.dartagnan.solver.caat4wmm.basePredicates.FenceGraph;
import com.dat3m.dartagnan.utils.logic.Conjunction;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.definition.Fences;
import com.dat3m.dartagnan.wmm.utils.Tuple;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.*;

// The CoreReasoner transforms base reasons of the CAATSolver to core reason of the WMMSolver
public class CoreReasoner {

    private final ExecutionGraph executionGraph;
    private final ExecutionAnalysis exec;
    private final RelationAnalysis ra;
    private final Map<String, Relation> termMap = new HashMap<>();

    public CoreReasoner(VerificationTask task, Context analysisContext, ExecutionGraph executionGraph) {
        this.executionGraph = executionGraph;
        this.exec = analysisContext.requires(ExecutionAnalysis.class);
        this.ra = analysisContext.requires(RelationAnalysis.class);
        for (Relation r : task.getMemoryModel().getRelations()) {
            termMap.put(r.getNameOrTerm(), r);
        }
    }


    public Conjunction<CoreLiteral> toCoreReason(Conjunction<CAATLiteral> baseReason) {

        EventDomain domain = executionGraph.getDomain();

        List<CoreLiteral> coreReason = new ArrayList<>(baseReason.getSize());
        for (CAATLiteral lit : baseReason.getLiterals()) {
            if (lit instanceof ElementLiteral elLit) {
                Event e = domain.getObjectById(elLit.getElement().getId()).getEvent();
                // We only have static tags, so all of them reduce to execution literals
                coreReason.add(new ExecLiteral(e, lit.isNegative()));
            } else {

                EdgeLiteral edgeLit = (EdgeLiteral) lit;
                Edge edge = edgeLit.getEdge();
                Event e1 = domain.getObjectById(edge.getFirst()).getEvent();
                Event e2 = domain.getObjectById(edge.getSecond()).getEvent();
                Tuple tuple = new Tuple(e1, e2);
                Relation rel = termMap.get(lit.getName());

                if (lit.isPositive() && ra.getKnowledge(rel).containsMust(tuple)) {
                    // Statically present edges
                    addExecReason(tuple, coreReason);
                } else if (lit.isNegative() && !ra.getKnowledge(rel).containsMay(tuple)) {
                    // Statically absent edges
                } else {
                    String name = rel.getNameOrTerm();
                    if (name.equals(RF) || name.equals(CO)
                            || executionGraph.getCutRelations().contains(rel)) {
                        coreReason.add(new RelLiteral(name, tuple, lit.isNegative()));
                    } else if (name.equals(LOC)) {
                        coreReason.add(new AddressLiteral(tuple, lit.isNegative()));
                    } else if (rel.getDefinition() instanceof Fences) {
                        // This is a special case since "fencerel(F) = po;[F];po".
                        // We should do this transformation directly on the Wmm to avoid this special reasoning
                        if (lit.isNegative()) {
                            throw new UnsupportedOperationException(String.format("FenceRel %s is not allowed on the rhs of differences.", rel));
                        }
                        addFenceReason(rel, edge, coreReason);
                    } else {
                        //TODO: Right now, we assume many relations like Data, Ctrl and Addr to be
                        // static.
                        if (lit.isNegative()) {
                            // TODO: Support negated literals
                            throw new UnsupportedOperationException(String.format("Negated literals of type %s are not supported.", rel));
                        }
                        addExecReason(tuple, coreReason);
                    }
                }
            }
        }

        minimize(coreReason);
        return new Conjunction<>(coreReason);
    }

    private void minimize(List<CoreLiteral> reason) {
        //TODO: Make sure that his is correct for exclusive events
        // Their execution variable can only be removed if it is contained in some
        // RelLiteral but not if it gets cf-implied!
        reason.removeIf( lit -> {
            if (!(lit instanceof ExecLiteral execLit) || lit.isNegative()) {
                return false;
            }
            Event ev = execLit.getData();
            return reason.stream().filter(e -> e instanceof RelLiteral && e.isPositive())
                    .map(RelLiteral.class::cast)
                    .anyMatch(e -> exec.isImplied(e.getData().getFirst(), ev)
                            || exec.isImplied(e.getData().getSecond(), ev));

        });
    }

    private void addExecReason(Tuple edge, List<CoreLiteral> coreReasons) {
        Event e1 = edge.getFirst();
        Event e2 = edge.getSecond();

        if (e1.getGlobalId() > e2.getGlobalId()) {
            // Normalize edge direction
            Event temp = e1;
            e1 = e2;
            e2 = temp;
        }

        if (exec.isImplied(e1, e2)) {
            coreReasons.add(new ExecLiteral(e1));
        } else if (exec.isImplied(e2, e1)) {
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
        if (!exec.isImplied(f.getEvent(), e1.getEvent())) {
            coreReasons.add(new ExecLiteral(e1.getEvent()));
        }
        if (!exec.isImplied(f.getEvent(), e2.getEvent())) {
            coreReasons.add(new ExecLiteral(e2.getEvent()));
        }
    }
}
