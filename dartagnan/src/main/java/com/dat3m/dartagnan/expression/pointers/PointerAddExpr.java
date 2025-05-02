package com.dat3m.dartagnan.expression.pointers;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionKind;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.base.ExpressionBase;
import com.dat3m.dartagnan.expression.type.PointerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableList;

public class PointerAddExpr extends ExpressionBase<PointerType> {

    private final Expression base;
    private final Expression offset;

    public PointerAddExpr(Expression base, Expression offset) {
        super((PointerType) base.getType());
        Preconditions.checkArgument(offset.getType().equals(TypeFactory.getInstance().getArchType()));
        this.base = base;
        this.offset = offset;
    }

    public Expression getBase() { return base; }
    public Expression getOffset() { return offset; }

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
        return visitor.visitPointerAddExpression(this);
    }
}
