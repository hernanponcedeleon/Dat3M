package com.dat3m.dartagnan.expression.utils;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.AggregateType;
import com.dat3m.dartagnan.expression.type.ArrayType;
import com.dat3m.dartagnan.expression.type.PointerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.google.common.base.Preconditions;

import java.util.List;

import static com.google.common.base.Preconditions.checkArgument;

public class ExpressionHelper {

    private ExpressionHelper() {}

    public static void checkSameType(Expression x, Expression y) {
        if (x.getType() instanceof PointerType) {
            Preconditions.checkArgument((y.getType() instanceof PointerType) || y.getType().equals(TypeFactory.getInstance().getArchType()),
                    "The types of %s and %s do not match.", x, y);
        } else if (y.getType() instanceof PointerType) {
            Preconditions.checkArgument((x.getType() instanceof PointerType) || x.getType().equals(TypeFactory.getInstance().getArchType()),
                    "The types of %s and %s do not match.", x, y);
        } else {
            Preconditions.checkArgument(x.getType().equals(y.getType()),
                    "The types of %s and %s do not match.", x, y);
        }
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

    public static boolean isAggregateLike(Type type) {
        return type instanceof AggregateType || type instanceof ArrayType;
    }

    public static boolean isAggregateLike(Expression expr) {
        return isAggregateLike(expr.getType());
    }

    public static Type extractType(Type type, List<?> indices) {
        for (Object index : indices) {
            if (index instanceof Integer intIdx) {
                checkInbounds(type, intIdx);
            } else if (index instanceof IntLiteral intLit) {
                checkInbounds(type, intLit.getValueAsInt());
            }
            if (type instanceof AggregateType aggregateType) {
                if (index instanceof Integer iIndex) {
                    type = aggregateType.getFields().get(iIndex).type();
                } else if (index instanceof IntLiteral eIndex) {
                    type = aggregateType.getFields().get(eIndex.getValueAsInt()).type();
                } else {
                    throw new IllegalArgumentException("Non-constant index of a struct member");
                }
            } else if (type instanceof ArrayType arrayType) {
                type = arrayType.getElementType();
            } else {
                throw new IllegalArgumentException("Index is too deep");
            }
        }
        return type;
    }

    private static void checkInbounds(Type aggregateType, int index) {
        Preconditions.checkArgument(index >= 0, "Index is negative");
        if (aggregateType instanceof AggregateType aggType) {
            checkArgument(index < aggType.getFields().size(),
                    "Index is out of bounds",
                    index, aggregateType);
        } else if (aggregateType instanceof ArrayType arrayType) {
            checkArgument(!arrayType.hasKnownNumElements() || index < arrayType.getNumElements(),
                    "Index is out of bounds",
                    index, arrayType);
        }
    }
}
