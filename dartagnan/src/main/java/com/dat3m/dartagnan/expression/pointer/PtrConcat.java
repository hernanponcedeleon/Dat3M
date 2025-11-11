package com.dat3m.dartagnan.expression.pointer;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionKind;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.base.NaryExpressionBase;
import com.dat3m.dartagnan.expression.type.PointerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.expression.utils.ExpressionHelper;
import com.google.common.collect.ImmutableList;

import java.util.List;

public class PtrConcat extends NaryExpressionBase<PointerType, ExpressionKind.Other> {

    public PtrConcat(List<? extends Expression> operands) {
        super(getConcatType(operands), ExpressionKind.Other.BV_CONCAT, ImmutableList.copyOf(operands));
    }

    private static PointerType getConcatType(List<? extends Expression> operands) {
        int size = 0;
        for (Expression op : operands) {
            ExpressionHelper.checkExpectedType(op, PointerType.class);
            size += ((PointerType)op.getType()).getBitWidth();
        }
        return TypeFactory.getInstance().getPointerType(size);
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitPtrConcat(this);
    }
}
