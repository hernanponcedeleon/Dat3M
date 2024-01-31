package com.dat3m.dartagnan.expression.processing;


import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.booleans.*;
import com.dat3m.dartagnan.expression.integers.*;
import com.dat3m.dartagnan.expression.misc.ConstructExpr;
import com.dat3m.dartagnan.expression.misc.ExtractExpr;
import com.dat3m.dartagnan.expression.misc.ITEExpr;
import com.dat3m.dartagnan.expression.utils.IntegerHelper;
import com.google.common.base.VerifyException;

import java.math.BigInteger;

import static com.dat3m.dartagnan.expression.booleans.BoolBinaryOp.AND;
import static com.dat3m.dartagnan.expression.booleans.BoolBinaryOp.OR;
import static com.dat3m.dartagnan.expression.integers.IntBinaryOp.*;

public class ExprSimplifier extends ExprTransformer {

    // If set to "false", the simplifier will not destroy register dependencies, i.e.,
    // it will maintain "expr.getRegs() == simplified(expr).getRegs()".
    // For example, "0*r" will not get simplified to "0";
    private final boolean aggressive;

    public ExprSimplifier(boolean aggressive) {
        this.aggressive = aggressive;
    }

    @Override
    public Expression visitBoolBinaryExpression(BoolBinaryExpr expr) {
        Expression left = expr.getLeft().accept(this);
        Expression right = expr.getRight().accept(this);
        BoolBinaryOp op = expr.getKind();

        // ------- Operations on same value -------
        if (aggressive && left.equals(right)) {
            return expressions.makeTrue();
        }

        // ------- Operations with constants -------
        if (left instanceof BoolLiteral) {
            // Swap constant to right
            Expression temp = right;
            right = left;
            left = temp;
        }

        if (left instanceof BoolLiteral l1 && right instanceof BoolLiteral l2) {
            final boolean newValue = switch (op) {
                case AND -> l1.getValue() && l2.getValue();
                case OR -> l1.getValue() || l2.getValue();
                case IFF -> l1.getValue() == l2.getValue();
            };
            return expressions.makeValue(newValue);
        }

        if (right instanceof BoolLiteral lit && (op == AND || op == OR)) {
            final boolean neutralValue = switch (expr.getKind()) {
                case AND -> true;
                case OR -> false;
                default -> throw new VerifyException("Unexpected bool operator: " + op);
            };
            final boolean absorbingValue = !neutralValue;

            if (lit.getValue() == neutralValue) {
                return left;
            } else if (aggressive || left.getRegs().isEmpty()) {
                return expressions.makeValue(absorbingValue);
            }
        }

        // TODO: Simplifications of nested expressions like "b && !b => false".

        return expressions.makeBoolBinary(left, expr.getKind(), right);
    }

    @Override
    public Expression visitBoolUnaryExpression(BoolUnaryExpr expr) {
        assert expr.getKind() == BoolUnaryOp.NOT;
        final Expression operand = expr.getOperand().accept(this);

        // Constant negation
        if (operand instanceof BoolLiteral lit) {
            expressions.makeValue(!lit.getValue());
        }

        // Double negation
        if (operand instanceof BoolUnaryExpr negation) {
            assert negation.getKind() == BoolUnaryOp.NOT;
            return negation.getOperand();
        }

        return expressions.makeBoolUnary(expr.getKind(), operand);
    }

    @Override
    public Expression visitIntCmpExpression(IntCmpExpr cmp) {
        Expression left = cmp.getLeft().accept(this);
        Expression right = cmp.getRight().accept(this);
        IntCmpOp op = cmp.getKind();

        // Normalize "x > y" to "y < x" (and similar).
        if (op == IntCmpOp.GTE || op == IntCmpOp.GT || op == IntCmpOp.UGTE || op == IntCmpOp.UGT) {
            Expression temp = left;
            left = right;
            right = temp;
            op = op.reverse();
        }

        // ------- Operations on same value -------
        if (aggressive && left.equals(right)) {
            return expressions.makeValue(!op.isStrict());
        }

        // ------- Operations with constants -------
        if (left instanceof IntLiteral l1 && right instanceof IntLiteral l2) {
            final int bitWidth = l1.getType().getBitWidth();
            final boolean cmpResult = switch (op) {
                case EQ -> IntegerHelper.equals(l1.getValue(), l2.getValue(), bitWidth);
                case NEQ -> !IntegerHelper.equals(l1.getValue(), l2.getValue(), bitWidth);
                case LT -> IntegerHelper.scmp(l1.getValue(), l2.getValue(), bitWidth) < 0;
                case LTE -> IntegerHelper.scmp(l1.getValue(), l2.getValue(), bitWidth) <= 0;
                case ULT -> IntegerHelper.ucmp(l1.getValue(), l2.getValue(), bitWidth) < 0;
                case ULTE -> IntegerHelper.ucmp(l1.getValue(), l2.getValue(), bitWidth) <= 0;
                default ->
                    throw new VerifyException(String.format("Unexpected comparison operator '%s'. Missing normalization?", op));
            };
            return expressions.makeValue(cmpResult);
        }

        return expressions.makeIntCmp(left, op, right);
    }

    @Override
    public Expression visitIntSizeCastExpression(IntSizeCast expr) {
        final Expression operand = expr.getOperand().accept(this);

        // ------- Operations with constants -------
        if (operand instanceof IntLiteral lit) {
            final int sourceWidth = expr.getSourceType().getBitWidth();
            final int targetWidth = expr.getTargetType().getBitWidth();
            final BigInteger newValue;
            if (expr.isExtension()) {
                newValue = IntegerHelper.extend(lit.getValue(), sourceWidth, targetWidth, expr.preservesSign());
            } else if (expr.isTruncation()) {
                newValue = IntegerHelper.truncate(lit.getValue(), targetWidth);
            } else {
                newValue = lit.getValue();
            }

            return expressions.makeValue(newValue, expr.getTargetType());
        }

        // TODO: Simplify nested casts

        // TODO: Push casts into operators?

        return expressions.makeIntegerCast(operand, expr.getTargetType(), expr.preservesSign());
    }

    @Override
    public Expression visitIntUnaryExpression(IntUnaryExpr expr) {
        final Expression operand = expr.getOperand().accept(this);

        // ------- Operations with constants -------
        if (operand instanceof IntLiteral lit) {
            final int bitWidth = expr.getType().getBitWidth();
            final BigInteger newValue = switch (expr.getKind()) {
                case MINUS -> IntegerHelper.neg(lit.getValue(), bitWidth);
                case CTLZ -> IntegerHelper.ctlz(lit.getValue(), bitWidth);
            };
            return expressions.makeValue(newValue, expr.getType());
        }

        // ------- Nested negation -------
        if (operand instanceof IntUnaryExpr neg && neg.getKind() == IntUnaryOp.MINUS) {
            return neg.getOperand();
        }

        return expressions.makeIntUnary(expr.getKind(), operand);
    }

    @Override
    public Expression visitIntBinaryExpression(IntBinaryExpr expr) {
        Expression left = expr.getLeft().accept(this);
        Expression right = expr.getRight().accept(this);
        IntBinaryOp op = expr.getKind();

        // ------- Operations with constants -------
        if (op.isCommutative() && left instanceof IntLiteral) {
            // Swap constant to right
            Expression temp = right;
            right = left;
            left = temp;
        }

        // Optimizations for "x op constant"
        if (right instanceof IntLiteral lit) {
            if (lit.isZero() && (op == ADD || op == SUB || op == IntBinaryOp.OR || op == XOR
                    || op == LSHIFT || op == RSHIFT || op == ARSHIFT)) {
                return left;
            }

            if (lit.isOne() && (op == MUL || op == DIV || op == UDIV)) {
                return left;
            }

            if (lit.isZero() && op == MUL && (aggressive || left.getRegs().isEmpty())) {
                return expressions.makeZero(expr.getType());
            }
        }

        // Folding of constants
        if (left instanceof IntLiteral leftLit && right instanceof IntLiteral rightLit) {
            final int bitWidth = expr.getType().getBitWidth();
            return expressions.makeValue(op.apply(leftLit.getValue(), rightLit.getValue(), bitWidth), expr.getType());
        }

        // TODO: Use associativity to merge nested operators

        return expressions.makeIntBinary(left, op, right);
    }

    @Override
    public Expression visitITEExpression(ITEExpr expr) {
        final Expression cond = expr.getCondition().accept(this);
        final Expression trueCase = expr.getTrueCase().accept(this);
        final Expression falseCase = expr.getFalseCase().accept(this);

        // ------- Operations with constants -------
        if (cond instanceof BoolLiteral lit) {
            if (lit.getValue() && (aggressive || falseCase.getRegs().isEmpty())) {
                return trueCase;
            }
            if (!lit.getValue() && (aggressive || trueCase.getRegs().isEmpty())) {
                return falseCase;
            }
        }

        // ------- Identical cases -------
        if (aggressive && trueCase.equals(falseCase)) {
            return trueCase;
        }

        return expressions.makeITE(cond, trueCase, falseCase);
    }

    @Override
    public Expression visitExtractExpression(ExtractExpr expr) {
        Expression inner = expr.getOperand().accept(this);
        if (inner instanceof ConstructExpr construct) {
            return construct.getOperands().get(expr.getFieldIndex());
        }

        return expressions.makeExtract(expr.getFieldIndex(), inner);
    }
}
