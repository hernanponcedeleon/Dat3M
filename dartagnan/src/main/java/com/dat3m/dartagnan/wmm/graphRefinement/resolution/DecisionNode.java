package com.dat3m.dartagnan.wmm.graphRefinement.resolution;

import com.dat3m.dartagnan.wmm.graphRefinement.coreReason.CoreLiteral;

public class DecisionNode extends SearchNode {
    CoreLiteral chosenLiteral;
    SearchNode positive;
    SearchNode negative;

    public SearchNode getPositive() { return positive; }
    public SearchNode getNegative() { return negative; }


    public DecisionNode(CoreLiteral choiceLiteral) {
        this.chosenLiteral = choiceLiteral;
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

}
