package com.dat3m.dartagnan.expression.memory;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionKind;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.base.NaryExpressionBase;
import com.dat3m.dartagnan.expression.type.MemoryType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.expression.utils.ExpressionHelper;
import com.google.common.collect.ImmutableList;

import java.util.List;

public class MemoryConcat extends NaryExpressionBase<MemoryType, ExpressionKind.Other> {

    public MemoryConcat(List<? extends Expression> operands) {
        super(getConcatType(operands), ExpressionKind.Other.BV_CONCAT, ImmutableList.copyOf(operands));
    }

    private static MemoryType getConcatType(List<? extends Expression> operands) {
        int size = 0;
        for (Expression op : operands) {
            ExpressionHelper.checkExpectedType(op, MemoryType.class);
            size += ((MemoryType)op.getType()).getBitWidth();
        }
        return TypeFactory.getInstance().getMemoryType(size);
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitMemoryConcatExpression(this);
    }
}
