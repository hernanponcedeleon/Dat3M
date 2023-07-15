package com.dat3m.dartagnan.parsers.program.boogie;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;

import java.util.Arrays;
import java.util.List;

public class SmackPredicates {

    private static final String TOS = "$tos.i";
    private static final String TOU = "$tou.i";

    public static List<String> SMACKPREDICATES = Arrays.asList(TOS, TOU);

    public static Expression smackPredicate(String name, List<Expression> callParams, ExpressionFactory expressions) {
        try {
            for (String prefix : SMACKPREDICATES) {
                if (name.startsWith(prefix)) {
                    String suffix = name.substring(prefix.length());
                    return smackPredicates(prefix, suffix, callParams, expressions);
                }
            }
        } catch (IllegalArgumentException x) {
            throw new ParsingException(String.format("Function %s is not implemented: %s.", name, x.getMessage()));
        }
        throw new ParsingException(String.format("Function %s is not implemented.", name));
    }

    private static Expression smackPredicates(String prefix, String suffix, List<Expression> callParams, ExpressionFactory expressions) {
        boolean signed = prefix.equals(TOS);
        TypeFactory types = TypeFactory.getInstance();
        IntegerType resultType = types.getIntegerType();
        int bitWidth = Integer.parseUnsignedInt(suffix);
        IntegerType targetType = types.getIntegerType(bitWidth);
        if (targetType.isMathematical()) {
            throw new ParsingException(String.format("Function %s%s is not implemented.", prefix, suffix));
        }
        Expression operand = callParams.get(0);
        Expression truncated = expressions.makeIntegerCast(operand, targetType, signed);
        return expressions.makeIntegerCast(truncated, resultType, signed);
    }
}
