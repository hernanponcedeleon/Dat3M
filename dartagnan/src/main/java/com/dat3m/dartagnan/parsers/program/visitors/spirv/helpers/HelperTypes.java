package com.dat3m.dartagnan.parsers.program.visitors.spirv.helpers;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.AggregateType;
import com.dat3m.dartagnan.expression.type.ArrayType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;

import java.util.List;

import static com.dat3m.dartagnan.expression.integers.IntBinaryOp.ADD;
import static com.dat3m.dartagnan.expression.integers.IntBinaryOp.MUL;

public class HelperTypes {

    private static final TypeFactory types = TypeFactory.getInstance();
    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();
    private static final IntegerType archType = types.getArchType();

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

    public static Expression getMemberAddress(String id, Expression base, Type type, List<Expression> indexes) {
        if (!indexes.isEmpty()) {
            id += "[" + indexes.get(0) + "]";
            if (type instanceof ArrayType aType) {
                return getArrayMemberAddress(id, base, aType, indexes);
            }
            if (type instanceof AggregateType aType) {
                return getStructMemberAddress(id, base, aType, indexes);
            }
            throw new ParsingException(indexTooDeepError(id));
        }
        return base;
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
            if (index < type.getDirectFields().size()) {
                return getMemberType(id, type.getDirectFields().get(index), indexes.subList(1, indexes.size()));
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
                offset += types.getOffsetInBytes(type, index);
                return getMemberOffset(id, offset, elType, indexes.subList(1, indexes.size()));
            }
            throw new ParsingException(indexOutOfBoundsError(id));
        }
        throw new ParsingException(indexNonConstantError(id));
    }

    private static int getStructMemberOffset(String id, int offset, AggregateType type, List<Integer> indexes) {
        int index = indexes.get(0);
        if (index >= 0) {
            if (index < type.getDirectFields().size()) {
                offset += types.getOffsetInBytes(type, index);
                Type elType = type.getDirectFields().get(index);
                return getMemberOffset(id, offset, elType, indexes.subList(1, indexes.size()));
            }
            throw new ParsingException(indexOutOfBoundsError(id));
        }
        throw new ParsingException(indexNonConstantError(id));
    }

    private static Expression getArrayMemberAddress(String id, Expression base, ArrayType type, List<Expression> indexes) {
        Type elementType = type.getElementType();
        int size = types.getMemorySizeInBytes(elementType);
        IntLiteral sizeExpr = expressions.makeValue(size, archType);
        Expression indexExpr = expressions.makeIntegerCast(indexes.get(0), archType, false);
        Expression offsetExpr = expressions.makeBinary(sizeExpr, MUL, indexExpr);
        Expression expression = expressions.makeBinary(base, ADD, offsetExpr);
        return getMemberAddress(id, expression, elementType, indexes.subList(1, indexes.size()));
    }

    private static Expression getStructMemberAddress(String id, Expression base, AggregateType type, List<Expression> indexes) {
        Expression indexExpr = indexes.get(0);
        if (indexExpr instanceof IntLiteral intLiteral) {
            int index = intLiteral.getValueAsInt();
            if (index < type.getDirectFields().size()) {
                int offset = 0;
                for (int i = 0; i < index; i++) {
                    offset += types.getMemorySizeInBytes(type.getDirectFields().get(i));
                }
                IntLiteral offsetExpr = expressions.makeValue(offset, archType);
                Expression expression = expressions.makeBinary(base, ADD, offsetExpr);
                return getMemberAddress(id, expression, type.getDirectFields().get(index), indexes.subList(1, indexes.size()));
            }
            throw new ParsingException(indexOutOfBoundsError(id));
        }
        throw new ParsingException(indexNonConstantForStructError(id));
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
