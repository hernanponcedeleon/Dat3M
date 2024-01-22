package com.dat3m.dartagnan.expression.processing;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.BoolUnaryOp;
import com.dat3m.dartagnan.expression.op.IntBinaryOp;
import com.dat3m.dartagnan.program.memory.MemoryObject;

import java.math.BigInteger;

import static com.dat3m.dartagnan.expression.op.IntBinaryOp.RSHIFT;

public class ExprSimplifier extends ExprTransformer {

    @Override
    public Expression visit(Atom atom) {
        Expression lhs = atom.getLHS().accept(this);
        Expression rhs = atom.getRHS().accept(this);
        if (lhs.equals(rhs)) {
            return switch (atom.getOp()) {
                case EQ, LTE, ULTE, GTE, UGTE -> expressions.makeTrue();
                case NEQ, LT, ULT, GT, UGT -> expressions.makeFalse();
            };
        }
        if (lhs instanceof IntLiteral lc && rhs instanceof IntLiteral rc) {
            return expressions.makeValue(atom.getOp().combine(lc.getValue(), rc.getValue()));
        }
        return expressions.makeBinary(lhs, atom.getOp(), rhs);
    }

    @Override
    public Expression visit(BoolBinaryExpr bBin) {
        Expression l = bBin.getLHS().accept(this);
        Expression r = bBin.getRHS().accept(this);
        Expression left = l instanceof BoolLiteral || !(r instanceof BoolLiteral) ? l : r;
        Expression right = left == l ? r : l;
        if (left instanceof BoolLiteral constant) {
            boolean value = constant.getValue();
            boolean neutralValue = switch (bBin.getOp()) {
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
        return expressions.makeBinary(left, bBin.getOp(), right);
    }

    @Override
    public Expression visit(BoolUnaryExpr bUn) {
        Expression inner = bUn.getInner().accept(this);
        assert bUn.getOp() == BoolUnaryOp.NOT;
        if (inner instanceof BoolLiteral constant) {
            return expressions.makeValue(!constant.getValue());
        }
        if (inner instanceof BoolUnaryExpr innerUnary && innerUnary.getOp() == BoolUnaryOp.NOT) {
            return innerUnary.getInner();
        }

        if (inner instanceof Atom atom) {
            // Move negations into the atoms COp
            return expressions.makeBinary(atom.getLHS(), atom.getOp().inverted(), atom.getRHS());
        }
        return expressions.makeUnary(bUn.getOp(), inner);
    }

    @Override
    public Expression visit(IntBinaryExpr iBin) {
        Expression lhs = iBin.getLHS().accept(this);
        Expression rhs = iBin.getRHS().accept(this);
        IntBinaryOp op = iBin.getOp();
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
                if(lhs instanceof IntBinaryExpr lhsBin && lhsBin.getRHS() instanceof IntLiteral && lhsBin.getOp() != RSHIFT) {
                    Expression newLHS = lhsBin.getLHS();
                    Expression newRHS = expressions.makeBinary(lhsBin.getRHS(), lhsBin.getOp(), rhs).reduce();
                    return expressions.makeBinary(newLHS, op, newRHS);
                }

        }
        return expressions.makeBinary(lhs, op, rhs);
    }

    @Override
    public Expression visit(IntUnaryExpr iUn) {
        // TODO: Add simplifications
        return super.visit(iUn);
    }

    @Override
    public Expression visit(ITEExpr iteExpr) {
        Expression cond = iteExpr.getGuard().accept(this);
        Expression t = iteExpr.getTrueBranch().accept(this);
        Expression f = iteExpr.getFalseBranch().accept(this);

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
