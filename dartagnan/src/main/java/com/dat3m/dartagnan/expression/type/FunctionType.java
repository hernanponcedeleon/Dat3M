package com.dat3m.dartagnan.expression.type;

import com.google.common.collect.Lists;

import java.util.Arrays;
import java.util.List;

public final class FunctionType implements Type {

    private final Type returnType;
    private final Type[] parameterTypes;

    FunctionType(Type returnType, Type... parameterTypes) {
        this.returnType = returnType;
        this.parameterTypes = parameterTypes;
    }

    public Type getReturnType() { return this.returnType; }
    public List<Type> getParameterTypes() { return Arrays.asList(this.parameterTypes); }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) {
            return true;
        }
        return (obj instanceof FunctionType other)
                && other.returnType == this.returnType
                && Arrays.equals(other.parameterTypes, this.parameterTypes);
    }

    @Override
    public int hashCode() {
        return 31 * returnType.hashCode() + Arrays.hashCode(parameterTypes);
    }

    @Override
    public String toString() {
        return String.format("(%s) -> %s",
                String.join(", ", Lists.transform(Arrays.asList(parameterTypes), Object::toString)),
                returnType);
    }
}
