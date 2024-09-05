package com.dat3m.dartagnan.solver.onlineCaatTest.caat.constraints;


import com.dat3m.dartagnan.solver.onlineCaatTest.caat.domain.Domain;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.misc.DenseIntegerSet;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.misc.MediumDenseIntegerSet;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.misc.ObjectPool;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.misc.PathAlgorithm;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.Derivable;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.misc.MaterializedSubgraphView;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.relationGraphs.RelationGraph;
import com.google.common.base.Preconditions;
import com.google.common.collect.Sets;

import java.util.*;

public class AcyclicityConstraint extends AbstractConstraint {
    static int counter = 0;

    private int thisCounter;

    private final RelationGraph constrainedGraph;

    private static final ObjectPool<DenseIntegerSet> SET_COLLECTION_POOL =
            new ObjectPool<>(DenseIntegerSet::new, 10);


    private final List<DenseIntegerSet> violatingSccs = new ArrayList<>();
    private final MediumDenseIntegerSet markedNodes = new MediumDenseIntegerSet();
    private ArrayList<Node> nodeMap = new ArrayList<>();

    public AcyclicityConstraint(RelationGraph constrainedGraph) {
        thisCounter = counter++;
        this.constrainedGraph = constrainedGraph;
    }

    @Override
    public RelationGraph getConstrainedPredicate() {
        return constrainedGraph;
    }

    @Override
    public boolean checkForViolations() {
        if (!violatingSccs.isEmpty()) {
            return true;
        } else if (markedNodes.isEmpty()) {
            return false;
        }
        ensureCapacity();
        tarjan();
        violatingSccs.sort(Comparator.comparingInt(Set::size));
        if (violatingSccs.isEmpty()) {
            markedNodes.clear();
        }
        return !violatingSccs.isEmpty();
    }

    @Override
    public List<List<Edge>> getViolations() {
        if (violatingSccs.isEmpty()) {
            return Collections.emptyList();
        }
        //System.out.println("NEW CALL");

        List<List<Edge>> cycles = new ArrayList<>();
        // Current implementation: For all marked events <e> in all SCCs:
        // (1) find a shortest path C from <e> to <e> (=cycle)
        // (2) remove all nodes in C from the search space (those nodes are likely to give the same cycle)
        // (3) remove chords and normalize cycle order (starting from element with smallest id)
        //System.out.println("NEW SCC");
        for (Set<Integer> scc : violatingSccs) {
            MaterializedSubgraphView subgraph = new MaterializedSubgraphView(constrainedGraph, scc);
            Set<Integer> nodes = new HashSet<>(Sets.intersection(scc, markedNodes));
            while (!nodes.isEmpty()) {
                int e = nodes.stream().findAny().get();

                List<Edge> cycle = PathAlgorithm.findShortestPath(subgraph, e, e);
                cycle = new ArrayList<>(cycle);
                cycle.forEach(edge -> nodes.remove(edge.getFirst()));
                //TODO: Most cycles have chords, so a specialized algorithm that avoids
                // chords altogether would be great
                reduceChordsAndNormalize(cycle);
                if (!cycles.contains(cycle)) {
                    cycles.add(cycle);
                }
            }
        }

        if (cycles.isEmpty()) {
            int i = 5;
        }

        return cycles;
    }

    private void reduceChordsAndNormalize(List<Edge> cycle) {
        // Reduces chords by iteratively merging first and last edge if possible
        // Note that edges in the middle should not have chords since
        // we start with a shortest cycle rooted at some node <e>
        //TODO: after the first merge, the two nodes of the merged edge
        // both may allow further merging but we only iteratively merge one of the two.
        boolean prog;
        do {
            if (cycle.size() == 1) {
                // Self-cycles are not reducible
                return;
            }
            prog = false;
            Edge in = cycle.get(cycle.size() - 1);
            Edge out = cycle.get(0);
            Edge chord = constrainedGraph.get(new Edge(in.getFirst(), out.getSecond()));
            if (chord != null) {
                cycle.remove(cycle.size() - 1);
                cycle.set(0, chord);
                prog = true;
            }
        } while (prog);

        // Normalize
        int first = 0;
        int minId = Integer.MAX_VALUE;
        int counter = 0;
        for (Edge e : cycle) {
            if (e.getFirst() < minId) {
                minId = e.getFirst();
                first = counter;
            }
            counter++;
        }
        Collections.rotate(cycle, -first);
    }

    //private final ArrayList<Integer> toAdd = new ArrayList<>();

    private void ensureCapacity() {
        markedNodes.ensureCapacity(domain.size());
        while (nodeMap.size() < domain.size()) {
            nodeMap.add(new Node(nodeMap.size()));
        }
    }

    @Override
    @SuppressWarnings("unchecked")
    public void onChanged(CAATPredicate predicate, Collection<? extends Derivable> added) {
        for (Edge e : (Collection<Edge>)added) {
            markedNodes.ensureCapacity(domain.size());
            markedNodes.add(e.getFirst());
        }
    }

    @Override
    public void onPush() {
        markedNodes.increaseLevel();
    }

    @Override
    public void onBacktrack(CAATPredicate predicate, int time) {
        markedNodes.resetToLevel((short)time);

        //System.out.println("\nMarked Nodes on Backtrack in Constraint " + thisCounter + ": ");
        //System.out.println(markedNodes);
        cleanUp();
    }

    @Override
    public void onDomainInit(CAATPredicate predicate, Domain<?> domain) {
        super.onDomainInit(predicate, domain);
        cleanUp();
        int domSize = domain.size();
        markedNodes.clear();
        markedNodes.ensureCapacity(domSize);
        nodeMap = new ArrayList<>(domSize);
        for (int i = 0; i < domSize; i++) {
            nodeMap.add(i, new Node(i));
        }
    }

    @Override
    public void onPopulation(CAATPredicate predicate) {
        Preconditions.checkArgument(predicate instanceof RelationGraph, "Expected relation graph.");
        onChanged(predicate, predicate.setView());
    }

    private void cleanUp() {
        violatingSccs.forEach(SET_COLLECTION_POOL::returnToPool);
        violatingSccs.clear();
        nodeMap.clear();
    }


    // ============== Tarjan & SCCs ================

    private final Deque<Node> stack = new ArrayDeque<>();
    private int index = 0;
    private void tarjan() {
        index = 0;
        stack.clear();

        for (Node node : nodeMap) {
            node.reset();
        }

        for (Node node : nodeMap) {
            if (!node.wasVisited()) {
                strongConnect(node);
            }
        }
    }

    // The TEMP_LIST is used to temporary hold the nodes in an SCC.
    // The SCC will only actually get created if it is violating! (selfloop or size > 1)
    private static final ArrayList<Integer> TEMP_LIST = new ArrayList<>();
    private void strongConnect(Node v) {
        v.index = index;
        v.lowlink = index;
        stack.push(v);
        v.isOnStack = true;
        index++;

        for (Edge e : constrainedGraph.outEdges(v.id)) {
            Node w = nodeMap.get(e.getSecond());
            if (!w.wasVisited()) {
                strongConnect(w);
                v.lowlink = Math.min(v.lowlink, w.lowlink);
            } else if (w.isOnStack) {
                v.lowlink = Math.min(v.lowlink, w.index);
            }

            if (w == v) {
                v.hasSelfLoop = true;
            }
        }


        if (v.lowlink == v.index) {
            Node w;
            do {
                w = stack.pop();
                w.isOnStack = false;
                TEMP_LIST.add(w.id);
            } while (w != v);

            if (v.hasSelfLoop || TEMP_LIST.size() > 1) {
                DenseIntegerSet scc = SET_COLLECTION_POOL.get();
                scc.ensureCapacity(domain.size());
                scc.clear();
                scc.addAll(TEMP_LIST);
                violatingSccs.add(scc);
            }
            TEMP_LIST.clear();
        }
    }

    private static class Node {
        final int id;

        boolean hasSelfLoop = false;
        boolean isOnStack = false;
        int index = -1;
        int lowlink = -1;

        public Node(int id) {
            this.id = id;
        }

        boolean wasVisited() {
            return index != -1;
        }

        public void reset() {
            hasSelfLoop = false;
            isOnStack = false;
            index = -1;
            lowlink = -1;
        }

        @Override
        public String toString() {
            return Integer.toString(id);
        }
    }
}