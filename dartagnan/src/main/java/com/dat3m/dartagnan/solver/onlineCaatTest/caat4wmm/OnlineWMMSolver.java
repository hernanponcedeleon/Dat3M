package com.dat3m.dartagnan.solver.onlineCaatTest.caat4wmm;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.solver.onlineCaatTest.Decoder;
import com.dat3m.dartagnan.solver.onlineCaatTest.EdgeInfo;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.CAATSolver;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.domain.Domain;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.domain.GenericDomain;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.relationGraphs.Edge;
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
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.PropagatorBackend;
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

    public OnlineWMMSolver(RefinementModel refinementModel, Context analysisContext, EncodingContext encCtx) {
        this.refinementModel = refinementModel;
        this.encodingContext = encCtx;
        this.executionGraph = new ExecutionGraph(refinementModel);
        this.reasoner = new CoreReasoner(analysisContext, executionGraph);
        this.decoder = new Decoder(encCtx, refinementModel);
        this.refiner = new Refiner(refinementModel);
        this.solver = CAATSolver.create();
        this.bmgr = encCtx.getFormulaManager().getBooleanFormulaManager();
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
        //System.out.println("Pushed: " + backtrackPoints.size());
    }

    @Override
    public void onPop(int numLevels) {
        int backtrackTo = 0;
        int popLevels = numLevels;
        while (popLevels > 0) {
            backtrackTo = backtrackPoints.pop();
            popLevels--;
        }

        domain.resetElements(numLevels);

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

            Decoder.Info info = decoder.decode(expr);
            for (Event event : info.events()) {
                if (event.hasTag(Tag.VISIBLE)) {
                    domain.addElement(event);
                }
            }
        }

        progressPropagation();
    }

    private final Queue<Refiner.Conflict> openPropagations = new ArrayDeque<>();

    private void progressPropagation() {
        if (!openPropagations.isEmpty()) {
            getBackend().propagateConsequence(new BooleanFormula[0], bmgr.not(openPropagations.poll().toFormula(bmgr)));
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
        }

        StringBuilder builder = new StringBuilder()
                .append("Model extraction: ").append(result.stats.modelExtractionTime).append("\n")
                .append("Population time: ").append(result.stats.caatStats.getPopulationTime()).append("\n")
                .append("Total Model extraction: ").append(totalModelExtractionTime).append("\n");

        System.out.printf("------------ Check #%d ------------ \n%s", checkCounter, builder);
        System.out.println("------------------------------------");
    }

    private void initModel() {
        List<EdgeInfo> edges = new ArrayList<>();
        for (BooleanFormula assigned : trueValues) {
            Decoder.Info info = decoder.decode(assigned);
            edges.addAll(info.edges());
        }

        // Init domain
        executionGraph.initializeToDomain(domain);

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


/*public class OnlineWMMSolver extends AbstractUserPropagator {
    private boolean toggleOnline = false;

    private final ExecutionGraph executionGraph;
    private final CAATSolver solver;
    private final EncodingContext encodingContext;
    private final CoreReasoner reasoner;
    private final Decoder decoder;
    private final Refiner refiner;
    private final BooleanFormulaManager bmgr;
    private final RefinementModel refinementModel;
    private final RelationAnalysis relationAnalysis;

    public OnlineWMMSolver(RefinementModel refinementModel, Context analysisContext, EncodingContext encCtx) {
        this.refinementModel = refinementModel;
        this.encodingContext = encCtx;
        this.executionGraph = new ExecutionGraph(refinementModel);
        this.reasoner = new CoreReasoner(analysisContext, executionGraph);
        this.decoder = new Decoder(encCtx, refinementModel);
        this.refiner = new Refiner(refinementModel);
        this.solver = CAATSolver.create();
        this.bmgr = encCtx.getFormulaManager().getBooleanFormulaManager();
        this.relationAnalysis = analysisContext.requires(RelationAnalysis.class);

        executionGraph.initializeToDomain(domain);
    }

    // ------------------------------------------------------------------------------------------------------
    // Online features

    private final Deque<Integer> backtrackPoints = new ArrayDeque<>();
    private final Deque<BooleanFormula> knownValues = new ArrayDeque<>();
    private final Map<BooleanFormula, Boolean> partialModel = new HashMap<>();
    private final Set<BooleanFormula> trueValues = new HashSet<>();
    private final Domain<Event> domain = new GenericDomain<>();

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
        System.out.println("########Pushed: " + backtrackPoints.getFirst());
    }

    @Override
    public void onPop(int numLevels) {
        if (!toggleOnline) {
            int backtrackTo = 0;
            int counter = numLevels;
            while (counter > 0) {
                backtrackTo = backtrackPoints.pop();
                counter--;
            }

            int backtrackTime = domain.getId(backtrackTo);
            domain.resetElements(numLevels);

            while (knownValues.size() > backtrackTo) {
                final BooleanFormula revertedAssignment = knownValues.pop();
                if (partialModel.remove(revertedAssignment)) {
                    trueValues.remove(revertedAssignment);
                }
                // use max event id as edge time
                executionGraph.backtrackTo(backtrackTo);
            }

            System.out.printf("***********Backtracked %d levels to level %d\n", numLevels, backtrackPoints.size());
        } else {
            int backtrackTo = 0;
            int popLevels = numLevels;
            while (popLevels > 0) {
                backtrackTo = backtrackPoints.pop();
                popLevels--;
            }

            while (knownValues.size() > backtrackTo) {
                final BooleanFormula revertedAssignment = knownValues.pop();
                if (partialModel.remove(revertedAssignment)) {
                    trueValues.remove(revertedAssignment);
                }
            }

            System.out.printf("Backtracked %d levels to level %d\n", popLevels, backtrackPoints.size());
        }
    }

    @Override
    public void onKnownValue(BooleanFormula expr, boolean value) {
        knownValues.push(expr);
        partialModel.put(expr, value);
        if (!toggleOnline) {
            if (value) {
                trueValues.add(expr);
                Decoder.Info info = decoder.decode(expr);
                for (Event event : info.events()) {
                    if (event.hasTag(Tag.VISIBLE)) {
                        domain.addElement(event);
                    }
                }
                for (EdgeInfo edge : info.edges()) {
                    final Relation relInFullModel = refinementModel.translateToOriginal(edge.relation());
                    final SimpleGraph graph = (SimpleGraph) executionGraph.getRelationGraph(relInFullModel);
                    // use max event id as edge time
                    if (graph != null) {
                        int sourceId = domain.getId(edge.source());
                        int targetId = domain.getId(edge.target());
                        graph.add(new Edge(sourceId, targetId).withTime(Math.max(sourceId, targetId)));
                    }
                }
            }
            Result result = check();
            processResult(result);
        } else {
            if (value) {
                trueValues.add(expr);
            }
        }
        progressPropagation();
    }

    private final Queue<Refiner.Conflict> openPropagations = new ArrayDeque<>();

    private void progressPropagation() {
        if (!openPropagations.isEmpty()) {
            getBackend().propagateConsequence(new BooleanFormula[0], bmgr.not(openPropagations.poll().toFormula(bmgr)));
        }
    }

    // --- start old code ---

    @Override
    public void onFinalCheck() {
        Result result = check2();
        checkCounter++;
        totalModelExtractionTime += result.stats.modelExtractionTime;

        if (result.status == CAATSolver.Status.INCONSISTENT) {
            final List<Refiner.Conflict> conflicts = refiner.computeConflicts(result.coreReasons, encodingContext);
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
        executionGraph.initializeToDomain(domain);

        // Setup base relation graphs
        for (EdgeInfo edge : edges) {
            final Relation relInFullModel = refinementModel.translateToOriginal(edge.relation());
            final SimpleGraph graph = (SimpleGraph) executionGraph.getRelationGraph(relInFullModel);
            if (graph != null) {
                graph.add(new Edge(domain.getId(edge.source()), domain.getId(edge.target())));
            }
        }
    }

    private Result check2() {
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

        toggleOnline = true;
        System.out.println("§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§");

        return result;
    }

    /// --- end old code ---

    // --- Some statistics ---
    private long totalModelExtractionTime = 0;
    private int checkCounter = 0;

   /* @Override
    public void onFinalCheck() {
        //Result result = check();
        //processResult(result);
    } // do comment out

    private void processResult (Result result) {
        checkCounter++;
        totalModelExtractionTime += result.stats.modelExtractionTime;

        if (result.status == CAATSolver.Status.INCONSISTENT) {
            final List<Refiner.Conflict> conflicts = refiner.computeConflicts(result.coreReasons, encodingContext);
            assert !conflicts.isEmpty();
            boolean isFirst = true;
            for (Refiner.Conflict conflict : conflicts) {
                // The second part of the check is for symmetric clauses that are not yet conflicts.
                final boolean isConflict = isFirst &&
                        conflict.getVariables().stream().allMatch(partialModel::containsKey);
                if (isConflict) {
                    getBackend().propagateConflict(conflict.assignment().toArray(new BooleanFormula[0]));
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

    private Result check() {
        // ============== Run the CAATSolver ==============
        CAATSolver.Result caatResult = solver.check(executionGraph.getCAATModel());
        Result result = Result.fromCAATResult(caatResult);
        Statistics stats = result.stats;
        stats.modelSize = executionGraph.getDomain().size();

        if (result.getStatus() == CAATSolver.Status.INCONSISTENT) {
            // ============== Compute Core reasons ==============
            long curTime = System.currentTimeMillis();
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
    }*/

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
