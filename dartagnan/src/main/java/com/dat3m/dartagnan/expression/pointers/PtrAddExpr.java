package com.dat3m.dartagnan.expression.pointers;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionKind;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.base.ExpressionBase;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.PointerType;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableList;
/* This expression has only one operation and therefore does not need an operation class.
 * Similar to the compare operation, ptrAdd expression is not recognised by the parsers.
 * IntAddOp is transformed into the ptrAdd expression in the visitors if Ptr + Int or Int + Ptr.
 */
public class PtrAddExpr extends ExpressionBase<PointerType> {

    private final Expression base;
    private final Expression offset;

    public PtrAddExpr(Expression base, Expression offset) {
        super((PointerType) base.getType());
        Preconditions.checkArgument(offset.getType() instanceof IntegerType);
        this.base = base;
        this.offset = offset;
    }

    public Expression getBase() {
        return base;
    }

    public Expression getOffset() {
        return offset;
    }

    @Override
    public ImmutableList<Expression> getOperands() {
        return ImmutableList.of(base, offset);
    }

    @Override
    public ExpressionKind getKind() {
        return () -> "ptradd";
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitPtrAddExpression(this);
    }
}
