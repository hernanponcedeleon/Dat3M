package com.dat3m.dartagnan.program.expression;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.*;
import com.dat3m.dartagnan.program.expression.type.Type;
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

    public BConst makeTrue() {
        return BConst.TRUE;
    }

    public BConst makeFalse() {
        return BConst.FALSE;
    }

    public BConst makeValue(boolean value) {
        return value ? BConst.TRUE : BConst.FALSE;
    }

    public IValue makeZero(Type type) {
        return makeValue(BigInteger.ZERO, type);
    }

    public IValue makeOne(Type type) {
        return makeValue(BigInteger.ONE, type);
    }

    public IValue parseValue(String text, Type type) {
        return makeValue(new BigInteger(text), type);
    }

    public IValue makeValue(BigInteger value, Type type) {
        return new IValue(value, type);
    }

    public Expression makeUnary(BOpUn operator, Expression inner) {
        return new BExprUn(operator, inner);
    }

    public IExpr makeUnary(IOpUn operator, IExpr inner) {
        return new IExprUn(operator, inner);
    }

    public Expression makeBinary(Expression left, BOpBin operator, Expression right) {
        if (!left.isBoolean() || !right.isBoolean()) {
            logger.warn("non-boolean operands {} {} {}", left, operator, right);
        }
        return new BExprBin(left, operator, right);
    }

    public Expression makeBinary(Expression left, COpBin comparator, Expression right) {
        checkTypes(left, comparator, right);
        return new Atom(left, comparator, right);
    }

    public IExpr makeBinary(IExpr left, IOpBin operator, IExpr right) {
        checkTypes(left, operator, right);
        return new IExprBin(left, operator, right);
    }

    public IExpr makeConditional(Expression condition, IExpr ifTrue, IExpr ifFalse) {
        return new IfExpr(condition, ifTrue, ifFalse);
    }

    private void checkTypes(Expression left, Object operator, Expression right) {
        if (!left.getType().equals(right.getType())) {
            logger.warn("Type mismatch: {} {} {}", left, operator, right);
        }
    }
}
