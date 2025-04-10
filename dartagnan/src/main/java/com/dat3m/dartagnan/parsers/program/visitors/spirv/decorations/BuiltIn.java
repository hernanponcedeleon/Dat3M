package com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.aggregates.ConstructExpr;
import com.dat3m.dartagnan.expression.type.ArrayType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.ThreadGrid;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.memory.MemoryObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class BuiltIn implements Decoration {

    private static final TypeFactory types = TypeFactory.getInstance();
    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();
    private ThreadGrid grid;
    private final Map<String, String> mapping;
    private int tid;

    public BuiltIn() {
        this.mapping = new HashMap<>();
    }

    public void setThreadGrid(ThreadGrid grid) {
        this.grid = grid;
    }

    public void setThreadId(int tid) {
        this.tid = tid;
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
                int size = types.getMemorySizeInBytes(elementType);
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
        if (grid.getArch() == Arch.VULKAN) {
            return switch (mapping.get(id)) {
                // BuiltIn decorations according to the Vulkan API
                case "SubgroupLocalInvocationId" -> makeScalar(id, type, tid % grid.getSize(Tag.Vulkan.SUB_GROUP));
                case "LocalInvocationId" -> makeArray(id, type, tid % grid.getSize(Tag.Vulkan.WORK_GROUP), 0, 0);
                case "LocalInvocationIndex" ->
                        makeScalar(id, type, tid % grid.getSize(Tag.Vulkan.WORK_GROUP)); // scalar of LocalInvocationId
                case "GlobalInvocationId" -> makeArray(id, type, tid % grid.getSize(Tag.Vulkan.DEVICE), 0, 0);
                case "DeviceIndex" -> makeScalar(id, type, grid.getId(Tag.Vulkan.DEVICE, tid));
                case "SubgroupId" -> makeScalar(id, type, grid.getId(Tag.Vulkan.SUB_GROUP, tid));
                case "WorkgroupId" -> makeArray(id, type, grid.getId(Tag.Vulkan.WORK_GROUP, tid), 0, 0);
                case "SubgroupSize" -> makeScalar(id, type, grid.getSize(Tag.Vulkan.SUB_GROUP));
                case "WorkgroupSize" -> makeArray(id, type, grid.getSize(Tag.Vulkan.WORK_GROUP), 1, 1);
                case "GlobalSize" -> makeArray(id, type, grid.getSize(Tag.Vulkan.DEVICE), 1, 1);
                case "NumWorkgroups" ->
                        makeArray(id, type, grid.getSize(Tag.Vulkan.DEVICE) / grid.getSize(Tag.Vulkan.WORK_GROUP), 1, 1);
                default -> throw new ParsingException("Unsupported decoration '%s'", mapping.get(id));
            };
        }
        if (grid.getArch() == Arch.OPENCL) {
            return switch (mapping.get(id)) {
                // BuiltIn decorations according to the OpenCL API
                case "GlobalInvocationId" -> makeArray(id, type, tid % grid.getSize(Tag.OpenCL.DEVICE), 0, 0);
                case "SubgroupLocalInvocationId" -> makeScalar(id, type, tid % grid.getSize(Tag.OpenCL.SUB_GROUP));
                case "SubgroupId" -> makeScalar(id, type, grid.getId(Tag.OpenCL.SUB_GROUP, tid));
                case "SubgroupSize" -> makeScalar(id, type, grid.getSize(Tag.OpenCL.SUB_GROUP));
                case "GlobalSize" -> makeArray(id, type, grid.getSize(Tag.OpenCL.DEVICE), 1, 1);
                case "LocalInvocationId" -> makeArray(id, type, tid % grid.getSize(Tag.OpenCL.WORK_GROUP), 0, 0);
                case "WorkgroupId" -> makeArray(id, type, grid.getId(Tag.OpenCL.WORK_GROUP, tid), 0, 0);
                case "WorkgroupSize" -> makeArray(id, type, grid.getSize(Tag.OpenCL.WORK_GROUP), 1, 1);
                case "NumWorkgroups" ->
                        makeArray(id, type, grid.getSize(Tag.OpenCL.DEVICE) / grid.getSize(Tag.OpenCL.WORK_GROUP), 1, 1);
                default -> throw new ParsingException("Unsupported decoration '%s'", mapping.get(id));
            };
        }
        throw new ParsingException("Unsupported architecture '%s'", grid.getArch());
    }

    private Expression makeArray(String id, Type type, int x, int y, int z) {
        List<Expression> operands = new ArrayList<>();
        IntegerType elementType = getArrayElementType(id, type);
        operands.add(expressions.makeValue(x, elementType));
        operands.add(expressions.makeValue(y, elementType));
        operands.add(expressions.makeValue(z, elementType));
        return expressions.makeArray(elementType, operands, true);
    }

    private Expression makeScalar(String id, Type type, int x) {
        IntegerType iType = getIntegerType(id, type);
        return expressions.makeValue(x, iType);
    }

    private IntegerType getArrayElementType(String id, Type type) {
        if (type instanceof ArrayType aType && aType.getNumElements() == 3) {
            return getIntegerType(id, aType.getElementType());
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
