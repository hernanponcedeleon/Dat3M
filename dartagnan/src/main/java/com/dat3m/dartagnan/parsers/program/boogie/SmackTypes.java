package com.dat3m.dartagnan.parsers.program.boogie;

import com.dat3m.dartagnan.program.expression.type.Type;
import com.dat3m.dartagnan.program.expression.type.TypeFactory;

public class SmackTypes {

    private static final TypeFactory types = TypeFactory.getInstance();
    public static final Type refType = types.getArchType();

    private SmackTypes() {}

    public static Type parseType(String name) {
        TypeFactory types = TypeFactory.getInstance();
        if (name.equals("bool")) {
            return types.getBooleanType();
        }
        if (name.startsWith("bv")) {
            return types.getIntegerType(Integer.parseInt(name.substring(2)));
        }
        return refType;
    }
}
