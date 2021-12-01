package com.dat3m.dartagnan.solver.newcaat4wmm;


import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.solver.newcaat.CAATSolver;
import com.dat3m.dartagnan.solver.newcaat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.newcaat.reasoning.CAATLiteral;
import com.dat3m.dartagnan.solver.newcaat.reasoning.EdgeLiteral;
import com.dat3m.dartagnan.solver.newcaat.reasoning.ElementLiteral;
import com.dat3m.dartagnan.solver.newcaat4wmm.base.FenceGraph;
import com.dat3m.dartagnan.solver.newcaat4wmm.coreReasoning.*;
import com.dat3m.dartagnan.utils.equivalence.BranchEquivalence;
import com.dat3m.dartagnan.utils.logic.Conjunction;
import com.dat3m.dartagnan.utils.logic.DNF;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.verification.model.ExecutionModel;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.relation.base.stat.RelFencerel;
import com.dat3m.dartagnan.wmm.utils.RelationRepository;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import org.sosy_lab.java_smt.api.Model;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.ArrayList;
import java.util.List;

import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.*;

/*
    This is our domain-specific bridge-ing component that specializes the CAATSolver to the WMM setting.

*/
public class WMMSolver {

    private final VerificationTask task;
    private final ExecutionGraph executionGraph;
    private final ExecutionModel executionModel;
    private final CAATSolver solver;
    private final Wmm memoryModel;
    private final BranchEquivalence eq;



    public WMMSolver(VerificationTask task) {
        this.task = task;
        this.memoryModel = task.getMemoryModel();
        this.eq = task.getBranchEquivalence();
        this.executionGraph = new ExecutionGraph(task, true);
        this.executionModel = new ExecutionModel(task);
        this.solver = CAATSolver.create();

        memoryModel.performRelationalAnalysis(false);
    }


    public Result check(Model model, SolverContext ctx) {
        long curTime = System.currentTimeMillis();
        executionModel.initialize(model, ctx);
        executionGraph.initializeFromModel(executionModel);
        long extractTime = System.currentTimeMillis() - curTime;

        CAATSolver.Result caatResult = solver.check(executionGraph.getCAATModel());
        Result result = Result.fromCAATResult(caatResult);
        result.stats.modelExtractionTime = extractTime;
        result.stats.modelSize = executionGraph.getDomain().size();

        if (result.getStatus() == CAATSolver.Status.INCONSISTENT) {
            List<Conjunction<CoreLiteral>> coreReasons = new ArrayList<>(caatResult.getBaseReasons().getNumberOfCubes());
            for (Conjunction<CAATLiteral> baseReason : caatResult.getBaseReasons().getCubes()) {
                coreReasons.add(toCoreReason(baseReason));
            }

            result.coreReasons = new DNF<>(coreReasons);
        }

        return result;
    }

    public ExecutionModel getExecution() {
        return executionModel;
    }

    public ExecutionGraph getExecutionGraph() {
        return executionGraph;
    }


    private Conjunction<CoreLiteral> toCoreReason(Conjunction<CAATLiteral> baseReason) {

        RelationRepository repo = memoryModel.getRelationRepository();
        EventDomain domain = executionGraph.getDomain();

        List<CoreLiteral> coreReason = new ArrayList<>(baseReason.getSize());
        for (CAATLiteral lit : baseReason.getLiterals()) {
            if (lit instanceof ElementLiteral) {
                Event e = domain.getObjectById(((ElementLiteral) lit).getElement().getId()).getEvent();
                coreReason.add(new TagLiteral(lit.getName(), e, lit.isNegative()));
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

        return new Conjunction<>(coreReason);
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


    // ===================== Classes ======================

    public static class Result {
        private CAATSolver.Status status;
        private DNF<CoreLiteral> coreReasons;
        private Statistics stats;

        public CAATSolver.Status getStatus() { return status; }
        public DNF<CoreLiteral> getCoreReasons() { return coreReasons; }
        public Statistics getStatistics() { return stats; }

        Result() {
            status = CAATSolver.Status.INCONCLUSIVE;
            coreReasons = DNF.FALSE();
        }

        static Result fromCAATResult(CAATSolver.Result caatResult) {
            Result result = new Result();
            result.status = caatResult.getStatus();
            result.stats = new Statistics();
            result.stats.caatStats = caatResult.getStatistics();

            return result;
        }

        @Override
        public String toString() {
            return status + "\n" +
                    coreReasons + "\n" +
                    stats;
        }
    }

    public static class Statistics {
        CAATSolver.Statistics caatStats;
        long modelExtractionTime;
        int modelSize;

        public long getModelExtractionTime() { return modelExtractionTime; }
        public long getPopulationTime() { return caatStats.getPopulationTime(); }
        public long getReasonComputationTime() { return caatStats.getReasonComputationTime(); }
        public long getConsistencyCheckTime() { return caatStats.getConsistencyCheckTime(); }
        public int getModelSize() { return modelSize; }
        public int getNumComputedReasons() { return caatStats.getNumComputedReasons(); }
        public int getNumComputedReducedReasons() { return caatStats.getNumComputedReducedReasons(); }

        public String toString() {
            StringBuilder str = new StringBuilder();
            str.append("Model extraction time(ms): ").append(getModelExtractionTime()).append("\n");
            str.append("Population time(ms): ").append(getPopulationTime()).append("\n");
            str.append("Consistency check time(ms): ").append(getConsistencyCheckTime()).append("\n");
            str.append("Reason computation time(ms): ").append(getReasonComputationTime()).append("\n");
            str.append("Model size (#events): ").append(getModelSize()).append("\n");
            str.append("#Computed reasons: ").append(getNumComputedReasons()).append("\n");
            str.append("#Computed reduced reasons: ").append(getNumComputedReducedReasons()).append("\n");
            return str.toString();
        }
    }

}
