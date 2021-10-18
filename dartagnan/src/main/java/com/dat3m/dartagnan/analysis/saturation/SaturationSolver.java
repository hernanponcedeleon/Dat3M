package com.dat3m.dartagnan.analysis.saturation;

import com.dat3m.dartagnan.analysis.saturation.graphs.ExecutionGraph;
import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.Edge;
import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.RelationGraph;
import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.constraints.Constraint;
import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.unary.RecursiveGraph;
import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.utils.PathAlgorithm;
import com.dat3m.dartagnan.analysis.saturation.logic.Conjunction;
import com.dat3m.dartagnan.analysis.saturation.logic.DNF;
import com.dat3m.dartagnan.analysis.saturation.reasoning.CoreLiteral;
import com.dat3m.dartagnan.analysis.saturation.reasoning.Reasoner;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.verification.model.ExecutionModel;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import org.sosy_lab.java_smt.api.Model;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static com.dat3m.dartagnan.GlobalSettings.SATURATION_ENABLE_DEBUG;
import static com.dat3m.dartagnan.analysis.saturation.SolverStatus.CONSISTENT;
import static com.dat3m.dartagnan.analysis.saturation.SolverStatus.INCONSISTENT;

public class SaturationSolver {

    // ================== Fields ==================

    // --------------- Static data ----------------
    private final VerificationTask task;
    private final ExecutionGraph execGraph;
    private final Reasoner reasoner;
    private final boolean useModelCoherences;

    // ----------- Iteration-specific data -----------
    //TODO: We might want to take an external executionModel to perform refinement on!
    private final ExecutionModel executionModel;
    private SolverStatistics stats;  // Statistics of the last call to kSearch

    // ============================================

    // =============== Accessors =================

    public VerificationTask getTask() {
        return task;
    }

    // NOTE: The execution graph should not be modified from the outside!
    public ExecutionGraph getExecutionGraph() { return execGraph; }

    public ExecutionModel getCurrentModel() {
        return executionModel;
    }


    // =============================================

    // =========== Construction & Init ==============

    public SaturationSolver(VerificationTask task, boolean useModelCoherences) {
        this.task = task;
        this.execGraph = new ExecutionGraph(task, true);
        this.executionModel = new ExecutionModel(task);
        this.reasoner = new Reasoner(execGraph, true);
        this.useModelCoherences = useModelCoherences;

        // We trigger a relational analysis (without active sets)
        // because we use this information in reason-computations
        task.getMemoryModel().performRelationalAnalysis(false);
    }

    // ----------------------------------------------

    private void populateFromModel(Model model, SolverContext ctx) {
        executionModel.initialize(model, ctx, useModelCoherences);
        execGraph.initializeFromModel(executionModel);
        PathAlgorithm.ensureCapacity(executionModel.getEventList().size());

        if (SATURATION_ENABLE_DEBUG) {
            testIteration();
            testGraphsContent();
        }
    }

    // ====================================================

    // ==============  Core functionality  =================

    public SolverResult check(Model model, SolverContext ctx) {
        return checkModel(model, ctx); // We only have one checking algorithm for now
    }

    /*
        This method checks a given model for consistency.
        The model may or may not contain coherences.
        If it does not contain coherences, the coherence-less model
        is checked as is and it may be considered consistent even though it has
        no possible coherence extensions (this could be useful for partial checking)
     */
    private SolverResult checkModel(Model model, SolverContext ctx) {
        SolverResult result = new SolverResult();
        stats = new SolverStatistics();
        result.setStats(stats);

        // ====== Populate from model ======
        long curTime = System.currentTimeMillis();
        populateFromModel(model, ctx);
        stats.modelConstructionTime = System.currentTimeMillis() - curTime;
        stats.modelSize = executionModel.getEventList().size();
        // =================================

        curTime = System.currentTimeMillis();
        SolverStatus status = execGraph.checkInconsistency() ? INCONSISTENT : CONSISTENT;
        stats.consistencyCheckTime = System.currentTimeMillis() - curTime;
        result.setStatus(status);
        if (status == INCONSISTENT) {
            curTime = System.currentTimeMillis();
            result.setCoreReasons(computeInconsistencyReasons());
            stats.reasonComputationTime += (System.currentTimeMillis() - curTime);
        }

        return result;
    }

    // ============= Violations + Resolution ================

    // Computes the inconsistency reasons (if any) of the current ExecutionGraph
    private DNF<CoreLiteral> computeInconsistencyReasons() {
        List<Conjunction<CoreLiteral>> reasons = new ArrayList<>();
        for (Constraint constraint : execGraph.getConstraints()) {
            reasons.addAll(reasoner.computeViolationReasons(constraint).getCubes());
        }
        stats.numComputedReasons += reasons.size();
        DNF<CoreLiteral> result = new DNF<>(reasons); // The conversion to DNF removes duplicates and dominated clauses
        stats.numComputedReducedReasons += result.getNumberOfCubes();

        return result;
    }


    // ====================================================

    // ===================== TESTING ======================

    /*
        The following methods check simple properties such as:
            - Iteration of edges in graphs works correctly (not trivial for virtual graphs)
            - Min-Sets of Relations are present in the corresponding RelationGraph
     */

    private void testIteration() {
        for (RelationGraph g : execGraph.getRelationGraphs()) {
            int size = g.size();
            for (Edge e : g) {
                size--;
                if (size < 0) {
                    throw new IllegalStateException(String.format(
                            "The size of relation graph %s is less than the number of edges returned by iteration.", g));
                }
                if (!g.contains(e)) {
                    throw new IllegalStateException(String.format(
                            "Iteration of relation graph %s returned an edge %s but <contains> returns false", g, e));
                }
            }
            if (size > 0) {
                throw new IllegalStateException(String.format(
                        "The size of relation graph %s is greater than the number of edges returned by iteration.", g));
            }

            if (g.edgeStream().count() != g.size()) {
                throw new IllegalStateException(String.format(
                        "The size of relation graph %s mismatches the number of streamed edges.", g));
            }
        }
    }

    //WARNING: This code will only run correctly if the relational analysis of the WMM has been performed
    // and min/max-sets have been computed.
    private void testGraphsContent() {
        for (Relation rel : task.getRelationDependencyGraph().getNodeContents()) {
            RelationGraph g = execGraph.getRelationGraph(rel);
            if (g == null || g instanceof RecursiveGraph) {
                continue;
            }
            for (Tuple t : rel.getMinTupleSet()) {
                Optional<EventData> e1 = executionModel.getData(t.getFirst());
                Optional<EventData> e2 = executionModel.getData(t.getSecond());
                if (e1.isPresent() && e2.isPresent() && !g.contains(new Edge(e1.get(), e2.get()))) {
                    throw new IllegalStateException(String.format(
                            "Static min tuple %s%s is not present in the corresponding relation graph %s.",
                            rel.getName(), t, g.getName()));
                }
            }
            for (Edge e : g) {
                if (!rel.getMaxTupleSet().contains(e.toTuple())) {
                    throw new IllegalStateException(String.format(
                            "Edge %s of relation graph %s is not present in the corresponding relations %s max set.",
                            e, g.getName(), rel.getName()));
                }
            }
        }
    }

    // ====================================================

}
