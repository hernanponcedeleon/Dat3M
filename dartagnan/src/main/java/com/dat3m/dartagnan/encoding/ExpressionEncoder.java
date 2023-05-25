package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.GlobalSettings;
import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.expression.op.IOpUn;
import com.dat3m.dartagnan.program.NondeterministicExpression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.expression.*;
import com.dat3m.dartagnan.program.expression.type.*;
import com.dat3m.dartagnan.program.memory.Location;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import org.sosy_lab.java_smt.api.*;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;

import java.util.OptionalInt;

import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Preconditions.checkState;
import static java.util.Arrays.asList;

class ExpressionEncoder implements ExpressionVisitor<Formula> {

    private final int precision;
    private final FormulaManager formulaManager;
    private final BooleanFormulaManager booleanFormulaManager;
    private final Event event;

    ExpressionEncoder(int precision, FormulaManager formulaManager, Event event) {
        checkArgument(precision >= -1, "Unknown option value %s", precision);
        this.precision = precision;
        this.formulaManager = formulaManager;
        this.booleanFormulaManager = formulaManager.getBooleanFormulaManager();
        this.event = event;
    }

    private IntegerFormulaManager integerFormulaManager() {
        return formulaManager.getIntegerFormulaManager();
    }

    private BitvectorFormulaManager bitvectorFormulaManager() {
        return formulaManager.getBitvectorFormulaManager();
    }

    BooleanFormula encodeAsBoolean(Expression expression) {
        Formula formula = expression.visit(this);
        if (formula instanceof BooleanFormula) {
            return (BooleanFormula) formula;
        }
        if (formula instanceof BitvectorFormula) {
            BitvectorFormulaManager bitvectorFormulaManager = bitvectorFormulaManager();
            int length = bitvectorFormulaManager.getLength((BitvectorFormula) formula);
            BitvectorFormula zero = bitvectorFormulaManager.makeBitvector(length, 0);
            return bitvectorFormulaManager.greaterThan((BitvectorFormula) formula, zero, false);
        }
        assert formula instanceof IntegerFormula;
        IntegerFormulaManager integerFormulaManager = integerFormulaManager();
        IntegerFormula zero = integerFormulaManager.makeNumber(0);
        return integerFormulaManager.greaterThan((IntegerFormula) formula, zero);
    }

    Formula encodeAsInteger(Expression expression) {
        Formula formula = expression.visit(this);
        if (formula instanceof BitvectorFormula || formula instanceof IntegerFormula) {
            return formula;
        }
        assert formula instanceof BooleanFormula;
        int precision = getArchPrecision();
        Formula one;
        Formula zero;
        if(precision > -1) {
            BitvectorFormulaManager bitvectorFormulaManager = bitvectorFormulaManager();
            one = bitvectorFormulaManager.makeBitvector(precision, 1);
            zero = bitvectorFormulaManager.makeBitvector(precision, 0);
        } else {
            IntegerFormulaManager integerFormulaManager = integerFormulaManager();
            one = integerFormulaManager.makeNumber(1);
            zero = integerFormulaManager.makeNumber(0);
        }
        return booleanFormulaManager.ifThenElse((BooleanFormula) formula, one, zero);
    }

    static BooleanFormula encodeComparison(COpBin op, Formula lhs, Formula rhs, FormulaManager fmgr) {
        BooleanFormulaManager booleanFormulaManager = fmgr.getBooleanFormulaManager();
        if (lhs instanceof BooleanFormula left && rhs instanceof BooleanFormula right) {
            return switch (op) {
                case EQ -> booleanFormulaManager.equivalence(left, right);
                case NEQ -> booleanFormulaManager.xor(left, right);
                case LT, ULT -> booleanFormulaManager.and(booleanFormulaManager.not(left), right);
                case LTE, ULTE -> booleanFormulaManager.or(booleanFormulaManager.not(left), right);
                case GT, UGT -> booleanFormulaManager.and(left, booleanFormulaManager.not(right));
                case GTE, UGTE -> booleanFormulaManager.or(left, booleanFormulaManager.not(right));
            };
        }
        if (lhs instanceof IntegerFormula left && rhs instanceof IntegerFormula right) {
            IntegerFormulaManager integerFormulaManager = fmgr.getIntegerFormulaManager();
            return switch (op) {
                case EQ -> integerFormulaManager.equal(left, right);
                case NEQ -> booleanFormulaManager.not(integerFormulaManager.equal(left, right));
                case LT, ULT -> integerFormulaManager.lessThan(left, right);
                case LTE, ULTE -> integerFormulaManager.lessOrEquals(left, right);
                case GT, UGT -> integerFormulaManager.greaterThan(left, right);
                case GTE, UGTE -> integerFormulaManager.greaterOrEquals(left, right);
            };
        }
        if (lhs instanceof BitvectorFormula left && rhs instanceof BitvectorFormula right) {
            BitvectorFormulaManager bitvectorFormulaManager = fmgr.getBitvectorFormulaManager();
            return switch (op) {
                case EQ -> bitvectorFormulaManager.equal(left, right);
                case NEQ -> booleanFormulaManager.not(bitvectorFormulaManager.equal(left, right));
                case LT, ULT -> bitvectorFormulaManager.lessThan(left, right, op.equals(COpBin.LT));
                case LTE, ULTE -> bitvectorFormulaManager.lessOrEquals(left, right, op.equals(COpBin.LTE));
                case GT, UGT -> bitvectorFormulaManager.greaterThan(left, right, op.equals(COpBin.GT));
                case GTE, UGTE -> bitvectorFormulaManager.greaterOrEquals(left, right, op.equals(COpBin.GTE));
            };
        }
        throw new UnsupportedOperationException(String.format("Encoding not supported for %s %s %s.", lhs, op, rhs));
    }

    Formula getLastMemValueExpr(MemoryObject object, int offset) {
        checkArgument(0 <= offset && offset < object.size(), "array index out of bounds");
        String name = String.format("last_val_at_%s_%d", object, offset);
        //TODO Use an analysis to infer which type should be used here.
        int length = getArchPrecision();
        if (length > -1) {
            return formulaManager.getBitvectorFormulaManager().makeVariable(length, name);
        } else {
            return formulaManager.getIntegerFormulaManager().makeVariable(name);
        }
    }

    OptionalInt getBitWidthFromIntegerType(Type type) {
        if (type instanceof BooleanType || type instanceof BoundedIntegerType bounded && bounded.getBitWidth() == 1) {
            return OptionalInt.of(1);
        }
        switch (precision) {
            case -1 -> {
                if (type instanceof PointerType) {
                    int archPrecision = GlobalSettings.getArchPrecision();
                    return archPrecision < 0 ? OptionalInt.empty() : OptionalInt.of(archPrecision);
                }
                if (type instanceof UnboundedIntegerType) {
                    return OptionalInt.empty();
                }
                assert type instanceof BoundedIntegerType;
                return OptionalInt.of(((BoundedIntegerType) type).getBitWidth());
            }
            case 0 -> {
                return OptionalInt.empty();
            }
            default -> {
                return OptionalInt.of(precision);
            }
        }
    }

    private int getArchPrecision() {
        return precision > -1 ? precision : GlobalSettings.getArchPrecision();
    }

    @Override
    public Formula visit(Comparison comparison) {
        Formula lhs = encodeAsInteger(comparison.getLHS());
        Formula rhs = encodeAsInteger(comparison.getRHS());
        return encodeComparison(comparison.getOp(), lhs, rhs, formulaManager);
    }

    @Override
    public Formula visit(BinaryBooleanExpression bBin) {
        BooleanFormula lhs = encodeAsBoolean(bBin.getLHS());
        BooleanFormula rhs = encodeAsBoolean(bBin.getRHS());
        return switch (bBin.getOp()) {
            case AND -> booleanFormulaManager.and(lhs, rhs);
            case OR -> booleanFormulaManager.or(lhs, rhs);
        };
    }

    @Override
    public Formula visit(UnaryBooleanExpression bUn) {
        BooleanFormula inner = encodeAsBoolean(bUn.getInner());
        return booleanFormulaManager.not(inner);
    }

    @Override
    public Formula visit(Literal literal) {
        if (literal.isBoolean()) {
            return booleanFormulaManager.makeBoolean(literal.isTrue());
        }
        OptionalInt bitWidth = getBitWidthFromIntegerType(literal.getType());
        if (bitWidth.isEmpty()) {
            return integerFormulaManager().makeNumber(literal.getValue());
        }
        return bitvectorFormulaManager().makeBitvector(bitWidth.getAsInt(), literal.getValue());
    }

    @Override
    public Formula visit(BinaryIntegerExpression iBin) {
        Formula lhs = encodeAsInteger(iBin.getLHS());
        Formula rhs = encodeAsInteger(iBin.getRHS());
        IOpBin operator = iBin.getOp();
        if (lhs instanceof IntegerFormula left && rhs instanceof IntegerFormula right) {
            IntegerFormulaManager integerFormulaManager = integerFormulaManager();
            return switch (operator) {
                case PLUS -> integerFormulaManager.add(left, right);
                case MINUS -> integerFormulaManager.subtract(left, right);
                case MULT -> integerFormulaManager.multiply(left, right);
                case DIV, UDIV -> integerFormulaManager.divide(left, right);
                case MOD -> integerFormulaManager.modulo(left, right);
                //FIXME if the type system works, the following should be dead
                case AND -> toIntegerFormula(bitvectorFormulaManager().and(toBitvectorFormula(left), toBitvectorFormula(right)));
                case OR -> toIntegerFormula(bitvectorFormulaManager().or(toBitvectorFormula(left), toBitvectorFormula(right)));
                case XOR -> toIntegerFormula(bitvectorFormulaManager().xor(toBitvectorFormula(left), toBitvectorFormula(right)));
                case L_SHIFT -> toIntegerFormula(bitvectorFormulaManager().shiftLeft(toBitvectorFormula(left), toBitvectorFormula(right)));
                case R_SHIFT -> toIntegerFormula(bitvectorFormulaManager().shiftRight(toBitvectorFormula(left), toBitvectorFormula(right), false));
                case AR_SHIFT -> toIntegerFormula(bitvectorFormulaManager().shiftRight(toBitvectorFormula(left), toBitvectorFormula(right), true));
                case SREM, UREM -> encodeRemainder(integerFormulaManager, left, right);
            };
        }
        if (lhs instanceof BitvectorFormula left && rhs instanceof BitvectorFormula right) {
            BitvectorFormulaManager bitvectorFormulaManager = bitvectorFormulaManager();
            return switch (iBin.getOp()) {
                case PLUS -> bitvectorFormulaManager.add(left, right);
                case MINUS -> bitvectorFormulaManager.subtract(left, right);
                case MULT -> bitvectorFormulaManager.multiply(left, right);
                case DIV -> bitvectorFormulaManager.divide(left, right, true);
                case UDIV -> bitvectorFormulaManager.divide(left, right, false);
                case MOD -> encodeMod(bitvectorFormulaManager, left, right);
                case SREM -> bitvectorFormulaManager.modulo(left, right, true);
                case UREM -> bitvectorFormulaManager.modulo(left, right, false);
                case AND -> bitvectorFormulaManager.and(left, right);
                case OR -> bitvectorFormulaManager.or(left, right);
                case XOR -> bitvectorFormulaManager.xor(left, right);
                case L_SHIFT -> bitvectorFormulaManager.shiftLeft(left, right);
                case R_SHIFT -> bitvectorFormulaManager.shiftRight(left, right, false);
                case AR_SHIFT -> bitvectorFormulaManager.shiftRight(left, right, true);
            };
        }
        throw new UnsupportedOperationException("Encoding of IOpBin operation " + iBin.getOp() + " not supported on formulas of mismatching type.");
    }

    private BitvectorFormula toBitvectorFormula(IntegerFormula inner) {
        return bitvectorFormulaManager().makeBitvector(32, inner);
    }

    private IntegerFormula toIntegerFormula(BitvectorFormula inner) {
        return bitvectorFormulaManager().toIntegerFormula(inner, false);
    }

    private Formula encodeRemainder(IntegerFormulaManager integerFormulaManager, IntegerFormula left, IntegerFormula right) {
        IntegerFormula zero = integerFormulaManager.makeNumber(0);
        IntegerFormula modulo = integerFormulaManager.modulo(left, right);
        BooleanFormula cond = booleanFormulaManager.and(
                integerFormulaManager.distinct(asList(modulo, zero)),
                integerFormulaManager.lessThan(left, zero));
        return booleanFormulaManager.ifThenElse(cond, integerFormulaManager.subtract(modulo, right), modulo);
    }

    private Formula encodeMod(BitvectorFormulaManager bitvectorFormulaManager, BitvectorFormula left, BitvectorFormula right) {
        BitvectorFormula rem = bitvectorFormulaManager.modulo(left, right, true);
        // Check if rem and right have the same sign
        int rem_length = bitvectorFormulaManager.getLength(rem);
        int bv2_length = bitvectorFormulaManager.getLength(right);
        BitvectorFormula srem = bitvectorFormulaManager.extract(rem, rem_length - 1, rem_length - 1);
        BitvectorFormula sbv2 = bitvectorFormulaManager.extract(right, bv2_length - 1, bv2_length - 1);
        BooleanFormula cond = bitvectorFormulaManager.equal(srem, sbv2);
        // If they have the same sign, return the reminder, otherwise invert it
        return booleanFormulaManager.ifThenElse(cond, rem, bitvectorFormulaManager.negate(rem));
    }

    @Override
    public Formula visit(UnaryIntegerExpression iUn) {
        //TODO if inner is a boolean formula, we still want to encode it as boolean in case of conversions
        Formula inner = encodeAsInteger(iUn.getInner());
        Type targetType = iUn.getType();
        switch (iUn.getOp()) {
            case MINUS -> {
                if (inner instanceof IntegerFormula number) {
                    return integerFormulaManager().negate(number);
                }
                if (inner instanceof BitvectorFormula number) {
                    return bitvectorFormulaManager().negate(number);
                }
            }
            case SIGNED_CAST, UNSIGNED_CAST -> {
                boolean signed = iUn.getOp().equals(IOpUn.SIGNED_CAST);
                if (targetType instanceof UnboundedIntegerType) {
                    if (inner instanceof IntegerFormula) {
                        return inner;
                    }
                    if (inner instanceof BitvectorFormula number) {
                        return bitvectorFormulaManager().toIntegerFormula(number, signed);
                    }
                }
                if (targetType instanceof BoundedIntegerType integerTargetType) {
                    int bitWidth = integerTargetType.getBitWidth();
                    if (inner instanceof IntegerFormula number) {
                        return bitvectorFormulaManager().makeBitvector(bitWidth, number);
                    }
                    if (inner instanceof BitvectorFormula number) {
                        int innerBitWidth = bitvectorFormulaManager().getLength(number);
                        if (innerBitWidth < bitWidth) {
                            return bitvectorFormulaManager().extend(number, bitWidth - innerBitWidth, signed);
                        }
                        return bitvectorFormulaManager().extract(number, bitWidth-1, 0);
                    }
                }
            }
            case CTLZ -> {
                if (inner instanceof BitvectorFormula bv) {
                    BitvectorFormulaManager bitvectorFormulaManager = bitvectorFormulaManager();
                    // enc = extract(bv, 63, 63) == 1 ? 0 : (extract(bv, 62, 62) == 1 ? 1 : extract ... extract(bv, 0, 0) ? 63 : 64)
                    int bvLength = bitvectorFormulaManager.getLength(bv);
                    BitvectorFormula bv1 = bitvectorFormulaManager.makeBitvector(1, 1);
                    BitvectorFormula enc = bitvectorFormulaManager.makeBitvector(bvLength, bvLength);
                    for(int i = bitvectorFormulaManager.getLength(bv) - 1; i >= 0; i--) {
                        BitvectorFormula bvi = bitvectorFormulaManager.makeBitvector(bvLength, i);
                        BitvectorFormula bvbit = bitvectorFormulaManager.extract(bv, bvLength - (i + 1), bvLength - (i + 1));
                        enc = booleanFormulaManager.ifThenElse(bitvectorFormulaManager.equal(bvbit, bv1), bvi, enc);
                    }
                    return enc;
                }
            }
        }
        throw new UnsupportedOperationException(String.format("Encoding of (%s) %s %s not supported.",
                targetType, iUn.getOp(), inner));
    }

    @Override
    public Formula visit(ConditionalExpression ifExpr) {
        BooleanFormula guard = encodeAsBoolean(ifExpr.getGuard());
        Formula tBranch = encodeAsInteger(ifExpr.getTrueBranch());
        Formula fBranch = encodeAsInteger(ifExpr.getFalseBranch());
        return booleanFormulaManager.ifThenElse(guard, tBranch, fBranch);
    }

    @Override
    public Formula visit(NondeterministicExpression iNonDet) {
        String name = iNonDet.getName();
        if (iNonDet.isBoolean()) {
            return booleanFormulaManager.makeVariable(name);
        }
        OptionalInt bitWidth = getBitWidthFromIntegerType(iNonDet.getType());
        if (bitWidth.isEmpty()) {
            return integerFormulaManager().makeVariable(name);
        }
        return bitvectorFormulaManager().makeVariable(bitWidth.getAsInt(), name);
    }

    @Override
    public Formula visit(Register reg) {
        String name = event == null ?
                reg.getName() + "_" + reg.getThreadId() + "_final" :
                reg.getName() + "(" + event.getGlobalId() + ")";
        OptionalInt bitWidth = getBitWidthFromIntegerType(reg.getType());
        if (bitWidth.isEmpty()) {
            return integerFormulaManager().makeVariable(name);
        }
        return bitvectorFormulaManager().makeVariable(bitWidth.getAsInt(), name);
    }

    @Override
    public Formula visit(MemoryObject address) {
        OptionalInt bitWidth = getBitWidthFromIntegerType(address.getType());
        if (bitWidth.isEmpty()) {
            return integerFormulaManager().makeNumber(address.getValue());
        }
        return bitvectorFormulaManager().makeBitvector(bitWidth.getAsInt(), address.getValue());
    }

    @Override
    public Formula visit(Location location) {
        checkState(event == null, "Cannot evaluate %s at event %s.", location, event);
        return getLastMemValueExpr(location.getMemoryObject(), location.getOffset());
    }
}
