package com.dat3m.dartagnan.parsers.program.visitors.spirv.helpers;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.aggregates.ConstructExpr;
import com.dat3m.dartagnan.expression.integers.IntBinaryOp;
import com.dat3m.dartagnan.expression.type.*;

import java.util.ArrayList;
import java.util.List;

import static com.dat3m.dartagnan.expression.utils.ExpressionHelper.isScalar;

public class HelperTypes {

    private static final TypeFactory types = TypeFactory.getInstance();
    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();

    private HelperTypes() {
    }

    public static Type getMemberType(String id, Type type, List<Integer> indexes) {
        if (!indexes.isEmpty()) {
            id += "[" + indexes.get(0) + "]";
            if (type instanceof ArrayType aType) {
                return getArrayMemberType(id, aType, indexes);
            }
            if (type instanceof AggregateType aType) {
                return getStructMemberType(id, aType, indexes);
            }
            throw new ParsingException(indexTooDeepError(id));
        }
        return type;
    }

    public static int getMemberOffset(String id, int offset, Type type, List<Integer> indexes) {
        if (!indexes.isEmpty()) {
            id += "[" + indexes.get(0) + "]";
            if (type instanceof ArrayType aType) {
                return getArrayMemberOffset(id, offset, aType, indexes);
            }
            if (type instanceof AggregateType aType) {
                return getStructMemberOffset(id, offset, aType, indexes);
            }
            throw new ParsingException(indexTooDeepError(id));
        }
        return offset;
    }

    public static Expression createResultExpression(String id, Type type, Expression op1, Expression op2, IntBinaryOp op) {
        if (isScalar(type)) {
            return expressions.makeBinary(op1, op, op2);
        }
        if (type instanceof ArrayType aType && aType.getElementType() instanceof IntegerType) {
            List<Expression> elements = new ArrayList<>();
            for (int i = 0; i < aType.getNumElements(); i++) {
                Expression elementOp1 = op1 instanceof ConstructExpr ? op1.getOperands().get(i) : expressions.makeExtract(op1, i);
                Expression elementOp2 = op2 instanceof ConstructExpr ? op2.getOperands().get(i) : expressions.makeExtract(op2, i);
                elements.add(expressions.makeBinary(elementOp1, op, elementOp2));
            }
            return expressions.makeArray(aType, elements);
        }
        throw new ParsingException("Illegal result type in definition of '%s'", id);
    }

    private static Type getArrayMemberType(String id, ArrayType type, List<Integer> indexes) {
        int index = indexes.get(0);
        if (!type.hasKnownNumElements() || index < type.getNumElements()) {
            return getMemberType(id, type.getElementType(), indexes.subList(1, indexes.size()));
        }
        throw new ParsingException(indexOutOfBoundsError(id));
    }

    private static Type getStructMemberType(String id, AggregateType type, List<Integer> indexes) {
        int index = indexes.get(0);
        if (index >= 0) {
            if (index < type.getFields().size()) {
                return getMemberType(id, type.getFields().get(index).type(), indexes.subList(1, indexes.size()));
            }
            throw new ParsingException(indexOutOfBoundsError(id));
        }
        throw new ParsingException(indexNonConstantForStructError(id));
    }

    private static int getArrayMemberOffset(String id, int offset, ArrayType type, List<Integer> indexes) {
        int index = indexes.get(0);
        if (index >= 0) {
            if (type.getNumElements() < 0 || index < type.getNumElements()) {
                Type elType = type.getElementType();
                if (type.getStride() != null) {
                    offset += index * type.getStride();
                } else {
                    offset += types.getOffsetInBytes(type, index);
                }
                return getMemberOffset(id, offset, elType, indexes.subList(1, indexes.size()));
            }
            throw new ParsingException(indexOutOfBoundsError(id));
        }
        throw new ParsingException(indexNonConstantError(id));
    }

    private static int getStructMemberOffset(String id, int offset, AggregateType type, List<Integer> indexes) {
        int index = indexes.get(0);
        if (index >= 0) {
            if (index < type.getFields().size()) {
                offset += type.getFields().get(index).offset();
                Type elType = type.getFields().get(index).type();
                return getMemberOffset(id, offset, elType, indexes.subList(1, indexes.size()));
            }
            throw new ParsingException(indexOutOfBoundsError(id));
        }
        throw new ParsingException(indexNonConstantError(id));
    }

    private static String indexTooDeepError(String id) {
        return String.format("Index is too deep for variable '%s'", id);
    }

    private static String indexOutOfBoundsError(String id) {
        return String.format("Index is out of bounds for variable '%s'", id);
    }

    private static String indexNonConstantError(String id) {
        return String.format("Index is non-constant for variable '%s'", id);
    }

    private static String indexNonConstantForStructError(String id) {
        return String.format("Index of a struct member is non-constant for variable '%s'", id);
    }
}
