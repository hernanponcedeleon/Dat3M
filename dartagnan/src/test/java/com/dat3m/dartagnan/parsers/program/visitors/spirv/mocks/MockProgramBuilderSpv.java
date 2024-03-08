package com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.type.*;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.ProgramBuilderSpv;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.memory.MemoryObject;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

public class MockProgramBuilderSpv extends ProgramBuilderSpv {

    private static final TypeFactory TYPE_FACTORY = TypeFactory.getInstance();
    private static final ExpressionFactory EXPR_FACTORY = ExpressionFactory.getInstance();

    public VoidType mockVoidType(String id) {
        return (VoidType) addType(id, TYPE_FACTORY.getVoidType());
    }

    public BooleanType mockBoolType(String id) {
        return (BooleanType) addType(id, TYPE_FACTORY.getBooleanType());
    }

    public IntegerType mockIntType(String id, int bitWidth) {
        return (IntegerType) addType(id, TYPE_FACTORY.getIntegerType(bitWidth));
    }

    public IntegerType mockPtrType(String id) {
        return (IntegerType) addType(id, TYPE_FACTORY.getPointerType());
    }

    public ArrayType mockVectorType(String id, String innerTypeId, int size) {
        Type innerType = getType(innerTypeId);
        ArrayType type = TYPE_FACTORY.getArrayType(innerType, size);
        return (ArrayType) addType(id, type);
    }

    public AggregateType mockAggregateType(String id, String... innerTypeIds) {
        List<Type> innerTypes = Arrays.stream(innerTypeIds).map(this::getType).toList();
        AggregateType type = TYPE_FACTORY.getAggregateType(innerTypes);
        return (AggregateType) addType(id, type);
    }

    public FunctionType mockFunctionType(String id, String retTypeId, String... argTypeIds) {
        Type retType = getType(retTypeId);
        List<Type> argTypes = Arrays.stream(argTypeIds).map(this::getType).toList();
        FunctionType type = TYPE_FACTORY.getFunctionType(retType, argTypes);
        return (FunctionType) addType(id, type);
    }

    public Expression mockConstant(String id, String typeId, Object value) {
        Type type = getType(typeId);
        if (type instanceof BooleanType) {
            BConst bConst = EXPR_FACTORY.makeValue((boolean) value);
            return addExpression(id, bConst);
        } else if (type instanceof IntegerType iType) {
            IValue iValue = EXPR_FACTORY.makeValue((int) value, iType);
            return addExpression(id, iValue);
        } else if (type instanceof ArrayType aType) {
            Type elementType = aType.getElementType();
            List<Expression> elements = mockConstantArrayElements(elementType, value);
            Construction construction = EXPR_FACTORY.makeArray(elementType, elements, true);
            return addExpression(id, construction);
        }
        throw new UnsupportedOperationException("Unsupported mock constant type " + typeId);
    }

    private List<Expression> mockConstantArrayElements(Type elementType, Object value) {
        if (elementType instanceof BooleanType) {
            return ((List<?>) value).stream()
                    .map(v -> EXPR_FACTORY.makeValue((boolean) v))
                    .collect(Collectors.toList());
        } else if (elementType instanceof IntegerType iType) {
            return ((List<?>) value).stream()
                    .map(v -> EXPR_FACTORY.makeValue((int) v, iType))
                    .collect(Collectors.toList());
        }
        throw new UnsupportedOperationException("Unsupported mock constant array element type " + elementType);
    }

    public void mockVariable(String id, String typeId) {
        int bytes = TYPE_FACTORY.getMemorySizeInBytes(getType(typeId));
        MemoryObject memObj = allocateMemory(bytes);
        memObj.setCVar(id);
        addExpression(id, memObj);
    }

    public void mockRegister(String id, String typeId) {
        addExpression(id, addRegister(id, typeId));
    }

    public void mockLabel() {
        startBlock(new Label("%mock_label"));
    }

    public void mockLabel(String id) {
        Label label = getOrCreateLabel(id);
        startBlock(label);
        addEvent(label);
    }

    public void mockFunctionStart() {
        FunctionType type = TYPE_FACTORY.getFunctionType(TYPE_FACTORY.getVoidType(), List.of());
        startFunctionDefinition("mock_function", type, List.of());
    }

    public Function getCurrentFunction() {
        return currentFunction;
    }
}
