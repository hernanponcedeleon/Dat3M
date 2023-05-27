package com.dat3m.dartagnan.expression.type;

import static com.google.common.base.Preconditions.checkState;

public final class IntegerType implements Type {

    final static int MATHEMATICAL = -1;

    private final int bitWidth;

    IntegerType(int bitWidth) {
        this.bitWidth = bitWidth;
    }

    public boolean isMathematical() {
        return bitWidth == MATHEMATICAL;
    }

    public int getBitWidth() {
        checkState(bitWidth > 0, "Invalid integer bound %s", bitWidth);
        return bitWidth;
    }

    @Override
    public String toString() {
        return isMathematical() ? "int" : "bv" + bitWidth;
    }
}
