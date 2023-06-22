package com.dat3m.dartagnan.expression.type;

import com.google.common.base.Preconditions;
import com.google.common.collect.Iterables;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

//TODO: Add to TypeFactory
public class FunctionType implements Type {

    private final Type returnType;
    private final Type[] parameterTypes;

    private FunctionType(Type returnType, Type... parameterTypes) {
        this.returnType = returnType;
        this.parameterTypes = parameterTypes;
    }

    private static final HashMap<FunctionType, FunctionType> normalizer = new HashMap<>();
    public static FunctionType get(Type returnType, Type... parameterTypes) {
        Preconditions.checkNotNull(returnType);
        Preconditions.checkNotNull(parameterTypes);
        // TODO: Do we want to check for first-class types (e.g., a function type cannot have a function as return type)
        return normalizer.computeIfAbsent(new FunctionType(returnType, parameterTypes), k -> k);
    }

    public Type getReturnType() { return this.returnType; }
    public List<Type> getParameterTypes() { return Arrays.asList(this.parameterTypes); }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) {
            return true;
        } else if (obj == null || this.getClass() != obj.getClass()) {
            return false;
        }
        FunctionType other = (FunctionType) obj;
        return other.returnType == this.returnType && Arrays.equals(other.parameterTypes, this.parameterTypes);
    }

    @Override
    public int hashCode() {
        return 31 * returnType.hashCode() + Arrays.hashCode(parameterTypes);
    }

    @Override
    public String toString() {
        return String.format("%s (%s)", returnType,
                String.join(", ", Iterables.transform(Arrays.asList(parameterTypes), Object::toString)));
    }
}
