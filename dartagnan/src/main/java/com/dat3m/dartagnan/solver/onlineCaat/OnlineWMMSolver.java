package com.dat3m.dartagnan.solver.onlineCaat;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.solver.caat.CAATSolver;
import com.dat3m.dartagnan.solver.caat.domain.DenseIdBiMap;
import com.dat3m.dartagnan.solver.caat.domain.Domain;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.base.SimpleGraph;
import com.dat3m.dartagnan.solver.caat.reasoning.CAATLiteral;
import com.dat3m.dartagnan.solver.caat4wmm.ExecutionGraph;
import com.dat3m.dartagnan.solver.caat4wmm.coreReasoning.CoreLiteral;
import com.dat3m.dartagnan.solver.caat4wmm.coreReasoning.CoreReasoner;
import com.dat3m.dartagnan.utils.logic.Conjunction;
import com.dat3m.dartagnan.utils.logic.DNF;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;

import java.util.*;

public class OnlineWMMSolver {

    private final ExecutionGraph executionGraph;
    private final CAATSolver solver;
    private final EncodingContext encodingContext;
    private final CoreReasoner reasoner;
    private final Decoder decoder;
    private final Refiner refiner;
    private final BooleanFormulaManager bmgr;

    public OnlineWMMSolver(VerificationTask task, EncodingContext encCtx, Context analysisContext, Set<Relation> cutRelations) {
        analysisContext.requires(RelationAnalysis.class);
        this.executionGraph = new ExecutionGraph(task, analysisContext, cutRelations, true);
        this.reasoner = new CoreReasoner(task, analysisContext, executionGraph);
        this.solver = CAATSolver.create();
        this.decoder = new Decoder(encCtx);
        this.encodingContext = encCtx;
        this.refiner = new Refiner();

        this.bmgr = encCtx.getFormulaManager().getBooleanFormulaManager();
    }

    // ----------------------------------------------------------------------------------------------------
    // Setup

    // ------------------------------------------------------------------------------------------------------
    // Online features


    private final Deque<Integer> backtrackPoints = new ArrayDeque<>();
    private final Deque<BooleanFormula> knownValues = new ArrayDeque<>();
    private final Map<BooleanFormula, Boolean> partialModel = new HashMap<>();

    protected void onPush() {
        backtrackPoints.push(knownValues.size());
    }

    protected void onPop(int numLevels) {
        while (numLevels > 0) {
            backtrackPoints.pop();
            numLevels--;
        }
        assert !backtrackPoints.isEmpty();

        final int backtrackTo = backtrackPoints.peek();
        while (knownValues.size() > backtrackTo) {
            partialModel.remove(knownValues.pop());
        }
    }

    protected void onKnownValue(BooleanFormula expr, BooleanFormula value) {
        knownValues.add(expr);
        partialModel.put(expr, bmgr.isTrue(value));
    }

    protected void onFinalCheck() {
        initModel();
        Result result = check();

        if (result.status == CAATSolver.Status.INCONSISTENT) {
            final List<Refiner.Conflict> conflicts = refiner.computeConflicts(result.coreReasons, encodingContext);
            for (Refiner.Conflict conflict : conflicts) {
                assert conflict.assignment().stream().allMatch(partialModel::containsKey);
                //backend.propagateConflict(conflict.toArray(new BooleanFormula[0]));
            }
        }
    }

    private void initModel() {
        List<Event> executedEvents = new ArrayList<>();
        List<RelationInfo> relationInfos = new ArrayList<>();
        for (BooleanFormula assigned : knownValues) {
            if (!partialModel.get(assigned)) {
                continue;
            }

            EncodingInfo info = decoder.decode(assigned);
            if (info instanceof ExecInfo eventInfo) {
                executedEvents.addAll(eventInfo.events());
            } else if (info instanceof RelationInfo relInfo) {
                relationInfos.add(relInfo);
            }
        }

        // Init domain
        executedEvents.removeIf(e -> !e.hasTag(Tag.VISIBLE));
        executedEvents.sort(Comparator.comparingInt(Event::getGlobalId));
        final EventDomain domain = new EventDomain();
        executedEvents.forEach(domain.eventMap::addObject);

        // Setup base relation graphs
        for (RelationInfo relInfo : relationInfos) {
            for (EdgeInfo edge : relInfo.edges()) {
                final SimpleGraph graph = (SimpleGraph) executionGraph.getRelationGraph(edge.relation());
                graph.add(new Edge(domain.getId(edge.source()), domain.getId(edge.target())));
            }
        }

        // Initialize CAATModel + populate all graphs
        executionGraph.getCAATModel().initializeToDomain(domain);
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

    private static class EventDomain implements Domain<Event> {

        final DenseIdBiMap<Event> eventMap = DenseIdBiMap.createHashBased(100);

        @Override
        public int size() { return eventMap.size(); }

        @Override
        public Collection<Event> getElements() { return eventMap.getKeys(); }

        @Override
        public int getId(Object obj) { return eventMap.getId(obj); }

        @Override
        public Event getObjectById(int id) { return eventMap.getObject(id); }
    }

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
