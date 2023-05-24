package com.dat3m.dartagnan.parsers.program.boogie;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.program.expression.Expression;
import com.dat3m.dartagnan.program.expression.ExpressionFactory;
import com.dat3m.dartagnan.program.expression.type.NumberType;
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

    public static Object llvmUnary(String name, List<Object> callParams, ExpressionFactory factory) {
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

    private static Object llvmUnary(String prefix, String suffix, List<Object> callParams, ExpressionFactory expressions) {
        TypeFactory types = TypeFactory.getInstance();
        Expression inner = (Expression) callParams.get(0);
        switch (prefix) {
            case NOT -> {
                //TODO type-cast
                return expressions.makeNot(inner);
            }
            case BITVECTOR_TO_SIGNED_INTEGER -> {
                assert inner.getType().equals(types.getIntegerType(Integer.parseInt(suffix)));
                return expressions.makeSignedCast(types.getNumberType(), inner);
            }
            case BITVECTOR_TO_UNSIGNED_INTEGER -> {
                assert inner.getType().equals(types.getIntegerType(Integer.parseInt(suffix)));
                return expressions.makeUnsignedCast(types.getNumberType(), inner);
            }
            case SIGNED_INTEGER_TO_BITVECTOR, UNSIGNED_INTEGER_TO_BITVECTOR -> {
                assert inner.getType() instanceof NumberType;
                int bitWidth = Integer.parseInt(suffix);
                Type targetType = types.getIntegerType(bitWidth);
                return expressions.makeCast(targetType, inner);
            }
            case TRUNCATE, SIGNED_EXTEND, UNSIGNED_EXTEND -> {
                String[] parts = suffix.split("\\.");
                assert parts.length == 2 && parts[0].startsWith("bv") && parts[1].startsWith("bv");
                assert inner.getType().equals(types.getIntegerType(Integer.parseInt(parts[0].substring(2))));
                int bitWidth = Integer.parseInt(parts[1].substring(2));
                Type targetType = types.getIntegerType(bitWidth);
                return switch(prefix) {
                    case SIGNED_EXTEND -> expressions.makeSignedCast(targetType, inner);
                    case UNSIGNED_EXTEND -> expressions.makeUnsignedCast(targetType, inner);
                    default -> expressions.makeCast(targetType, inner);
                };
            }
        }
        throw new AssertionError();
    }
}
