package com.dat3m.dartagnan.encoding.formulas;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.google.common.base.Preconditions;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.Formula;

import java.util.ArrayList;
import java.util.List;


/*
    Note: This class cannot actually create variables of tuple type and merely gives the illusion of
    a proper tuple theory.
    To simulate tuple variables, the user instead has to construct tuples of variables.
 */
public final class TupleFormulaManager {

    private final EncodingContext context;

    public TupleFormulaManager(EncodingContext context) {
        this.context = context;

    }

    public BooleanFormula equal(TupleFormula x, TupleFormula y) {
        Preconditions.checkArgument(x.elements.size() == y.elements.size());
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        final List<BooleanFormula> enc = new ArrayList<>();
        for (int i = 0; i < x.elements.size(); i++) {
            enc.add(context.equal(x.elements.get(i), y.elements.get(i)));;
        }
        return bmgr.and(enc);
    }

    public Formula extract(TupleFormula f, int index) {
        Preconditions.checkArgument(0 <= index && index < f.elements.size());
        return f.elements.get(index);
    }

    public TupleFormula makeTuple(List<Formula> elements) {
        return new TupleFormula(elements);
    }
}
