package com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.misc.ConstructExpr;
import com.dat3m.dartagnan.expression.type.ArrayType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.memory.MemoryObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Stream;

public class BuiltIn implements Decoration {

    private static final ExpressionFactory FACTORY = ExpressionFactory.getInstance();
    public static final int GRID_SIZE = 4;

    // grid(0) - number of threads in a subgroup
    // grid(1) - number of subgroups in a local workgroup
    //      assuming sgSize <= wgSize and a flat workgroup
    // grid(2) - number of local workgroups in a queue family (global wg)
    //      assuming a flat workgroup
    // grid(3) - number of queue families (global wg) in a device
    private final List<Integer> grid;
    private final List<Integer> threadId;
    private final Map<String, String> mapping;

    public BuiltIn(int sgSize, int wgSize, int qfSize, int dvSize) {
        if (sgSize <= 0 || wgSize <= 0 || qfSize <= 0 || dvSize <= 0) {
            throw new ParsingException("Illegal BuiltIn size ('%d', '%d', '%d', '%d')",
                    sgSize, wgSize, qfSize, dvSize);
        }
        this.grid = List.of(sgSize, wgSize, qfSize, dvSize);
        this.threadId =  new ArrayList<>(Stream.generate(() -> 0)
                .limit(GRID_SIZE).toList());
        this.mapping = new HashMap<>();
    }

    public void setHierarchy(List<Integer> threadId) {
        if (threadId.stream().anyMatch(e -> e < 0) || threadId.size() != GRID_SIZE) {
            throw new ParsingException("Illegal BuiltIn hierarchy %s",
                    String.join(", ", threadId.stream().map(Object::toString).toList()));
        }
        this.threadId.clear();
        this.threadId.addAll(threadId);
    }

    public int getGlobalIdAtIndex(int idx) {
        if (idx >= GRID_SIZE) {
            throw new ParsingException("Illegal thread hierarchy index %d", idx);
        }
        int id = 0;
        for (int i = idx; i < GRID_SIZE; i++) {
            int v = threadId.get(i);
            for (int j = idx; j < i; j++) {
                v *= grid.get(j);
            }
            id += v;
        }
        return id;
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
            Expression expression = getDecoration(id, type);
            if (expression instanceof ConstructExpr cExpr) {
                Type elementType = getArrayElementType(id, type);
                int size = TypeFactory.getInstance().getMemorySizeInBytes(elementType);
                memObj.setInitialValue(0, cExpr.getOperands().get(0));
                memObj.setInitialValue(size, cExpr.getOperands().get(1));
                memObj.setInitialValue(size * 2, cExpr.getOperands().get(2));
            } else {
                memObj.setInitialValue(0, expression);
            }
        }
    }

    public boolean hasDecoration(String id) {
        return mapping.containsKey(id);
    }

    public Expression getDecoration(String id, Type type) {
        if (mapping.containsKey(id)) {
            return getDecorationExpressions(id, type);
        }
        return null;
    }

    private Expression getDecorationExpressions(String id, Type type) {
        return switch (mapping.get(id)) {
            case "SubgroupLocalInvocationId" -> makeScalar(id, type, threadId.get(0));
            case "LocalInvocationId" -> makeArray(id, type, threadId.get(0) + threadId.get(1) * grid.get(0), 0, 0);
            case "LocalInvocationIndex" -> makeScalar(id, type, threadId.get(0) + threadId.get(1) * grid.get(0)); // scalar of LocalInvocationId
            case "GlobalInvocationId" -> makeArray(id, type, threadId.get(0) + threadId.get(1) * grid.get(0) + threadId.get(2) * grid.get(0) * grid.get(1) + threadId.get(3) * grid.get(0) * grid.get(1) * grid.get(2), 0, 0);
            case "DeviceIndex" -> makeScalar(id, type, 0);
            case "SubgroupId" -> makeScalar(id, type, threadId.get(1));
            case "WorkgroupId" -> makeArray(id, type, threadId.get(2), 0, 0);
            case "SubgroupSize" -> makeScalar(id, type, grid.get(0));
            case "WorkgroupSize" -> makeArray(id, type, grid.get(0) * grid.get(1), 1, 1);
            default -> throw new ParsingException("Unsupported decoration '%s'", mapping.get(id));
        };
    }

    private Expression makeArray(String id, Type type, int a, int b, int c) {
        List<Expression> operands = new ArrayList<>();
        IntegerType elementType = getArrayElementType(id, type);
        operands.add(FACTORY.makeValue(a, elementType));
        operands.add(FACTORY.makeValue(b, elementType));
        operands.add(FACTORY.makeValue(c, elementType));
        return FACTORY.makeArray(elementType, operands, true);
    }

    private Expression makeScalar(String id, Type type, int a) {
        IntegerType iType = getIntegerType(id, type);
        return FACTORY.makeValue(a, iType);
    }

    private IntegerType getArrayElementType(String id, Type type) {
        if (type instanceof ArrayType aType && aType.getNumElements() == 3) {
            return getIntegerType(id, ((ArrayType) type).getElementType());
        }
        throw new ParsingException("Illegal type of element '%s', " +
                "expected array of three elements but received '%s'", id, type);
    }

    private IntegerType getIntegerType(String id, Type type) {
        if (type instanceof IntegerType iType && iType.getBitWidth() == 32) {
            return iType;
        }
        throw new ParsingException("Illegal type in '%s', " +
                "expected a 32-bit integer but received '%s'", id, type);
    }
}
