package com.dat3m.dartagnan.solver.onlineCaat;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.solver.caat.CAATSolver;
import com.dat3m.dartagnan.solver.caat.domain.GenericDomain;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.base.SimpleGraph;
import com.dat3m.dartagnan.solver.caat.reasoning.CAATLiteral;
import com.dat3m.dartagnan.solver.caat4wmm.RefinementModel;
import com.dat3m.dartagnan.solver.caat4wmm.coreReasoning.CoreLiteral;
import com.dat3m.dartagnan.utils.logic.Conjunction;
import com.dat3m.dartagnan.utils.logic.DNF;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.basicimpl.AbstractUserPropagator;

import java.util.*;

public class OnlineWMMSolver extends AbstractUserPropagator {

    private final ExecutionGraph executionGraph;
    private final CAATSolver solver;
    private final EncodingContext encodingContext;
    private final CoreReasoner reasoner;
    private final Decoder decoder;
    private final Refiner refiner;
    private final BooleanFormulaManager bmgr;
    private final RefinementModel refinementModel;

    //private final Map<Relation, Relation> encodedRelation2OriginalRelationMap = Maps.newIdentityHashMap();

    public OnlineWMMSolver(VerificationTask task, EncodingContext encCtx, Context analysisContext,
                           RefinementModel refinementModel) {
        analysisContext.requires(RelationAnalysis.class);
        this.executionGraph = new ExecutionGraph(task, analysisContext, refinementModel, true);
        this.reasoner = new CoreReasoner(task, analysisContext, executionGraph);
        this.solver = CAATSolver.create();
        this.decoder = new Decoder(encCtx, refinementModel);
        this.encodingContext = encCtx;
        this.refiner = new Refiner();
        this.bmgr = encCtx.getFormulaManager().getBooleanFormulaManager();
        this.refinementModel = refinementModel;
    }

    // ------------------------------------------------------------------------------------------------------
    // Online features

    private final Deque<Integer> backtrackPoints = new ArrayDeque<>();
    private final Deque<BooleanFormula> knownValues = new ArrayDeque<>();
    private final Map<BooleanFormula, Boolean> partialModel = new HashMap<>();
    private final Set<BooleanFormula> trueValues = new HashSet<>();

    @Override
    public void initialize() {
        backend.notifyOnKnownValue();
        backend.notifyOnFinalCheck();

        for (BooleanFormula formula : decoder.getDecodableFormulas()) {
            backend.registerExpression(formula);
        }
    }

    @Override
    public void onPush() {
        backtrackPoints.push(knownValues.size());
        //System.out.println("Pushed: " + backtrackPoints.size());
    }

    @Override
    public void onPop(int numLevels) {
        int backtrackTo = 0;
        while (numLevels > 0) {
            backtrackTo = backtrackPoints.pop();
            numLevels--;
        }

        while (knownValues.size() > backtrackTo) {
            final BooleanFormula revertedAssignment = knownValues.pop();
            if (partialModel.remove(revertedAssignment)) {
                trueValues.remove(revertedAssignment);
            }
        }

        //System.out.printf("Backtracked %d levels to level %d\n", popLevels, backtrackPoints.size());
    }

    @Override
    public void onKnownValue(BooleanFormula expr, boolean value) {
        knownValues.push(expr);
        partialModel.put(expr, value);
        if (value) {
            trueValues.add(expr);
        }

        progressPropagation();
    }

    private final Queue<Refiner.Conflict> openPropagations = new ArrayDeque<>();

    private void progressPropagation() {
        if (!openPropagations.isEmpty()) {
            backend.propagateConsequence(new BooleanFormula[0],
                    bmgr.not(bmgr.and(openPropagations.poll().assignment().toArray(new BooleanFormula[0]))));
        }
    }

    // --- Some statistics ---
    private long totalModelExtractionTime = 0;
    private int checkCounter = 0;

    @Override
    public void onFinalCheck() {
        Result result = check();
        checkCounter++;
        totalModelExtractionTime += result.stats.modelExtractionTime;

        if (result.status == CAATSolver.Status.INCONSISTENT) {
            final List<Refiner.Conflict> conflicts = refiner.computeConflicts(result.coreReasons, encodingContext);
            boolean isFirst = true;
            for (Refiner.Conflict conflict : conflicts) {
                // The second part of the check is for symmetric clauses that are not yet conflicts.
                final boolean isConflict = isFirst &&
                        conflict.assignment().stream().allMatch(l -> partialModel.getOrDefault(l, false));
                if (isConflict) {
                    backend.propagateConflict(conflict.assignment().toArray(new BooleanFormula[0]));
                    isFirst = false;
                } else {
                   openPropagations.add(conflict);
                }
            }
            assert !isFirst;
        }

        StringBuilder builder = new StringBuilder()
                .append("Model extraction: ").append(result.stats.modelExtractionTime).append("\n")
                .append("Population time: ").append(result.stats.caatStats.getPopulationTime()).append("\n")
                .append("Total Model extraction: ").append(totalModelExtractionTime).append("\n");

        System.out.printf("------------ Check #%d ------------ \n%s", checkCounter, builder);
        System.out.println("------------------------------------");
    }

    private void initModel() {
        List<Event> executedEvents = new ArrayList<>();
        List<EdgeInfo> edges = new ArrayList<>();
        for (BooleanFormula assigned : trueValues) {
            Decoder.Info info = decoder.decode(assigned);
            executedEvents.addAll(info.events());
            edges.addAll(info.edges());
        }

        // Init domain
        executedEvents.removeIf(e -> !e.hasTag(Tag.VISIBLE));
        GenericDomain<Event> domain = new GenericDomain<>(executedEvents);
        executionGraph.getCAATModel().initializeToDomain(domain);

        // Setup base relation graphs
        for (EdgeInfo edge : edges) {
            final Relation relInFullModel = refinementModel.translateToOriginal(edge.relation());
            final SimpleGraph graph = (SimpleGraph) executionGraph.getRelationGraph(relInFullModel);
            if (graph != null) {
                graph.add(new Edge(domain.getId(edge.source()), domain.getId(edge.target())));
            }
        }
    }

    private Result check() {
        // ============ Extract CAAT base model ==============
        long curTime = System.currentTimeMillis();
        initModel();
        long extractTime = System.currentTimeMillis() - curTime;

        // ============== Run the CAATSolver ==============
        CAATSolver.Result caatResult = solver.check(executionGraph.getCAATModel());
        Result result = Result.fromCAATResult(caatResult);
        Statistics stats = result.stats;
        stats.modelExtractionTime = extractTime;
        stats.modelSize = executionGraph.getDomain().size();

        if (result.getStatus() == CAATSolver.Status.INCONSISTENT) {
            // ============== Compute Core reasons ==============
            curTime = System.currentTimeMillis();
            List<Conjunction<CoreLiteral>> coreReasons = new ArrayList<>(caatResult.getBaseReasons().getNumberOfCubes());
            for (Conjunction<CAATLiteral> baseReason : caatResult.getBaseReasons().getCubes()) {
                coreReasons.addAll(reasoner.toCoreReasons(baseReason));
            }
            stats.numComputedCoreReasons = coreReasons.size();
            result.coreReasons = new DNF<>(coreReasons);
            stats.numComputedReducedCoreReasons = result.coreReasons.getNumberOfCubes();
            stats.coreReasonComputationTime = System.currentTimeMillis() - curTime;
        }

        return result;
    }

    // ------------------------------------------------------------------------------------------------------
    // Classes

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
        long coreReasonComputationTime;
        int modelSize;
        int numComputedCoreReasons;
        int numComputedReducedCoreReasons;

        public long getModelExtractionTime() { return modelExtractionTime; }
        public long getPopulationTime() { return caatStats.getPopulationTime(); }
        public long getBaseReasonComputationTime() { return caatStats.getReasonComputationTime(); }
        public long getCoreReasonComputationTime() { return coreReasonComputationTime; }
        public long getConsistencyCheckTime() { return caatStats.getConsistencyCheckTime(); }
        public int getModelSize() { return modelSize; }
        public int getNumComputedBaseReasons() { return caatStats.getNumComputedReasons(); }
        public int getNumComputedReducedBaseReasons() { return caatStats.getNumComputedReducedReasons(); }
        public int getNumComputedCoreReasons() { return numComputedCoreReasons; }
        public int getNumComputedReducedCoreReasons() { return numComputedReducedCoreReasons; }

        public String toString() {
            StringBuilder str = new StringBuilder();
            str.append("Model extraction time(ms): ").append(getModelExtractionTime()).append("\n");
            str.append("Population time(ms): ").append(getPopulationTime()).append("\n");
            str.append("Consistency check time(ms): ").append(getConsistencyCheckTime()).append("\n");
            str.append("Base Reason computation time(ms): ").append(getBaseReasonComputationTime()).append("\n");
            str.append("Core Reason computation time(ms): ").append(getCoreReasonComputationTime()).append("\n");
            str.append("Model size (#events): ").append(getModelSize()).append("\n");
            str.append("#Computed reasons (base/core): ").append(getNumComputedBaseReasons())
                    .append("/").append(getNumComputedCoreReasons()).append("\n");
            str.append("#Computed reduced reasons (base/core): ").append(getNumComputedReducedBaseReasons())
                    .append("/").append(getNumComputedReducedCoreReasons()).append("\n");
            return str.toString();
        }
    }


}
