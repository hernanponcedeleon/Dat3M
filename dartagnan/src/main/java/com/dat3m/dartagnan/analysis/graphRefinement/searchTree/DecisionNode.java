package com.dat3m.dartagnan.analysis.graphRefinement.searchTree;

import com.dat3m.dartagnan.verification.model.Edge;

public class DecisionNode extends SearchNode {
    Edge edge;
    SearchNode positive;
    SearchNode negative;

    public Edge getEdge() { return edge; }
    public SearchNode getPositive() { return positive; }
    public SearchNode getNegative() { return negative; }


    public DecisionNode(Edge edge) {
        this.edge = edge;
        positive = new EmptyNode();
        negative = new EmptyNode();
        positive.setParent(this);
        negative.setParent(this);
    }

    public void appendPositive(SearchNode node) {
        positive = node;
        node.parent = this;
    }

    public void appendNegative(SearchNode node) {
        negative = node;
        node.parent = this;
    }

    @Override
    protected SearchNode copy() {
        DecisionNode copy = new DecisionNode(edge);
        copy.positive.replaceBy(positive.copy());
        copy.negative.replaceBy(negative.copy());
        return copy;
    }
}
