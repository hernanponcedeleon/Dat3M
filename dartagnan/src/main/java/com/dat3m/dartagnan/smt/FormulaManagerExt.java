package com.dat3m.dartagnan.smt;

import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableList;
import org.sosy_lab.java_smt.api.*;

import java.util.List;
import java.util.stream.IntStream;

/*
    Enriches JavaSMT's FormulaManager with
        - new theories (TupleFormulaManager)
        - utility functions
 */
public class FormulaManagerExt {

    private final FormulaManager fmgr;
    private final TupleFormulaManager tmgr;

    public FormulaManagerExt(FormulaManager fmgr) {
        this.fmgr = fmgr;
        this.tmgr = new TupleFormulaManager(this);
    }

    public FormulaManager getUnderlyingFormulaManager() { return fmgr; }
    public BooleanFormulaManager getBooleanFormulaManager() { return fmgr.getBooleanFormulaManager(); }
    public IntegerFormulaManager getIntegerFormulaManager() { return fmgr.getIntegerFormulaManager(); }
    public BitvectorFormulaManager getBitvectorFormulaManager() { return fmgr.getBitvectorFormulaManager(); }
    public TupleFormulaManager getTupleFormulaManager() { return tmgr; }

    // ====================================================================================================
    // Convenience

    public String escape(String varName) {
        return fmgr.escape(varName);
    }

    // ====================================================================================================
    // Utility

    public boolean hasSameType(Formula left, Formula right) {
        if (left instanceof NumeralFormula.IntegerFormula && right instanceof NumeralFormula.IntegerFormula) {
            return true;
        } else if (left instanceof BooleanFormula && right instanceof BooleanFormula) {
            return true;
        } else if (left instanceof BitvectorFormula x && right instanceof BitvectorFormula y) {
            final BitvectorFormulaManager bvmgr = getBitvectorFormulaManager();
            return bvmgr.getLength(x) == bvmgr.getLength(y);
        } else if (left instanceof TupleFormula x && right instanceof TupleFormula y) {
            if (x.elements.size() != y.elements.size()) {
                return false;
            }
            return IntStream.range(0, x.elements.size()).allMatch(
                    i -> hasSameType(x.elements.get(i), y.elements.get(i))
            );
        }

        return false;
    }

    public BooleanFormula equal(Formula left, Formula right) {
        Preconditions.checkArgument(hasSameType(left, right));

        if (left instanceof NumeralFormula.IntegerFormula l) {
            return getIntegerFormulaManager().equal(l, (NumeralFormula.IntegerFormula) right);
        } else if (left instanceof BitvectorFormula l) {
            return getBitvectorFormulaManager().equal(l, (BitvectorFormula) right);
        } else if (left instanceof BooleanFormula l) {
            return getBooleanFormulaManager().equivalence(l, (BooleanFormula) right);
        } else if (left instanceof TupleFormula l && right instanceof TupleFormula r) {
            Preconditions.checkArgument(l.elements.size() == r.elements.size());
            final BooleanFormulaManager bmgr = getBooleanFormulaManager();
            return IntStream.range(0, l.elements.size())
                    .mapToObj(i -> equal(l.elements.get(i), r.elements.get(i)))
                    .reduce(bmgr.makeTrue(), bmgr::and);
        }

        throw new UnsupportedOperationException(String.format("Unknown types for equal(%s, %s)", left, right));
    }

    @SuppressWarnings("unchecked")
    public <TFormula extends Formula> TFormula ifThenElse(BooleanFormula guard, TFormula thenF, TFormula elseF) {
        Preconditions.checkArgument(hasSameType(thenF, elseF));

        if (thenF instanceof TupleFormula thenT && elseF instanceof TupleFormula elseT) {
            final List<Formula> inner = IntStream.range(0, thenT.elements.size())
                    .mapToObj(i -> ifThenElse(guard, thenT.elements.get(i), elseT.elements.get(i)))
                    .collect(ImmutableList.toImmutableList());
            return (TFormula) getTupleFormulaManager().makeTuple(inner);
        }

        return getBooleanFormulaManager().ifThenElse(guard, thenF, elseF);
    }

}
