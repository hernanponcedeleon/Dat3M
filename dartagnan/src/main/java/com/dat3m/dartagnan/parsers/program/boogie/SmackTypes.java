package com.dat3m.dartagnan.parsers.program.boogie;

import com.dat3m.dartagnan.program.expression.type.Type;
import com.dat3m.dartagnan.program.expression.type.TypeFactory;

import static com.dat3m.dartagnan.GlobalSettings.getArchPrecision;

public class SmackTypes {

    private static final TypeFactory types = TypeFactory.getInstance();
    private static final int archPrecision = getArchPrecision();
    public static final Type refType = archPrecision < 0 ? types.getIntegerType() : types.getIntegerType(archPrecision);

    private SmackTypes() {}

    public static Type parseType(String name) {
        TypeFactory types = TypeFactory.getInstance();
        //TODO this part should be in sync with VisitorBoogie
        if (name.equals("bool")) {
            return types.getBooleanType();
        }
        if (name.startsWith("bv")) {
            return types.getIntegerType(Integer.parseInt(name.substring(2)));
        }
        return refType;
    }
}
