package com.dat3m.dartagnan.prototype.expr.integers;

import com.dat3m.dartagnan.prototype.expr.Expression;
import com.dat3m.dartagnan.prototype.expr.ExpressionKind;
import com.dat3m.dartagnan.prototype.expr.ExpressionVisitor;
import com.dat3m.dartagnan.prototype.expr.helper.CastExpressionBase;
import com.dat3m.dartagnan.prototype.expr.types.IntegerType;
import com.google.common.base.Preconditions;

public class BitWidthCastExpression extends CastExpressionBase<IntegerType, IntegerType> {

    protected final boolean isSignPreserving;

    protected BitWidthCastExpression(IntegerType targetType, Expression operand, boolean preserveSign) {
        super(targetType, ExpressionKind.Cast.CONVERT, operand);
        this.isSignPreserving = preserveSign;
    }

    public static BitWidthCastExpression create(IntegerType targetType, Expression operand, boolean preserveSign) {
        //TODO: Check if <preserveSign> makes sense for this cast.
        Preconditions.checkArgument(operand.getType() instanceof IntegerType);
        return new BitWidthCastExpression(targetType, operand, preserveSign);
    }

    public boolean isTruncating() { return this.getSourceType().canContain(this.getType()); }
    public boolean isExtending() { return getType().canContain(this.getSourceType()); }
    public boolean isNoop() { return getSourceType() == this.getType();}
    public boolean isSignPreserving() { return this.isSignPreserving; }

    @Override
    public <TRet> TRet accept(ExpressionVisitor<TRet> visitor) {
        return visitor.visitBitWidthCastExpression(this);
    }
}
