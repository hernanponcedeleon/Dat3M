package com.dat3m.dartagnan.wmm.graphRefinement.analysis;

import com.dat3m.dartagnan.wmm.graphRefinement.decoration.RelationData;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.RelationMap;

import java.util.*;

public class DependencyAnalysis {
    private List<RelationData> relDataList;
    private Map<RelationData, Node> nodeMap;

    public List<RelationData> getRelationDataList() {
        return relDataList;
    }

    public DependencyAnalysis(RelationMap relMap) {
        nodeMap = new HashMap<>();
        for (RelationData relData : relMap.getRelationValues()) {
            nodeMap.put(relData, new Node(relData));
        }
        for (RelationData relData : relMap.getAxiomValues()) {
            nodeMap.put(relData, new Node(relData));
        }
        tarjan();
    }

    // ================== Tarjan's Algorithm for computing topological ordering + SCC ================

    private int index;
    private int topIndex;
    private Stack<Node> stack = new Stack<>();
    private void tarjan() {
        index = 0;
        topIndex = -1;
        stack.clear();

        for (Node node : nodeMap.values()) {
            if (!node.wasVisited())
                strongConnect(node);
        }

        // Tarjan finds reverse topological ordering, so we put it into standard order
        for (Node node : nodeMap.values()) {
            node.data.setTopologicalIndex(topIndex - node.data.getTopologicalIndex());
        }

        // Create sorted list of all relation data
        // and sort their dependencies/dependents as well
        Comparator<RelationData> cmp = Comparator.comparingInt(x -> x.getTopologicalIndex());
        relDataList = new ArrayList<>(nodeMap.keySet());
        relDataList.sort(cmp);
        for (RelationData relData : relDataList){
            relData.getDependencies().sort(cmp);
            relData.getDependents().sort(cmp);
        }

    }

    private void strongConnect(Node v) {
        v.index = index;
        v.lowlink = index;
        stack.push(v);
        v.isOnStack = true;
        index++;

        for (RelationData wData : v.data.getDependents()) {
            Node w = nodeMap.get(wData);
            if (!w.wasVisited()) {
                strongConnect(w);
                v.lowlink = Math.min(v.lowlink, w.lowlink);
            }
            else if (w.isOnStack)
                v.lowlink = Math.min(v.lowlink, w.index);
        }


        if (v.lowlink == v.index) {
            Set<RelationData> scc = new HashSet<>();
            v.data.setTopologicalIndex(++topIndex);
            Node w;
            do {
                w = stack.pop();
                w.isOnStack = false;
                scc.add(w.data);
                w.data.setSCC(scc);
                w.data.setTopologicalIndex( v.data.getTopologicalIndex());
            } while (w != v);
        }
    }

    private class Node {
        RelationData data;
        boolean isOnStack = false;
        int index = -1;
        int lowlink = -1;

        boolean wasVisited() {
            return index != -1;
        }

        public Node(RelationData data) {
            this.data = data;
        }
    }

}
