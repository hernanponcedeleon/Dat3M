package com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.misc.ConstructExpr;
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
    private final int sgSize;
    private final int wgSize;
    private final int qfSize;
    private final int dvSize;
    private int thId = 0;
    private int sgId = 0;
    private int wgId = 0;
    private int qfId = 0;

    public BuiltIn(int sgSize, int wgSize, int qfSize, int dvSize) {
        if (sgSize <= 0 || wgSize <= 0 || qfSize <= 0 || dvSize <= 0) {
            throw new ParsingException("Illegal BuiltIn size ('%d', '%d', '%d', '%d')",
                    sgSize, wgSize, qfSize, dvSize);
        }
        // number of threads in a subgroup
        this.sgSize = sgSize;
        // number of subgroups in a local workgroup
        // assuming sgSize <= wgSize and a flat workgroup
        this.wgSize = wgSize;
        // number of local workgroups in a queue family (global wg)
        // assuming a flat workgroup
        this.qfSize = qfSize;
        // number of queue families (global wg) in a device
        this.dvSize = dvSize;
    }

    public BuiltIn setHierarchy(int thId, int sbId, int wgId, int qfId) {
        if (thId < 0 || sbId < 0 || wgId < 0 || qfId < 0) {
            throw new ParsingException("Illegal BuiltIn hierarchy " +
                    "('%d', '%d', '%d', '%d')", thId, sbId, wgId, qfId);
        }
        this.thId = thId;
        this.sgId = sbId;
        this.wgId = wgId;
        this.qfId = qfId;
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
            case "SubgroupLocalInvocationId" -> makeScalar(id, type, thId);
            case "LocalInvocationId" -> makeArray(id, type, thId + sgId * sgSize + wgId * sgSize * wgSize, 0, 0);
            case "LocalInvocationIndex" -> makeScalar(id, type, thId + sgId * sgSize + wgId * sgSize * wgSize); // scalar of LocalInvocationId
            case "GlobalInvocationId" -> makeArray(id, type, thId + sgId * sgSize + wgId * sgSize * wgSize + qfId * sgSize * wgSize * qfSize, 0, 0);
            case "DeviceIndex" -> makeScalar(id, type, 0);
            case "SubgroupId" -> makeScalar(id, type, sgId);
            case "WorkgroupId" -> makeArray(id, type, wgId, 0, 0);
            case "InvocationId" -> makeScalar(id, type, qfId);
            case "SubgroupSize" -> makeScalar(id, type, sgSize);
            case "WorkgroupSize" -> makeArray(id, type, sgSize * wgSize, 1, 1);
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
