package com.dat3m.dartagnan.expression.type;

import com.dat3m.dartagnan.GlobalSettings;

import java.util.HashMap;
import java.util.Map;

import static com.google.common.base.Preconditions.checkArgument;

public final class TypeFactory {

    private static TypeFactory instance = new TypeFactory();
    private final VoidType voidType = new VoidType();
    private final BooleanType booleanType = new BooleanType();
    private final IntegerType mathematicalIntegerType = new IntegerType(IntegerType.MATHEMATICAL);

    private final Map<Integer, IntegerType> integerTypeMap = new HashMap<>();

    private TypeFactory() {}

    //TODO make this part of the program.
    public static TypeFactory getInstance() {
        return instance;
    }

    public BooleanType getBooleanType() {
        return booleanType;
    }

    public VoidType getVoidType() { return voidType; }

    public IntegerType getIntegerType() {
        return mathematicalIntegerType;
    }

    public IntegerType getIntegerType(int bitWidth) {
        checkArgument(bitWidth >= 0, "Negative bit width %s.", bitWidth);
        return integerTypeMap.computeIfAbsent(bitWidth, IntegerType::new);
    }

    public IntegerType getArchType() {
        int archPrecision = GlobalSettings.getArchPrecision();
        return archPrecision < 0 ? getIntegerType() : getIntegerType(archPrecision);
    }
}
