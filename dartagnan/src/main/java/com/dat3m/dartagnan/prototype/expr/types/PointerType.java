package com.dat3m.dartagnan.prototype.expr.types;

import com.dat3m.dartagnan.prototype.expr.Type;

public final class PointerType implements Type {

    private PointerType() { }

    private static final PointerType POINTER_TYPE = new PointerType();

    public static PointerType get() { return POINTER_TYPE; }

    @Override
    public int getMemoryAlignment() {
        return 4;//TODO use a global option
    }

    @Override
    public int getMemorySize() {
        return getMemoryAlignment();
    }

    @Override
    public String toString() {
        return "Pointer";
    }

}
