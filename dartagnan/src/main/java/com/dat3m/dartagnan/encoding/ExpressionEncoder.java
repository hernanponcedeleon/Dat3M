package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.IntUnaryOp;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.expression.type.Type;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.memory.Location;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import org.sosy_lab.java_smt.api.*;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;

import java.math.BigInteger;

import static com.google.common.base.Preconditions.checkState;
import static com.google.common.base.Verify.verify;
import static java.util.Arrays.asList;

class ExpressionEncoder implements ExpressionVisitor<Formula> {

    private final EncodingContext context;
    private final FormulaManager formulaManager;
    private final BooleanFormulaManager booleanFormulaManager;
    private final Event event;

    ExpressionEncoder(EncodingContext context, Event event) {
        this.context = context;
        this.formulaManager = context.getFormulaManager();
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
        Formula formula = expression.accept(this);
        if (formula instanceof BooleanFormula bForm) {
            return bForm;
        }
        if (formula instanceof BitvectorFormula bvForm) {
            BitvectorFormulaManager bitvectorFormulaManager = bitvectorFormulaManager();
            int length = bitvectorFormulaManager.getLength(bvForm);
            BitvectorFormula zero = bitvectorFormulaManager.makeBitvector(length, 0);
            return bitvectorFormulaManager.greaterThan(bvForm, zero, false);
        }
        assert formula instanceof IntegerFormula;
        IntegerFormulaManager integerFormulaManager = integerFormulaManager();
        IntegerFormula zero = integerFormulaManager.makeNumber(0);
        return integerFormulaManager.greaterThan((IntegerFormula) formula, zero);
    }

    Formula encode(Expression expression) {
        return expression.accept(this);
    }

    @Override
    public Formula visit(Atom atom) {
        Formula lhs = encode(atom.getLHS());
        Formula rhs = encode(atom.getRHS());
        return context.encodeComparison(atom.getOp(), lhs, rhs);
    }

    @Override
    public Formula visit(BoolLiteral boolLiteral) {
        return booleanFormulaManager.makeBoolean(boolLiteral.getValue());
    }

    @Override
    public Formula visit(BoolBinaryExpr bBin) {
        BooleanFormula lhs = encodeAsBoolean(bBin.getLHS());
        BooleanFormula rhs = encodeAsBoolean(bBin.getRHS());
        switch (bBin.getOp()) {
            case AND:
                return booleanFormulaManager.and(lhs, rhs);
            case OR:
                return booleanFormulaManager.or(lhs, rhs);
        }
        throw new UnsupportedOperationException("Encoding not supported for BoolBinaryOp " + bBin.getOp());
    }

    @Override
    public Formula visit(BoolUnaryExpr bUn) {
        BooleanFormula inner = encodeAsBoolean(bUn.getInner());
        return booleanFormulaManager.not(inner);
    }

    @Override
    public Formula visit(NonDetBool nonDetBool) {
        return booleanFormulaManager.makeVariable(Integer.toString(nonDetBool.hashCode()));
    }

    @Override
    public Formula visit(IntLiteral intLiteral) {
        
        BigInteger value = intLiteral.getValue();
        Type type = intLiteral.getType();
        return context.makeLiteral(type, value);
    }

    @Override
    public Formula visit(IntBinaryExpr iBin) {
        Formula lhs = encode(iBin.getLHS());
        Formula rhs = encode(iBin.getRHS());
        if (lhs instanceof IntegerFormula i1 && rhs instanceof IntegerFormula i2) {
            BitvectorFormulaManager bitvectorFormulaManager;
            IntegerFormulaManager integerFormulaManager = integerFormulaManager();
            switch (iBin.getOp()) {
                case ADD:
                    return integerFormulaManager.add(i1, i2);
                case SUB:
                    return integerFormulaManager.subtract(i1, i2);
                case MUL:
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
                case LSHIFT:
                    bitvectorFormulaManager = bitvectorFormulaManager();
                    return bitvectorFormulaManager.toIntegerFormula(
                            bitvectorFormulaManager.shiftLeft(
                                    bitvectorFormulaManager.makeBitvector(32, i1),
                                    bitvectorFormulaManager.makeBitvector(32, i2)),
                            false);
                case RSHIFT:
                    bitvectorFormulaManager = bitvectorFormulaManager();
                    return bitvectorFormulaManager.toIntegerFormula(
                            bitvectorFormulaManager.shiftRight(
                                    bitvectorFormulaManager.makeBitvector(32, i1),
                                    bitvectorFormulaManager.makeBitvector(32, i2),
                                    false),
                            false);
                case ARSHIFT:
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
                    throw new UnsupportedOperationException("Encoding of IntBinaryOp operation " + iBin.getOp() + " not supported on integer formulas.");
            }
        } else if (lhs instanceof BitvectorFormula bv1 && rhs instanceof BitvectorFormula bv2) {
            BitvectorFormulaManager bitvectorFormulaManager = bitvectorFormulaManager();
            switch (iBin.getOp()) {
                case ADD:
                    return bitvectorFormulaManager.add(bv1, bv2);
                case SUB:
                    return bitvectorFormulaManager.subtract(bv1, bv2);
                case MUL:
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
                case LSHIFT:
                    return bitvectorFormulaManager.shiftLeft(bv1, bv2);
                case RSHIFT:
                    return bitvectorFormulaManager.shiftRight(bv1, bv2, false);
                case ARSHIFT:
                    return bitvectorFormulaManager.shiftRight(bv1, bv2, true);
                default:
                    throw new UnsupportedOperationException("Encoding of IntBinaryOp operation " + iBin.getOp() + " not supported on bitvector formulas.");
            }
        } else {
            throw new UnsupportedOperationException("Encoding of IntBinaryOp operation " + iBin.getOp() + " not supported on formulas of mismatching type.");
        }
    }

    @Override
    public Formula visit(IntUnaryExpr iUn) {
        Formula inner = encode(iUn.getInner());
        switch (iUn.getOp()) {
            case MINUS -> {
                if (inner instanceof IntegerFormula number) {
                    return integerFormulaManager().negate(number);
                }
                if (inner instanceof BitvectorFormula number) {
                    return bitvectorFormulaManager().negate(number);
                }
            }
            case CAST_SIGNED, CAST_UNSIGNED -> {
                boolean signed = iUn.getOp().equals(IntUnaryOp.CAST_SIGNED);
                if (inner instanceof BooleanFormula bool) {
                    return bool;
                }
                if (context.useIntegers || iUn.getType().isMathematical()) {
                    verify(!context.useIntegers || inner instanceof IntegerFormula);
                    if(inner instanceof BitvectorFormula number) {
                        return bitvectorFormulaManager().toIntegerFormula(number, signed);
                    }
                    //TODO If narrowing, constrain the value.
                    return inner;
                } else {
                    final int bitWidth = iUn.getType().getBitWidth();
                    if (inner instanceof IntegerFormula number) {
                        return bitvectorFormulaManager().makeBitvector(bitWidth, number);
                    }
                    if (inner instanceof BitvectorFormula number) {
                        int innerBitWidth = bitvectorFormulaManager().getLength(number);
                        if (innerBitWidth < bitWidth) {
                            return bitvectorFormulaManager().extend(number, bitWidth - innerBitWidth, signed);
                        }
                        return bitvectorFormulaManager().extract(number, bitWidth - 1, 0);
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
        throw new UnsupportedOperationException(
                String.format("Encoding of (%s) %s %s not supported.", iUn.getType(), iUn.getOp(), inner));
    }

    @Override
    public Formula visit(ITEExpr iteExpr) {
        BooleanFormula guard = encodeAsBoolean(iteExpr.getGuard());
        Formula tBranch = encode(iteExpr.getTrueBranch());
        Formula fBranch = encode(iteExpr.getFalseBranch());
        return booleanFormulaManager.ifThenElse(guard, tBranch, fBranch);
    }

    @Override
    public Formula visit(NonDetInt iNonDet) {
        String name = iNonDet.getName();
        Type type = iNonDet.getType();
        return context.makeVariable(name, type);
    }

    @Override
    public Formula visit(Register reg) {
        String name = event == null ?
                reg.getName() + "_" + reg.getFunction().getId() + "_final" :
                reg.getName() + "(" + event.getGlobalId() + ")";
        Type type = reg.getType();
        return context.makeVariable(name, type);
    }

    @Override
    public Formula visit(MemoryObject memObj) {
        return context.makeLiteral(memObj.getType(), memObj.getAddress());
    }

    @Override
    public Formula visit(Location location) {
        checkState(event == null, "Cannot evaluate %s at event %s.", location, event);
        return context.lastValue(location.getMemoryObject(), location.getOffset());
    }
}
