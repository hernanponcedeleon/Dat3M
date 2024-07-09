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

public class HelperAccessChain {

    private static final TypeFactory typeFactory = TypeFactory.getInstance();
    private static final ExpressionFactory expressionFactory = ExpressionFactory.getInstance();
    private static final IntegerType archType = typeFactory.getArchType();

    private HelperAccessChain(){
    }

    public static Type getMemberType(String id, Type type, List<Expression> indexes) {
        if (indexes.isEmpty()) {
            return type;
        }
        if (type instanceof ArrayType aType) {
            return getArrayMemberType(id, aType, indexes);
        }
        if (type instanceof AggregateType aType) {
            return getStructMemberType(id, aType, indexes);
        }
        throw new ParsingException("Index is too deep in access chain '%s'", id);
    }

    private static Type getArrayMemberType(String id, ArrayType type, List<Expression> indexes) {
        return getMemberType(id, type.getElementType(), indexes.subList(1, indexes.size()));
    }

    private static Type getStructMemberType(String id, AggregateType type, List<Expression> indexes) {
        Expression expression = indexes.get(0);
        if (expression instanceof IntLiteral intLiteral) {
            int index = intLiteral.getValueAsInt();
            if (index < type.getDirectFields().size()) {
                return getMemberType(id, type.getDirectFields().get(index), indexes.subList(1, indexes.size()));
            }
            throw new ParsingException("Out of bound index in access chain '%s'", id);
        }
        throw new ParsingException("Unsupported non-constant index in access chain '%s'", id);
    }

    public static Expression getMemberAddress(String id, Expression base, Type type, List<Expression> indexes) {
        if (indexes.isEmpty()) {
            return base;
        }
        if (type instanceof ArrayType aType) {
            return getArrayMemberAddress(id, base, aType, indexes);
        }
        if (type instanceof AggregateType aType) {
            return getStructMemberAddress(id, base, aType, indexes);
        }
        throw new ParsingException("Index is too deep in access chain '%s'", id);
    }

    private static Expression getArrayMemberAddress(String id, Expression base, ArrayType type, List<Expression> indexes) {
        Type elementType = type.getElementType();
        int size = typeFactory.getMemorySizeInBytes(elementType);
        IntLiteral sizeExpr = expressionFactory.makeValue(size, archType);
        Expression indexExpr = expressionFactory.makeIntegerCast(indexes.get(0), archType, false);
        Expression offsetExpr = expressionFactory.makeBinary(sizeExpr, MUL, indexExpr);
        Expression expression = expressionFactory.makeBinary(base, ADD, offsetExpr);
        return getMemberAddress(id, expression, elementType, indexes.subList(1, indexes.size()));
    }

    private static Expression getStructMemberAddress(String id, Expression base, AggregateType type, List<Expression> indexes) {
        Expression indexExpr = indexes.get(0);
        if (indexExpr instanceof IntLiteral intLiteral) {
            int index = intLiteral.getValueAsInt();
            if (index < type.getDirectFields().size()) {
                int offset = 0;
                for (int i = 0; i < index; i++) {
                    offset += typeFactory.getMemorySizeInBytes(type.getDirectFields().get(i));
                }
                IntLiteral offsetExpr = expressionFactory.makeValue(offset, archType);
                Expression expression = expressionFactory.makeBinary(base, ADD, offsetExpr);
                return getMemberAddress(id, expression, type.getDirectFields().get(index), indexes.subList(1, indexes.size()));
            }
            throw new ParsingException("Out of bound index in access chain '%s'", id);
        }
        throw new ParsingException("Unsupported non-constant index in access chain '%s'", id);
    }
}
