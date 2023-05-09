package com.dat3m.dartagnan.program.expression;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.*;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.math.BigInteger;

public final class ExpressionFactory {

    private static final Logger logger = LogManager.getLogger(ExpressionFactory.class);
    private static final ExpressionFactory instance = new ExpressionFactory();

    private ExpressionFactory() {}

    public static ExpressionFactory getInstance() {
        return instance;
    }

    public BExpr makeTrue() {
        return BConst.TRUE;
    }

    public BExpr makeFalse() {
        return BConst.FALSE;
    }

    public BExpr makeValue(boolean value) {
        return value ? BConst.TRUE : BConst.FALSE;
    }

    public IExpr makeZero(int bitWidth) {
        return makeValue(BigInteger.ZERO, bitWidth);
    }

    public IExpr makeOne(int bitWidth) {
        return makeValue(BigInteger.ONE, bitWidth);
    }

    public IExpr parseValue(String text, int bitWidth) {
        return makeValue(new BigInteger(text), bitWidth);
    }

    public IExpr makeValue(BigInteger value, int bitWidth) {
        return new IValue(value, bitWidth);
    }

    public BExpr makeUnary(BOpUn operator, ExprInterface inner) {
        return new BExprUn(operator, inner);
    }

    public IExpr makeUnary(IOpUn operator, IExpr inner) {
        return new IExprUn(operator, inner);
    }

    public BExpr makeBinary(ExprInterface left, BOpBin operator, ExprInterface right) {
        if (!(left instanceof BExpr) || !(right instanceof BExpr)) {
            logger.warn("non-boolean operands {} {} {}", left, operator, right);
        }
        return new BExprBin(left, operator, right);
    }

    public BExpr makeBinary(ExprInterface left, COpBin comparator, ExprInterface right) {
        checkTypes(left, comparator, right);
        return new Atom(left, comparator, right);
    }

    public IExpr makeBinary(IExpr left, IOpBin operator, IExpr right) {
        checkTypes(left, operator, right);
        return new IExprBin(left, operator, right);
    }

    public IExpr makeConditional(BExpr condition, IExpr ifTrue, IExpr ifFalse) {
        return new IfExpr(condition, ifTrue, ifFalse);
    }

    private void checkTypes(ExprInterface left, Object operator, ExprInterface right) {
        if (!left.getType().equals(right.getType())) {
            logger.warn("Type mismatch: {} {} {}", left, operator, right);
        }
    }
}
