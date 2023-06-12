package com.dat3m.dartagnan.parsers.program.boogie;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;

import java.util.Arrays;
import java.util.List;

import static com.google.common.base.Preconditions.checkArgument;

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
    public static final List<String> LLVMUNARY = Arrays.asList(
            NOT,
            BITVECTOR_TO_SIGNED_INTEGER,
            BITVECTOR_TO_UNSIGNED_INTEGER,
            SIGNED_INTEGER_TO_BITVECTOR,
            UNSIGNED_INTEGER_TO_BITVECTOR,
            TRUNCATE,
            SIGNED_EXTEND,
            UNSIGNED_EXTEND
    );

    public static Object llvmUnary(String name, List<Object> callParams, ExpressionFactory expressions) {
        try {
            for (String prefix : LLVMUNARY) {
                if (name.startsWith(prefix)) {
                    String suffix = name.substring(prefix.length());
                    return llvmUnary(prefix, suffix, callParams, expressions);
                }
            }
        } catch (IllegalArgumentException x) {
            throw new ParsingException(String.format("Function %s is not implemented: %s", name, x.getMessage()));
        }
        throw new ParsingException(String.format("Function %s is not implemented.", name));
    }

    private static Object llvmUnary(String prefix, String suffix, List<Object> callParams, ExpressionFactory expressions) {
        TypeFactory types = TypeFactory.getInstance();
        Expression inner = (Expression) callParams.get(0);
        if (!(inner.getType() instanceof IntegerType integerType)) {
            throw new ParsingException(String.format("%s is not an integer expression.", inner));
        }
        switch (prefix) {
            case NOT -> {
                //TODO type-cast
                return expressions.makeNot(inner);
            }
            case BITVECTOR_TO_SIGNED_INTEGER, BITVECTOR_TO_UNSIGNED_INTEGER -> {
                checkArgument(!integerType.isMathematical(), "Expected bv, got int.");
                boolean signed = prefix.equals(BITVECTOR_TO_SIGNED_INTEGER);
                return expressions.makeIntegerCast(inner, types.getArchType(), signed);
            }
            case SIGNED_INTEGER_TO_BITVECTOR, UNSIGNED_INTEGER_TO_BITVECTOR -> {
                checkArgument(integerType.isMathematical(), "Expected int, got %s.", integerType);
                boolean signed = prefix.equals(SIGNED_INTEGER_TO_BITVECTOR);
                int bitWidth = Integer.parseInt(suffix);
                IntegerType targetType = types.getIntegerType(bitWidth);
                return expressions.makeIntegerCast(inner, targetType, signed);
            }
            case TRUNCATE, SIGNED_EXTEND, UNSIGNED_EXTEND -> {
                boolean signed = !prefix.equals(UNSIGNED_EXTEND);
                String[] suffixParts = suffix.split("\\.");
                assert suffixParts.length == 2;
                IntegerType innerType = Types.parseIntegerType(suffixParts[0], types);
                checkArgument(integerType.equals(innerType),
                        "Type mismatch between %s and %s.", integerType, innerType);
                IntegerType targetType = Types.parseIntegerType(suffixParts[1], types);
                return expressions.makeIntegerCast(inner, targetType, signed);
            }
        }
        throw new AssertionError();
    }
}
