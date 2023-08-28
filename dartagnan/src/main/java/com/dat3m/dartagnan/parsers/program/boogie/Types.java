package com.dat3m.dartagnan.parsers.program.boogie;

import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;

public class Types {

    private Types() {}

    public static IntegerType parseIntegerType(String name, TypeFactory types) {
        if (name.contains("bv")) {
            return types.getIntegerType(Integer.parseInt(name.split("bv")[1]));
        }
        return types.getArchType();
    }
}
