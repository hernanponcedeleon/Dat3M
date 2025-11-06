package com.dat3m.dartagnan.expression.pointer;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionKind;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.base.UnaryExpressionBase;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.PointerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.expression.utils.ExpressionHelper;
import com.google.common.base.Preconditions;

public class PtrExtract extends UnaryExpressionBase<PointerType, ExpressionKind.Other> {

    private final int lowBit;
    private final int highBit;

    public PtrExtract(Expression operand, int lowBit, int highBit) {
        super(TypeFactory.getInstance().getPointerType(highBit - lowBit + 1),
                ExpressionKind.Other.BV_EXTRACT,
                operand);
        ExpressionHelper.checkExpectedType(operand, PointerType.class);
        int originalWidth = ((IntegerType)operand.getType()).getBitWidth();
        Preconditions.checkArgument(0 <= lowBit && lowBit <= highBit && highBit < originalWidth);
        this.lowBit = lowBit;
        this.highBit = highBit;
    }

    public int getLowBit() { return lowBit; }
    public int getHighBit() { return highBit; }

    public boolean isExtractingLowBits() {
        return lowBit == 0;
    }
    public boolean isExtractingHighBits() {
        return operand.getType() instanceof IntegerType t && highBit + 1 == t.getBitWidth();
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitPtrExtract(this);
    }
}
