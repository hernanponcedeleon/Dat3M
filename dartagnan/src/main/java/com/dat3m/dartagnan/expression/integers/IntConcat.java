package com.dat3m.dartagnan.expression.integers;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionKind;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.base.NaryExpressionBase;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.expression.utils.ExpressionHelper;
import com.google.common.collect.ImmutableList;

import java.util.List;

public class IntConcat extends NaryExpressionBase<IntegerType, ExpressionKind.Other> {

    public IntConcat(List<? extends Expression> operands) {
        super(getConcatType(operands), ExpressionKind.Other.BV_CONCAT, ImmutableList.copyOf(operands));
    }

    private static IntegerType getConcatType(List<? extends Expression> operands) {
        int size = 0;
        for (Expression op : operands) {
            ExpressionHelper.checkExpectedType(op, IntegerType.class);
            size += ((IntegerType)op.getType()).getBitWidth();
        }
        return TypeFactory.getInstance().getIntegerType(size);
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitIntConcat(this);
    }
}
