package com.dat3m.dartagnan.parsers.program.boogie;

import com.dat3m.dartagnan.program.expression.Expression;
import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.program.expression.ExpressionFactory;
import com.dat3m.dartagnan.program.expression.type.Type;

import java.util.List;

import static com.dat3m.dartagnan.expression.op.COpBin.*;
import static com.dat3m.dartagnan.parsers.program.boogie.SmackTypes.parseType;

public class LlvmPredicates {

    private static final String EQUAL = "$eq.";
    private static final String NOT_EQUAL = "$ne.";
    private static final String SIGNED_LESS = "$slt.";
    private static final String SIGNED_LESS_OR_EQUAL = "$sle.";
    private static final String SIGNED_GREATER = "$sgt.";
    private static final String SIGNED_GREATER_OR_EQUAL = "$sge.";
    private static final String UNSIGNED_LESS = "$ult.";
    private static final String UNSIGNED_LESS_OR_EQUAL = "$ule.";
    private static final String UNSIGNED_GREATER = "$ugt.";
    private static final String UNSIGNED_GREATER_OR_EQUAL = "$uge.";
    public static List<String> LLVMPREDICATES = List.of(
            EQUAL,
            NOT_EQUAL,
            SIGNED_LESS,
            SIGNED_LESS_OR_EQUAL,
            SIGNED_GREATER,
            SIGNED_GREATER_OR_EQUAL,
            UNSIGNED_LESS,
            UNSIGNED_LESS_OR_EQUAL,
            UNSIGNED_GREATER,
            UNSIGNED_GREATER_OR_EQUAL);

    public static Expression llvmPredicate(String name, List<Object> callParams, ExpressionFactory expressions) {
        try {
            for (String prefix : LLVMPREDICATES) {
                if (name.startsWith(prefix)) {
                    String suffix = name.substring(prefix.length());
                    return llvmPredicate(prefix, suffix, callParams, expressions);
                }
            }
        } catch (NumberFormatException | AssertionError ignored) {
        }
        throw new ParsingException("Function " + name + " has no implementation.");
    }

    private static Expression llvmPredicate(String prefix, String suffix, List<Object> callParams, ExpressionFactory expressions) {
        COpBin op = switch (prefix) {
            case EQUAL -> EQ;
            case NOT_EQUAL -> NEQ;
            case SIGNED_LESS -> LT;
            case SIGNED_LESS_OR_EQUAL -> LTE;
            case SIGNED_GREATER -> GT;
            case SIGNED_GREATER_OR_EQUAL -> GTE;
            case UNSIGNED_LESS -> ULT;
            case UNSIGNED_LESS_OR_EQUAL -> ULTE;
            case UNSIGNED_GREATER -> UGT;
            case UNSIGNED_GREATER_OR_EQUAL -> UGTE;
            default -> throw new AssertionError();
        };
        Expression left = (Expression) callParams.get(0);
        Expression right = (Expression) callParams.get(1);
        String[] parts = suffix.split("\\.");
        assert parts.length == 2;
        Type innerType = parseType(parts[0]);
        Type targetType = parseType(parts[1]);
        assert left.getType().equals(innerType) && right.getType().equals(innerType);
        Expression expression = expressions.makeBinary(left, op, right);
        return expressions.makeCast(targetType, expression, true);
    }
}
