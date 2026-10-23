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
    private final EncodingUtils encUtils;

    public FormulaManagerExt(FormulaManager fmgr) {
        this.fmgr = fmgr;
        this.tmgr = new TupleFormulaManager(this);
        this.encUtils = new EncodingUtils(this);
    }

    public FormulaManager getUnderlyingFormulaManager() { return fmgr; }
    public BooleanFormulaManager getBooleanFormulaManager() { return fmgr.getBooleanFormulaManager(); }
    public IntegerFormulaManager getIntegerFormulaManager() { return fmgr.getIntegerFormulaManager(); }
    public BitvectorFormulaManager getBitvectorFormulaManager() { return fmgr.getBitvectorFormulaManager(); }
    public FloatingPointFormulaManager getFloatingPointFormulaManager() { return fmgr.getFloatingPointFormulaManager(); }
    public TupleFormulaManager getTupleFormulaManager() { return tmgr; }

    // ====================================================================================================
    // Convenience

    public String escape(String varName) {
        return fmgr.escape(varName);
    }

    // ====================================================================================================
    // Utility

    public EncodingUtils getEncodingUtils() { return encUtils; }

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

        return switch (left) {
            case NumeralFormula.IntegerFormula l -> getIntegerFormulaManager().equal(l, (NumeralFormula.IntegerFormula) right);
            case BitvectorFormula l -> getBitvectorFormulaManager().equal(l, (BitvectorFormula) right);
            case BooleanFormula l -> getBooleanFormulaManager().equivalence(l, (BooleanFormula) right);
            case TupleFormula l when right instanceof TupleFormula r -> {
                Preconditions.checkArgument(l.elements.size() == r.elements.size());
                final BooleanFormulaManager bmgr = getBooleanFormulaManager();
                yield IntStream.range(0, l.elements.size())
                        .mapToObj(i -> equal(l.elements.get(i), r.elements.get(i)))
                        .reduce(bmgr.makeTrue(), bmgr::and);
            }
            default -> throw new UnsupportedOperationException(String.format("Unknown types for equal(%s, %s)", left, right));
        };
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