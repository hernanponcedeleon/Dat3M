package com.dat3m.dartagnan.prototype.expr.helper;

import com.dat3m.dartagnan.prototype.expr.ExpressionKind;
import com.dat3m.dartagnan.prototype.expr.LeafExpression;
import com.dat3m.dartagnan.prototype.expr.Type;

import java.util.List;

public abstract class LeafExpressionBase<TType extends Type, TKind extends ExpressionKind>
        extends ExpressionBase<TType, TKind> implements LeafExpression {

    protected LeafExpressionBase(TType type, TKind kind) {
        super(type, kind, List.of());
    }
}