package com.dat3m.dartagnan.program.expression.type;

import static com.google.common.base.Preconditions.checkArgument;

public final class BoundedIntegerType implements Type {

    private final int bitWidth;

    BoundedIntegerType(int bitWidth) {
        checkArgument(bitWidth > 0);
        this.bitWidth = bitWidth;
    }

    public int getBitWidth() {
        return bitWidth;
    }

    @Override
    public String toString() {
        return "bv" + bitWidth;
    }
}
