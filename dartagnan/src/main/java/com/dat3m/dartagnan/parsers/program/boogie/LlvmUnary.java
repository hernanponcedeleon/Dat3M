package com.dat3m.dartagnan.parsers.program.boogie;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.BOpUn;
import com.dat3m.dartagnan.expression.op.IOpUn;
import com.dat3m.dartagnan.expression.type.*;

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

    public static Object llvmUnary(String name, List<Object> callParams) {
        try {
            for (String prefix : LLVMUNARY) {
                if (name.startsWith(prefix)) {
                    String suffix = name.substring(prefix.length());
                    return llvmUnary(prefix, suffix, callParams);
                }
            }
        } catch (IllegalArgumentException x) {
            throw new ParsingException(String.format("Function %s is not implemented: %s", name, x.getMessage()));
        }
        throw new ParsingException(String.format("Function %s is not implemented.", name));
    }

    private static Object llvmUnary(String prefix, String suffix, List<Object> callParams) {
        TypeFactory types = TypeFactory.getInstance();
        IExpr inner = (IExpr) callParams.get(0);
        IntegerType integerType = inner.getType();
        switch (prefix) {
            case NOT -> {
                //TODO type-cast
                return new BExprUn(BOpUn.NOT, inner);
            }
            case BITVECTOR_TO_SIGNED_INTEGER, BITVECTOR_TO_UNSIGNED_INTEGER -> {
                checkArgument(!integerType.isMathematical(), "Expected bv, got int.");
                boolean signed = prefix.equals(BITVECTOR_TO_SIGNED_INTEGER);
                IOpUn operator = signed ? IOpUn.CAST_SIGNED : IOpUn.CAST_UNSIGNED;
                return new IExprUn(operator, inner, types.getIntegerType());
            }
            case SIGNED_INTEGER_TO_BITVECTOR, UNSIGNED_INTEGER_TO_BITVECTOR -> {
                checkArgument(integerType.isMathematical(), "Expected int, got %s.", integerType);
                boolean signed = prefix.equals(SIGNED_INTEGER_TO_BITVECTOR);
                IOpUn operator = signed ? IOpUn.CAST_SIGNED : IOpUn.CAST_UNSIGNED;
                int bitWidth = Integer.parseInt(suffix);
                IntegerType targetType = types.getIntegerType(bitWidth);
                return new IExprUn(operator, inner, targetType);
            }
            case TRUNCATE, SIGNED_EXTEND, UNSIGNED_EXTEND -> {
                boolean signed = !prefix.equals(UNSIGNED_EXTEND);
                IOpUn operator = signed ? IOpUn.CAST_SIGNED : IOpUn.CAST_UNSIGNED;
                String[] suffixParts = suffix.split("\\.");
                assert suffixParts.length == 2 && suffixParts[0].startsWith("bv") && suffixParts[1].startsWith("bv");
                int expectedBitWidth = Integer.parseInt(suffixParts[0].substring(2));
                checkArgument(!integerType.isMathematical() && integerType.getBitWidth() == expectedBitWidth,
                        "Type mismatch between %s and bv%s.", integerType, expectedBitWidth);
                int bitWidth = Integer.parseInt(suffixParts[1].substring(2));
                IntegerType targetType = types.getIntegerType(bitWidth);
                return new IExprUn(operator, inner, targetType);
            }
        }
        throw new AssertionError();
    }
}
