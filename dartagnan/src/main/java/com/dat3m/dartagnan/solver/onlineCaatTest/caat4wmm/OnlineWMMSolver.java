package com.dat3m.dartagnan.solver.onlineCaatTest.caat4wmm;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.solver.onlineCaatTest.Decoder;
import com.dat3m.dartagnan.solver.onlineCaatTest.EdgeInfo;
import com.dat3m.dartagnan.solver.onlineCaatTest.PendingEdgeInfo;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.CAATModel;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.CAATSolver;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.domain.Domain;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.domain.GenericDomain;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.PredicateHierarchy;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.relationGraphs.RelationGraph;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.relationGraphs.base.SimpleGraph;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.reasoning.CAATLiteral;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat4wmm.ExecutionGraph;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat4wmm.RefinementModel;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat4wmm.Refiner;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat4wmm.coreReasoning.CoreLiteral;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat4wmm.coreReasoning.CoreReasoner;
import com.dat3m.dartagnan.utils.logic.Conjunction;
import com.dat3m.dartagnan.utils.logic.DNF;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.google.common.collect.BiMap;
import io.github.cvc5.Stat;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.PropagatorBackend;
import org.sosy_lab.java_smt.basicimpl.AbstractUserPropagator;

import java.util.*;
import java.util.stream.Collectors;


public class OnlineWMMSolver extends AbstractUserPropagator {

    private final ExecutionGraph executionGraph;
    private final CAATSolver solver;
    private final EncodingContext encodingContext;
    private final CoreReasoner reasoner;
    private final Decoder decoder;
    private final Refiner refiner;
    private final BooleanFormulaManager bmgr;
    private final RefinementModel refinementModel;

    // used for (semi-) offline solving
    /*private final ExecutionGraph offlineExecutionGraph;
    private final CoreReasoner offlineReasoner;
    private final CAATSolver offlineSolver;*/

    public OnlineWMMSolver(RefinementModel refinementModel, Context analysisContext, EncodingContext encCtx) {
        this.refinementModel = refinementModel;
        this.encodingContext = encCtx;
        this.executionGraph = new ExecutionGraph(refinementModel);
        this.reasoner = new CoreReasoner(analysisContext, executionGraph);
        this.decoder = new Decoder(encCtx, refinementModel);
        this.refiner = new Refiner(refinementModel);
        this.solver = CAATSolver.create();
        this.bmgr = encCtx.getFormulaManager().getBooleanFormulaManager();

        executionGraph.initializeToDomain(domain);

        // used for (semi-) offline solving
        /*this.offlineExecutionGraph = new ExecutionGraph(refinementModel);
        this.offlineReasoner = new CoreReasoner(analysisContext, offlineExecutionGraph);
        this.offlineSolver = CAATSolver.create();*/
    }

    //-------------------------------------------------------------------------------------------------------
    // Statistics
    private final Statistics totalStats = new Statistics();
    private final Statistics curStats = new Statistics();

    public Statistics getTotalStats() {
        return totalStats;
    }

    // ------------------------------------------------------------------------------------------------------
    // Online features

    private final Deque<Integer> backtrackPoints = new ArrayDeque<>();
    private final Deque<BooleanFormula> knownValues = new ArrayDeque<>();
    private final Map<BooleanFormula, Boolean> partialModel = new HashMap<>();
    private final Set<BooleanFormula> trueValues = new HashSet<>();
    private final GenericDomain<Event> domain = new GenericDomain<>();



    @Override
    public void initializeWithBackend(PropagatorBackend backend) {
        super.initializeWithBackend(backend);
        getBackend().notifyOnKnownValue();
        getBackend().notifyOnFinalCheck();

        for (BooleanFormula formula : decoder.getDecodableFormulas()) {
            getBackend().registerExpression(formula);
        }
    }

    @Override
    public void onPush() {
        backtrackPoints.push(knownValues.size());
        domain.push();
        long curTime = System.currentTimeMillis();
        executionGraph.getCAATModel().getHierarchy().onPush();
        curStats.modelExtractionTime += System.currentTimeMillis() - curTime;
        //System.out.println("PUSH " + backtrackPoints.size());

        onlineCheck();
    }

    @Override
    public void onPop(int numLevels) {
        long curTime = System.currentTimeMillis();
        int oldDomainSize = domain.size();
        int oldTime = backtrackPoints.size();

        int backtrackTo = domain.resetElements(numLevels);
        if (backtrackTo < 0) {
            throw new RuntimeException("Cannot backtrack to negative time");
        }

        curStats.numBacktracks++;

        int popLevels = numLevels;
        int backtrackKnownValuesTo = knownValues.size();
        while (popLevels > 0) {
            popLevels--;
            backtrackKnownValuesTo = backtrackPoints.pop();
        }

        executionGraph.backtrackTo(backtrackPoints.size());
        backtrackEdgesTo(backtrackPoints.size());

        //System.out.println("\nPOP to time " + backtrackPoints.size() + " (event in domain: " + backtrackTo + ") from " + oldTime + " (" + oldDomainSize + ")");

        while (knownValues.size() > backtrackKnownValuesTo) {
            final BooleanFormula revertedAssignment = knownValues.pop();
            if (partialModel.remove(revertedAssignment) != null) {
                trueValues.remove(revertedAssignment);
            }
        }

        curStats.backtrackTime += System.currentTimeMillis() - curTime;

        // Validate is a debug tool only
        //executionGraph.validate(backtrackPoints.size());

        //System.out.printf("Backtracked %d levels to level %d\n", popLevels, backtrackPoints.size());
    }

    @Override
    public void onKnownValue(BooleanFormula expr, boolean value) {
        long curTime = System.currentTimeMillis();
        knownValues.push(expr);
        partialModel.put(expr, value);
        progressEdges();
        if (value) {
            trueValues.add(expr);

            Decoder.Info info = decoder.decode(expr);

            //System.out.print("KNOW " + expr + ":" + knownValues.size() + "   ");

            for (Event event : info.events()) {
                if (event.hasTag(Tag.VISIBLE)) {
                    domain.addElement(event);
                }
            }

            for (EdgeInfo edge : info.edges()) {
                final Relation relInFullModel = refinementModel.translateToOriginal(edge.relation());
                final SimpleGraph graph = (SimpleGraph) executionGraph.getRelationGraph(relInFullModel);
                if (graph != null) {
                    int sourceId = domain.getId(edge.source());
                    int targetId = domain.getId(edge.target());
                    if (sourceId < 0 || targetId < 0) {
                        pendingEdges.add(new PendingEdgeInfo(edge.relation(), edge.source(), edge.target(), backtrackPoints.size(), -1));
                    } else {
                        Edge e = new Edge(sourceId, targetId).withTime(backtrackPoints.size());
                        executionGraph.getCAATModel().getHierarchy().addAndPropagate(graph, Collections.singleton(e));
                    }
                }
            }
        }

        curStats.modelExtractionTime += System.currentTimeMillis() - curTime;
        curTime = System.currentTimeMillis();
        progressPropagation();
        curStats.refinementTime += System.currentTimeMillis() - curTime;
    }


    // Two-staged memory for pending edges
    // (no stage: edge is no longer in proposal for use, it is not relevant)
    // First stage: edge is not (yet) in use (inactive)
    // Second stage: edge is currently in use (active)

    private List<PendingEdgeInfo> pendingEdges = new ArrayList<>();
    private List<PendingEdgeInfo> usedEdges = new ArrayList<>();

    private void backtrackEdgesTo(int time) {
        List<PendingEdgeInfo> notUsedAnymore = usedEdges.stream().filter(info -> info.addTime() > time)
                .collect(Collectors.toList());
        usedEdges.removeAll(notUsedAnymore);
        pendingEdges.addAll(notUsedAnymore);
        pendingEdges = pendingEdges.stream().filter(info -> info.deleteTime() <= time).collect(Collectors.toList());
    }

    private final Queue<Refiner.Conflict> openPropagations = new ArrayDeque<>();

    private void progressEdges() {
        List<PendingEdgeInfo> done = new ArrayList<>();
        for (PendingEdgeInfo edge : pendingEdges) {
            int sourceId = domain.getId(edge.source());
            int targetId = domain.getId(edge.target());
            if (sourceId >= 0 && targetId >= 0) {
                final Relation relInFullModel = refinementModel.translateToOriginal(edge.relation());
                final SimpleGraph graph = (SimpleGraph) executionGraph.getRelationGraph(relInFullModel);
                if (graph != null) {
                    Edge e = new Edge(sourceId, targetId).withTime(backtrackPoints.size());
                    executionGraph.getCAATModel().getHierarchy().addAndPropagate(graph, Collections.singleton(e));

                    done.add(edge);
                    PendingEdgeInfo usedEdge = new PendingEdgeInfo(edge.relation(), edge.source(), edge.target(), edge.deleteTime(), backtrackPoints.size());
                    usedEdges.add(usedEdge);
                }
            }
        }
        pendingEdges.removeAll(done);
    }
    private void progressPropagation() {
        if (!openPropagations.isEmpty()) {
            getBackend().propagateConsequence(new BooleanFormula[0], bmgr.not(openPropagations.poll().toFormula(bmgr)));
        }
    }

    private Result onlineCheck() {
        Result result = check();
        //Result offlineResult = checkOffline();
        curStats.numChecks++;
        curStats.consistencyTime += result.caatStats.getConsistencyCheckTime();
        curStats.reasoningTime += result.caatStats.getReasonComputationTime();

        if (result.status == CAATSolver.Status.INCONSISTENT) {
            long curTime = System.currentTimeMillis();
            final List<Refiner.Conflict> conflicts = refiner.computeConflicts(result.coreReasons, encodingContext);
            if (conflicts.isEmpty()) {
                int i = 5;
            }
            assert !conflicts.isEmpty();
            boolean isFirst = true;
            for (Refiner.Conflict conflict : conflicts) {
                // The second part of the check is for symmetric clauses that are not yet conflicts.
                final boolean isConflict = isFirst &&
                        conflict.getVariables().stream().allMatch(partialModel::containsKey);
                if (isConflict) {
                    getBackend().propagateConflict(conflict.getVariables().toArray(new BooleanFormula[0]));
                    isFirst = false;
                } else {
                    openPropagations.add(conflict);
                }
            }
            assert !isFirst;
            curStats.refinementTime += System.currentTimeMillis() - curTime;
        }

        // compares online graph to (semi-) offline graph
        /*
        if (offlineResult.status != result.status) {
            System.out.println("\nRESULT SHOULD BE " + offlineResult.status + " BUT IS " + result.status);
        }
        HashMap<Relation, List<Edge>> wrongEdges = new HashMap<>();
        HashMap<Relation, List<Edge>> missingEdges = new HashMap<>();

        BiMap<Relation, RelationGraph> offlineGraphs = offlineExecutionGraph.getRelationGraphMap();
        BiMap<Relation, RelationGraph> graphs = executionGraph.getRelationGraphMap();

        for (Map.Entry<Relation, RelationGraph> relationTuple : graphs.entrySet()) {
            List<Edge> wrong = relationTuple.getValue().edgeStream().filter(e -> offlineGraphs.get(relationTuple.getKey()).edgeStream().noneMatch(offlineE -> e.equals(offlineE))).collect(Collectors.toList());
            if (!wrong.isEmpty()) {
                wrongEdges.put(relationTuple.getKey(), wrong);
            }
        }

        for (Map.Entry<Relation, RelationGraph> relationTuple : offlineGraphs.entrySet()) {
            List<Edge> missing = relationTuple.getValue().edgeStream().filter(offlineE -> graphs.get(relationTuple.getKey()).edgeStream().noneMatch(e -> offlineE.equals(e))).collect(Collectors.toList());
            if (!missing.isEmpty()) {
                missingEdges.put(relationTuple.getKey(), missing);
            }
        }

        List<Map.Entry> nonEmpty = graphs.entrySet().stream().filter(tuple -> !tuple.getValue().isEmpty()).collect(Collectors.toList());

        if (!wrongEdges.isEmpty() || !missingEdges.isEmpty()) {
            int i = 5;
        }

        PredicateHierarchy offlinePredicateHierarchy = offlineExecutionGraph.getCAATModel().getHierarchy();
        List<CAATPredicate> offlinePredicates = offlinePredicateHierarchy.getPredicateList();
        PredicateHierarchy predicateHierarchy = executionGraph.getCAATModel().getHierarchy();
        List<CAATPredicate> predicates = predicateHierarchy.getPredicateList();
        */

        return result;
    }


    @Override
    public void onFinalCheck() {
        Result result = onlineCheck();

        totalStats.add(curStats);
        curStats.clear();

        if (result.status != CAATSolver.Status.INCONSISTENT) {
        }

    }

    // used for (semi-) offline solving only
    /*private void  initModel() {
        List<EdgeInfo> edges = new ArrayList<>();
        for (BooleanFormula assigned : trueValues) {
            Decoder.Info info = decoder.decode(assigned);
            edges.addAll(info.edges());
        }

        // Init domain
        offlineExecutionGraph.initializeToDomain(domain);

        // Setup base relation graphs
        for (EdgeInfo edge : edges) {
            final Relation relInFullModel = refinementModel.translateToOriginal(edge.relation());
            final SimpleGraph graph = (SimpleGraph) offlineExecutionGraph.getRelationGraph(relInFullModel);
            if (graph != null) {
                int sourceId = domain.getId(edge.source());
                int targetId = domain.getId(edge.target());
                int edgeTime = Math.max(sourceId, targetId);
                Edge e = (new Edge(sourceId, targetId)).withTime(edgeTime);
                graph.add(e);
            }
        }
    }*/

    private Result check() {
        // ============== Run the CAATSolver ==============
        CAATSolver.Result caatResult = solver.check(executionGraph.getCAATModel());
        Result result = Result.fromCAATResult(caatResult);

        if (result.getStatus() == CAATSolver.Status.INCONSISTENT) {
            System.out.println("===========");
            // ============== Compute Core reasons ==============
            long curTime = System.currentTimeMillis();
            List<Conjunction<CoreLiteral>> coreReasons = new ArrayList<>(caatResult.getBaseReasons().getNumberOfCubes());
            for (Conjunction<CAATLiteral> baseReason : caatResult.getBaseReasons().getCubes()) {
                coreReasons.addAll(reasoner.toCoreReasons(baseReason));
                System.out.println("WAS IN LOOP");
            }
            if (coreReasons.isEmpty()) {
                int i = 5;
            }
            curStats.numComputedCoreReasons = coreReasons.size();
            result.coreReasons = new DNF<>(coreReasons);
            curStats.numComputedReducedCoreReasons = result.coreReasons.getNumberOfCubes();
            curStats.coreReasonComputationTime += System.currentTimeMillis() - curTime;
        }

        return result;
    }
    // used for (semi-) offline solving only
    /*private Result checkOffline() {
        // ============ Extract CAAT base model ==============
        long curTime = System.currentTimeMillis();
        initModel();
        long extractTime = System.currentTimeMillis() - curTime;

        // ============== Run the CAATSolver ==============
        CAATSolver.Result caatResult = offlineSolver.check(offlineExecutionGraph.getCAATModel(), true);
        Result result = Result.fromCAATResult(caatResult);
        Statistics stats = result.stats;
        stats.modelExtractionTime = extractTime;
        stats.modelSize = offlineExecutionGraph.getDomain().size();

        if (result.getStatus() == CAATSolver.Status.INCONSISTENT) {
            // ============== Compute Core reasons ==============
            curTime = System.currentTimeMillis();
            List<Conjunction<CoreLiteral>> coreReasons = new ArrayList<>(caatResult.getBaseReasons().getNumberOfCubes());
            for (Conjunction<CAATLiteral> baseReason : caatResult.getBaseReasons().getCubes()) {
                coreReasons.addAll(offlineReasoner.toCoreReasons(baseReason));
            }
            stats.numComputedCoreReasons = coreReasons.size();
            result.coreReasons = new DNF<>(coreReasons);
            stats.numComputedReducedCoreReasons = result.coreReasons.getNumberOfCubes();
            stats.coreReasonComputationTime = System.currentTimeMillis() - curTime;
        }

        return result;
    }*/

    // ------------------------------------------------------------------------------------------------------
    // Classes

    public static class Result {
        private CAATSolver.Status status;
        private DNF<CoreLiteral> coreReasons;
        private CAATSolver.Statistics caatStats;

        public CAATSolver.Status getStatus() { return status; }
        public DNF<CoreLiteral> getCoreReasons() { return coreReasons; }
        public CAATSolver.Statistics getCaatStatistics() { return caatStats; }

        Result() {
            status = CAATSolver.Status.INCONCLUSIVE;
            coreReasons = DNF.FALSE();
        }

        static Result fromCAATResult(CAATSolver.Result caatResult) {
            Result result = new Result();
            result.status = caatResult.getStatus();
            result.caatStats =  caatResult.getStatistics();

            return result;
        }

        @Override
        public String toString() {
            return status + "\n" +
                    coreReasons + "\n" +
                    caatStats;
        }
    }

    public static class Statistics {
        long modelExtractionTime;
        long coreReasonComputationTime;
        long backtrackTime;
        long refinementTime;
        long consistencyTime;
        long reasoningTime;
        long populationTime;

        int numComputedCoreReasons;
        int numComputedBaseReasons;
        int numComputedReducedCoreReasons;
        int numComputedReducedBaseReasons;
        int numBacktracks;
        int numChecks;


        public long getModelExtractionTime() { return modelExtractionTime; }
        public long getPopulationTime() { return populationTime; }
        public long getBaseReasonComputationTime() { return reasoningTime; }
        public long getCoreReasonComputationTime() { return coreReasonComputationTime; }
        public long getConsistencyCheckTime() { return consistencyTime; }
        public long getRefinementTime() { return refinementTime; }
        public long getBacktrackTime() { return backtrackTime; }
        //public int getModelSize() { return modelSize; }
        public int getNumComputedBaseReasons() { return numComputedBaseReasons; }
        public int getNumComputedReducedBaseReasons() { return numComputedReducedBaseReasons; }
        public int getNumComputedCoreReasons() { return numComputedCoreReasons; }
        public int getNumComputedReducedCoreReasons() { return numComputedReducedCoreReasons; }
        public int getNumBacktracks() { return numBacktracks; }
        public int getNumChecks() { return numChecks; }

        public void clear() {
            modelExtractionTime = 0;
            coreReasonComputationTime = 0;
            backtrackTime = 0;
            refinementTime = 0;
            consistencyTime = 0;
            reasoningTime = 0;
            populationTime = 0;

            numComputedCoreReasons = 0;
            numComputedBaseReasons = 0;
            numComputedReducedCoreReasons = 0;
            numComputedReducedBaseReasons = 0;
            numBacktracks = 0;
            numChecks = 0;
        }

        public void add (Statistics stats) {
            modelExtractionTime += stats.modelExtractionTime;
            coreReasonComputationTime += stats.coreReasonComputationTime;
            backtrackTime += stats.backtrackTime;
            refinementTime += stats.refinementTime;
            consistencyTime += stats.consistencyTime;
            reasoningTime += stats.reasoningTime;
            populationTime += stats.populationTime;

            numComputedCoreReasons += stats.numComputedCoreReasons;
            numComputedBaseReasons += stats.numComputedBaseReasons;
            numComputedReducedCoreReasons += stats.numComputedReducedCoreReasons;
            numComputedReducedBaseReasons += stats.numComputedReducedBaseReasons;
            numBacktracks += stats.numBacktracks;
            numChecks += stats.numChecks;
        }

        public String toString() {
            StringBuilder str = new StringBuilder();
            str.append("Model extraction time(ms): ").append(getModelExtractionTime()).append("\n");
            str.append("Population time(ms): ").append(getPopulationTime()).append("\n");
            str.append("Consistency check time(ms): ").append(getConsistencyCheckTime()).append("\n");
            str.append("Base Reason computation time(ms): ").append(getBaseReasonComputationTime()).append("\n");
            str.append("Core Reason computation time(ms): ").append(getCoreReasonComputationTime()).append("\n");
            str.append("Refinement time(ms): ").append(getRefinementTime()).append("\n");
            str.append("Backtrack time(ms) (#Backtracks): ").append(getBacktrackTime()).append(" (").append(getNumBacktracks()).append(")\n");
            //str.append("Model size (#events): ").append(getModelSize()).append("\n");
            str.append("#Computed reasons (base/core): ").append(getNumComputedBaseReasons())
                    .append("/").append(getNumComputedCoreReasons()).append("\n");
            str.append("#Computed reduced reasons (base/core): ").append(getNumComputedReducedBaseReasons())
                    .append("/").append(getNumComputedReducedCoreReasons()).append("\n");
            str.append("#Checks: ").append(getNumChecks()).append("\n");
            return str.toString();
        }
    }


}
