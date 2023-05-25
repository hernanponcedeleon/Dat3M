package com.dat3m.dartagnan.program.expression.type;

import com.dat3m.dartagnan.GlobalSettings;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static com.google.common.base.Preconditions.checkArgument;

public final class TypeFactory {

    private static final TypeFactory instance = new TypeFactory();
    private final BooleanType booleanType = new BooleanType();
    private final UnboundedIntegerType unboundedIntegerType = new UnboundedIntegerType();
    private final PointerType pointerType = new PointerType();
    private final Map<Integer, BoundedIntegerType> integerTypeMap = new HashMap<>();
    private final Map<Type, Map<Integer, ArrayType>> arrayTypeMap = new HashMap<>();
    private final Map<List<Type>, AggregateType> aggregateTypeMap = new HashMap<>();

    private TypeFactory() {}

    public static TypeFactory getInstance() {
        return instance;
    }

    public Type getArchType() {
        int archPrecision = GlobalSettings.getArchPrecision();
        return archPrecision < 0 ? getIntegerType() : getIntegerType(archPrecision);
    }

    public BooleanType getBooleanType() {
        return booleanType;
    }

    public PointerType getPointerType() {
        return pointerType;
    }

    public UnboundedIntegerType getIntegerType() {
        return unboundedIntegerType;
    }

    public BoundedIntegerType getIntegerType(int bitWidth) {
        return integerTypeMap.computeIfAbsent(bitWidth, BoundedIntegerType::new);
    }

    public ArrayType getArrayType(Type elementType, int elementCount) {
        checkArgument(elementCount >= 0);
        return arrayTypeMap.computeIfAbsent(elementType, k -> new HashMap<>())
                .computeIfAbsent(elementCount, k -> new ArrayType(elementType, k));
    }

    public ArrayType getArrayType(Type elementType) {
        return arrayTypeMap.computeIfAbsent(elementType, k -> new HashMap<>())
                .computeIfAbsent(-1, k -> new ArrayType(elementType, -1));
    }

    public AggregateType getAggregateType(List<Type> elementTypes) {
        return aggregateTypeMap.computeIfAbsent(elementTypes, AggregateType::new);
    }
}
