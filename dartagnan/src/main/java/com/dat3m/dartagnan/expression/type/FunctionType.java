package com.dat3m.dartagnan.expression.type;

import com.dat3m.dartagnan.expression.Type;
import com.google.common.collect.Lists;

import java.util.Arrays;
import java.util.List;

public final class FunctionType implements Type {

    private final Type returnType;
    private final Type[] parameterTypes;
    private final boolean isVarArgs;

    FunctionType(Type returnType, Type[] parameterTypes, boolean isVarArgs) {
        this.returnType = returnType;
        this.parameterTypes = parameterTypes;
        this.isVarArgs = isVarArgs;
    }

    public Type getReturnType() { return this.returnType; }
    public List<Type> getParameterTypes() { return Arrays.asList(this.parameterTypes); }
    public boolean isVarArgs() { return this.isVarArgs; }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) {
            return true;
        }
        return (obj instanceof FunctionType other)
                && other.returnType.equals(this.returnType)
                && Arrays.equals(other.parameterTypes, this.parameterTypes)
                && other.isVarArgs == this.isVarArgs;
    }

    @Override
    public int hashCode() {
        return 127 * Boolean.hashCode(isVarArgs) + 31 * returnType.hashCode() + Arrays.hashCode(parameterTypes);
    }

    @Override
    public String toString() {
        return String.format("(%s%s) -> %s",
                String.join(", ", Lists.transform(Arrays.asList(parameterTypes), Object::toString)),
                isVarArgs ? ", ..." : "",
                returnType);
    }
}
