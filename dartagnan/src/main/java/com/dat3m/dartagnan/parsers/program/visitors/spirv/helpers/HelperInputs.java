package com.dat3m.dartagnan.parsers.program.visitors.spirv.helpers;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.aggregates.ConstructExpr;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.*;

import java.util.ArrayList;
import java.util.List;

public class HelperInputs {

    private static final TypeFactory types = TypeFactory.getInstance();
    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();

    private HelperInputs() {
    }

    public static String castPointerId(String id) {
        return "&" + id;
    }

    public static Expression castInput(String id, Type type, Expression value) {
        if (!(type instanceof ScopedPointerType)) {
            if (type.equals(value.getType())) {
                return value;
            }
            if (type instanceof ArrayType aType) {
                return castArray(id, aType, value);
            }
            if (type instanceof AggregateType aType) {
                return castAggregate(id, aType, value);
            }
            return castScalar(id, type, value);
        }
        throw new ParsingException(errorMismatchingType(id, type, value.getType()));
    }

    private static Expression castArray(String id, ArrayType type, Expression value) {
        if (value instanceof ConstructExpr aValue) {
            int expectedSize = type.getNumElements();
            int actualSize = aValue.getOperands().size();
            if (expectedSize == -1 || expectedSize == actualSize) {
                Type elType = type.getElementType();
                List<Expression> elements = new ArrayList<>();
                for (int i = 0; i < actualSize; i++) {
                    elements.add(castInput(String.format("%s[%d]", id, i), elType, aValue.getOperands().get(i)));
                }
                long distinctTypeCount = elements.stream().map(Expression::getType).distinct().count();
                if (distinctTypeCount <= 1) {
                    if (!elements.isEmpty()) {
                        elType = elements.get(0).getType();
                        if (type.getStride() != null && type.getStride() < types.getMemorySizeInBytes(elType)) {
                            throw new ParsingException("Mismatching value type for variable '%s', " +
                                    "element size %d is greater than array stride %d", id,
                                    types.getMemorySizeInBytes(elType), type.getStride());
                        }
                    }
                    ArrayType aType = types.getArrayType(elType, actualSize, type.getStride(), type.getAlignment());
                    return expressions.makeArray(aType, elements);
                }
            }
        }
        throw new ParsingException(errorMismatchingType(id, type, value.getType()));
    }

    private static Expression castAggregate(String id, AggregateType type, Expression value) {
        if (value instanceof ConstructExpr aValue) {
            int expectedSize = type.getFields().size();
            int actualSize = aValue.getOperands().size();
            if (expectedSize == actualSize) {
                List<Expression> elements = new ArrayList<>();
                for (int i = 0; i < actualSize; i++) {
                    elements.add(castInput(String.format("%s[%d]", id, i), type.getFields().get(i).type(), aValue.getOperands().get(i)));
                }
                List<Type> fields = elements.stream().map(Expression::getType).toList();
                List<Integer> offsets = type.getFields().stream().map(TypeOffset::offset).toList();
                AggregateType aType = types.getAggregateType(fields, offsets);
                return expressions.makeConstruct(aType, elements);
            }
        }
        throw new ParsingException(errorMismatchingType(id, type, value.getType()));
    }

    private static Expression castScalar(String id, Type type, Expression value) {
        if (value instanceof IntLiteral iConst) {
            int iValue = iConst.getValueAsInt();
            if (type instanceof BooleanType) {
                return iValue == 0 ? expressions.makeFalse() : expressions.makeTrue();
            }
            if (type instanceof IntegerType iType) {
                return expressions.makeValue(iValue, iType);
            }
            throw new ParsingException("Unexpected element type '%s' for variable '%s'", type, id);
        }
        throw new ParsingException(errorMismatchingType(id, type, value.getType()));
    }

    private static String errorMismatchingType(String id, Type expected, Type actual) {
        return String.format("Mismatching value type for variable '%s', " +
                "expected '%s' but received '%s'", id, expected, actual);
    }
}
