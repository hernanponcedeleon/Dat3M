package com.dat3m.dartagnan.program.expression.type;

import static com.google.common.base.Preconditions.checkArgument;

public final class IntegerType implements Type {

    private final int bitWidth;

    IntegerType(int bitWidth) {
        checkArgument(bitWidth > 0);
        this.bitWidth = bitWidth;
    }

    public int getBitWidth() {
        return bitWidth;
    }
}
