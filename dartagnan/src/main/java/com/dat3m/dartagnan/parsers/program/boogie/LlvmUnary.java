package com.dat3m.dartagnan.parsers.program.boogie;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.program.expression.Expression;
import com.dat3m.dartagnan.program.expression.ExpressionFactory;
import com.dat3m.dartagnan.program.expression.type.UnboundedIntegerType;
import com.dat3m.dartagnan.program.expression.type.Type;
import com.dat3m.dartagnan.program.expression.type.TypeFactory;

import java.util.Arrays;
import java.util.List;

public class LlvmUnary {

    // List of supported prefixes.
    private static final String NOT = "$not.";
    private static final String BITVECTOR_TO_SIGNED_INTEGER = "$bv2int.";
    private static final String BITVECTOR_TO_UNSIGNED_INTEGER = "$bv2uint.";
    private static final String SIGNED_INTEGER_TO_BITVECTOR = "$int2bv.";
    private static final String UNSIGNED_INTEGER_TO_BITVECTOR = "$uint2bv.";
    private static final String TRUNCATE = "$trunc.";
    private static final String SIGNED_EXTEND = "$sext.";
    private static final String UNSIGNED_EXTEND = "$zext.";
    public static List<String> LLVMUNARY = Arrays.asList(
            NOT,
            BITVECTOR_TO_SIGNED_INTEGER,
            BITVECTOR_TO_UNSIGNED_INTEGER,
            SIGNED_INTEGER_TO_BITVECTOR,
            UNSIGNED_INTEGER_TO_BITVECTOR,
            TRUNCATE,
            SIGNED_EXTEND,
            UNSIGNED_EXTEND
    );

    public static Expression llvmUnary(String name, List<Object> callParams, ExpressionFactory factory) {
        try {
            for (String prefix : LLVMUNARY) {
                if (name.startsWith(prefix)) {
                    String suffix = name.substring(prefix.length());
                    return llvmUnary(prefix, suffix, callParams, factory);
                }
            }
        } catch (AssertionError | NumberFormatException ignored) {
        }
        throw new ParsingException("Function " + name + " has no implementation");
    }

    private static Expression llvmUnary(String prefix, String suffix, List<Object> callParams, ExpressionFactory expressions) {
        TypeFactory types = TypeFactory.getInstance();
        Expression inner = (Expression) callParams.get(0);
        switch (prefix) {
            case NOT -> {
                //TODO type-cast
                return expressions.makeNot(inner);
            }
            case BITVECTOR_TO_SIGNED_INTEGER -> {
                assert inner.getType().equals(types.getIntegerType(Integer.parseInt(suffix)));
                return expressions.makeCast(types.getIntegerType(), inner, true);
            }
            case BITVECTOR_TO_UNSIGNED_INTEGER -> {
                assert inner.getType().equals(types.getIntegerType(Integer.parseInt(suffix)));
                return expressions.makeCast(types.getIntegerType(), inner, false);
            }
            case SIGNED_INTEGER_TO_BITVECTOR, UNSIGNED_INTEGER_TO_BITVECTOR -> {
                assert inner.getType() instanceof UnboundedIntegerType;
                int bitWidth = Integer.parseInt(suffix);
                Type targetType = types.getIntegerType(bitWidth);
                return expressions.makeCast(targetType, inner, true);
            }
            case TRUNCATE, SIGNED_EXTEND, UNSIGNED_EXTEND -> {
                String[] parts = suffix.split("\\.");
                assert parts.length == 2;
                boolean inputStartsWithBV = parts[0].startsWith("bv");
                boolean targetStartsWithBV = parts[1].startsWith("bv");
                assert inputStartsWithBV || parts[0].startsWith("i");
                assert targetStartsWithBV || parts[1].startsWith("i");
                //int inputBitWidth = Integer.parseInt(parts[0].substring(inputStartsWithBV ? 2 : 1));
                int targetBitWidth = Integer.parseInt(parts[1].substring(targetStartsWithBV ? 2 : 1));
                //TODO assert inner.getType().equals(types.getIntegerType(inputBitWidth));
                Type targetType = types.getIntegerType(targetBitWidth);
                return expressions.makeCast(targetType, inner, !prefix.equals(UNSIGNED_EXTEND));
            }
        }
        throw new AssertionError();
    }
}
