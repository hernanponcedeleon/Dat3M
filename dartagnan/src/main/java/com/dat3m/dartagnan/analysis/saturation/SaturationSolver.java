package com.dat3m.dartagnan.analysis.saturation;

import com.dat3m.dartagnan.analysis.saturation.graphs.ExecutionGraph;
import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.Edge;
import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.RelationGraph;
import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.constraints.Constraint;
import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.utils.PathAlgorithm;
import com.dat3m.dartagnan.analysis.saturation.logic.Conjunction;
import com.dat3m.dartagnan.analysis.saturation.logic.DNF;
import com.dat3m.dartagnan.analysis.saturation.logic.SortedCubeSet;
import com.dat3m.dartagnan.analysis.saturation.reasoning.CoreLiteral;
import com.dat3m.dartagnan.analysis.saturation.reasoning.Reasoner;
import com.dat3m.dartagnan.analysis.saturation.resolution.TreeResolution;
import com.dat3m.dartagnan.analysis.saturation.searchTree.DecisionNode;
import com.dat3m.dartagnan.analysis.saturation.searchTree.LeafNode;
import com.dat3m.dartagnan.analysis.saturation.searchTree.SearchNode;
import com.dat3m.dartagnan.analysis.saturation.searchTree.SearchTree;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.verification.model.ExecutionModel;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import org.sosy_lab.java_smt.api.Model;
import org.sosy_lab.java_smt.api.SolverContext;

import java.math.BigInteger;
import java.util.*;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.GlobalSettings.*;
import static com.dat3m.dartagnan.analysis.saturation.SolverStatus.*;
import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.CO;

/*
    The SaturationSolver works as follows (with some simplifications):
    (1) We extract an ExecutionModel (~abstract execution) from the model produced by the outer solver
    (2) We initialize an ExecutionGraph with all data from the model (rf, po, dependencies, min-set coherences etc.)
        - The ExecutionGraph in turn maintains a GraphHierarchy, which consists of a graph for each relation in the WMM
    (3) We perform an initial check of all axioms (if there is any violation, we compute reasons for it and are done)
    (4) We start the 'Saturation' algorithm:
        -- Maintained Data --
            - A list of coherences to be tested
            - A SearchTree with binary DecisionNodes for tested coherences and LeafNodes for found violations.
        -- Algorithm --
            (1) We pick a coherence edge co(w1, w2) and create a DecisionNode in the SearchTree
                - If we already tested each coherence edge without any progress, we terminate with inconclusive results
                - If we have a complete coherence order, we have verified the violation and terminate
            (2) We add the coherence edge to the ExecutionGraph (which propagates all changes to derived graphs)
            (3) We check all axioms:
                - CASE Violation found:
                    (1) We compute the reasons of all found violations
                    (2) We create a LeafNode in the SearchTree that contains all found reasons.
                    (3) We backtrack (remove the new co-edge + all derived edges)
                    (4) We permanently add the opposite coherence edge co(w2, w1) to the ExecutionGraph
                        - We repeat the axiom checks for this new edge
                        - If we again find violations, we have established inconsistency. We perform resolution
                          and return the resolved violations.
                - CASE No Violation found:
                    (1) We backtrack
                    (2) We check the opposite coherence edge (add edge + axiom checks)
             (4) We repeat the procedure. If neither of the two coherences caused a violation, we remove the DecisionNode

     NOTES:
        - The above algorithm is 1-Saturation.
        - The propagation is handled by GraphHierarchy which is maintained by ExecutionGraph
        - The reason computation is handled by Reasoner.
        - The resolution is handled by TreeResolution.
 */
public class SaturationSolver {

    public enum Mode {
        SATURATION, MODEL_CHECKING
    }

    // ================== Fields ==================

    // --------------- Static data ----------------
    private final VerificationTask task;
    private final ExecutionGraph execGraph;
    private final Reasoner reasoner;
    //private final Learner learner;
    private final Mode mode;

    // ----------- Iteration-specific data -----------
    //TODO: We might want to take an external executionModel to perform refinement on!
    private final ExecutionModel executionModel;
    private int maxSaturationDepth = SATURATION_MAX_DEPTH;
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

    /*public DNF<CoreLiteral> getLearnedViolations() { return learner.getLearnedViolationsAsDNF(); }
    public List<DNF<CoreLiteral>> getLearnedDerivations() { return  learner.getLearnedDerivations(); }*/

    public int getMaxSaturationDepth() { return  maxSaturationDepth; }
    public void setMaxSaturationDepth(int depth) { maxSaturationDepth = depth; }

    public Mode getMode() { return mode; }



    // =============================================

    // =========== Construction & Init ==============

    public SaturationSolver(VerificationTask task, Mode mode) {
        this.task = task;
        this.execGraph = new ExecutionGraph(task);
        this.executionModel = new ExecutionModel(task);
        this.reasoner = new Reasoner(execGraph, true);
        //this.learner = new Learner();
        this.mode = mode;

        /*if (mode == Mode.MODEL_CHECKING) {
            learner.setViolationLearningStrategy(Learner.ViolationLearningStrategy.NONE);
        } else {
            learner.setViolationLearningStrategy(SATURATION_VIOLATION_LEARNING);
        }*/
    }

    // ----------------------------------------------

    private void populateFromModel(Model model, SolverContext ctx) {
        executionModel.initialize(model, ctx, SATURATION_USE_MODEL_COHERENCES);
        execGraph.initializeFromModel(executionModel);
        if (mode == Mode.MODEL_CHECKING && SATURATION_USE_MODEL_COHERENCES) {
            populateModelCoherences();
        }
        PathAlgorithm.ensureCapacity(executionModel.getEventList().size());
        //learner.clear(); // TODO: We assume "outer learning" for now. For inner learning we cannot forget the learned cubes
        if (SATURATION_ENABLE_DEBUG) {
            testIteration();
            testStaticGraphs();
            testMaxSetContainment();
        }
    }

    private void populateModelCoherences() {
        if (!executionModel.hasCoherences()) {
            throw new IllegalStateException("The solver model has no coherences.");
        }

        List<Edge> coherences = new ArrayList<>();
        // ----------------------------------------------
        // We find the total order per address (w1, w2, ..., wk) induced by the coherences in the ExecutionModel
        // and only add coherence edges for consecutive writes
        Map<EventData, Set<EventData>> coMap = executionModel.getCoherenceMap();
        DependencyGraph<EventData> coGraph = DependencyGraph.from(coMap.keySet(), coMap);

        List<EventData> events = coGraph.getSCCs().stream().map(scc -> scc.stream().findAny().get().getContent()).collect(Collectors.toList());
        Collections.reverse(events);
        for (BigInteger addr : executionModel.getAddressWritesMap().keySet()) {
            List<EventData> sameAddrWrites = events.stream().filter(e -> e.getAccessedAddress().equals(addr)).collect(Collectors.toList());
            for (int i = 1; i < sameAddrWrites.size(); i++) {
                coherences.add(new Edge(sameAddrWrites.get(i - 1), sameAddrWrites.get(i)));
            }
        }
        // ----------------------------------------------

        execGraph.addCoherenceEdges(coherences);
    }

    /*
        Creates a list of coherence that need to be searched by Saturation.
        All coherences that are trivially present (e.g. min-set coherences or initial coherences)
        are directly added to the coherence graph.
     */
    private List<Edge> createCoSearchList() {
        Relation co = task.getMemoryModel().getRelationRepository().getRelation(CO);
        Map<BigInteger, Set<Edge>> possibleCoEdges = new HashMap<>();
        List<Edge> initCoherences = new ArrayList<>();
        TupleSet minSet = co.getMinTupleSet();
        TupleSet maxSet = co.getMaxTupleSet();

        for (Map.Entry<BigInteger, Set<EventData>> addressedWrites : executionModel.getAddressWritesMap().entrySet()) {
            Set<EventData> writes = addressedWrites.getValue();
            BigInteger address = addressedWrites.getKey();
            Set<Edge> coEdges = new HashSet<>();
            possibleCoEdges.put(address, coEdges);

            for (EventData e1 : writes) {
                for (EventData e2: writes) {
                    if (e1 == e2) {
                        continue;
                    }

                    Tuple t = new Tuple(e1.getEvent(), e2.getEvent());

                    if (!maxSet.contains(t)) {
                        // The co(e1, e2) edge can never be contained in any execution
                        // so co(e2, e1) must be present instead.
                        initCoherences.add(new Edge(e2, e1));
                        continue;
                    } else if (minSet.contains(t)) {
                        // Min-Set coherences have to be contained in all executions
                        initCoherences.add(new Edge(e1, e2));
                        continue;
                    }

                    // We only add edges in one direction since the search procedure will test
                    // each coherence in both directions anyways!
                    if (e2.getId() >= e1.getId()) {
                        continue;
                    }

                    if (e1.isInit() && !e2.isInit()) {
                        // This is a fallback. The maxSet check should cover this.
                        initCoherences.add(new Edge(e1, e2));
                    } else if (!e1.isInit() && !e2.isInit()) {
                        coEdges.add(new Edge(e1, e2));
                    }
                }
            }
        }
        possibleCoEdges.values().removeIf(Collection::isEmpty);
        execGraph.addCoherenceEdges(initCoherences);

        List<Edge> coSearchList = new ArrayList<>();
        for (Set<Edge> coEdges : possibleCoEdges.values()) {
            coSearchList.addAll(coEdges);
        }
        return coSearchList;

    }

    /*
        A simple heuristic which moves all coherences to the front, which connect writes
        that have many reads (more rf-edges ~ higher likelihood that a coherence will cause violations)
    */
    private void sortCoSearchList(List<Edge> list) {
        list.sort(Comparator.comparingInt(x -> -(x.getFirst().getImportance() + x.getSecond().getImportance())));
    }


    // ====================================================

    // ==============  Core functionality  =================

    public SolverResult check(Model model, SolverContext ctx) {
        switch (mode) {
            case SATURATION:
                return checkUsingSaturation(model, ctx, maxSaturationDepth);
            case MODEL_CHECKING:
                return checkModel(model, ctx);
            default:
                throw new IllegalStateException("Unknown Mode: " + mode);
        }
    }

    /*
        This method checks a given model without performing any search.
        The model may or may not contain coherences.
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
        SolverStatus status = checkInconsistency() ? INCONSISTENT : CONSISTENT;
        result.setStatus(status);
        if (status == INCONSISTENT) {
            long time = System.currentTimeMillis();
            // Test code
            /*reasoner.clear();
            if (!reasoner.hasCut()) {
                Set<RelationGraph> cut = execGraph.computeMinimalCut();
                reasoner.setCut(cut);
            }*/
            result.setCoreReasons(convertToDNF(computeInconsistencyReasons()));
            stats.reasonComputationTime += (System.currentTimeMillis() - time);
        }

        stats.searchTime = System.currentTimeMillis() - curTime;
        return result;
    }

    public Reasoner getReasoner() { return reasoner; }

    /*
        <checkUsingSaturation> performs a sequence of k-Saturations, starting from 0 up to <maxSaturationDepth>
        It returns whether the model is consistent, what inconsistency reasons where found (if any) and statistics
        about the computation.
     */
    private SolverResult checkUsingSaturation(Model model, SolverContext ctx, int maxSaturationDepth) {
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
        // ======= Initialize search =======
        SearchTree sTree = new SearchTree();
        List<Edge> coSearchList = createCoSearchList();
        sortCoSearchList(coSearchList);
        // =================================

        // ========= Actual search =========
        for (int k = 0; k <= maxSaturationDepth; k++) {
            stats.saturationDepth = k;
            // There should always exist a single empty node unless we found a violation
            SearchNode start = sTree.findNodes(SearchNode::isEmptyNode).get(0);
            SolverStatus status = saturation(start, 0, k, coSearchList, 0);
            if (status != INCONCLUSIVE) {
                result.setStatus(status);
                if (status == INCONSISTENT) {
                    long temp = System.currentTimeMillis();
                    result.setCoreReasons(computeInconsistencyReasonsFromSearchTree(sTree));
                    stats.resolutionTime = System.currentTimeMillis() - temp;
                }
                break;
            }
            if (k > 0) {
                // For k=0, it is impossible to exclude coherences since no search is happening at all
                coSearchList.removeIf(this::coExists);
            }
            /*TODO: Maybe reduce k, whenever progress is made?
                if e.g. 2-SAT makes progress (finds some edge), then 1-SAT might be able to
                make use of that progress.
             */
        }
        // ==============================

        stats.searchTime = System.currentTimeMillis() - curTime;
        if (SATURATION_ENABLE_DEBUG && result.getStatus() == CONSISTENT) {
            testCoherence();
        }
        return result;
    }

    // ----------------------------------------------

    /*
        <searchList> is a list of coherences that need to be tested. It is assumed
        that for each write-pair (w1,w2) there is exactly one edge in the list, either co(w1, w2) or
        co(w2, w1).
     */
    private SolverStatus saturation(SearchNode curSearchNode, int curTime, int depth, List<Edge> searchList, int searchStart) {
        searchList = searchList.subList(searchStart, searchList.size());
        if (depth == 0 || searchList.isEmpty()) {
            // 0-SAT amounts to a simple violation check
            if (checkInconsistency()) {
                long time = System.currentTimeMillis();
                curSearchNode.replaceBy(new LeafNode(computeInconsistencyReasons()));
                stats.reasonComputationTime += (System.currentTimeMillis() - time);
                return INCONSISTENT;
            } else if (searchList.stream().allMatch(this::coExists)) {
                // All remaining edges in the search list are already in the graph (due to transitivity and totality of co)
                return CONSISTENT;
            } else {
                return INCONCLUSIVE;
            }
        }

        searchList = new ArrayList<>(searchList);
        boolean progress;
        do {
            progress = false;

            for (int i = 0; i < searchList.size(); i++) {
                Edge coEdge = searchList.get(i);
                if (coExists(coEdge)) {
                    continue;
                }

                DecisionNode decNode = new DecisionNode(coEdge);
                // Add coEdge with new time stamp
                int nextTime = curTime + 1;
                execGraph.addCoherenceEdges(coEdge.withTime(nextTime));
                stats.numGuessedCoherences++;
                SolverStatus status = saturation(decNode.getPositive(), nextTime, depth - 1, searchList, i + 1);
                if (status == CONSISTENT && searchList.stream().allMatch(this::coExists)) {
                    return CONSISTENT;
                }
                // Always backtrack the added edge, because either it caused a constraint violation and needs to be removed
                // or it did not cause a violation so we want to test another co-edge.
                backtrackTo(curTime);

                if (status == INCONSISTENT) {
                    // ...the last added edge caused a constraint violation
                    curSearchNode.replaceBy(decNode);
                    curSearchNode = decNode.getNegative();
                    // We now add the opposite edge but with the old time stamp, since this
                    // edge is now permanent with respect to our current search depth.
                    execGraph.addCoherenceEdges(coEdge.inverse().withTime(curTime));
                    status = saturation(decNode.getNegative(), curTime, depth - 1, searchList, i + 1);
                    if (status == INCONSISTENT) {
                        // ... both directions of the co edge caused a violation, so we have an inconsistency
                        return INCONSISTENT;
                    } else if (status == CONSISTENT && searchList.stream().allMatch(this::coExists)) {
                        // ... the inner Saturation verified the violation to be true, and the current Saturation
                        // has no more coherences to test, so it agrees and also returns consistency.
                        return CONSISTENT;
                    }
                    // We made progress since we permanently added a new edge for this saturation depth.
                    //TODO: We might want to restart the search or do some other heuristic
                    // to guide our search.
                    progress = true;
                } else {
                    // ... the last added edge did NOT cause a consistency violation.
                    // We still need to test the opposite edge but with a new timestamp again.
                    nextTime = curTime + 1;
                    execGraph.addCoherenceEdges(coEdge.inverse().withTime(nextTime));
                    stats.numGuessedCoherences++;
                    status = saturation(decNode.getNegative(), nextTime, depth - 1, searchList, i + 1);
                    if (status == CONSISTENT && searchList.stream().allMatch(this::coExists)) {
                        return CONSISTENT;
                    }
                    backtrackTo(curTime);

                    if (status == INCONSISTENT) {
                        // ... the inverse co-edge caused a consistency violation but the original did not
                        // so we fix the original one as permanent now (using the old timestamp) and proceed
                        curSearchNode.replaceBy(decNode);
                        curSearchNode = decNode.getPositive();
                        execGraph.addCoherenceEdges(coEdge.withTime(curTime));
                        progress = true;
                    }
                }
            }
            // Each full iteration, we can remove all coherences we already found
            // from the search list.
            searchList.removeIf(this::coExists);
        } while (progress);
        return INCONCLUSIVE;
    }

    private void backtrackTo(int time) {
        execGraph.backtrackTo(time);
    }

    private boolean coExists(Edge coEdge) {
        return execGraph.getCoherenceGraph().contains(coEdge) || execGraph.getCoherenceGraph().contains(coEdge.inverse());
    }

    // ============= Violations + Resolution ================

    private boolean checkInconsistency() {
        return execGraph.getConstraints().stream().anyMatch(Constraint::checkForViolations);
    }

    // Computes the inconsistency reasons (if any) of the current ExecutionGraph
    private List<Conjunction<CoreLiteral>> computeInconsistencyReasons() {
        List<Conjunction<CoreLiteral>> reasons = new ArrayList<>();
        for (Constraint constraint : execGraph.getConstraints()) {
            reasons.addAll(reasoner.computeViolationReasons(constraint).getCubes());
        }
        stats.numComputedReasons += reasons.size();

        if ( mode == Mode.SATURATION && !SATURATION_NO_RESOLUTION) {
            // Important code: We only retain those reasons with the least number of co-literals
            // this heavily boosts the performance of the resolution!!!
            int minComplexity = reasons.stream().mapToInt(Conjunction::getResolutionComplexity).min().getAsInt();
            reasons.removeIf(x -> x.getResolutionComplexity() > minComplexity);
        }
        // TODO: The following is ugly, but we convert to DNF again to remove dominated clauses and duplicates
        reasons = new ArrayList<>(new DNF<>(reasons).getCubes());

        //learner.suggestViolations(reasons);

        stats.numComputedReducedReasons += reasons.size();

        return reasons;
    }

    // Computes the inconsistency (core) reasons from a given search tree.
    // This may either just return all found reasons in the leaves
    // or perform a resolution to obtain core reasons.
    private DNF<CoreLiteral> computeInconsistencyReasonsFromSearchTree(SearchTree tree) {
        SortedCubeSet<CoreLiteral> res = new SortedCubeSet<>();

        if (SATURATION_NO_RESOLUTION) {
           List<Conjunction<CoreLiteral>> reasons = tree.findNodes(SearchNode::isLeaf).stream()
                   .map(node -> (LeafNode)node).flatMap(leaf -> leaf.getInconsistencyReasons().stream())
                   .collect(Collectors.toList());
           res.addAll(reasons);
        } else {
            res = new TreeResolution(tree).computeReasons();
        }

        return convertToDNF(res.getCubes());
    }

    private DNF<CoreLiteral> convertToDNF(Collection<Conjunction<CoreLiteral>> cubes) {
        SortedCubeSet<CoreLiteral> res = new SortedCubeSet<>();
        cubes.forEach(cube -> res.add(reasoner.simplifyReason(cube)));
        res.simplify();
        return res.toDNF();

    }

    // ====================================================

    // ===================== TESTING ======================

    /*
        The following methods check simple properties such as:
            - Iteration of edges in graphs works correctly (not trivial for virtual graphs)
            - Min-Sets of Relations are present in the corresponding RelationGraph
            - Coherence is total and transitive
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
                        "The size of relation graph %s mismatches the number of streamed edges..", g));
            }
        }
    }

    private void testMaxSetContainment() {
        task.getMemoryModel().encodeBase(executionModel.getContext());
        Map<Relation, TupleSet> missingTuples = new HashMap<>();
        for (Relation relData : execGraph.getRelationGraphMap().keySet()) {
            missingTuples.put(relData, new TupleSet());
            TupleSet maxSet = relData.getMaxTupleSet();
            RelationGraph graph = execGraph.getRelationGraph(relData);

            for (Edge e : graph) {
                if (!maxSet.contains(e.toTuple())) {
                    missingTuples.get(relData).add(e.toTuple());
                }
            }
        }
        missingTuples.values().removeIf(Collection::isEmpty);
        if (missingTuples.size() > 0) {
            throw new IllegalStateException("There are graphs with more edges than the corresponding relation's maxSet has.");
        }
    }

    private void testStaticGraphs() {
        for (Relation relData : task.getRelationDependencyGraph().getNodeContents()) {
            if (relData.getName().equals(CO)) {
                continue;
            }
            if (relData.isStaticRelation() || relData.isRecursiveRelation()) {
                RelationGraph g = execGraph.getRelationGraph(relData);
                if (g == null) {
                    continue;
                }
                for (Tuple t : relData.getMinTupleSet()) {
                    Optional<EventData> e1 = executionModel.getData(t.getFirst());
                    Optional<EventData> e2 = executionModel.getData(t.getSecond());
                    if (e1.isPresent() && e2.isPresent() && !g.contains(new Edge(e1.get(), e2.get()))) {
                        throw new IllegalStateException(String.format(
                                "Static min tuple %s%s is not present in the corresponding relation graph %s.",
                                relData.getName(), t, g.getName()));
                    }
                }
            }
        }
    }

    private void testCoherence() {
        TupleSet tSet = new TupleSet();
        for (Edge e : execGraph.getSimpleCoherenceGraph()) {
            tSet.add(new Tuple(e.getFirst().getEvent(), e.getSecond().getEvent()));
        }
        Map<Event, Set<Event>> map = tSet.transMap();
        for (Event e1 : map.keySet()) {
            for (Event e2 : map.get(e1)) {
                EventData e1Data = executionModel.getData(e1).get();
                EventData e2Data = executionModel.getData(e2).get();
                Edge edge = new Edge(e1Data, e2Data);
                if (!execGraph.getCoherenceGraph().contains(edge)) {
                    throw new IllegalStateException(String.format(
                            "Edge %s is transitively derivable from sco-edges but not present in the co-graph.", edge));
                }
            }
        }

        for (Set<EventData> writes : executionModel.getAddressWritesMap().values()) {
            for (EventData e1 : writes) {
                for (EventData e2 : writes) {
                    if (e1 == e2) {
                        continue;
                    }

                    if (!coExists(new Edge(e1,e2))) {
                        throw new IllegalStateException(String.format(
                                "The two same-address writes %s and %s have no coherence edge between them.", e1, e2));
                    }
                }
            }
        }
    }

    // ====================================================

}
