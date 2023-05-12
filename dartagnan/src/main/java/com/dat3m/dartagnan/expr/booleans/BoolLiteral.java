package com.dat3m.dartagnan.expr.booleans;

import com.dat3m.dartagnan.expr.Expression;
import com.dat3m.dartagnan.expr.ExpressionKind;
import com.dat3m.dartagnan.expr.ExpressionVisitor;
import com.dat3m.dartagnan.expr.Literal;
import com.dat3m.dartagnan.expr.types.BooleanType;

import java.util.List;

public class BoolLiteral implements Literal<Boolean> {

    public static final BoolLiteral TRUE = new BoolLiteral();
    public static final BoolLiteral FALSE = new BoolLiteral();

    public static BoolLiteral create(boolean value) {
        return value ? TRUE : FALSE;
    }

    private BoolLiteral() {}

    @Override
    public BooleanType getType() { return BooleanType.get(); }

    @Override
    public List<? extends Expression> getOperands() { return List.of(); }

    @Override
    public ExpressionKind.Leaf getKind() { return ExpressionKind.Leaf.LITERAL; }

    @Override
    public Boolean getValue() { return this == TRUE; }

    @Override
    public String toString() {
        return getValue() ? "TRUE" : "FALSE";
    }

    @Override
    public <TRet> TRet accept(ExpressionVisitor<TRet> visitor) {
        return visitor.visitBoolLiteral(this);
    }
}
