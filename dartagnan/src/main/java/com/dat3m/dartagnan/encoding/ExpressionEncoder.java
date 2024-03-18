package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.booleans.BoolBinaryExpr;
import com.dat3m.dartagnan.expression.booleans.BoolLiteral;
import com.dat3m.dartagnan.expression.booleans.BoolUnaryExpr;
import com.dat3m.dartagnan.expression.integers.*;
import com.dat3m.dartagnan.expression.misc.ITEExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.memory.Location;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.misc.NonDetValue;
import org.sosy_lab.java_smt.api.*;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;

import java.math.BigInteger;

import static com.google.common.base.Preconditions.checkState;
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
            BitvectorFormulaManager bvmgr = bitvectorFormulaManager();
            BitvectorFormula zero = bvmgr.makeBitvector(bvmgr.getLength(bvForm), 0);
            return bvmgr.greaterThan(bvForm, zero, false);
        }
        assert formula instanceof IntegerFormula;
        IntegerFormulaManager imgr = integerFormulaManager();
        IntegerFormula zero = imgr.makeNumber(0);
        return imgr.greaterThan((IntegerFormula) formula, zero);
    }

    Formula encode(Expression expression) {
        return expression.accept(this);
    }

    @Override
    public Formula visitIntCmpExpression(IntCmpExpr cmp) {
        Formula lhs = encode(cmp.getLeft());
        Formula rhs = encode(cmp.getRight());
        return context.encodeComparison(cmp.getKind(), lhs, rhs);
    }

    @Override
    public Formula visitBoolLiteral(BoolLiteral boolLiteral) {
        return booleanFormulaManager.makeBoolean(boolLiteral.getValue());
    }

    @Override
    public Formula visitBoolBinaryExpression(BoolBinaryExpr bBin) {
        BooleanFormula lhs = encodeAsBoolean(bBin.getLeft());
        BooleanFormula rhs = encodeAsBoolean(bBin.getRight());
        return switch (bBin.getKind()) {
            case AND -> booleanFormulaManager.and(lhs, rhs);
            case OR -> booleanFormulaManager.or(lhs, rhs);
            case IFF -> booleanFormulaManager.equivalence(lhs, rhs);
        };
    }

    @Override
    public Formula visitBoolUnaryExpression(BoolUnaryExpr bUn) {
        BooleanFormula inner = encodeAsBoolean(bUn.getOperand());
        return booleanFormulaManager.not(inner);
    }

    @Override
    public Formula visitNonDetValue(NonDetValue nonDet) {
        return context.makeVariable(nonDet.toString(), nonDet.getType());
    }

    @Override
    public Formula visitIntLiteral(IntLiteral intLiteral) {
        
        BigInteger value = intLiteral.getValue();
        Type type = intLiteral.getType();
        return context.makeLiteral(type, value);
    }

    @Override
    public Formula visitIntBinaryExpression(IntBinaryExpr iBin) {
        final Formula lhs = encode(iBin.getLeft());
        final Formula rhs = encode(iBin.getRight());
        final int bitWidth = iBin.getType().getBitWidth();

        if (lhs instanceof IntegerFormula i1 && rhs instanceof IntegerFormula i2) {
            BitvectorFormulaManager bvmgr;
            IntegerFormulaManager imgr = integerFormulaManager();
            switch (iBin.getKind()) {
                case ADD:
                    return imgr.add(i1, i2);
                case SUB:
                    return imgr.subtract(i1, i2);
                case MUL:
                    return imgr.multiply(i1, i2);
                case DIV:
                case UDIV:
                    return imgr.divide(i1, i2);
                case AND:
                    bvmgr = bitvectorFormulaManager();
                    return bvmgr.toIntegerFormula(
                            bvmgr.and(
                                    bvmgr.makeBitvector(bitWidth, i1),
                                    bvmgr.makeBitvector(bitWidth, i2)),
                            false);
                case OR:
                    bvmgr = bitvectorFormulaManager();
                    return bvmgr.toIntegerFormula(
                            bvmgr.or(
                                    bvmgr.makeBitvector(bitWidth, i1),
                                    bvmgr.makeBitvector(bitWidth, i2)),
                            false);
                case XOR:
                    bvmgr = bitvectorFormulaManager();
                    return bvmgr.toIntegerFormula(
                            bvmgr.xor(
                                    bvmgr.makeBitvector(bitWidth, i1),
                                    bvmgr.makeBitvector(bitWidth, i2)),
                            false);
                case LSHIFT:
                    bvmgr = bitvectorFormulaManager();
                    return bvmgr.toIntegerFormula(
                            bvmgr.shiftLeft(
                                    bvmgr.makeBitvector(bitWidth, i1),
                                    bvmgr.makeBitvector(bitWidth, i2)),
                            false);
                case RSHIFT:
                    bvmgr = bitvectorFormulaManager();
                    return bvmgr.toIntegerFormula(
                            bvmgr.shiftRight(
                                    bvmgr.makeBitvector(bitWidth, i1),
                                    bvmgr.makeBitvector(bitWidth, i2),
                                    false),
                            false);
                case ARSHIFT:
                    bvmgr = bitvectorFormulaManager();
                    return bvmgr.toIntegerFormula(
                            bvmgr.shiftRight(
                                    bvmgr.makeBitvector(bitWidth, i1),
                                    bvmgr.makeBitvector(bitWidth, i2),
                                    true),
                            false);
                case SREM:
                case UREM:
                    IntegerFormula zero = imgr.makeNumber(0);
                    IntegerFormula modulo = imgr.modulo(i1, i2);
                    BooleanFormula cond = booleanFormulaManager.and(
                            imgr.distinct(asList(modulo, zero)),
                            imgr.lessThan(i1, zero));
                    return booleanFormulaManager.ifThenElse(cond, imgr.subtract(modulo, i2), modulo);
                default:
                    throw new UnsupportedOperationException("Encoding of IntBinaryOp operation " + iBin.getKind() + " not supported on integer formulas.");
            }
        } else if (lhs instanceof BitvectorFormula bv1 && rhs instanceof BitvectorFormula bv2) {
            BitvectorFormulaManager bvmgr = bitvectorFormulaManager();
            return switch (iBin.getKind()) {
                case ADD -> bvmgr.add(bv1, bv2);
                case SUB -> bvmgr.subtract(bv1, bv2);
                case MUL -> bvmgr.multiply(bv1, bv2);
                case DIV -> bvmgr.divide(bv1, bv2, true);
                case UDIV -> bvmgr.divide(bv1, bv2, false);
                case SREM -> bvmgr.modulo(bv1, bv2, true);
                case UREM -> bvmgr.modulo(bv1, bv2, false);
                case AND -> bvmgr.and(bv1, bv2);
                case OR -> bvmgr.or(bv1, bv2);
                case XOR -> bvmgr.xor(bv1, bv2);
                case LSHIFT -> bvmgr.shiftLeft(bv1, bv2);
                case RSHIFT -> bvmgr.shiftRight(bv1, bv2, false);
                case ARSHIFT -> bvmgr.shiftRight(bv1, bv2, true);
            };
        } else {
            throw new UnsupportedOperationException("Encoding of IntBinaryOp operation " + iBin.getKind() + " not supported on formulas of mismatching type.");
        }
    }

    @Override
    public Formula visitIntSizeCastExpression(IntSizeCast expr) {
        Formula inner = encode(expr.getOperand());
        if (inner instanceof IntegerFormula || expr.isNoop()) {
            //TODO If narrowing, constrain the value.
            return inner;
        }

        if (inner instanceof BitvectorFormula number) {
            final BitvectorFormulaManager bvmgr = bitvectorFormulaManager();
            final int targetBitWidth = expr.getTargetType().getBitWidth();
            final int sourceBitWidth = expr.getSourceType().getBitWidth();
            assert (sourceBitWidth == bvmgr.getLength(number));

            if (expr.isExtension()) {
                return bvmgr.extend(number, targetBitWidth - sourceBitWidth, expr.preservesSign());
            } else {
                return bvmgr.extract(number, targetBitWidth - 1, 0);
            }
        }

        throw new UnsupportedOperationException(String.format("Encoding of (%s) not supported.", expr));
    }

    @Override
    public Formula visitIntUnaryExpression(IntUnaryExpr iUn) {
        Formula inner = encode(iUn.getOperand());
        switch (iUn.getKind()) {
            case MINUS -> {
                if (inner instanceof IntegerFormula number) {
                    return integerFormulaManager().negate(number);
                }
                if (inner instanceof BitvectorFormula number) {
                    return bitvectorFormulaManager().negate(number);
                }
            }
            case CTLZ -> {
                if (inner instanceof BitvectorFormula bv) {
                    BitvectorFormulaManager bvmgr = bitvectorFormulaManager();
                    // enc = extract(bv, 63, 63) == 1 ? 0 : (extract(bv, 62, 62) == 1 ? 1 : extract ... extract(bv, 0, 0) ? 63 : 64)
                    int bvLength = bvmgr.getLength(bv);
                    BitvectorFormula bv1 = bvmgr.makeBitvector(1, 1);
                    BitvectorFormula enc = bvmgr.makeBitvector(bvLength, bvLength);
                    for(int i = bvmgr.getLength(bv) - 1; i >= 0; i--) {
                        BitvectorFormula bvi = bvmgr.makeBitvector(bvLength, i);
                        BitvectorFormula bvbit = bvmgr.extract(bv, bvLength - (i + 1), bvLength - (i + 1));
                        enc = booleanFormulaManager.ifThenElse(bvmgr.equal(bvbit, bv1), bvi, enc);
                    }
                    return enc;
                }
            }
        }
        throw new UnsupportedOperationException(
                String.format("Encoding of (%s) %s %s not supported.", iUn.getType(), iUn.getKind(), inner));
    }

    @Override
    public Formula visitITEExpression(ITEExpr iteExpr) {
        BooleanFormula guard = encodeAsBoolean(iteExpr.getCondition());
        Formula tBranch = encode(iteExpr.getTrueCase());
        Formula fBranch = encode(iteExpr.getFalseCase());
        return booleanFormulaManager.ifThenElse(guard, tBranch, fBranch);
    }

    @Override
    public Formula visitRegister(Register reg) {
        String name = event == null ?
                reg.getName() + "_" + reg.getFunction().getId() + "_final" :
                reg.getName() + "(" + event.getGlobalId() + ")";
        Type type = reg.getType();
        return context.makeVariable(name, type);
    }

    @Override
    public Formula visitMemoryObject(MemoryObject memObj) {
        return context.makeLiteral(memObj.getType(), memObj.getAddress());
    }

    @Override
    public Formula visitLocation(Location location) {
        checkState(event == null, "Cannot evaluate %s at event %s.", location, event);
        return context.lastValue(location.getMemoryObject(), location.getOffset());
    }
}
