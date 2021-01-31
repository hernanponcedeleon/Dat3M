package com.dat3m.dartagnan.wmm.graphRefinement.resolution;

import com.dat3m.dartagnan.wmm.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.wmm.graphRefinement.logic.Conjunction;

import java.util.ArrayList;
import java.util.List;

public class LeafNode extends SearchNode {
    List<Conjunction<CoreLiteral>> violations;

    public LeafNode() {
        violations = new ArrayList<>();
    }
}
