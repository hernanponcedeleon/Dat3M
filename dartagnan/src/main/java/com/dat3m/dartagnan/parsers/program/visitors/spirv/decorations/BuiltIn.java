package com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.ArrayType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.Type;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.memory.MemoryObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class BuiltIn implements Decoration {

    private static final ExpressionFactory FACTORY = ExpressionFactory.getInstance();

    private final Map<String, String> mapping = new HashMap<>();
    private final int dimensionX;
    private final int dimensionY;
    private final int dimensionZ;
    private int x = 0;
    private int y = 0;
    private int z = 0;

    public BuiltIn(int dimensionX, int dimensionY, int dimensionZ) {
        if (dimensionX <= 0 || dimensionY <= 0 || dimensionZ <= 0) {
            throw new ParsingException("Illegal BuiltIn size ('%d', '%d', '%d')", dimensionX, dimensionY, dimensionZ);
        }
        this.dimensionX = dimensionX;
        this.dimensionY = dimensionY;
        this.dimensionZ = dimensionZ;
    }

    public BuiltIn setHierarchy(int x, int y, int z) {
        if (x < 0 || y < 0 || z < 0) {
            throw new ParsingException("Illegal BuiltIn hierarchy ('%d', '%d', '%d')", x, y, z);
        }
        this.x = x;
        this.y = y;
        this.z = z;
        return this;
    }

    @Override
    public void addDecoration(String id, String... params) {
        if (params.length != 1) {
            throw new ParsingException("Illegal decoration '%s' for '%s'",
                    getClass().getSimpleName(), id);
        }
        if (mapping.containsKey(params[0])) {
            throw new ParsingException("Multiple '%s' decorations for '%s'",
                    getClass().getSimpleName(), id);
        }
        mapping.put(id, params[0]);
    }

    public void decorate(String id, MemoryObject memObj, Type type) {
        if (mapping.containsKey(id)) {
            List<Expression> operands = getDecorationExpressions(mapping.get(id), type);
            IntegerType elementType = getArrayElementType(type, 3);
            int size = TypeFactory.getInstance().getMemorySizeInBytes(elementType);
            memObj.setInitialValue(0, operands.get(0));
            memObj.setInitialValue(size, operands.get(1));
            memObj.setInitialValue(size * 2, operands.get(2));
        }
    }

    public boolean hasDecoration(String id) {
        return mapping.containsKey(id);
    }

    public Expression getDecoration(String id, Type type) {
        if (mapping.containsKey(id)) {
            List<Expression> operands = getDecorationExpressions(mapping.get(id), type);
            IntegerType elementType = getArrayElementType(type, 3);
            return FACTORY.makeArray(elementType, operands, true);
        }
        return null;
    }

    private List<Expression> getDecorationExpressions(String decoration, Type type) {
        // TODO: Check if values are computed correctly with respect to the spec
        return switch (decoration) {
            case "LocalInvocationId", "GlobalInvocationId" -> makeOperands(type, x, y, z);
            case "WorkgroupSize" -> makeOperands(type, dimensionX, dimensionY, dimensionZ);
            case "WorkgroupId" -> makeOperands(type, y, 1, 1);
            default -> throw new ParsingException("Unsupported decoration '%s'", decoration);
        };
    }

    private List<Expression> makeOperands(Type type, int a, int b, int c) {
        List<Expression> operands = new ArrayList<>();
        IntegerType elementType = getArrayElementType(type, 3);
        operands.add(FACTORY.makeValue(a, elementType));
        operands.add(FACTORY.makeValue(b, elementType));
        operands.add(FACTORY.makeValue(c, elementType));
        return operands;
    }

    private IntegerType getArrayElementType(Type type, int expectedSize) {
        if (type instanceof ArrayType arrayType && arrayType.getNumElements() == expectedSize
                && (arrayType.getElementType() instanceof IntegerType integerType)) {
            return integerType;
        }
        throw new ParsingException("Unsupported type '%s'", type);
    }
}
