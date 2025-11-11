package com.dat3m.dartagnan.expression.type;

import com.dat3m.dartagnan.expression.Type;

public class PointerType implements Type {

    public int bitWidth;

    // todo change the encoding to recognise bit width

    PointerType(int bitWidth) {
        this.bitWidth = bitWidth;
    }

    @Override
    public String toString() {
        return "ptr_"+ bitWidth;
    }

    @Override
    public boolean equals(Object obj) {
        return obj instanceof PointerType other
                && other.bitWidth == this.bitWidth;
    }

    public int getBitWidth() {
        return bitWidth;
    }
}
