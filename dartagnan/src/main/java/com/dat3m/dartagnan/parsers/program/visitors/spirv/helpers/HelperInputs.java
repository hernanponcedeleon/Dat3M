package com.dat3m.dartagnan.parsers.program.visitors.spirv.helpers;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.misc.ConstructExpr;
import com.dat3m.dartagnan.expression.type.*;

import java.util.ArrayList;
import java.util.List;

public class HelperInputs {

    private static final TypeFactory types = TypeFactory.getInstance();
    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();

    private HelperInputs(){
    }

    public static Expression castInput(String id, Type type, Expression value) {
        if (type instanceof ArrayType aType) {
            return castArray(id, aType, value);
        }
        if (type instanceof AggregateType aType) {
            return castAggregate(id, aType, value);
        }
        return castScalar(id, type, value);
    }

    private static Expression castArray(String id, ArrayType type, Expression value) {
        if (value instanceof ConstructExpr aValue) {
            int expectedSize = type.getNumElements();
            int actualSize = aValue.getOperands().size();
            if (expectedSize != -1 && expectedSize != actualSize) {
                throw new ParsingException(errorMismatchingElementCount(id, expectedSize, actualSize));
            }
            Type elementType = type.getElementType();
            List<Expression> elements = new ArrayList<>();
            for (int i = 0; i < actualSize; i++) {
                elements.add(castInput(String.format("%s[%d]", id, i), elementType, aValue.getOperands().get(i)));
            }
            return expressions.makeArray(elements.get(0).getType(), elements, true);
        }
        throw new ParsingException(errorMismatchingType(id, type, value.getType()));
    }

    private static Expression castAggregate(String id, AggregateType type, Expression value) {
        if (value instanceof ConstructExpr aValue) {
            int expectedSize = type.getDirectFields().size();
            int actualSize = aValue.getOperands().size();
            if (expectedSize != actualSize) {
                throw new ParsingException(errorMismatchingElementCount(id, expectedSize, actualSize));
            }
            List<Expression> elements = new ArrayList<>();
            for (int i = 0; i < actualSize; i++) {
                elements.add(castInput(id, type.getDirectFields().get(i), aValue.getOperands().get(i)));
            }
            return expressions.makeConstruct(elements);
        }
        throw new ParsingException(errorMismatchingType(id, type, value.getType()));
    }

    private static Expression castScalar(String id, Type type, Expression value) {
        if (value.getType().equals(types.getArchType())) {
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
            throw new ParsingException("Illegal input for variable '%s', the value is not constant", id);
        }
        throw new ParsingException(errorMismatchingType(id, type, value.getType()));
    }

    private static String errorMismatchingType(String id, Type expected, Type actual) {
        return String.format("Mismatching value type for variable '%s', " +
                "expected '%s' but received '%s'", id, expected, actual);
    }

    private static String errorMismatchingElementCount(String id, int expected, int actual) {
        return String.format("Unexpected number of elements in variable '%s', " +
                "expected %d but received %d", id, expected, actual);
    }
}
