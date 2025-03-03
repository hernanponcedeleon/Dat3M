package com.dat3m.dartagnan.parsers.program.visitors.spirv.helpers;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.aggregates.ConstructExpr;
import com.dat3m.dartagnan.expression.integers.IntBinaryOp;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.*;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.IntStream;

import static com.dat3m.dartagnan.expression.integers.IntBinaryOp.ADD;
import static com.dat3m.dartagnan.expression.integers.IntBinaryOp.MUL;
import static com.dat3m.dartagnan.expression.utils.ExpressionHelper.isScalar;

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
            return expressions.makeArray(aType.getElementType(), elements, true);
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
            if (index < type.getFields().size()) {
                offset += type.getFields().get(index).offset();
                Type elType = type.getFields().get(index).type();
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
            if (index < type.getFields().size()) {
                Type subType = type.getFields().get(index).type();
                int offset = type.getFields().get(index).offset();
                IntLiteral offsetExpr = expressions.makeValue(offset, archType);
                Expression expression = expressions.makeBinary(base, ADD, offsetExpr);
                return getMemberAddress(id, expression, subType, indexes.subList(1, indexes.size()));
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

    public static Type getAlignedType(Type type, int alignmentNum) {
        if (type instanceof IntegerType) {
            return types.getIntegerType(alignmentNum * 8);
        }
        if (type instanceof AggregateType aggregateType) {
            List<Type> fieldTypes = new ArrayList<>();
            for (int i = 0; i < aggregateType.getFields().size(); i++) {
                Type fieldType = aggregateType.getFields().get(i).type();
                if (types.getMemorySizeInBytes(fieldType) > alignmentNum) {
                    fieldType = getAlignedType(fieldType, alignmentNum);
                }
                fieldTypes.add(fieldType);
            }
            List<Integer> alignmentList = new ArrayList<>(List.of(0));
            IntStream.range(0, fieldTypes.size() - 1).forEach(i -> {
                int fieldAlignment = types.getMemorySizeInBytes(fieldTypes.get(i));
                alignmentList.add(fieldAlignment + alignmentList.get(i));
            });
            return types.getAggregateType(fieldTypes, alignmentList);
        }
        if (type instanceof ArrayType arrayType) {
            Type elementType = arrayType.getElementType();
            int arraySizeInBytes = types.getMemorySizeInBytes(arrayType);
            if (arraySizeInBytes > alignmentNum) {
                return types.getArrayType(getAlignedType(elementType, alignmentNum), arrayType.getNumElements());
            }
            int paddedSize = alignmentNum / types.getMemorySizeInBytes(elementType);
            int paddingStart = arrayType.getNumElements();
            return types.getArrayType(elementType, paddedSize, paddingStart);
        }
        throw new ParsingException("Invalid type '%s' for alignment '%d'", type, alignmentNum);
    }
}
