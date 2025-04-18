package com.dat3m.dartagnan.expression.integers;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionKind;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.base.UnaryExpressionBase;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.expression.utils.ExpressionHelper;
import com.google.common.base.Preconditions;

public class IntExtract extends UnaryExpressionBase<IntegerType, ExpressionKind.Other> {

    private final int lowBit;
    private final int highBit;

    public IntExtract(Expression operand, int lowBit, int highBit) {
        super(TypeFactory.getInstance().getIntegerType(highBit - lowBit + 1),
                ExpressionKind.Other.BV_EXTRACT,
                operand);
        ExpressionHelper.checkExpectedType(operand, IntegerType.class);
        int originalWidth = ((IntegerType)operand.getType()).getBitWidth();
        Preconditions.checkArgument(0 <= lowBit && lowBit <= highBit && highBit < originalWidth);
        this.lowBit = lowBit;
        this.highBit = highBit;
    }

    public int getLowBit() { return lowBit; }
    public int getHighBit() { return highBit; }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitIntExtract(this);
    }
}
