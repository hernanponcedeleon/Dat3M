package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.expression.Expression;
import com.dat3m.dartagnan.program.expression.type.IntegerType;
import com.dat3m.dartagnan.program.expression.type.NumberType;
import com.dat3m.dartagnan.program.expression.type.PointerType;
import com.dat3m.dartagnan.program.expression.type.Type;
import com.dat3m.dartagnan.program.memory.Location;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import org.sosy_lab.java_smt.api.*;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;

import java.util.OptionalInt;

import static com.dat3m.dartagnan.GlobalSettings.getArchPrecision;
import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Preconditions.checkState;
import static java.util.Arrays.asList;

class ExpressionEncoder implements ExpressionVisitor<Formula> {

    private final FormulaManager formulaManager;
    private final BooleanFormulaManager booleanFormulaManager;
    private final Event event;

    public ExpressionEncoder(FormulaManager formulaManager, Event event) {
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
        BooleanFormulaManager bmgr = fmgr.getBooleanFormulaManager();
        if (lhs instanceof BooleanFormula && rhs instanceof BooleanFormula) {
            BooleanFormula b1 = (BooleanFormula) lhs;
            BooleanFormula b2 = (BooleanFormula) rhs;
            switch (op) {
                case EQ:
                    return bmgr.equivalence(b1, b2);
                case NEQ:
                    return bmgr.not(bmgr.equivalence(b1, b2));
                default:
                    throw new UnsupportedOperationException("Encoding of COpBin operation" + op + " not supported on boolean formulas.");
            }
        }
        if (lhs instanceof IntegerFormula && rhs instanceof IntegerFormula) {
            IntegerFormulaManager imgr = fmgr.getIntegerFormulaManager();
            IntegerFormula i1 = (IntegerFormula) lhs;
            IntegerFormula i2 = (IntegerFormula) rhs;
            switch (op) {
                case EQ:
                    return imgr.equal(i1, i2);
                case NEQ:
                    return bmgr.not(imgr.equal(i1, i2));
                case LT:
                case ULT:
                    return imgr.lessThan(i1, i2);
                case LTE:
                case ULTE:
                    return imgr.lessOrEquals(i1, i2);
                case GT:
                case UGT:
                    return imgr.greaterThan(i1, i2);
                case GTE:
                case UGTE:
                    return imgr.greaterOrEquals(i1, i2);
            }
        }
        if (lhs instanceof BitvectorFormula && rhs instanceof BitvectorFormula) {
            BitvectorFormulaManager bvmgr = fmgr.getBitvectorFormulaManager();
            BitvectorFormula bv1 = (BitvectorFormula) lhs;
            BitvectorFormula bv2 = (BitvectorFormula) rhs;
            switch (op) {
                case EQ:
                    return bvmgr.equal(bv1, bv2);
                case NEQ:
                    return bmgr.not(bvmgr.equal(bv1, bv2));
                case LT:
                case ULT:
                    return bvmgr.lessThan(bv1, bv2, op.equals(COpBin.LT));
                case LTE:
                case ULTE:
                    return bvmgr.lessOrEquals(bv1, bv2, op.equals(COpBin.LTE));
                case GT:
                case UGT:
                    return bvmgr.greaterThan(bv1, bv2, op.equals(COpBin.GT));
                case GTE:
                case UGTE:
                    return bvmgr.greaterOrEquals(bv1, bv2, op.equals(COpBin.GTE));
            }
        }
        throw new UnsupportedOperationException("Encoding not supported for COpBin: " + lhs + " " + op + " " + rhs);
    }

    static Formula getLastMemValueExpr(MemoryObject object, int offset, FormulaManager formulaManager) {
        checkArgument(0 <= offset && offset < object.size(), "array index out of bounds");
        String name = String.format("last_val_at_%s_%d", object, offset);
        if (getArchPrecision() > -1) {
            return formulaManager.getBitvectorFormulaManager().makeVariable(getArchPrecision(), name);
        } else {
            return formulaManager.getIntegerFormulaManager().makeVariable(name);
        }
    }

    @Override
    public Formula visit(Atom atom) {
        Formula lhs = encodeAsInteger(atom.getLHS());
        Formula rhs = encodeAsInteger(atom.getRHS());
        return encodeComparison(atom.getOp(), lhs, rhs, formulaManager);
    }

    @Override
    public Formula visit(BExprBin bBin) {
        BooleanFormula lhs = encodeAsBoolean(bBin.getLHS());
        BooleanFormula rhs = encodeAsBoolean(bBin.getRHS());
        switch (bBin.getOp()) {
            case AND:
                return booleanFormulaManager.and(lhs, rhs);
            case OR:
                return booleanFormulaManager.or(lhs, rhs);
        }
        throw new UnsupportedOperationException("Encoding not supported for BOpBin " + bBin.getOp());
    }

    @Override
    public Formula visit(BExprUn bUn) {
        BooleanFormula inner = encodeAsBoolean(bUn.getInner());
        return booleanFormulaManager.not(inner);
    }

    @Override
    public Formula visit(IValue iValue) {
        if (iValue.isBoolean()) {
            return booleanFormulaManager.makeBoolean(iValue.isTrue());
        }
        OptionalInt bitWidth = getBitWidthFromLeafType(iValue.getType());
        if (bitWidth.isEmpty()) {
            return integerFormulaManager().makeNumber(iValue.getValue());
        }
        return bitvectorFormulaManager().makeBitvector(bitWidth.getAsInt(), iValue.getValue());
    }

    @Override
    public Formula visit(IExprBin iBin) {
        Formula lhs = encodeAsInteger(iBin.getLHS());
        Formula rhs = encodeAsInteger(iBin.getRHS());
        if (lhs instanceof IntegerFormula && rhs instanceof IntegerFormula) {
            IntegerFormula i1 = (IntegerFormula) lhs;
            IntegerFormula i2 = (IntegerFormula) rhs;
            BitvectorFormulaManager bitvectorFormulaManager;
            IntegerFormulaManager integerFormulaManager = integerFormulaManager();
            switch (iBin.getOp()) {
                case PLUS:
                    return integerFormulaManager.add(i1, i2);
                case MINUS:
                    return integerFormulaManager.subtract(i1, i2);
                case MULT:
                    return integerFormulaManager.multiply(i1, i2);
                case DIV:
                case UDIV:
                    return integerFormulaManager.divide(i1, i2);
                case MOD:
                    return integerFormulaManager.modulo(i1, i2);
                case AND:
                    bitvectorFormulaManager = bitvectorFormulaManager();
                    return bitvectorFormulaManager.toIntegerFormula(
                            bitvectorFormulaManager.and(
                                    bitvectorFormulaManager.makeBitvector(32, i1),
                                    bitvectorFormulaManager.makeBitvector(32, i2)),
                            false);
                case OR:
                    bitvectorFormulaManager = bitvectorFormulaManager();
                    return bitvectorFormulaManager.toIntegerFormula(
                            bitvectorFormulaManager.or(
                                    bitvectorFormulaManager.makeBitvector(32, i1),
                                    bitvectorFormulaManager.makeBitvector(32, i2)),
                            false);
                case XOR:
                    bitvectorFormulaManager = bitvectorFormulaManager();
                    return bitvectorFormulaManager.toIntegerFormula(
                            bitvectorFormulaManager.xor(
                                    bitvectorFormulaManager.makeBitvector(32, i1),
                                    bitvectorFormulaManager.makeBitvector(32, i2)),
                            false);
                case L_SHIFT:
                    bitvectorFormulaManager = bitvectorFormulaManager();
                    return bitvectorFormulaManager.toIntegerFormula(
                            bitvectorFormulaManager.shiftLeft(
                                    bitvectorFormulaManager.makeBitvector(32, i1),
                                    bitvectorFormulaManager.makeBitvector(32, i2)),
                            false);
                case R_SHIFT:
                    bitvectorFormulaManager = bitvectorFormulaManager();
                    return bitvectorFormulaManager.toIntegerFormula(
                            bitvectorFormulaManager.shiftRight(
                                    bitvectorFormulaManager.makeBitvector(32, i1),
                                    bitvectorFormulaManager.makeBitvector(32, i2),
                                    false),
                            false);
                case AR_SHIFT:
                    bitvectorFormulaManager = bitvectorFormulaManager();
                    return bitvectorFormulaManager.toIntegerFormula(
                            bitvectorFormulaManager.shiftRight(
                                    bitvectorFormulaManager.makeBitvector(32, i1),
                                    bitvectorFormulaManager.makeBitvector(32, i2),
                                    true),
                            false);
                case SREM:
                case UREM:
                    IntegerFormula zero = integerFormulaManager.makeNumber(0);
                    IntegerFormula modulo = integerFormulaManager.modulo(i1, i2);
                    BooleanFormula cond = booleanFormulaManager.and(
                            integerFormulaManager.distinct(asList(modulo, zero)),
                            integerFormulaManager.lessThan(i1, zero));
                    return booleanFormulaManager.ifThenElse(cond, integerFormulaManager.subtract(modulo, i2), modulo);
                default:
                    throw new UnsupportedOperationException("Encoding of IOpBin operation " + iBin.getOp() + " not supported on integer formulas.");
            }
        } else if (lhs instanceof BitvectorFormula && rhs instanceof BitvectorFormula) {
            BitvectorFormula bv1 = (BitvectorFormula) lhs;
            BitvectorFormula bv2 = (BitvectorFormula) rhs;
            BitvectorFormulaManager bitvectorFormulaManager = bitvectorFormulaManager();
            switch (iBin.getOp()) {
                case PLUS:
                    return bitvectorFormulaManager.add(bv1, bv2);
                case MINUS:
                    return bitvectorFormulaManager.subtract(bv1, bv2);
                case MULT:
                    return bitvectorFormulaManager.multiply(bv1, bv2);
                case DIV:
                    return bitvectorFormulaManager.divide(bv1, bv2, true);
                case UDIV:
                    return bitvectorFormulaManager.divide(bv1, bv2, false);
                case MOD:
                    BitvectorFormula rem = bitvectorFormulaManager.modulo(bv1, bv2, true);
                    // Check if rem and bv2 have the same sign
                    int rem_length = bitvectorFormulaManager.getLength(rem);
                    int bv2_length = bitvectorFormulaManager.getLength(bv2);
                    BitvectorFormula srem = bitvectorFormulaManager.extract(rem, rem_length - 1, rem_length - 1);
                    BitvectorFormula sbv2 = bitvectorFormulaManager.extract(bv2, bv2_length - 1, bv2_length - 1);
                    BooleanFormula cond = bitvectorFormulaManager.equal(srem, sbv2);
                    // If they have the same sign, return the reminder, otherwise invert it
                    return booleanFormulaManager.ifThenElse(cond, rem, bitvectorFormulaManager.negate(rem));
                case SREM:
                    return bitvectorFormulaManager.modulo(bv1, bv2, true);
                case UREM:
                    return bitvectorFormulaManager.modulo(bv1, bv2, false);
                case AND:
                    return bitvectorFormulaManager.and(bv1, bv2);
                case OR:
                    return bitvectorFormulaManager.or(bv1, bv2);
                case XOR:
                    return bitvectorFormulaManager.xor(bv1, bv2);
                case L_SHIFT:
                    return bitvectorFormulaManager.shiftLeft(bv1, bv2);
                case R_SHIFT:
                    return bitvectorFormulaManager.shiftRight(bv1, bv2, false);
                case AR_SHIFT:
                    return bitvectorFormulaManager.shiftRight(bv1, bv2, true);
                default:
                    throw new UnsupportedOperationException("Encoding of IOpBin operation " + iBin.getOp() + " not supported on bitvector formulas.");
            }
        } else {
            throw new UnsupportedOperationException("Encoding of IOpBin operation " + iBin.getOp() + " not supported on formulas of mismatching type.");
        }
    }

    @Override
    public Formula visit(IExprUn iUn) {
        Formula inner = encodeAsInteger(iUn.getInner());
        if (inner instanceof IntegerFormula) {
            IntegerFormula i = (IntegerFormula) inner;
            switch (iUn.getOp()) {
                case MINUS:
                    return integerFormulaManager().subtract(integerFormulaManager().makeNumber(0), i);
                case BV2UINT:
                case BV2INT:
                    return inner;
                // ============ INT2BV ============
                case INT2BV1:
                    return bitvectorFormulaManager().makeBitvector(1, i);
                case INT2BV8:
                    return bitvectorFormulaManager().makeBitvector(8, i);
                case INT2BV16:
                    return bitvectorFormulaManager().makeBitvector(16, i);
                case INT2BV32:
                    return bitvectorFormulaManager().makeBitvector(32, i);
                case INT2BV64:
                    return bitvectorFormulaManager().makeBitvector(64, i);
                // ============ TRUNC ============
                case TRUNC6432:
                case TRUNC6416:
                case TRUNC3216:
                case TRUNC648:
                case TRUNC328:
                case TRUNC168:
                case TRUNC641:
                case TRUNC321:
                case TRUNC161:
                case TRUNC81:
                // ============ ZEXT ============
                case ZEXT18:
                case ZEXT116:
                case ZEXT132:
                case ZEXT164:
                case ZEXT816:
                case ZEXT832:
                case ZEXT864:
                case ZEXT1632:
                case ZEXT1664:
                case ZEXT3264:
                // ============ SEXT ============
                case SEXT18:
                case SEXT116:
                case SEXT132:
                case SEXT164:
                case SEXT816:
                case SEXT832:
                case SEXT864:
                case SEXT1632:
                case SEXT1664:
                case SEXT3264:
                    return inner;
                default:
                    // TODO CTLZ. Right now we assume constant propagation got rid of such instructions
                    throw new UnsupportedOperationException("Encoding of IOpUn operation " + iUn.getOp() + " not supported on integer formulas.");
            }
        } else {
            BitvectorFormula bv = (BitvectorFormula) inner;
            BitvectorFormulaManager bitvectorFormulaManager = bitvectorFormulaManager();
            switch (iUn.getOp()) {
                case MINUS:
                    return bitvectorFormulaManager.negate(bv);
                case BV2UINT:
                    return getArchPrecision() < 0 ? bitvectorFormulaManager.toIntegerFormula(bv, false)
                            : bitvectorFormulaManager.extend(bv, getArchPrecision() - bitvectorFormulaManager.getLength(bv), false);
                case BV2INT:
                    return getArchPrecision() < 0 ? bitvectorFormulaManager.toIntegerFormula(bv, true)
                            : bitvectorFormulaManager.extend(bv, getArchPrecision() - bitvectorFormulaManager.getLength(bv), true);
                // ============ INT2BV ============
                case INT2BV1:
                case INT2BV8:
                case INT2BV16:
                case INT2BV32:
                case INT2BV64:
                    return inner;
                // ============ TRUNC ============
                case TRUNC6432:
                    return bitvectorFormulaManager.extract(bv, 31, 0);
                case TRUNC6416:
                case TRUNC3216:
                    return bitvectorFormulaManager.extract(bv, 15, 0);
                case TRUNC648:
                case TRUNC328:
                case TRUNC168:
                    return bitvectorFormulaManager.extract(bv, 7, 0);
                case TRUNC641:
                case TRUNC321:
                case TRUNC161:
                case TRUNC81:
                    return bitvectorFormulaManager.extract(bv, 1, 0);
                // ============ ZEXT ============
                case ZEXT18:
                    return bitvectorFormulaManager.extend(bv, 7, false);
                case ZEXT116:
                    return bitvectorFormulaManager.extend(bv, 15, false);
                case ZEXT132:
                    return bitvectorFormulaManager.extend(bv, 31, false);
                case ZEXT164:
                    return bitvectorFormulaManager.extend(bv, 63, false);
                case ZEXT816:
                    return bitvectorFormulaManager.extend(bv, 8, false);
                case ZEXT832:
                    return bitvectorFormulaManager.extend(bv, 24, false);
                case ZEXT864:
                    return bitvectorFormulaManager.extend(bv, 56, false);
                case ZEXT1632:
                    return bitvectorFormulaManager.extend(bv, 16, false);
                case ZEXT1664:
                    return bitvectorFormulaManager.extend(bv, 48, false);
                case ZEXT3264:
                    return bitvectorFormulaManager.extend(bv, 32, false);
                // ============ SEXT ============
                case SEXT18:
                    return bitvectorFormulaManager.extend(bv, 7, true);
                case SEXT116:
                    return bitvectorFormulaManager.extend(bv, 15, true);
                case SEXT132:
                    return bitvectorFormulaManager.extend(bv, 31, true);
                case SEXT164:
                    return bitvectorFormulaManager.extend(bv, 63, true);
                case SEXT816:
                    return bitvectorFormulaManager.extend(bv, 8, true);
                case SEXT832:
                    return bitvectorFormulaManager.extend(bv, 24, true);
                case SEXT864:
                    return bitvectorFormulaManager.extend(bv, 56, true);
                case SEXT1632:
                    return bitvectorFormulaManager.extend(bv, 16, true);
                case SEXT1664:
                    return bitvectorFormulaManager.extend(bv, 48, true);
                case SEXT3264:
                    return bitvectorFormulaManager.extend(bv, 32, true);
                case CTLZ:
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
                default:
                    throw new UnsupportedOperationException("Encoding of IOpUn operation " + iUn.getOp() + " not supported on bitvector formulas.");
            }
        }
    }

    @Override
    public Formula visit(IfExpr ifExpr) {
        BooleanFormula guard = encodeAsBoolean(ifExpr.getGuard());
        Formula tBranch = encodeAsInteger(ifExpr.getTrueBranch());
        Formula fBranch = encodeAsInteger(ifExpr.getFalseBranch());
        return booleanFormulaManager.ifThenElse(guard, tBranch, fBranch);
    }

    @Override
    public Formula visit(INonDet iNonDet) {
        String name = iNonDet.getName();
        if (iNonDet.isBoolean()) {
            return booleanFormulaManager.makeVariable(name);
        }
        OptionalInt bitWidth = getBitWidthFromLeafType(iNonDet.getType());
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
        OptionalInt bitWidth = getBitWidthFromLeafType(reg.getType());
        if (bitWidth.isEmpty()) {
            return integerFormulaManager().makeVariable(name);
        }
        return bitvectorFormulaManager().makeVariable(bitWidth.getAsInt(), name);
    }

    @Override
    public Formula visit(MemoryObject address) {
        OptionalInt bitWidth = getBitWidthFromLeafType(address.getType());
        if (bitWidth.isEmpty()) {
            return integerFormulaManager().makeNumber(address.getValue());
        }
        return bitvectorFormulaManager().makeBitvector(bitWidth.getAsInt(), address.getValue());
    }

    @Override
    public Formula visit(Location location) {
        checkState(event == null, "Cannot evaluate %s at event %s.", location, event);
        return getLastMemValueExpr(location.getMemoryObject(), location.getOffset(), formulaManager);
    }

    static OptionalInt getBitWidthFromLeafType(Type type) {
        if (type instanceof PointerType) {
            int archPrecision = getArchPrecision();
            return archPrecision < 0 ? OptionalInt.empty() : OptionalInt.of(archPrecision);
        }
        if (type instanceof NumberType) {
            return OptionalInt.empty();
        }
        return OptionalInt.of(((IntegerType) type).getBitWidth());
    }
}
