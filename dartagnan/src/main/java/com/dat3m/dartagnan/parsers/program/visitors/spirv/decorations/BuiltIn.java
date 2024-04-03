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

    private final Map<String, List<String>> mapping = new HashMap<>();

    private int x = -1;
    private int y = -1;
    private int z = -1;
    private final int dimensionX;
    private final int dimensionY;
    private final int dimensionZ;

    public BuiltIn(int dimensionX, int dimensionY, int dimensionZ) {
        this.dimensionX = dimensionX;
        this.dimensionY = dimensionY;
        this.dimensionZ = dimensionZ;
    }

    public BuiltIn setHierarchy(int x, int y, int z) {
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
        List<String> values = mapping.computeIfAbsent(id, k -> new ArrayList<>());
        if (values.contains(params[0])) {
            throw new ParsingException("Duplicated decoration '%s' '%s' for '%s'",
                    getClass().getSimpleName(), params[0], id);
        }
        values.add(params[0]);
    }

    public Expression decorate(String id, Expression expr, Type type) {
        for (String decoration : mapping.getOrDefault(id, List.of())) {
            switch (decoration) {
                case "LocalInvocationId", "GlobalInvocationId" -> {
                    if (x < 0 || y < 0 || z < 0) {
                        throw new ParsingException("Illegal BuiltIn hierarchy ('%d', '%d', '%d')", x, y, z);
                    }
                    MemoryObject memObj = (MemoryObject) expr;
                    IntegerType elementType = getArrayElementType(type, 3);
                    int size = TypeFactory.getInstance().getMemorySizeInBytes(elementType);
                    memObj.setInitialValue(0, FACTORY.makeValue(x, elementType));
                    memObj.setInitialValue(size, FACTORY.makeValue(y, elementType));
                    memObj.setInitialValue(size * 2, FACTORY.makeValue(z, elementType));
                }
                case "WorkgroupSize" -> {
                    if (dimensionX <= 0 || dimensionY <= 0 || dimensionZ <= 0) {
                        throw new ParsingException("Illegal BuiltIn size ('%d', '%d', '%d')", dimensionX, dimensionY, dimensionZ);
                    }
                    List<Expression> operands = new ArrayList<>();
                    IntegerType elementType = getArrayElementType(type, 3);
                    operands.add(FACTORY.makeValue(dimensionX, elementType));
                    operands.add(FACTORY.makeValue(dimensionY, elementType));
                    operands.add(FACTORY.makeValue(dimensionZ, elementType));
                    return FACTORY.makeArray(elementType, operands, true);
                }
                default -> throw new ParsingException("Unsupported decoration '%s'", decoration);
            }
        }
        return expr;
    }

    public boolean hasDecoration(String id, String decoration) {
        return mapping.containsKey(id) && mapping.get(id).contains(decoration);
    }

    private IntegerType getArrayElementType(Type type, int expectedSize) {
        if (type instanceof ArrayType arrayType && arrayType.getNumElements() == expectedSize
                && (arrayType.getElementType() instanceof IntegerType integerType)) {
                return integerType;
        } else {
            throw new ParsingException("Unsupported type '%s'", type);
        }
    }
}
