package com.dat3m.dartagnan.analysis.graphRefinement.searchTree;

import java.util.ArrayList;
import java.util.List;
import java.util.function.Predicate;

public abstract class SearchNode {
    protected DecisionNode parent;

    public DecisionNode getParent() {
        return parent;
    }

    void setParent(DecisionNode parent) {
        this.parent = parent;
    }

    public boolean isRoot() {
        return parent == null || parent.getClass() == FakeRoot.class;
    }

    public boolean isLeaf() {
        return this.getClass() == LeafNode.class;
    }

    public boolean isDecisionNode() {
        return this.getClass() == DecisionNode.class;
    }

    public boolean isEmptyNode() {
        return this.getClass() == EmptyNode.class;
    }

    public SearchNode replaceBy(SearchNode newNode) {
        newNode.setParent(parent);
        if (parent != null) {
            if (parent.positive == this) {
                parent.positive = newNode;
            } else {
                parent.negative = newNode;
            }
        }
        return newNode;
    }

    public SearchNode delete() {
        return this.isEmptyNode() ? this : replaceBy(new EmptyNode());
    }


    public List<? extends SearchNode> findNodes(Predicate<SearchNode> pred) {
        List<SearchNode> foundNodes = new ArrayList<>();
        findNodesRecursive(pred, foundNodes);
        return foundNodes;
    }


    private void findNodesRecursive(Predicate<SearchNode> pred, List<SearchNode> foundNodes) {
        if (pred.test(this)) {
            foundNodes.add(this);
        }
        if (this.isDecisionNode()) {
            DecisionNode decNode = (DecisionNode)this;
            decNode.positive.findNodesRecursive(pred, foundNodes);
            decNode.negative.findNodesRecursive(pred, foundNodes);
        }
    }

    protected abstract SearchNode copy();

}
