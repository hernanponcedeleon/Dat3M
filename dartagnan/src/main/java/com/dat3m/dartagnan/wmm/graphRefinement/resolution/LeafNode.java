package com.dat3m.dartagnan.wmm.graphRefinement.resolution;

import com.dat3m.dartagnan.wmm.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.wmm.graphRefinement.logic.Conjunction;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class LeafNode extends SearchNode {
    List<Conjunction<CoreLiteral>> violations;

    public LeafNode() {
        violations = new ArrayList<>();
    }

    public LeafNode(List<Conjunction<CoreLiteral>> violations) {
        this.violations = violations;
    }

    public LeafNode(Conjunction<CoreLiteral>... violations) {
        this(new ArrayList<>(Arrays.asList(violations)));
    }
}
