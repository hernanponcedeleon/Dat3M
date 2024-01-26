package com.dat3m.dartagnan.expression.utils;

import com.dat3m.dartagnan.expression.Expression;
import com.google.common.base.Preconditions;

public class ExpressionHelper {

    private ExpressionHelper() {}

    public static void checkSameType(Expression x, Expression y) {
        Preconditions.checkArgument(x.getType().equals(y.getType()),
                "The types of %s and %s do not match.", x, y);
    }
}
