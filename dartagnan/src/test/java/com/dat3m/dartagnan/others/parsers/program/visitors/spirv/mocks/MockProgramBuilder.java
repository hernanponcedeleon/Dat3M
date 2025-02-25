package com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.booleans.BoolLiteral;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.*;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.Decoration;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.DecorationType;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.Offset;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.helpers.HelperTags;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.builders.ProgramBuilder;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.utils.ThreadGrid;
import com.dat3m.dartagnan.program.memory.ScopedPointerVariable;
import com.dat3m.dartagnan.expression.type.ScopedPointerType;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.memory.MemoryObject;

import java.util.*;
import java.util.stream.Collectors;

public class MockProgramBuilder extends ProgramBuilder {

    private static final TypeFactory typeFactory = TypeFactory.getInstance();
    private static final ExpressionFactory exprFactory = ExpressionFactory.getInstance();

    public MockProgramBuilder() {
        this(new ThreadGrid(1, 1, 1, 1));
    }

    public MockProgramBuilder(ThreadGrid grid) {
        super(grid);
        controlFlowBuilder = new MockControlFlowBuilder(expressions);
    }

    @Override
    public void setNextOps(Set<String> nextOps) {
        // Do nothing in the mock
    }

    public VoidType mockVoidType(String id) {
        return (VoidType) addType(id, typeFactory.getVoidType());
    }

    public BooleanType mockBoolType(String id) {
        return (BooleanType) addType(id, typeFactory.getBooleanType());
    }

    public IntegerType mockIntType(String id, int bitWidth) {
        return (IntegerType) addType(id, typeFactory.getIntegerType(bitWidth));
    }

    public ScopedPointerType mockPtrType(String id, String typeId, String storageClass) {
        String storageClassTag = HelperTags.parseStorageClass(storageClass);
        return (ScopedPointerType) addType(id, typeFactory.getScopedPointerType(storageClassTag, getType(typeId)));
    }

    public ArrayType mockVectorType(String id, String innerTypeId, int size) {
        Type innerType = getType(innerTypeId);
        ArrayType type = size > 0
                ? typeFactory.getArrayType(innerType, size)
                : typeFactory.getArrayType(innerType);
        return (ArrayType) addType(id, type);
    }

    public AggregateType mockAggregateType(String id, String... innerTypeIds) {
        Offset decoration = (Offset) getDecorationsBuilder().getDecoration(DecorationType.OFFSET);
        Map<Integer, Integer> offsets = decoration.getValue(id);
        List<Type> innerTypes = Arrays.stream(innerTypeIds).map(this::getType).toList();
        AggregateType type = offsets != null
                ? typeFactory.getAggregateType(innerTypes, new ArrayList<>(offsets.values()))
                : typeFactory.getAggregateType(innerTypes);
        return (AggregateType) addType(id, type);
    }

    public FunctionType mockFunctionType(String id, String retTypeId, String... argTypeIds) {
        Type retType = getType(retTypeId);
        List<Type> argTypes = Arrays.stream(argTypeIds).map(this::getType).toList();
        FunctionType type = typeFactory.getFunctionType(retType, argTypes);
        return (FunctionType) addType(id, type);
    }

    public Expression mockConstant(String id, String typeId, Object value) {
        Type type = getType(typeId);
        if (type instanceof BooleanType) {
            BoolLiteral bConst = exprFactory.makeValue((boolean) value);
            return addExpression(id, bConst);
        } else if (type instanceof IntegerType iType) {
            IntLiteral iValue = exprFactory.makeValue((int) value, iType);
            return addExpression(id, iValue);
        } else if (type instanceof ArrayType aType) {
            Type elementType = aType.getElementType();
            List<Expression> elements = mockConstantArrayElements(elementType, value);
            Expression construction = exprFactory.makeArray(elementType, elements, true);
            return addExpression(id, construction);
        } else if (type instanceof AggregateType) {
            List<Expression> members = ((List<?>) value).stream().map(s -> getExpression((String) s)).toList();
            Expression construction = exprFactory.makeConstruct(type, members);
            return addExpression(id, construction);
        }
        throw new UnsupportedOperationException("Unsupported mock constant type " + typeId);
    }

    private List<Expression> mockConstantArrayElements(Type elementType, Object value) {
        if (elementType instanceof BooleanType) {
            return ((List<?>) value).stream()
                    .map(v -> exprFactory.makeValue((boolean) v))
                    .collect(Collectors.toList());
        } else if (elementType instanceof IntegerType iType) {
            return ((List<?>) value).stream()
                    .map(v -> exprFactory.makeValue((int) v, iType))
                    .collect(Collectors.toList());
        }
        throw new UnsupportedOperationException("Unsupported mock constant array element type " + elementType);
    }

    public Expression mockUndefinedValue(String id, String typeId) {
        Expression expression = makeUndefinedValue(getType(typeId));
        return addExpression(id, expression);
    }

    public ScopedPointerVariable mockVariable(String id, String typeId) {
        ScopedPointerType pointerType = (ScopedPointerType)getType(typeId);
        Type pointedType = pointerType.getPointedType();
        String scopeId = pointerType.getScopeId();
        int bytes = typeFactory.getMemorySizeInBytes(pointedType);
        MemoryObject memoryObject = program.getMemory().allocate(bytes);
        memoryObject.setName(id);
        ScopedPointerVariable pointer = exprFactory.makeScopedPointerVariable(id, scopeId, pointedType, memoryObject);
        return (ScopedPointerVariable) addExpression(id, pointer);
    }

    public void mockStructMemberOffsets(String id, Integer... offsets) {
        Decoration decoration = getDecorationsBuilder().getDecoration(DecorationType.OFFSET);
        for (int i = 0; i < offsets.length; i++) {
            decoration.addDecoration(id, Integer.toString(i), Integer.toString(offsets[i]));
        }
    }

    public void mockFunctionStart(boolean addStartLabel) {
        FunctionType type = typeFactory.getFunctionType(typeFactory.getVoidType(), List.of());
        startCurrentFunction(new Function("mock_function", type, List.of(), 0, null));
        if (addStartLabel) {
            Label label = controlFlowBuilder.getOrCreateLabel("%mock_label");
            controlFlowBuilder.startBlock("%mock_label");
            addEvent(label);
        }
    }

    public Function getCurrentFunction() {
        return currentFunction;
    }

    public Map<String, Type> getTypes() {
        return Map.copyOf(types);
    }

    public Map<String, Expression> getExpressions() {
        return Map.copyOf(expressions);
    }
}
