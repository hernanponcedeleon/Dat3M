package com.dat3m.dartagnan.expression.processing;


import com.dat3m.dartagnan.expression.BinaryExpression;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionKind;
import com.dat3m.dartagnan.expression.booleans.*;
import com.dat3m.dartagnan.expression.integers.*;
import com.dat3m.dartagnan.expression.misc.ConstructExpr;
import com.dat3m.dartagnan.expression.misc.ExtractExpr;
import com.dat3m.dartagnan.expression.misc.ITEExpr;
import com.dat3m.dartagnan.expression.utils.IntegerHelper;
import com.google.common.base.VerifyException;

import java.math.BigInteger;

public class ExprSimplifier extends ExprTransformer {

    // If set to "false", the simplifier will not destroy register dependencies, i.e.,
    // it will maintain "expr.getRegs() == simplified(expr).getRegs()".
    // For example, "0*r" will not get simplified to "0";
    private final boolean aggressive;

    public ExprSimplifier(boolean aggressive) {
        this.aggressive = aggressive;
    }

    // Tries to perform a general rewriting of a binary expression.
    // For now, it only rewrites "ITE(cond, x, y) op z" to "ITE(cond, x op z, y op z)".
    // Returns NULL, if no rewriting is applicable.
    private Expression tryGeneralRewrite(BinaryExpression expression) {
        final Expression left = expression.getLeft().accept(this);
        final Expression right = expression.getRight().accept(this);
        if (!(left instanceof ITEExpr) && !(right instanceof ITEExpr)
                // We don't rewrite "ITE op ITE" for now
                || (left instanceof ITEExpr && right instanceof ITEExpr)) {
            return null;
        }

        final boolean iteIsLeft = left instanceof ITEExpr;
        final ITEExpr ite = iteIsLeft ? (ITEExpr) left : (ITEExpr) right;
        final Expression other = (iteIsLeft ? right : left);
        final ExpressionKind op = expression.getKind();

        final Expression hoistedIte = expressions.makeITE(
                ite.getCondition(),
                iteIsLeft ? expressions.makeBinary(ite.getTrueCase(), op, other) : expressions.makeBinary(other, op, ite.getTrueCase()),
                iteIsLeft ? expressions.makeBinary(ite.getFalseCase(), op, other) : expressions.makeBinary(other, op, ite.getFalseCase())
        ).accept(this);

        return hoistedIte;
    }

    @Override
    public Expression visitBoolBinaryExpression(BoolBinaryExpr expr) {
        final Expression rewrite = tryGeneralRewrite(expr);
        if (rewrite != null) {
            return rewrite;
        }

        final Expression l = expr.getLeft().accept(this);
        final Expression r = expr.getRight().accept(this);
        final BoolBinaryOp op = expr.getKind();

        // ------- Operations with constants -------
        final boolean swap = l instanceof BoolLiteral;
        final Expression left = swap ? r : l;
        final Expression right = swap ? l : r;

        // ------- Operations on same value -------
        if (aggressive && op == BoolBinaryOp.IFF && left.equals(right)) {
            return expressions.makeTrue();
        }


        if (left instanceof BoolLiteral l1 && right instanceof BoolLiteral l2) {
            final boolean newValue = switch (op) {
                case AND -> l1.getValue() && l2.getValue();
                case OR -> l1.getValue() || l2.getValue();
                case IFF -> l1.getValue() == l2.getValue();
            };
            return expressions.makeValue(newValue);
        }

        final boolean isRing = switch (op) {
            case AND, OR -> true;
            default -> false;
        };
        if (right instanceof BoolLiteral lit && isRing) {
            final boolean neutralValue = op == BoolBinaryOp.AND;
            final boolean absorbingValue = !neutralValue;

            if (lit.getValue() == neutralValue) {
                return left;
            } else if (isPotentiallyEliminable(left)) {
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
            return expressions.makeValue(!lit.getValue());
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
        final Expression rewrite = tryGeneralRewrite(cmp);
        if (rewrite != null) {
            return rewrite;
        }

        final Expression l = cmp.getLeft().accept(this);
        final Expression r = cmp.getRight().accept(this);

        // Normalize "x > y" to "y < x" (and similar).
        final boolean swap = switch (cmp.getKind()) {
            case GTE, GT, UGTE, UGT -> true;
            default -> false;
        };
        final IntCmpOp op = swap ? cmp.getKind().reverse() : cmp.getKind();
        final Expression left = swap ? r : l;
        final Expression right = swap ? l : r;

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
        final Expression rewrite = tryGeneralRewrite(expr);
        if (rewrite != null) {
            return rewrite;
        }

        final Expression l = expr.getLeft().accept(this);
        final Expression r = expr.getRight().accept(this);
        final IntBinaryOp op = expr.getKind();

        // ------- Operations with constants -------
        final boolean swap = op.isCommutative() && l instanceof IntLiteral;
        final Expression left = swap ? r : l;
        final Expression right = swap ? l : r;

        // Optimizations for "x op constant"
        if (right instanceof IntLiteral lit) {
            final boolean isZeroNeutral = lit.isZero() && switch (op) {
                case ADD, SUB, OR, XOR, LSHIFT, RSHIFT, ARSHIFT -> true;
                default -> false;
            };
            final boolean isOneNeutral = lit.isOne() && switch (op) {
                case MUL, DIV, UDIV -> true;
                default -> false;
            };
            if (isZeroNeutral || isOneNeutral) {
                return left;
            }

            if (lit.isZero() && op == IntBinaryOp.MUL && isPotentiallyEliminable(left)) {
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
            if (lit.getValue() && isPotentiallyEliminable(falseCase)) {
                return trueCase;
            }
            if (!lit.getValue() && isPotentiallyEliminable(trueCase)) {
                return falseCase;
            }
        }

        if (trueCase instanceof BoolLiteral tLit && falseCase instanceof BoolLiteral fLit) {
            if (tLit.getValue() == fLit.getValue()) {
                if (isPotentiallyEliminable(cond)) {
                    return tLit;
                } else if (tLit.getValue()) {
                    return expressions.makeBoolBinary(cond, BoolBinaryOp.OR, expressions.makeTrue());
                } else {
                    return expressions.makeBoolBinary(cond, BoolBinaryOp.AND, expressions.makeFalse());
                }

            }

            if (tLit.getValue()) {
                return expr.getCondition();
            } else {
                return expressions.makeNot(expr.getCondition()).accept(this);
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
        final Expression inner = expr.getOperand().accept(this);
        if (inner instanceof ConstructExpr construct) {
            return construct.getOperands().get(expr.getFieldIndex());
        }

        return expressions.makeExtract(expr.getFieldIndex(), inner);
    }

    // =================================== Helper methods ===================================

    // An expression is potentially eliminable if it either carries no dependencies
    // or we are in aggressive mode.
    private boolean isPotentiallyEliminable(Expression expr) {
        return aggressive || expr.getRegs().isEmpty();
    }
}
