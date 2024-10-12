package com.dat3m.dartagnan.encoding;

import com.google.common.base.Preconditions;
import org.sosy_lab.java_smt.api.*;

import java.math.BigInteger;

public class EncodingHelper {

    private final FormulaManager fmgr;

    public EncodingHelper(FormulaManager fmgr) {
        this.fmgr = fmgr;
    }

    public BooleanFormula equals(Formula left, Formula right) {
        if (left instanceof NumeralFormula.IntegerFormula iLeft && right instanceof NumeralFormula.IntegerFormula iRight) {
            return fmgr.getIntegerFormulaManager().equal(iLeft, iRight);
        }

        if (left instanceof BitvectorFormula bvLeft && right instanceof BitvectorFormula bvRight) {
            final BitvectorFormulaManager bvmgr = fmgr.getBitvectorFormulaManager();
            Preconditions.checkState(bvmgr.getLength(bvLeft) == bvmgr.getLength(bvRight));
            return fmgr.getBitvectorFormulaManager().equal(bvLeft, bvRight);
        }

        throw new UnsupportedOperationException("Mismatching types: " + left + " and " + right);
    }

    public BooleanFormula greaterThan(Formula left, Formula right, boolean signed) {
        if (left instanceof NumeralFormula.IntegerFormula iLeft && right instanceof NumeralFormula.IntegerFormula iRight) {
            return fmgr.getIntegerFormulaManager().greaterThan(iLeft, iRight);
        }

        if (left instanceof BitvectorFormula bvLeft && right instanceof BitvectorFormula bvRight) {
            final BitvectorFormulaManager bvmgr = fmgr.getBitvectorFormulaManager();
            Preconditions.checkState(bvmgr.getLength(bvLeft) == bvmgr.getLength(bvRight));
            return fmgr.getBitvectorFormulaManager().greaterThan(bvLeft, bvRight, signed);
        }

        throw new UnsupportedOperationException("Mismatching types: " + left + " and " + right);
    }

    public BooleanFormula greaterOrEquals(Formula left, Formula right, boolean signed) {
        if (left instanceof NumeralFormula.IntegerFormula iLeft && right instanceof NumeralFormula.IntegerFormula iRight) {
            return fmgr.getIntegerFormulaManager().greaterOrEquals(iLeft, iRight);
        }

        if (left instanceof BitvectorFormula bvLeft && right instanceof BitvectorFormula bvRight) {
            final BitvectorFormulaManager bvmgr = fmgr.getBitvectorFormulaManager();
            Preconditions.checkState(bvmgr.getLength(bvLeft) == bvmgr.getLength(bvRight));
            return fmgr.getBitvectorFormulaManager().greaterOrEquals(bvLeft, bvRight, signed);
        }

        throw new UnsupportedOperationException("Mismatching types: " + left + " and " + right);
    }

    public Formula add(Formula left, Formula right) {
        if (left instanceof NumeralFormula.IntegerFormula iLeft && right instanceof NumeralFormula.IntegerFormula iRight) {
            return fmgr.getIntegerFormulaManager().add(iLeft, iRight);
        }

        if (left instanceof BitvectorFormula bvLeft && right instanceof BitvectorFormula bvRight) {
            final BitvectorFormulaManager bvmgr = fmgr.getBitvectorFormulaManager();
            Preconditions.checkState(bvmgr.getLength(bvLeft) == bvmgr.getLength(bvRight));
            return fmgr.getBitvectorFormulaManager().add(bvLeft, bvRight);
        }

        throw new UnsupportedOperationException("Mismatching types: " + left + " and " + right);
    }

    public Formula subtract(Formula left, Formula right) {
        if (left instanceof NumeralFormula.IntegerFormula iLeft && right instanceof NumeralFormula.IntegerFormula iRight) {
            return fmgr.getIntegerFormulaManager().subtract(iLeft, iRight);
        }

        if (left instanceof BitvectorFormula bvLeft && right instanceof BitvectorFormula bvRight) {
            final BitvectorFormulaManager bvmgr = fmgr.getBitvectorFormulaManager();
            Preconditions.checkState(bvmgr.getLength(bvLeft) == bvmgr.getLength(bvRight));
            return fmgr.getBitvectorFormulaManager().subtract(bvLeft, bvRight);
        }

        throw new UnsupportedOperationException("Mismatching types: " + left + " and " + right);
    }

    public Formula remainder(Formula left, Formula right) {
        //FIXME: integer modulo and BV modulo have different semantics, the former is always positive, the latter
        // returns a value whose sign depends on one of the two BVs.
        // The results in this implementation will match if the denominator <right> is positive which is the most usual case.
        if (left instanceof NumeralFormula.IntegerFormula iLeft && right instanceof NumeralFormula.IntegerFormula iRight) {
            return fmgr.getIntegerFormulaManager().modulo(iLeft, iRight);
        }

        if (left instanceof BitvectorFormula bvLeft && right instanceof BitvectorFormula bvRight) {
            final BitvectorFormulaManager bvmgr = fmgr.getBitvectorFormulaManager();
            Preconditions.checkState(bvmgr.getLength(bvLeft) == bvmgr.getLength(bvRight));
            return fmgr.getBitvectorFormulaManager().smodulo(bvLeft, bvRight);
        }

        throw new UnsupportedOperationException("Mismatching types: " + left + " and " + right);
    }

    public Formula value(BigInteger value, FormulaType<?> type) {
        if (type.isIntegerType()) {
            return fmgr.getIntegerFormulaManager().makeNumber(value);
        } else if (type.isBitvectorType()) {
            int size = getBitSize(type);
            return fmgr.getBitvectorFormulaManager().makeBitvector(size, value);
        }
        throw new UnsupportedOperationException("Cannot generate value of type " + type);
    }

    public int getBitSize(FormulaType<?> type) {
        if (type.isIntegerType()) {
            return -1;
        } else if (type.isBitvectorType()) {
            return ((FormulaType.BitvectorType)type).getSize();
        }
        throw new UnsupportedOperationException("Cannot get bit-size for type " + type);
    }

    public FormulaType<?> typeOf(Formula formula) {
        return fmgr.getFormulaType(formula);
    }
}
