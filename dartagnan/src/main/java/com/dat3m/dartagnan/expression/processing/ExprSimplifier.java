package com.dat3m.dartagnan.expression.processing;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.booleans.BoolBinaryExpr;
import com.dat3m.dartagnan.expression.booleans.BoolLiteral;
import com.dat3m.dartagnan.expression.booleans.BoolUnaryExpr;
import com.dat3m.dartagnan.expression.integers.IntBinaryExpr;
import com.dat3m.dartagnan.expression.integers.IntCmpExpr;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.integers.IntUnaryExpr;
import com.dat3m.dartagnan.expression.misc.ITEExpr;
import com.dat3m.dartagnan.expression.op.BoolUnaryOp;
import com.dat3m.dartagnan.expression.op.IntBinaryOp;
import com.dat3m.dartagnan.program.memory.MemoryObject;

import java.math.BigInteger;

import static com.dat3m.dartagnan.expression.op.IntBinaryOp.RSHIFT;

public class ExprSimplifier extends ExprTransformer {

    @Override
    public Expression visitIntCmpExpression(IntCmpExpr cmp) {
        Expression lhs = cmp.getLeft().accept(this);
        Expression rhs = cmp.getRight().accept(this);
        if (lhs.equals(rhs)) {
            return switch (cmp.getKind()) {
                case EQ, LTE, ULTE, GTE, UGTE -> expressions.makeTrue();
                case NEQ, LT, ULT, GT, UGT -> expressions.makeFalse();
            };
        }
        if (lhs instanceof IntLiteral lc && rhs instanceof IntLiteral rc) {
            return expressions.makeValue(cmp.getKind().combine(lc.getValue(), rc.getValue()));
        }
        return expressions.makeBinary(lhs, cmp.getKind(), rhs);
    }

    @Override
    public Expression visitBoolBinaryExpression(BoolBinaryExpr bBin) {
        Expression l = bBin.getLeft().accept(this);
        Expression r = bBin.getRight().accept(this);
        Expression left = l instanceof BoolLiteral || !(r instanceof BoolLiteral) ? l : r;
        Expression right = left == l ? r : l;
        if (left instanceof BoolLiteral constant) {
            boolean value = constant.getValue();
            boolean neutralValue = switch (bBin.getKind()) {
                case OR -> false;
                case AND -> true;
            };
            if (value == neutralValue) {
                return right;
            }
            // otherwise value is the absorbing value
            if (right.getRegs().isEmpty()) {
                return left;
            }
        }
        return expressions.makeBinary(left, bBin.getKind(), right);
    }

    @Override
    public Expression visitBoolUnaryExpression(BoolUnaryExpr bUn) {
        Expression inner = bUn.getOperand().accept(this);
        assert bUn.getKind() == BoolUnaryOp.NOT;
        if (inner instanceof BoolLiteral constant) {
            return expressions.makeValue(!constant.getValue());
        }
        if (inner instanceof BoolUnaryExpr innerUnary && innerUnary.getKind() == BoolUnaryOp.NOT) {
            return innerUnary.getOperand();
        }

        if (inner instanceof IntCmpExpr cmp) {
            // Move negations into the atoms COp
            return expressions.makeBinary(cmp.getLeft(), cmp.getKind().inverted(), cmp.getRight());
        }
        return expressions.makeUnary(bUn.getKind(), inner);
    }

    @Override
    public Expression visitIntBinaryExpression(IntBinaryExpr iBin) {
        Expression lhs = iBin.getLeft().accept(this);
        Expression rhs = iBin.getRight().accept(this);
        IntBinaryOp op = iBin.getKind();
        if (lhs.equals(rhs)) {
            switch(op) {
                case AND:
                case OR:
                    return lhs;
                case XOR:
                    return expressions.makeZero(iBin.getType());
            }
        }
        if (! (lhs instanceof IntLiteral || rhs instanceof IntLiteral)) {
            return expressions.makeBinary(lhs, op, rhs);
        } else if (lhs instanceof IntLiteral && rhs instanceof IntLiteral) {
            // If we reduce MemoryObject as a normal IntLiteral, we loose the fact that it is a Memory Object
            // We cannot call reduce for RSHIFT (lack of implementation)
            if(!(lhs instanceof MemoryObject) && op != RSHIFT) {
                return expressions.makeBinary(lhs, op, rhs).reduce();
            }
            // Rule to reduce &mem + 0
            if(lhs instanceof MemoryObject && rhs.equals(expressions.makeZero(types.getArchType()))) {
                return lhs;
            }
        }

        if (lhs instanceof IntLiteral lc) {
            BigInteger val = lc.getValue();
            switch (op) {
                case MUL:
                    if (val.equals(BigInteger.ZERO)) {
                        return lhs;
                    }
                    if (val.equals(BigInteger.ONE)) {
                        return rhs;
                    }
                case ADD:
                    if (val.equals(BigInteger.ZERO)) {
                        return rhs;
                    }
            }
            return expressions.makeBinary(lhs, op, rhs);
        }

        IntLiteral rc = (IntLiteral)rhs;
        BigInteger val = rc.getValue();
        switch (op) {
            case MUL:
                if (val.equals(BigInteger.ZERO)) {
                    return rhs;
                }
                if (val.equals(BigInteger.ONE)) {
                    return lhs;
                }
                break;
            case ADD:
            case SUB:
                if(val.equals(BigInteger.ZERO)) {
                    return lhs;
                }
                // Rule for associativity (rhs is IntLiteral) since we cannot reduce MemoryObjects
                // Either op can be +/-, but this does not affect correctness
                // e.g. (&mem + x) - y -> &mem + reduced(x - y)
                if(lhs instanceof IntBinaryExpr lhsBin && lhsBin.getRight() instanceof IntLiteral && lhsBin.getKind() != RSHIFT) {
                    Expression newLHS = lhsBin.getLeft();
                    Expression newRHS = expressions.makeBinary(lhsBin.getRight(), lhsBin.getKind(), rhs).reduce();
                    return expressions.makeBinary(newLHS, op, newRHS);
                }

        }
        return expressions.makeBinary(lhs, op, rhs);
    }

    @Override
    public Expression visitIntUnaryExpression(IntUnaryExpr iUn) {
        // TODO: Add simplifications
        return super.visitIntUnaryExpression(iUn);
    }

    @Override
    public Expression visitITEExpression(ITEExpr iteExpr) {
        Expression cond = iteExpr.getCondition().accept(this);
        Expression t = iteExpr.getTrueCase().accept(this);
        Expression f = iteExpr.getFalseCase().accept(this);

        if (cond instanceof BoolLiteral constantGuard) {
            return constantGuard.getValue() ? t : f;
        } else if (t.equals(f)) {
            return t;
        }

        // Simplifies "ITE(cond, 1, 0)" to "cond" and "ITE(cond, 0, 1) to "!cond"
        // TODO: It is not clear if this gives performance improvements or not
        if (t instanceof IntLiteral tConstant && tConstant.getType().isMathematical() && tConstant.getValueAsInt() == 1
                && f instanceof IntLiteral fConstant && fConstant.getType().isMathematical() && fConstant.getValueAsInt() == 0) {
            return cond;
        } else if (t instanceof IntLiteral tConstant && tConstant.getType().isMathematical() && tConstant.getValueAsInt() == 0
                && f instanceof IntLiteral fConstant && fConstant.getType().isMathematical() && fConstant.getValueAsInt() == 1) {
            return expressions.makeNot(cond);
        }

        return expressions.makeITE(cond, t, f);
    }


}
