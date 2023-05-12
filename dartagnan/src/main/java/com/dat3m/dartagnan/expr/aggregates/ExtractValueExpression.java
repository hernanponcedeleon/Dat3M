package com.dat3m.dartagnan.expr.aggregates;

import com.dat3m.dartagnan.expr.Expression;
import com.dat3m.dartagnan.expr.ExpressionKind;
import com.dat3m.dartagnan.expr.ExpressionVisitor;
import com.dat3m.dartagnan.expr.Type;
import com.dat3m.dartagnan.expr.helper.UnaryExpressionBase;
import com.dat3m.dartagnan.expr.types.AggregateType;
import com.google.common.base.Preconditions;

public class ExtractValueExpression extends UnaryExpressionBase<Type, ExpressionKind.Aggregates> {

    protected final int index;

    protected ExtractValueExpression(int index, Expression operand) {
        super(((AggregateType)operand.getType()).getAggregatedTypes().get(index), ExpressionKind.Aggregates.EXTRACT, operand);
        this.index = index;
    }

    public static ExtractValueExpression create(int index, Expression operand) {
        Preconditions.checkArgument(operand.getType() instanceof AggregateType);
        Preconditions.checkArgument(index >= 0);
        Preconditions.checkArgument(index <= ((AggregateType)operand.getType()).getAggregatedTypes().size());
        return new ExtractValueExpression(index, operand);
    }

    @Override
    public String toString() {
        return String.format("%s(%d, %s)", getKind().getSymbol(), index, getOperand());
    }

    @Override
    public <TRet> TRet accept(ExpressionVisitor<TRet> visitor) {
        return visitor.visitExtractValueExpression(this);
    }
}
