package com.dat3m.dartagnan.expression.utils;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.*;
import com.google.common.base.Preconditions;

import static com.google.common.base.Preconditions.checkArgument;

public class ExpressionHelper {

    private ExpressionHelper() {}

    public static void checkSameType(Expression x, Expression y) {
        Preconditions.checkArgument(x.getType().equals(y.getType()),
                "The types of %s and %s do not match.", x, y);
    }

    public static void checkSameType(Type x, Type y) {
        Preconditions.checkArgument(x.equals(y),
                "The types %s and %s do not match.", x, y);
    }

    public static void checkExpectedType(Expression expr, Class<? extends Type> expectedClass) {
        final Class<? extends Type> exprClass = expr.getType().getClass();
        Preconditions.checkArgument(expectedClass.isAssignableFrom(exprClass),
                "The expression '%s' has unexpected type class '%s', expected type class is '%s'.",
                expr, exprClass.getSimpleName(), expectedClass.getSimpleName());
    }

    public static void checkSameExpectedType(Expression x, Expression y, Class<? extends Type> expectedClass) {
        checkSameType(x, y);
        checkExpectedType(x, expectedClass);
    }

    public static void checkInbounds(Type aggregateType, int index) {
        Preconditions.checkArgument(isAggregateLike(aggregateType), "Non-aggregate type %s.", aggregateType);
        Preconditions.checkArgument(index >= 0, "Negative index: %s.", index);
        if (aggregateType instanceof AggregateType aggType) {
            checkArgument(index < aggType.getFields().size(),
                    "Index %s out of bounds for type %s.",
                    index, aggregateType);
        } else if (aggregateType instanceof ArrayType arrayType) {
            checkArgument(!arrayType.hasKnownNumElements() || index < arrayType.getNumElements(),
                    "Index %s out of bounds for type %s.",
                    index, arrayType);
        }
    }

    public static boolean isScalar(Type type) {
        return type instanceof BooleanType || type instanceof IntegerType || type instanceof FloatType;
    }

    public static boolean isAggregateLike(Type type) {
        return type instanceof AggregateType || type instanceof ArrayType;
    }

    public static boolean isAggregateLike(Expression expr) {
        return isAggregateLike(expr.getType());
    }

    public static Type extractType(Type type, Iterable<Integer> indices) {
        for (int index : indices) {
            checkInbounds(type, index);
            if (type instanceof AggregateType aggregateType) {
                type = aggregateType.getFields().get(index).type();
            } else if (type instanceof ArrayType arrayType) {
                type = arrayType.getElementType();
            } else {
                // Actually unreachable, because checkInbounds does this already.
                throw new IllegalArgumentException("Cannot extract from non-aggregate type " + type);
            }
        }
        return type;
    }
}
