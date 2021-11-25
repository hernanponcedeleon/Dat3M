package com.dat3m.dartagnan.solver.caatBridge;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.solver.caat.CAATSolver;
import com.dat3m.dartagnan.solver.caat.graphs.ExecutionGraph;
import com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.stat.FenceGraph;
import com.dat3m.dartagnan.solver.caat.reasoning.CAATLiteral;
import com.dat3m.dartagnan.solver.caat.reasoning.EdgeLiteral;
import com.dat3m.dartagnan.utils.equivalence.BranchEquivalence;
import com.dat3m.dartagnan.utils.logic.Conjunction;
import com.dat3m.dartagnan.utils.logic.DNF;
import com.dat3m.dartagnan.verification.VerificationTask;
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
    This is our domain-specific bridge-ing component that specializes the CAATSolver to the BMC setting.

    TODO: The CAAT-Solver is partially specialized already to take an ExecutionModel as input.
     In general, however, this class should convert a model into some representation understandable
     by the CAAT-Solver
*/
public class BMCSolver {

    private final VerificationTask task;
    private final CAATSolver solver;
    private final Wmm memoryModel;
    private final BranchEquivalence eq;


    public BMCSolver(VerificationTask task) {
        this.task = task;
        this.memoryModel = task.getMemoryModel();
        this.eq = task.getBranchEquivalence();
        this.solver = new CAATSolver(task, true);

        memoryModel.performRelationalAnalysis(false);
    }


    public Result check(Model model, SolverContext ctx) {
        CAATSolver.Result caatResult = solver.check(model, ctx);
        Result result = Result.fromCAATResult(caatResult);

        if (result.getStatus() == CAATSolver.Status.INCONSISTENT) {
            List<Conjunction<CoreLiteral>> coreReasons = new ArrayList<>(caatResult.getBaseReasons().getNumberOfCubes());
            for (Conjunction<CAATLiteral> baseReason : caatResult.getBaseReasons().getCubes()) {
                coreReasons.add(toCoreReason(baseReason));
            }

            result.coreReasons = new DNF<>(coreReasons);
        }

        return result;
    }

    public ExecutionModel getCurrentModel() {
        return solver.getCurrentModel();
    }

    public ExecutionGraph getExecutionGraph() {
        return solver.getExecutionGraph();
    }


    private Conjunction<CoreLiteral> toCoreReason(Conjunction<CAATLiteral> baseReason) {

        RelationRepository repo = memoryModel.getRelationRepository();

        List<CoreLiteral> coreReason = new ArrayList<>(baseReason.getSize());
        for (CAATLiteral lit : baseReason.getLiterals()) {
            if (!(lit instanceof EdgeLiteral)) {
                // We assume to only have EdgeLiterals for now
                continue;
            }

            EdgeLiteral edgeLit = (EdgeLiteral)lit;
            Edge edge = edgeLit.getEdge();
            Tuple tuple = edge.toTuple();
            Relation rel = repo.getRelation(lit.getName());

            if (lit.isPositive() && rel.getMinTupleSet().contains(tuple)) {
                // Statically present edges
                addExecReason(tuple, coreReason);
            } else if (lit.isNegative() && !rel.getMaxTupleSet().contains(tuple)) {
                // Statically absent edges
            } else {
                //TODO: Fix problems with negation
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
            coreReasons.add(new EventLiteral(e1));
            coreReasons.add(new EventLiteral(e2));
        } else if (eq.isImplied(e1, e2)) {
            coreReasons.add(new EventLiteral(e1));
        } else if (eq.isImplied(e2, e1)) {
            coreReasons.add(new EventLiteral(e2));
        } else {
            coreReasons.add(new EventLiteral(e1));
            coreReasons.add(new EventLiteral(e2));
        }
    }

    private void addFenceReason(Relation rel, Edge edge, List<CoreLiteral> coreReasons) {
        FenceGraph fenceGraph = (FenceGraph) solver.getExecutionGraph().getRelationGraph(rel);
        Event f = fenceGraph.getNextFence(edge.getFirst()).getEvent();
        Event e1 = edge.getFirst().getEvent();
        Event e2 = edge.getSecond().getEvent();

        coreReasons.add(new EventLiteral(f));
        if (!eq.isImplied(f, e1)) {
            coreReasons.add(new EventLiteral(e1));
        }
        if (!eq.isImplied(f, e2)) {
            coreReasons.add(new EventLiteral(e2));
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

        public long getModelConstructionTime() { return caatStats.getModelConstructionTime(); }
        public long getReasonComputationTime() { return caatStats.getReasonComputationTime(); }
        public long getConsistencyCheckTime() { return caatStats.getConsistencyCheckTime(); }
        public int getModelSize() { return caatStats.getModelSize(); }
        public int getNumComputedReasons() { return caatStats.getNumComputedReasons(); }
        public int getNumComputedReducedReasons() { return caatStats.getNumComputedReducedReasons(); }

        public String toString() {
            StringBuilder str = new StringBuilder();
            str.append("Model construction time(ms): ").append(getModelConstructionTime()).append("\n");
            str.append("Consistency check time(ms): ").append(getConsistencyCheckTime()).append("\n");
            str.append("Reason computation time(ms): ").append(getReasonComputationTime()).append("\n");
            str.append("Model size (#events): ").append(getModelSize()).append("\n");
            str.append("#Computed reasons: ").append(getNumComputedReasons()).append("\n");
            str.append("#Computed reduced reasons: ").append(getNumComputedReducedReasons()).append("\n");

            return str.toString();
        }
    }

}
