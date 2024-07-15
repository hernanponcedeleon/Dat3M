package com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.booleans.BoolLiteral;
import com.dat3m.dartagnan.expression.integers.IntCmpOp;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.*;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.memory.ScopedPointerVariable;
import com.dat3m.dartagnan.expression.type.ScopedPointerType;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.memory.MemoryObject;

import java.util.*;
import java.util.stream.Collectors;

public class MockProgramBuilder extends ProgramBuilder {

    private static final TypeFactory typeFactory = TypeFactory.getInstance();
    private static final ExpressionFactory exprFactory = ExpressionFactory.getInstance();

    public MockProgramBuilder() {
        this(List.of(1, 1, 1, 1), Map.of());
    }

    public MockProgramBuilder(Map<String, Expression> input) {
        this(List.of(1, 1, 1, 1), input);
    }

    public MockProgramBuilder(List<Integer> grid, Map<String, Expression> input) {
        super(grid, input);
        cfBuilder = new MockControlFlowBuilder(expressions);
    }

    @Override
    public void setNextOps(Set<String> nextOps) {
        // The value of nextOps is reset by the parent SpirvVisitor,
        // so we skip it in unit tests of child visitors
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

    public ScopedPointerType mockPtrType(String id, String pointedTypeId, String storageClass) {
        return (ScopedPointerType) addType(id, typeFactory.getScopedPointerType(getStorageClass(storageClass), getType(pointedTypeId)));
    }

    public ArrayType mockVectorType(String id, String innerTypeId, int size) {
        Type innerType = getType(innerTypeId);
        ArrayType type = size > 0
                ? typeFactory.getArrayType(innerType, size)
                : typeFactory.getArrayType(innerType);
        return (ArrayType) addType(id, type);
    }

    public AggregateType mockAggregateType(String id, String... innerTypeIds) {
        List<Type> innerTypes = Arrays.stream(innerTypeIds).map(this::getType).toList();
        AggregateType type = typeFactory.getAggregateType(innerTypes);
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
            Expression construction = exprFactory.makeConstruct(members);
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

    public ScopedPointerVariable mockVariable(String id, String typeId) {
        Type pointedType = ((ScopedPointerType)getType(typeId)).getPointedType();
        int bytes = typeFactory.getMemorySizeInBytes(pointedType);
        MemoryObject memoryObject = program.getMemory().allocate(bytes);
        memoryObject.setName(id);
        ScopedPointerVariable pointer = new ScopedPointerVariable(id, ((ScopedPointerType) getType(typeId)).getScopeId(), ((ScopedPointerType)getType(typeId)).getPointedType(), memoryObject);
        addExpression(id, pointer);
        return pointer;
    }

    public Expression mockCondition(String left, IntCmpOp kind, String right) {
        Expression leftExpr = getExpression(left);
        Expression rightExpr = getExpression(right);
        Expression cmpExpr = exprFactory.makeIntCmp(leftExpr, kind, rightExpr);
        return exprFactory.makeBooleanCast(cmpExpr);
    }

    public Expression mockITE(Expression cond, String thenId, String elseId) {
        Expression thenExpr = getExpression(thenId);
        Expression elseExpr = getExpression(elseId);
        return exprFactory.makeITE(cond, thenExpr, elseExpr);
    }

    public Register mockRegister(String id, String typeId) {
        return (Register) addExpression(id, addRegister(id, typeId));
    }

    public void mockLabel() {
        cfBuilder.getOrCreateLabel("%mock_label");
        cfBuilder.startBlock("%mock_label");
    }

    public void mockLabel(String id) {
        Label label = cfBuilder.getOrCreateLabel(id);
        cfBuilder.startBlock(id);
        addEvent(label);
    }

    public void mockFunctionStart() {
        FunctionType type = typeFactory.getFunctionType(typeFactory.getVoidType(), List.of());
        startFunctionDefinition("mock_function", type, List.of());
    }

    public Function getCurrentFunction() {
        return currentFunction;
    }

    public Event getLastEvent() {
        List<Event> events = currentFunction.getEvents();
        if (!events.isEmpty()) {
            return events.get(events.size() - 1);
        }
        return null;
    }

    public Map<String, Type> getTypes() {
        return Map.copyOf(types);
    }

    public Map<String, Expression> getExpressions() {
        return Map.copyOf(expressions);
    }

    public Set<Function> getForwardFunctions() {
        return Set.copyOf(forwardFunctions.values());
    }
}
