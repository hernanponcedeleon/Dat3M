package com.dat3m.dartagnan.expr.integers;

import com.dat3m.dartagnan.expr.Constant;
import com.dat3m.dartagnan.expr.ExpressionKind;
import com.dat3m.dartagnan.expr.ExpressionVisitor;
import com.dat3m.dartagnan.expr.helper.LeafExpressionBase;
import com.dat3m.dartagnan.expr.types.IntegerType;
import com.google.common.base.Preconditions;

import java.math.BigInteger;
import java.util.HashMap;
import java.util.Map;

/*
    A nondeterministic integer expression takes a nondeterministic value from an interval of possible values.
    Such an expression is considered constant because its point of evaluation does not matter.
    Nondeterministic expressions have a unique identifier so that all instances with the same identifier
    always take the same value.

    TODO: The identifier may not be needed if we can make sure to never copy instances of IntNonDet and instead
     reuse existing ones. To determine this, we need to check existing and potential use-cases.
 */
public class IntNonDetExpression extends LeafExpressionBase<IntegerType, ExpressionKind.Leaf> implements Constant {

    private static int nextId = 0;
    private static final Map<Integer, IntNonDetExpression> nonDetInstanceMap = new HashMap<>();

    private final int identifier;
    private final BigInteger lowerBound;
    private final BigInteger upperBound;

    protected IntNonDetExpression(IntegerType type, int identifier, BigInteger lowerBound, BigInteger upperBound) {
        super(type, ExpressionKind.Leaf.NONDET);
        this.identifier = identifier;
        this.lowerBound = lowerBound;
        this.upperBound = upperBound;
    }

    public static IntNonDetExpression create(IntegerType type, int identifier, BigInteger lowerBound, BigInteger upperBound) {
        //TODO: Add checks to make sure the given range fits into the integer type.
        final IntNonDetExpression old = nonDetInstanceMap.get(identifier);
        if (old != null) {
            Preconditions.checkState(old.type.equals(type) &&
                    old.lowerBound.equals(lowerBound) && old.upperBound.equals(upperBound),
                    "IntNonDetExpression with the same identifier but different values already exists.");
            return old;
        } else {
            final IntNonDetExpression newInstance = new IntNonDetExpression(type, identifier, lowerBound, upperBound);
            nonDetInstanceMap.put(identifier, newInstance);
            return newInstance;
        }
    }

    public static IntNonDetExpression create(IntegerType type, BigInteger lowerBound, BigInteger upperBound) {
        return create(type, nextId++, lowerBound, upperBound);
    }

    public static IntNonDetExpression create(IntegerType type, boolean isSigned) {
        return create(type, nextId++, type.getMinimalValue(isSigned), type.getMaximalValue(isSigned));
    }

    public int getIdentifier() { return identifier; }
    public BigInteger getLowerBound() { return lowerBound; }
    public BigInteger getUpperBound() { return upperBound; }

    @Override
    public int hashCode() { return identifier; }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) {
            return true;
        } else if (obj == null || obj.getClass() != this.getClass()) {
            return false;
        }

        final IntNonDetExpression nonDet = (IntNonDetExpression) obj;
        return nonDet.identifier == this.identifier;
    }


    @Override
    public String toString() { return String.format("nondet_%s_%d[%d, %d]", type, identifier, lowerBound, upperBound); }

    @Override
    public <TRet> TRet accept(ExpressionVisitor<TRet> visitor) {
        return visitor.visitIntNonDetExpression(this);
    }
}
