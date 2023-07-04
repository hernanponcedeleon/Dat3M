package com.dat3m.dartagnan.expression.type;

import com.dat3m.dartagnan.GlobalSettings;
import com.dat3m.dartagnan.utils.Normalizer;

import java.util.List;

import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Preconditions.checkNotNull;

public final class TypeFactory {

    private static final TypeFactory instance = new TypeFactory();

    private final VoidType voidType = new VoidType();
    private final BooleanType booleanType = new BooleanType();
    private final IntegerType mathematicalIntegerType = new IntegerType(IntegerType.MATHEMATICAL);

    private final Normalizer typeNormalizer = new Normalizer();

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
        checkArgument(bitWidth > 0, "Non-positive bit width %s.", bitWidth);
        return typeNormalizer.normalize(new IntegerType(bitWidth));
    }

    public FunctionType getFunctionType(Type returnType, List<? extends Type> parameterTypes) {
        checkNotNull(returnType);
        checkNotNull(parameterTypes);
        checkArgument(parameterTypes.stream().noneMatch(t -> t == voidType), "Void parameters are not allowed");
        return typeNormalizer.normalize(new FunctionType(returnType, parameterTypes.toArray(new Type[0])));
    }

    public IntegerType getArchType() {
        final int archPrecision = GlobalSettings.getArchPrecision();
        return archPrecision < 0 ? getIntegerType() : getIntegerType(archPrecision);
    }
}
