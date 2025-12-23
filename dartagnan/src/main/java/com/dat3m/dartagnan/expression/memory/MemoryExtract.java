package com.dat3m.dartagnan.expression.memory;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionKind;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.base.UnaryExpressionBase;
import com.dat3m.dartagnan.expression.type.MemoryType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.expression.utils.ExpressionHelper;
import com.google.common.base.Preconditions;

public class MemoryExtract extends UnaryExpressionBase<MemoryType, ExpressionKind.Other> {

    private final int lowBit;
    private final int highBit;

    public MemoryExtract(Expression operand, int lowBit, int highBit) {
        super(TypeFactory.getInstance().getMemoryType(highBit - lowBit + 1),
                ExpressionKind.Other.BV_EXTRACT,
                operand);
        ExpressionHelper.checkExpectedType(operand, MemoryType.class);
        int originalWidth = ((MemoryType) operand.getType()).getBitWidth();
        Preconditions.checkArgument(0 <= lowBit && lowBit <= highBit && highBit < originalWidth);
        this.lowBit = lowBit;
        this.highBit = highBit;
    }

    public int getLowBit() { return lowBit; }
    public int getHighBit() { return highBit; }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitMemoryExtractExpression(this);
    }
}
