package com.dat3m.dartagnan.wmm.graphRefinement.graphs;

import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.wmm.graphRefinement.ModelContext;
import com.dat3m.dartagnan.wmm.graphRefinement.VerificationContext;
import com.dat3m.dartagnan.wmm.graphRefinement.coreReason.*;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.Edge;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.EventData;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.eventGraph.axiom.GraphAxiom;
import com.dat3m.dartagnan.wmm.graphRefinement.logic.Conjunction;
import com.dat3m.dartagnan.wmm.graphRefinement.logic.DNF;
import com.dat3m.dartagnan.wmm.graphRefinement.logic.Literal;
import com.dat3m.dartagnan.wmm.graphRefinement.logic.SortedClauseSet;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.timeable.Timestamp;
import com.dat3m.dartagnan.wmm.graphRefinement.resolution.DecisionNode;
import com.dat3m.dartagnan.wmm.graphRefinement.resolution.LeafNode;
import com.dat3m.dartagnan.wmm.graphRefinement.resolution.ResolutionTree;
import com.dat3m.dartagnan.wmm.graphRefinement.resolution.SearchNode;
import com.microsoft.z3.Context;
import com.microsoft.z3.Model;

import java.util.*;


//TODO: Improve resolvent computation (compute only needed resolvents!)
public class GraphRefinement {

    private final VerificationContext context;
    private final ExecutionGraph execGraph;

    // ====== Data specific for a single refinement =======
    private final ModelContext modelContext;


    public GraphRefinement(VerificationContext context) {
        this.context = context;
        normalizeMemoryModel();
        this.execGraph = new ExecutionGraph(context);
        modelContext = new ModelContext(context);
    }

    private void normalizeMemoryModel() {
        context.addNontransitiveWriteOrder();
        //context.replaceAcyclicityAxioms(); //TODO: avoid this replacement operation by performing acyclicity checks directly
    }


    private void populateFromModel(Model model, Context ctx) {
        modelContext.initialize(model, ctx);
        execGraph.initializeFromModel(modelContext);
    }

    private final Map<Integer, Set<Edge>> possibleCoEdges = new HashMap<>();
    private final SortedClauseSet<CoreLiteral> coreReasonsSorted = new SortedClauseSet<>();
   /* public GraphResult search() {

        EventGraph coGraph = execGraph.getCoGraph();
        GraphResult result = new GraphResult();
        Timestamp time = Timestamp.ZERO;

        coreReasonsSorted.clear();
        possibleCoEdges.clear();
        initSearch();

        if (checkViolations()) {
            computeViolations();
            result.setResult(Result.FAIL);
            result.setViolations(resolveViolations());
            return result;
        }

        List<Edge> coSearchList = new ArrayList<>();
        for (Set<Edge> coEdges : possibleCoEdges.values()) {
            coSearchList.addAll(coEdges);
        }
        sortCoSearchList(coSearchList);

        boolean progress;
        boolean invalid = false;
        do {
            Timestamp curTime = time;
            progress = false;
            for (int i = 0; i < coSearchList.size(); i++) {
                Edge coEdge = coSearchList.get(i);
                if (coGraph.contains(coEdge) || coGraph.contains(coEdge.getInverse())) {
                    coSearchList.remove(i);
                    coSearchList.remove(coEdge.getInverse());
                    progress = true;
                    break;
                }
                Timestamp nextTime = curTime.next();
                execGraph.addCoherenceEdge(coEdge.withTimestamp(nextTime));
                if (checkViolations()) {
                    computeViolations();
                    progress = true;
                    coSearchList.remove(i);
                    coSearchList.remove(coEdge.getInverse());
                    backtrackOn(nextTime);
                    execGraph.addCoherenceEdge(coEdge.getInverse().withTimestamp(curTime));
                    if (checkViolations()) {
                        computeViolations();
                        invalid = true;
                    }
                    break;
                }
                backtrackOn(nextTime);

                nextTime = curTime.next();
                execGraph.addCoherenceEdge(coEdge.getInverse().withTimestamp(nextTime));
                if (checkViolations()) {
                    computeViolations();
                    progress = true;
                    coSearchList.remove(i);
                    coSearchList.remove(coEdge.getInverse());
                    backtrackOn(nextTime);
                    execGraph.addCoherenceEdge(coEdge.withTimestamp(curTime));
                    break;
                }
                nextTime.invalidate();
                backtrack();
            }
        } while(progress && !invalid);

        if (invalid) {
            result.setResult(Result.FAIL);
            result.setViolations(resolveViolations());
        } else if (coSearchList.size() == 0) {
            result.setResult(Result.PASS);
        } else {
            //TODO: Figure out why sometimes violations are not found at all
            result.setResult(Result.UNKNOWN);
            System.out.println("Missing edges: " + coSearchList.size());
        }
        return result;
    }
    */


    private RefinementStats stats;

    /*
    kSearch performs a sequence of k-Saturations, starting from 0 up to <maxSaturationDepth>
    It returns whether it was successful, what violations where found (if any) and at which saturation depth
    they were found.
     */
    public RefinementResult kSearch(Model model, Context ctx, int maxSaturationDepth) {
        RefinementResult result = new RefinementResult();
        stats = new RefinementStats();
        result.setStats(stats);

        // ====== Populate from model ======
        long curTime = System.currentTimeMillis();
        populateFromModel(model, ctx);
        stats.modelConstructionTime = System.currentTimeMillis() - curTime;
        // =================================

        // ======= Initialize search =======
        ResolutionTree resTree = new ResolutionTree();
        coreReasonsSorted.clear();
        possibleCoEdges.clear();
        SearchNode node = initSearch(resTree.getRootNode());

        List<Edge> coSearchList = new ArrayList<>();
        for (Set<Edge> coEdges : possibleCoEdges.values()) {
            coSearchList.addAll(coEdges);
        }
        sortCoSearchList(coSearchList);
        // =================================

        // ========= Actual search =========
        curTime = System.currentTimeMillis();
        for (int k = 0; k <= maxSaturationDepth; k++) {
            stats.saturationDepth = k;
            Result r = kSaturation(node, Timestamp.ZERO, k, coSearchList, 0);
            if (r != Result.UNKNOWN) {
                result.setResult(r);
                if (r == Result.FAIL) {
                    long temp = System.currentTimeMillis();
                    // ----- Test code -----
                    SortedClauseSet<CoreLiteral> res = resTree.computeViolations();
                    SortedClauseSet<CoreLiteral> res2 = new SortedClauseSet<>();
                    res.forEach(clause -> res2.add(clause.removeIf(x -> canBeRemoved(x, clause))));
                    new DNF<>(res2.getClauses());
                    result.setViolations(new DNF<>(res2.getClauses()));
                    // --------------------
                    //result.setViolations(resolveViolations());
                    stats.resolutionTime = System.currentTimeMillis() - temp;
                }
                break;
            }
            if (k > 0) {
                // For k=0, it is impossible to exclude coherences since no search is happening at all
                coSearchList.removeIf(this::coExists);
            }
            //TODO: Maybe reset k, whenever progress is made?
        }
        // ==============================

        stats.searchTime = System.currentTimeMillis() - curTime;
        return result;
    }



    /*
        <searchList> is a list of coherences that need to be tested. It is assumed
        that for each write-pair (w1,w2) there is exactly one edge in the list, either co(w1, w2) or
        co(w2, w1).
     */
    private Result kSaturation(SearchNode node, Timestamp curTime, int k, List<Edge> searchList, int searchStart) {
        if (k == 0) {
            // 0-SAT amounts to a simple violation check
            if (checkViolations()) {
                long time = System.currentTimeMillis();
                //computeViolations();
                node.replaceBy(new LeafNode(computeViolationList()));
                stats.violationComputationTime += (System.currentTimeMillis() - time);
                return Result.FAIL;
            } else if (searchList.subList(searchStart, searchList.size()).stream().allMatch(this::coExists)) {
                // All remaining edges in the search list are already in the graph (due to transitivity and totality of co)
                return Result.PASS;
            } else {
                return Result.UNKNOWN;
            }
        }

        boolean progress = true;
        while (progress) {
            progress = false;

            for (int i = searchStart; i < searchList.size(); i++) {
                Edge coEdge = searchList.get(i);
                if (coExists(coEdge))
                    continue;

                Timestamp nextTime = curTime.next();
                coEdge = coEdge.withTimestamp(nextTime);

                CoLiteral edgeLiteral = new CoLiteral(coEdge);
                DecisionNode decNode = new DecisionNode(edgeLiteral);

                execGraph.addCoherenceEdge(coEdge);
                stats.numGuessedCoherences++;
                Result r = kSaturation(decNode.getPositive(), nextTime, k - 1, searchList, i + 1);
                if (r == Result.PASS) {
                    return Result.PASS;
                }
                backtrackOn(nextTime);

                if (r == Result.FAIL) {
                    execGraph.addCoherenceEdge(coEdge.getInverse().withTimestamp(curTime));
                    node.replaceBy(decNode);
                    node = decNode.getNegative();
                    r = kSaturation(node, curTime, k - 1, searchList, i + 1);
                    if (r != Result.UNKNOWN) {
                        return r;
                    }
                    // We made progress
                    //TODO: We might want to restart the search or do some other heuristic
                    // to guide our search.
                    progress = true;
                } else {
                    nextTime = curTime.next();
                    Edge coEdgeInv = coEdge.getInverse().withTimestamp(nextTime);
                    execGraph.addCoherenceEdge(coEdgeInv);
                    stats.numGuessedCoherences++;
                    r = kSaturation(decNode.getNegative(), nextTime, k - 1, searchList, i + 1);
                    if (r == Result.PASS) {
                        return Result.PASS;
                    }
                    backtrackOn(nextTime);

                    if(r == Result.FAIL) {
                        execGraph.addCoherenceEdge(coEdge.withTimestamp(curTime));
                        node.replaceBy(decNode);
                        node = decNode.getPositive();
                    }
                }
            }
        }
        return Result.UNKNOWN;
    }

    private boolean coExists(Edge coEdge) {
        return execGraph.getCoGraph().contains(coEdge) || execGraph.getCoGraph().contains(coEdge.getInverse());
    }

    private boolean checkViolations() {
        boolean hasViolation = false;
        for (GraphAxiom axiom : execGraph.getGraphAxioms()) {
            hasViolation |= axiom.checkForViolations();
        }

        return hasViolation;
    }

    private List<Conjunction<CoreLiteral>> computeViolationList() {
        List<Conjunction<CoreLiteral>> violations = new ArrayList<>();
        for (GraphAxiom axiom : execGraph.getGraphAxioms()) {
            DNF<CoreLiteral> clauses = axiom.computeReasons();
            if (!clauses.isFalse()) {
                for (Conjunction<CoreLiteral> clause : clauses.getCubes()) {
                    violations.add(clause.removeIf(x -> canBeRemoved(x, clause)));
                    stats.numComputedViolations++;
                }
            }
        }
        return violations;
    }

    private void computeViolations() {
        //TODO: Compute more than just some reason. What we do depends on the implementation
        // very important!!!!!!!! Finding all violations causes HUGE resolvents in the end
        // finding just some reason can cause many, many iterations!!!!
        int curSize = coreReasonsSorted.getClauseSize();
        for (GraphAxiom axiom : execGraph.getGraphAxioms()) {
            // Computes a single reason
            /*Conjunction<CoreLiteral> clause = axiom.computeSomeReason();
            if (!clause.isFalse()) {
                coreReasonsSorted.add(clause.removeIf(x -> canBeRemoved(x, clause)));
            }*/

            // Computes many reasons
            DNF<CoreLiteral> clauses = axiom.computeReasons();
            if (!clauses.isFalse()) {
                for (Conjunction<CoreLiteral> clause : clauses.getCubes()) {
                    coreReasonsSorted.add(clause.removeIf(x -> canBeRemoved(x, clause)));
                }
            }
        }
        stats.numComputedViolations += coreReasonsSorted.getClauseSize() - curSize;
    }

    // Returns TRUE, if <literal> is an EventLiteral that is implied by some non-coherence
    // EdgeLiteral (cause CoLiterals may get removed by resolution)
    private boolean canBeRemoved(CoreLiteral literal, Conjunction<CoreLiteral> clause) {
        if (!(literal instanceof EventLiteral))
            return false;
        EventLiteral eventLit = (EventLiteral)literal;
        return clause.getLiterals().stream().anyMatch(x -> {
            if (!(x instanceof AbstractEdgeLiteral) || x.hasOpposite())
                return false;
            AbstractEdgeLiteral edgeLiteral = (AbstractEdgeLiteral)x;
            return edgeLiteral.getEdge().getFirst().equals(eventLit.getEvent())
                    || edgeLiteral.getEdge().getSecond().equals(eventLit.getEvent());
        });
    }

    private DNF<CoreLiteral> resolveViolations() {
        coreReasonsSorted.simplify();
        //SortedClauseSet<CoreLiteral> res =  coreReasonsSorted.computeAllResolvents();
        //TODO: replace this test code by some rigorous code
        SortedClauseSet<CoreLiteral> res =  coreReasonsSorted.computeProductiveResolvents();
        res.removeIf(Literal::hasOpposite);
        //TODO: replace following temporary code. We should already simplify during resolution
        SortedClauseSet<CoreLiteral> res2 = new SortedClauseSet<>();
        res.forEach(clause -> res2.add(clause.removeIf(x -> canBeRemoved(x, clause))));
        return new DNF<>(res2.getClauses());
    }

    private void sortCoSearchList(List<Edge> list) {
        int index = 0;
        EventGraph rf = execGraph.getRfGraph();
        for (int i = 0; i < list.size(); i++) {
            Edge t = list.get(i);
            if (i > index && (rf.inEdgeIterator(t.getFirst()).hasNext() || rf.inEdgeIterator(t.getSecond()).hasNext()
            || rf.outEdgeIterator(t.getSecond()).hasNext() || rf.outEdgeIterator(t.getSecond()).hasNext()))
            {
                list.set(i, list.get(index));
                list.set(index++, t);
            }
        }
    }

    private void backtrackOn(Timestamp time) {
        time.invalidate();
        execGraph.backtrack();
    }


    private SearchNode initSearch(SearchNode node) {
        for (Map.Entry<Integer, Set<EventData>> addressedWrites : modelContext.getAddressWritesMap().entrySet()) {
            Set<EventData> writes = addressedWrites.getValue();
            Integer address = addressedWrites.getKey();
            Set<Edge> coEdges = new HashSet<>();
            possibleCoEdges.put(address, coEdges);

            for (EventData e1 : writes) {
                for (EventData e2: writes) {
                    // We only add edges in one direction
                    if (e2.getId() >= e1.getId())
                        continue;

                    if (e1.isInit() && !e2.isInit()) {
                        execGraph.addCoherenceEdge(new Edge(e1, e2));
                        // Test code: add violation for anti initial writes cause we will
                        // never search for them otherwise

                        //coreReasonsSorted.add( new Conjunction<>(new CoLiteral(new Edge(e2, e1))));
                        CoLiteral decLit = new CoLiteral(new Edge(e2, e1));
                        DecisionNode decNode = new DecisionNode(decLit);
                        decNode.appendPositive(new LeafNode(new Conjunction<>(decLit)));
                        node.replaceBy(decNode);
                        node = decNode.getNegative();
                    } else if (!e1.isInit() && !e2.isInit()) {
                        coEdges.add(new Edge(e1, e2));
                    }
                }
            }
        }
        possibleCoEdges.values().removeIf(Collection::isEmpty);
        return node;
    }

}
