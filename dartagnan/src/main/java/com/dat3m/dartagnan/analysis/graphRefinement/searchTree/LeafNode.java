package com.dat3m.dartagnan.analysis.graphRefinement.searchTree;

import com.dat3m.dartagnan.analysis.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.analysis.graphRefinement.logic.Conjunction;

import java.util.ArrayList;
import java.util.List;

public class LeafNode extends SearchNode {
    List<Conjunction<CoreLiteral>> violations;

    public LeafNode(List<Conjunction<CoreLiteral>> violations) {
        this.violations = violations;
    }

    public List<Conjunction<CoreLiteral>> getViolations() {
        return violations;
    }

    @Override
    protected SearchNode copy() {
        return new LeafNode(new ArrayList<>(violations));
    }
}
