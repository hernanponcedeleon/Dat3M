package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.floats.FloatLiteral;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.memory.ToMemoryCast;
import com.dat3m.dartagnan.expression.type.*;
import com.dat3m.dartagnan.expression.utils.IntegerHelper;
import com.dat3m.dartagnan.smt.TupleValue;
import com.google.common.base.Preconditions;
import org.sosy_lab.java_smt.api.FloatingPointNumber;

import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;

/*
    Decodes values from an SMT model into constant IR expressions (literals).
    This is the inverse of the type mapping in ExpressionEncoder.makeVariable and must be kept in sync with it:
    booleans <-> boolean formulas, integers and memory <-> bit-vectors, floats <-> floating-point formulas,
    aggregates and arrays <-> tuple formulas.
    Integers are normalized to their unsigned representation.
 */
final class ExpressionDecoder {

    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();
    private static final TypeFactory types = TypeFactory.getInstance();

    private ExpressionDecoder() {}

    static Expression decode(Type type, Object value) {
        return switch (type) {
            case BooleanType _ -> expressions.makeValue((Boolean) value);
            case IntegerType intType -> decodeInteger((BigInteger) value, intType);
            case MemoryType memType ->
                    new ToMemoryCast(memType, decodeInteger((BigInteger) value, types.getIntegerType(memType.getBitWidth())));
            case FloatType floatType -> decodeFloat(value, floatType);
            case ArrayType arrayType -> {
                final List<?> elements = ((TupleValue) value).values();
                Preconditions.checkArgument(elements.size() == arrayType.getNumElements());
                yield expressions.makeArray(arrayType,
                        elements.stream().map(v -> decode(arrayType.getElementType(), v)).toList());
            }
            case AggregateType aggType -> {
                final List<?> fields = ((TupleValue) value).values();
                Preconditions.checkArgument(fields.size() == aggType.getFields().size());
                final List<Expression> args = new ArrayList<>(fields.size());
                for (int i = 0; i < fields.size(); i++) {
                    args.add(decode(aggType.getFields().get(i).type(), fields.get(i)));
                }
                yield expressions.makeConstruct(aggType, args);
            }
            default -> throw new UnsupportedOperationException(
                    String.format("Cannot decode model value %s of type %s", value, type));
        };
    }

    // ======================================================================================================

    private static IntLiteral decodeInteger(BigInteger value, IntegerType type) {
        return expressions.makeValue(IntegerHelper.normalizeUnsigned(value, type.getBitWidth()), type);
    }

    private static FloatLiteral decodeFloat(Object value, FloatType type) {
        return switch (value) {
            case FloatingPointNumber fp -> fromFloatingPointNumber(fp, type);
            case Double d -> fromDouble(d, type);
            case Float f -> fromDouble(f.doubleValue(), type);
            default -> throw new UnsupportedOperationException(
                    String.format("Cannot decode floating-point model value %s (%s)", value, value.getClass()));
        };
    }

    private static FloatLiteral fromDouble(double d, FloatType type) {
        if (Double.isNaN(d)) {
            return expressions.makeNan(type);
        } else if (Double.isInfinite(d)) {
            return d > 0 ? expressions.makePlusInf(type) : expressions.makeMinusInf(type);
        }
        final boolean negative = d < 0 || (d == 0 && 1 / d < 0);
        return expressions.makeValue(new BigDecimal(Math.abs(d)), negative, type);
    }

    // Exact conversion of an IEEE-754 value given as (sign, biased exponent, mantissa without hidden bit).
    private static FloatLiteral fromFloatingPointNumber(FloatingPointNumber fp, FloatType type) {
        final int mantissaSize = fp.getMantissaSize();
        final BigInteger maxExponent = BigInteger.TWO.pow(fp.getExponentSize()).subtract(BigInteger.ONE);
        final BigInteger exponent = fp.getExponent();
        final BigInteger mantissa = fp.getMantissa();
        if (exponent.equals(maxExponent)) {
            if (mantissa.signum() != 0) {
                return expressions.makeNan(type);
            }
            return fp.getSign() ? expressions.makeMinusInf(type) : expressions.makePlusInf(type);
        }
        final int bias = (1 << (fp.getExponentSize() - 1)) - 1;
        final boolean isSubnormal = exponent.signum() == 0;
        final BigInteger significand = isSubnormal ? mantissa : mantissa.setBit(mantissaSize);
        final int power = (isSubnormal ? 1 - bias : exponent.intValueExact() - bias) - mantissaSize;
        final BigDecimal absValue = power >= 0
                ? new BigDecimal(significand.shiftLeft(power))
                : new BigDecimal(significand).divide(new BigDecimal(BigInteger.TWO.pow(-power)));
        return expressions.makeValue(absValue, fp.getSign(), type);
    }
}
