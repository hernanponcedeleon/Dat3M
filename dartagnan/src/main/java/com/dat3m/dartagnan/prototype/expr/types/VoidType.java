package com.dat3m.dartagnan.prototype.expr.types;

import com.dat3m.dartagnan.prototype.expr.Type;

public final class VoidType implements Type {

    private VoidType() { }

    private static final VoidType VOID_TYPE = new VoidType();

    public static VoidType get() { return VOID_TYPE; }

    @Override
    public int getMemoryAlignment() {
        return 0;
    }

    @Override
    public int getMemorySize() {
        return 0;
    }

    @Override
    public String toString() {
        return "Void";
    }

}
