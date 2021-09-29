package com.dat3m.dartagnan.analysis.saturation.searchTree;

import com.dat3m.dartagnan.analysis.saturation.logic.Conjunction;
import com.dat3m.dartagnan.analysis.saturation.reasoning.CoreLiteral;

import java.util.ArrayList;
import java.util.List;

public class LeafNode extends SearchNode {
    List<Conjunction<CoreLiteral>> inconsistencyReasons;

    public LeafNode(List<Conjunction<CoreLiteral>> inconsistencyReasons) {
        this.inconsistencyReasons = inconsistencyReasons;
    }

    public List<Conjunction<CoreLiteral>> getInconsistencyReasons() {
        return inconsistencyReasons;
    }

    @Override
    protected SearchNode copy() {
        return new LeafNode(new ArrayList<>(inconsistencyReasons));
    }
}
