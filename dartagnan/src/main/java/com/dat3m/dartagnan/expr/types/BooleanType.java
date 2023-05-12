package com.dat3m.dartagnan.expr.types;

import com.dat3m.dartagnan.expr.Type;
import com.dat3m.dartagnan.expr.booleans.BoolLiteral;

public final class BooleanType implements Type {

    private BooleanType() {}

    private static final BooleanType BOOL_TYPE = new BooleanType();

    public static BooleanType get() { return BOOL_TYPE; }

    public static BoolLiteral createConstant(boolean value) {
        return BoolLiteral.create(value);
    }

    @Override
    public int getMemoryAlignment() {
        return 1;
    }

    @Override
    public int getMemorySize() {
        return 1;
    }

    @Override
    public String toString() {
        return "Bool";
    }
}
