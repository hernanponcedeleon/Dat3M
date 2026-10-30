package com.dat3m.dartagnan.expression.utils;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.aggregates.ConstructExpr;
import com.dat3m.dartagnan.expression.booleans.BoolLiteral;
import com.dat3m.dartagnan.expression.floats.FloatLiteral;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.memory.ToMemoryCast;
import com.dat3m.dartagnan.expression.type.*;
import com.google.common.base.Preconditions;

import java.math.BigInteger;

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
        switch (aggregateType) {
            case AggregateType aggType -> checkArgument(index < aggType.getFields().size(),
                    "Index %s out of bounds for type %s.",
                    index, aggregateType);
            case ArrayType arrayType -> checkArgument(!arrayType.hasKnownNumElements() || index < arrayType.getNumElements(),
                    "Index %s out of bounds for type %s.",
                    index, arrayType);
            default -> { }
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

    // Whether the expression is a fully evaluated constant (literals, possibly inside aggregates or memory casts).
    public static boolean isConstant(Expression expr) {
        return switch (expr) {
            case IntLiteral _, BoolLiteral _, FloatLiteral _ -> true;
            case ToMemoryCast cast -> isConstant(cast.getOperand());
            case ConstructExpr construct -> construct.getOperands().stream().allMatch(ExpressionHelper::isConstant);
            default -> false;
        };
    }

    // Unsigned value of an integer-like constant (IntLiteral or memory cast of one).
    public static BigInteger toUnsignedValue(Expression expr) {
        final IntLiteral lit = switch (expr) {
            case IntLiteral l -> l;
            case ToMemoryCast cast when cast.getOperand() instanceof IntLiteral l -> l;
            default -> throw new IllegalArgumentException("Not an integer constant: " + expr);
        };
        return IntegerHelper.normalizeUnsigned(lit.getValue(), lit.getType().getBitWidth());
    }

    public static Type extractType(Type type, Iterable<Integer> indices) {
        for (int index : indices) {
            checkInbounds(type, index);
            type = switch (type) {
                case AggregateType aggregateType -> aggregateType.getFields().get(index).type();
                case ArrayType arrayType -> arrayType.getElementType();
                // Actually unreachable, because checkInbounds does this already.
                default -> throw new IllegalArgumentException("Cannot extract from non-aggregate type " + type);
            };
        }
        return type;
    }
}
