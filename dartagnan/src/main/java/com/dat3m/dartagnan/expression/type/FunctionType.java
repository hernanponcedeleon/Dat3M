package com.dat3m.dartagnan.expression.type;

import com.dat3m.dartagnan.expression.Type;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.Lists;

import java.util.List;

public final class FunctionType implements Type {

    private final Type returnType;
    private final ImmutableList<Type> parameterTypes;
    private final boolean isVarArgs;

    FunctionType(Type returnType, List<? extends Type> parameterTypes, boolean isVarArgs) {
        this.returnType = returnType;
        this.parameterTypes = ImmutableList.copyOf(parameterTypes);
        this.isVarArgs = isVarArgs;
    }

    public Type getReturnType() { return this.returnType; }
    public ImmutableList<Type> getParameterTypes() { return parameterTypes; }
    public boolean isVarArgs() { return this.isVarArgs; }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) {
            return true;
        }
        return (obj instanceof FunctionType other)
                && other.returnType.equals(this.returnType)
                && other.parameterTypes.equals(this.parameterTypes)
                && other.isVarArgs == this.isVarArgs;
    }

    @Override
    public int hashCode() {
        return 127 * Boolean.hashCode(isVarArgs) + 31 * returnType.hashCode() + parameterTypes.hashCode();
    }

    @Override
    public String toString() {
        return String.format("(%s%s) -> %s",
                String.join(", ", Lists.transform(parameterTypes, Object::toString)),
                isVarArgs ? ", ..." : "",
                returnType);
    }
}
