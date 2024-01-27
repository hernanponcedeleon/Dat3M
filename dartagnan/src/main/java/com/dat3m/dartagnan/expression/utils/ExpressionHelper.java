package com.dat3m.dartagnan.expression.utils;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.Type;
import com.google.common.base.Preconditions;

public class ExpressionHelper {

    private ExpressionHelper() {}

    public static void checkSameType(Expression x, Expression y) {
        Preconditions.checkArgument(x.getType().equals(y.getType()),
                "The types of %s and %s do not match.", x, y);
    }

    public static void checkExpectedType(Expression expr, Class<? extends Type> expectedClass) {
        final Class<? extends Type> exprClass = expr.getType().getClass();
        Preconditions.checkArgument(expectedClass.isAssignableFrom(exprClass),
                "The expression '%s' has unexpected type class '%s', expected type class is '%s'",
                expr, exprClass.getSimpleName(), expectedClass.getSimpleName());
    }

    public static void checkSameExpectedType(Expression x, Expression y, Class<? extends Type> expectedClass) {
        checkSameType(x, y);
        checkExpectedType(x, expectedClass);
    }
}
