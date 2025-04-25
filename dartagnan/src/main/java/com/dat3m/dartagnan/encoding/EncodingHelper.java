package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.encoding.formulas.TupleFormula;
import com.dat3m.dartagnan.encoding.formulas.TupleValue;
import com.dat3m.dartagnan.expression.integers.IntCmpOp;
import com.google.common.base.Preconditions;
import org.sosy_lab.java_smt.api.*;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.IntStream;

/*
    This class provides general-purpose functionality for SMT formulas.

    TODO: This class should probably be extended to wrap a SolverContext
          and basically enrich it with new custom theories (see TupleFormulaManager)
          and convenience functions.
 */
public class EncodingHelper {

    private final FormulaManager fmgr;

    public EncodingHelper(FormulaManager fmgr) {
        this.fmgr = fmgr;
    }

    public EncodingHelper(EncodingContext ctx) {
        this(ctx.getFormulaManager());
    }

    // ====================================================================================
    // Dynamic conversion

    public enum ConversionMode {
        NO,
        LEFT_TO_RIGHT,
        RIGHT_TO_LEFT,
    }

    public BooleanFormula equal(Formula left, Formula right, ConversionMode cMode) {
        if (cMode == ConversionMode.LEFT_TO_RIGHT) {
            return equal(right, left, ConversionMode.RIGHT_TO_LEFT);
        } else if (cMode == ConversionMode.NO && !hasSameType(left, right)) {
            final String error = String.format("Mismatching formula types: %s and %s", left, right);
            throw new IllegalArgumentException(error);
        }

        if (left instanceof IntegerFormula l) {
            final IntegerFormulaManager imgr = fmgr.getIntegerFormulaManager();
            return imgr.equal(l, toInteger(right));
        } else if (left instanceof BitvectorFormula l) {
            final BitvectorFormulaManager bvmgr = fmgr.getBitvectorFormulaManager();
            return bvmgr.equal(l, toBitvector(right, bvmgr.getLength(l)));
        } else if (left instanceof BooleanFormula l) {
            return fmgr.getBooleanFormulaManager().equivalence(l, toBoolean(right));
        } else if (left instanceof TupleFormula l && right instanceof TupleFormula r) {
            Preconditions.checkArgument(l.getElements().size() == r.getElements().size());
            final BooleanFormulaManager bmgr = fmgr.getBooleanFormulaManager();
            final List<BooleanFormula> enc = new ArrayList<>();
            for (int i = 0; i < l.getElements().size(); i++) {
                enc.add(equal(l.getElements().get(i), r.getElements().get(i), cMode));
            }
            return bmgr.and(enc);
        }

        throw new UnsupportedOperationException(String.format("Unknown types for equal(%s,%s)", left, right));
    }

    public BooleanFormula equal(Formula left, Formula right) {
        return equal(left, right, ConversionMode.NO);
    }

    public IntegerFormula toInteger(Formula formula) {
        if (formula instanceof IntegerFormula f) {
            return f;
        }
        if (formula instanceof BooleanFormula f) {
            IntegerFormulaManager imgr = fmgr.getIntegerFormulaManager();
            IntegerFormula zero = imgr.makeNumber(0);
            IntegerFormula one = imgr.makeNumber(1);
            return fmgr.getBooleanFormulaManager().ifThenElse(f, one, zero);
        }
        if (formula instanceof BitvectorFormula f) {
            return fmgr.getBitvectorFormulaManager().toIntegerFormula(f, false);
        }
        throw new UnsupportedOperationException(String.format("Unknown type for toInteger(%s).", formula));
    }

    public BooleanFormula toBoolean(Formula formula) {
        if (formula instanceof BooleanFormula f) {
            return f;
        }
        return fmgr.getBooleanFormulaManager().not(equalZero(formula));
    }

    public BitvectorFormula toBitvector(Formula formula, int length) {
        BitvectorFormulaManager bvmgr = fmgr.getBitvectorFormulaManager();
        if (formula instanceof BitvectorFormula f) {
            int formulaLength = bvmgr.getLength(f);
            // FIXME: Signedness may be wrong here.
            return formulaLength >= length ?
                    bvmgr.extract(f, length - 1, 0)
                    : bvmgr.extend(f, length - formulaLength, false);
        }
        if (formula instanceof BooleanFormula f) {
            final BitvectorFormula zero = bvmgr.makeBitvector(length, 0);
            final BitvectorFormula one = bvmgr.makeBitvector(length, 1);
            return fmgr.getBooleanFormulaManager().ifThenElse(f, one, zero);
        }
        throw new UnsupportedOperationException(String.format("Unknown type for toBitvector(%s,%s).", formula, length));
    }

    public BooleanFormula equalZero(Formula formula) {
        if (formula instanceof BooleanFormula f) {
            return fmgr.getBooleanFormulaManager().not(f);
        }
        if (formula instanceof IntegerFormula f) {
            IntegerFormulaManager imgr = fmgr.getIntegerFormulaManager();
            return imgr.equal(f, imgr.makeNumber(0));
        }
        if (formula instanceof BitvectorFormula f) {
            BitvectorFormulaManager bvmgr = fmgr.getBitvectorFormulaManager();
            return bvmgr.equal(f, bvmgr.makeBitvector(bvmgr.getLength(f), 0));
        }
        throw new UnsupportedOperationException(String.format("Unknown type for equalZero(%s).", formula));
    }

    // ====================================================================================


    public BooleanFormula encodeComparison(IntCmpOp op, Formula lhs, Formula rhs) {
        if (lhs instanceof BooleanFormula l && rhs instanceof BooleanFormula r) {
            BooleanFormulaManager bmgr = fmgr.getBooleanFormulaManager();
            return switch (op) {
                case EQ -> bmgr.equivalence(l, r);
                case NEQ -> bmgr.not(bmgr.equivalence(l, r));
                default -> throw new UnsupportedOperationException(
                        String.format("Encoding of IntCmpOp operation %s not supported on boolean formulas.", op));
            };
        }
        if (lhs instanceof IntegerFormula l && rhs instanceof IntegerFormula r) {
            IntegerFormulaManager imgr = fmgr.getIntegerFormulaManager();
            return switch (op) {
                case EQ -> imgr.equal(l, r);
                case NEQ -> fmgr.getBooleanFormulaManager().not(imgr.equal(l, r));
                case LT, ULT -> imgr.lessThan(l, r);
                case LTE, ULTE -> imgr.lessOrEquals(l, r);
                case GT, UGT -> imgr.greaterThan(l, r);
                case GTE, UGTE -> imgr.greaterOrEquals(l, r);
            };
        }
        if (lhs instanceof BitvectorFormula l && rhs instanceof BitvectorFormula r) {
            BitvectorFormulaManager bvmgr = fmgr.getBitvectorFormulaManager();
            return switch (op) {
                case EQ -> bvmgr.equal(l, r);
                case NEQ -> fmgr.getBooleanFormulaManager().not(bvmgr.equal(l, r));
                case LT, ULT -> bvmgr.lessThan(l, r, op.equals(IntCmpOp.LT));
                case LTE, ULTE -> bvmgr.lessOrEquals(l, r, op.equals(IntCmpOp.LTE));
                case GT, UGT -> bvmgr.greaterThan(l, r, op.equals(IntCmpOp.GT));
                case GTE, UGTE -> bvmgr.greaterOrEquals(l, r, op.equals(IntCmpOp.GTE));
            };
        }
        throw new UnsupportedOperationException("Encoding not supported for IntCmpOp: " + lhs + " " + op + " " + rhs);
    }

    public Formula add(Formula left, Formula right) {
        if (left instanceof IntegerFormula iLeft && right instanceof IntegerFormula iRight) {
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
        if (left instanceof IntegerFormula iLeft && right instanceof IntegerFormula iRight) {
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
        if (left instanceof IntegerFormula iLeft && right instanceof IntegerFormula iRight) {
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

    public boolean hasSameType(Formula left, Formula right) {
        if (left instanceof IntegerFormula && right instanceof IntegerFormula) {
            return true;
        } else if (left instanceof BooleanFormula && right instanceof BooleanFormula) {
            return true;
        } else if (left instanceof BitvectorFormula x && right instanceof BitvectorFormula y) {
            final BitvectorFormulaManager bvmgr = fmgr.getBitvectorFormulaManager();
            return bvmgr.getLength(x) == bvmgr.getLength(y);
        } else if (left instanceof TupleFormula x && right instanceof TupleFormula y) {
            if (x.getElements().size() != y.getElements().size()) {
                return false;
            }
            return IntStream.range(0, x.getElements().size()).allMatch(
                    i -> hasSameType(x.getElements().get(i), y.getElements().get(i))
            );
        }

        return false;
    }


    // ======================================== Static utility ========================================

    public static Object evaluate(Formula f, Model model) {
        if (f instanceof TupleFormula tf) {
            return evaluate(tf, model);
        }
        return model.evaluate(f);
    }

    public static TupleValue evaluate(TupleFormula tupleFormula, Model model) {
        return new TupleValue(tupleFormula.getElements().stream().map(v -> evaluate(v, model)).toList());
    }
}
