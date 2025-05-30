package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.ArrayType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.helpers.HelperInputs;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockProgramBuilder;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockSpirvParser;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.Local;
import com.dat3m.dartagnan.program.event.core.Skip;
import com.dat3m.dartagnan.program.event.functions.ValueFunctionCall;
import com.dat3m.dartagnan.program.event.functions.VoidFunctionCall;
import com.dat3m.dartagnan.program.memory.ScopedPointerVariable;
import com.dat3m.dartagnan.program.memory.VirtualMemoryObject;
import org.junit.Before;
import org.junit.Test;

import java.util.List;

import static org.junit.Assert.*;

public class VisitorOpsFunctionTest {

    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();
    private final MockProgramBuilder builder = new MockProgramBuilder();
    private final VisitorOpsFunction visitor = new VisitorOpsFunction(builder);

    @Before
    public void before() {
        builder.mockVoidType("%void");
        builder.mockBoolType("%bool");
        builder.mockIntType("%int", 64);
        builder.mockVectorType("%arr", "%int", 4);
        builder.mockPtrType("%bool_ptr", "%bool", "Uniform");
        builder.mockPtrType("%int_ptr", "%int", "Uniform");
        builder.mockPtrType("%arr_ptr", "%arr", "Uniform");
    }

    @Test
    public void testFunctionWithoutParameters() {
        // given
        String input = "%func = OpFunction %void None %void_func";
        Type type = builder.mockFunctionType("%void_func", "%void");

        // when
        visit(input);

        // then
        Function function = builder.getCurrentFunction();
        assertEquals("%func", function.getName());
        assertEquals(type, function.getFunctionType());
        assertTrue(function.getParameterRegisters().isEmpty());
        assertEquals(function, builder.getExpression("%func"));
    }

    @Test
    public void testFunctionWithParameters() {
        // given
        String input = """
                %func = OpFunction %int None %int_func
                %param_bool = OpFunctionParameter %bool_ptr
                %param_int = OpFunctionParameter %int_ptr
                %param_arr = OpFunctionParameter %arr_ptr
                """;

        Type type = builder.mockFunctionType("%int_func", "%int", "%bool_ptr", "%int_ptr", "%arr_ptr");

        // when
        visit(input);

        // then
        Function function = builder.getCurrentFunction();
        assertNotNull(function);
        assertEquals("%func", function.getName());
        assertEquals(type, function.getFunctionType());

        List<Register> registers = function.getParameterRegisters();
        assertEquals(3, registers.size());
        assertEquals("%param_bool", registers.get(0).getName());
        assertEquals(builder.getType("%bool_ptr"), registers.get(0).getType());
        assertEquals("%param_int", registers.get(1).getName());
        assertEquals(builder.getType("%int_ptr"), registers.get(1).getType());
        assertEquals("%param_arr", registers.get(2).getName());
        assertEquals(builder.getType("%arr_ptr"), registers.get(2).getType());

        assertEquals(function, builder.getExpression("%func"));
    }

    @Test(expected = ParsingException.class)
    public void testFunctionWithMismatchingType() {
        // given
        String input = "%func = OpFunction %void None %void_func";
        builder.mockVoidType("%void_func");

        // when
        visit(input);
    }

    @Test(expected = ParsingException.class)
    public void testFunctionWithMismatchingReturnType() {
        // given
        String input = "%func = OpFunction %mismatching None %void_func";
        builder.mockIntType("%mismatching", 64);
        builder.mockFunctionType("%void_func", "%void");

        // when
        visit(input);
    }

    @Test
    public void testFunctionWithMismatchingParameterTypes() {
        doTestFunctionParameters("""
                        %func = OpFunction %int None %int_func
                        %param_bool = OpFunctionParameter %bool_ptr
                        %param_int = OpFunctionParameter %int_ptr
                        %mismatching = OpFunctionParameter %int_ptr
                        """,
                "Mismatching argument type in function '%func' " +
                        "for argument '%mismatching'");
    }

    @Test
    public void testFunctionWithMissingParameters() {
        doTestFunctionParameters("""
                        %func = OpFunction %int None %int_func
                        %param_bool = OpFunctionParameter %bool_ptr
                        %param_int = OpFunctionParameter %int_ptr
                        OpFunctionEnd
                        """,
                "Illegal attempt to exit a function definition");
    }

    @Test
    public void testFunctionWithExtraParameters() {
        doTestFunctionParameters("""
                        %func = OpFunction %int None %int_func
                        %param_bool = OpFunctionParameter %bool_ptr
                        %param_int = OpFunctionParameter %int_ptr
                        %param_arr = OpFunctionParameter %arr_ptr
                        %extra = OpFunctionParameter %arr_ptr
                        """,
                "Attempt to declare function parameter '%extra' " +
                        "outside of a function definition");
    }

    @Test
    public void testFunctionWithIncorrectParameterOrder() {
        // given
        doTestFunctionParameters("""
                        %func = OpFunction %int None %int_func
                        %param_bool = OpFunctionParameter %bool_ptr
                        %param_arr = OpFunctionParameter %arr_ptr
                        %param_int = OpFunctionParameter %int_ptr
                        """,
                "Mismatching argument type in function '%func' " +
                        "for argument '%param_arr'");
    }

    @Test
    public void testFunctionWithDuplicatedParameterNames() {
        // given
        doTestFunctionParameters("""
                        %func = OpFunction %int None %int_func
                        %unique = OpFunctionParameter %bool_ptr
                        %duplicated = OpFunctionParameter %int_ptr
                        %duplicated = OpFunctionParameter %arr_ptr
                        """,
                "Duplicated parameter id '%duplicated' in function '%func'");
    }

    private void doTestFunctionParameters(String input, String error) {
        // given
        builder.mockFunctionType("%int_func", "%int", "%bool_ptr", "%int_ptr", "%arr_ptr");

        try {
            // when
            visit(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals(error, e.getMessage());
        }
    }

    @Test
    public void testFunctionEnd() {
        // given
        String input = """
                %func = OpFunction %void None %void_func
                OpFunctionEnd
                """;
        builder.mockFunctionType("%void_func", "%void");
        Event event = new Skip();
        visit(input);

        try {
            // when
            builder.addEvent(event);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Attempt to add an event outside a function definition",
                    e.getMessage());
        }
    }

    @Test(expected = ParsingException.class)
    public void testFunctionEndIllegal() {
        // given
        String input = "OpFunctionEnd";

        // when
        visit(input);
    }

    @Test
    public void testFunctionCall() {
        // given
        String input = """
                %func = OpFunction %bool None %bool_func
                %param1 = OpFunctionParameter %int_ptr
                %param2 = OpFunctionParameter %arr_ptr
                OpFunctionEnd
                %main = OpFunction %void None %main_func
                %ret = OpFunctionCall %bool %func %arg1 %arg2
                """;

        builder.mockFunctionType("%main_func", "%void");
        builder.mockFunctionType("%bool_func", "%bool", "%int_ptr", "%arr_ptr");

        Expression arg1 = builder.mockVariable("%arg1", "%int_ptr");
        Expression arg2 = builder.mockVariable("%arg2", "%arr_ptr");

        // when
        visit(input);

        // then
        Function func = (Function) builder.getExpression("%func");
        Function main = (Function) builder.getExpression("%main");

        ValueFunctionCall call = (ValueFunctionCall) main.getEvents().get(0);
        assertEquals(main, call.getFunction());
        assertEquals(func, call.getCalledFunction());
        assertEquals(main.getRegister("%ret"), call.getResultRegister());

        assertEquals(2, call.getArguments().size());
        assertEquals(arg1, call.getArguments().get(0));
        assertEquals(arg2, call.getArguments().get(1));

        assertTrue(visitor.getForwardFunctions().isEmpty());
        assertTrue(visitor.getForwardCalls().isEmpty());
    }

    @Test
    public void testRecursiveFunctionCall() {
        // given
        String input = """
                %func = OpFunction %bool None %bool_func
                %param1 = OpFunctionParameter %int_ptr
                %param2 = OpFunctionParameter %arr_ptr
                %ret = OpFunctionCall %bool %func %arg1 %arg2
                """;

        builder.mockFunctionType("%bool_func", "%bool", "%int_ptr", "%arr_ptr");

        Expression arg1 = builder.mockVariable("%arg1", "%int_ptr");
        Expression arg2 = builder.mockVariable("%arg2", "%arr_ptr");

        // when
        visit(input);

        // then
        Function func = (Function) builder.getExpression("%func");
        ValueFunctionCall call = (ValueFunctionCall) func.getEvents().get(0);
        assertEquals(func, call.getFunction());
        assertEquals(func, call.getCalledFunction());
        assertEquals(func.getRegister("%ret"), call.getResultRegister());

        assertEquals(2, call.getArguments().size());
        assertEquals(arg1, call.getArguments().get(0));
        assertEquals(arg2, call.getArguments().get(1));

        assertTrue(visitor.getForwardFunctions().isEmpty());
        assertTrue(visitor.getForwardCalls().isEmpty());
    }

    @Test
    public void testForwardFunctionCall() {
        // given
        String input = """
                %main = OpFunction %void None %main_func
                %ret = OpFunctionCall %bool %func %arg1 %arg2
                OpFunctionEnd
                %func = OpFunction %bool None %bool_func
                %param1 = OpFunctionParameter %int_ptr
                %param2 = OpFunctionParameter %arr_ptr
                """;

        builder.mockFunctionType("%main_func", "%void");
        builder.mockFunctionType("%bool_func", "%bool", "%int_ptr", "%arr_ptr");

        Expression arg1 = builder.mockVariable("%arg1", "%int_ptr");
        Expression arg2 = builder.mockVariable("%arg2", "%arr_ptr");

        // when
        visit(input);

        // then
        Function main = (Function) builder.getExpression("%main");
        Function func = (Function) builder.getExpression("%func");

        ValueFunctionCall call = (ValueFunctionCall) main.getEvents().get(0);
        assertEquals(main, call.getFunction());
        assertEquals(func, call.getCalledFunction());
        assertEquals(main.getRegister("%ret"), call.getResultRegister());

        assertEquals(2, func.getParameterRegisters().size());
        assertEquals("%param1", func.getParameterRegisters().get(0).getName());
        assertEquals("%param2", func.getParameterRegisters().get(1).getName());

        assertEquals(2, call.getArguments().size());
        assertEquals(arg1, call.getArguments().get(0));
        assertEquals(arg2, call.getArguments().get(1));

        assertTrue(visitor.getForwardFunctions().isEmpty());
        assertTrue(visitor.getForwardCalls().isEmpty());
    }

    @Test
    public void testFunctionCallMismatchingArguments() {
        doTestFunctionCallMismatchingParameters("""
                %func = OpFunction %bool None %bool_func
                %param1 = OpFunctionParameter %int_ptr
                %param2 = OpFunctionParameter %arr_ptr
                OpFunctionEnd
                %main = OpFunction %void None %main_func
                %ret = OpFunctionCall %bool %func %arg1 %arg2
                """);
    }

    @Test
    public void testRecursiveFunctionCallMismatchingArguments() {
        doTestFunctionCallMismatchingParameters("""
                %func = OpFunction %bool None %bool_func
                %param1 = OpFunctionParameter %int_ptr
                %param2 = OpFunctionParameter %arr_ptr
                %ret = OpFunctionCall %bool %func %arg1 %arg2
                """);
    }

    @Test
    public void testForwardFunctionCallMismatchingParameters() {
        doTestFunctionCallMismatchingParameters("""
                %main = OpFunction %void None %main_func
                %ret = OpFunctionCall %bool %func %arg1 %arg2
                OpFunctionEnd
                %func = OpFunction %bool None %bool_func
                %param1 = OpFunctionParameter %int_ptr
                %param2 = OpFunctionParameter %arr_ptr
                """);
    }

    @Test
    public void testFunctionCallMismatchingReturnType() {
        doTestFunctionCallMismatchingParameters("""
                %func = OpFunction %bool None %bool_func
                %param1 = OpFunctionParameter %int_ptr
                %param2 = OpFunctionParameter %arr_ptr
                OpFunctionEnd
                %main = OpFunction %void None %main_func
                %ret = OpFunctionCall %void %func %arg1 %arg2
                """);
    }

    private void doTestFunctionCallMismatchingParameters(String input) {
        // given
        builder.mockFunctionType("%main_func", "%void");
        builder.mockFunctionType("%bool_func", "%bool", "%int_ptr", "%arr_ptr");
        builder.mockVariable("%arg1", "%int_ptr");
        builder.mockVariable("%arg2", "%int_ptr");

        try {
            // when
            visit(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            assertEquals("Illegal call of function '%func', " +
                            "function type doesn't match the function definition",
                    e.getMessage());
        }
    }

    @Test(expected = ParsingException.class)
    public void testForwardFunctionCallUndefinedFunction() {
        // given
        String input = """
                %main = OpFunction %void None %main_func
                %ret = OpFunctionCall %bool %func %arg1 %arg2
                OpFunctionEnd
                """;

        builder.mockFunctionType("%main_func", "%void");
        builder.mockFunctionType("%bool_func", "%bool", "%int_ptr", "%arr_ptr");
        builder.mockVariable("%arg1", "%int_ptr");
        builder.mockVariable("%arg2", "%arr_ptr");

        // when
        visit(input);
        builder.build();
    }

    @Test
    public void testCreatingMultipleFunctions() {
        // given
        String input = """
                %f1 = OpFunction %void None %void_func
                %c11 = OpFunctionCall %void %f1
                %c12 = OpFunctionCall %bool %f2 %a2
                %c13 = OpFunctionCall %int %f3 %a3
                OpFunctionEnd
                %f2 = OpFunction %bool None %bool_func
                %p2 = OpFunctionParameter %bool_ptr
                %c21 = OpFunctionCall %void %f1
                %c22 = OpFunctionCall %bool %f2 %a2
                %c23 = OpFunctionCall %int %f3 %a3
                OpFunctionEnd
                %f3 = OpFunction %int None %int_func
                %p3 = OpFunctionParameter %int_ptr
                OpFunctionEnd
                %main = OpFunction %void None %void_func
                OpFunctionEnd
                """;

        builder.mockFunctionType("%void_func", "%void");
        builder.mockFunctionType("%bool_func", "%bool", "%bool_ptr");
        builder.mockFunctionType("%int_func", "%int", "%int_ptr");

        Expression a2 = builder.mockVariable("%a2", "%bool_ptr");
        Expression a3 = builder.mockVariable("%a3", "%int_ptr");

        // when
        visit(input);

        // then
        Function f1 = (Function) builder.getExpression("%f1");
        Function f2 = (Function) builder.getExpression("%f2");
        Function f3 = (Function) builder.getExpression("%f3");

        VoidFunctionCall c11 = (VoidFunctionCall) f1.getEvents().get(0);
        ValueFunctionCall c12 = (ValueFunctionCall) f1.getEvents().get(1);
        ValueFunctionCall c13 = (ValueFunctionCall) f1.getEvents().get(2);
        VoidFunctionCall c21 = (VoidFunctionCall) f2.getEvents().get(0);
        ValueFunctionCall c22 = (ValueFunctionCall) f2.getEvents().get(1);
        ValueFunctionCall c23 = (ValueFunctionCall) f2.getEvents().get(2);

        assertEquals(f1, c11.getFunction());
        assertEquals(f1, c11.getCalledFunction());
        assertEquals(f1, c12.getFunction());
        assertEquals(f2, c12.getCalledFunction());
        assertEquals(f1, c13.getFunction());
        assertEquals(f3, c13.getCalledFunction());
        assertEquals(f2, c21.getFunction());
        assertEquals(f1, c21.getCalledFunction());
        assertEquals(f2, c22.getFunction());
        assertEquals(f2, c22.getCalledFunction());
        assertEquals(f2, c23.getFunction());
        assertEquals(f3, c23.getCalledFunction());

        assertEquals(f1.getRegister("%c12"), c12.getResultRegister());
        assertEquals(f1.getRegister("%c13"), c13.getResultRegister());
        assertEquals(f2.getRegister("%c22"), c22.getResultRegister());
        assertEquals(f2.getRegister("%c23"), c23.getResultRegister());

        assertEquals(a2, c12.getArguments().get(0));
        assertEquals(a3, c13.getArguments().get(0));
        assertEquals(a2, c22.getArguments().get(0));
        assertEquals(a3, c23.getArguments().get(0));

        assertNotNull(builder.getExpression("%main"));
        assertTrue(visitor.getForwardFunctions().isEmpty());
        assertTrue(visitor.getForwardCalls().isEmpty());
    }

    @Test
    public void testScalaFunctionParameterWithInput() {
        // given
        String input = """
                %func = OpFunction %void None %void_func
                %param = OpFunctionParameter %int
                """;

        builder.mockFunctionType("%void_func", "%void", "%int");
        builder.setEntryPointId("%func");
        Expression parmInput = expressions.makeValue(1, (IntegerType) builder.getType("%int"));
        builder.addInput("%param", parmInput);

        // when
        visit(input);

        // then
        Function function = builder.getCurrentFunction();
        Local local = (Local) function.getEvents().get(0);
        assertNotNull(function);
        assertEquals("%func", function.getName());
        assertEquals(1, function.getParameterRegisters().size());
        assertEquals("%param", function.getParameterRegisters().get(0).getName());
        assertEquals(builder.getType("%int"), function.getParameterRegisters().get(0).getType());
        assertEquals(parmInput, local.getExpr());
        assertEquals(builder.getExpression("%param"), local.getResultRegister());
    }

    @Test
    public void testPointerFunctionParameterWithIntInput() {
        // given
        String input = """
                %func = OpFunction %void None %void_func
                %param = OpFunctionParameter %int_ptr
                """;

        builder.mockFunctionType("%void_func", "%void", "%int_ptr");
        builder.setEntryPointId("%func");
        builder.mockConstant("%0", "%int", 0);
        builder.mockConstant("%input", "%arr", List.of("%0", "%0", "%0", "%0"));
        builder.addInput("%param", builder.getExpression("%input"));

        // when
        visit(input);

        // then
        Function function = builder.getCurrentFunction();
        Local local = (Local) function.getEvents().get(0);
        assertNotNull(function);
        assertEquals("%func", function.getName());
        assertEquals(1, function.getParameterRegisters().size());
        assertEquals("%param", function.getParameterRegisters().get(0).getName());
        assertEquals(builder.getType("%int_ptr"), function.getParameterRegisters().get(0).getType());
        assertEquals(HelperInputs.castPointerId("%param"), ((VirtualMemoryObject) local.getExpr()).getName());
        assertEquals(expressions.makeZero((IntegerType) builder.getType("%int")), ((VirtualMemoryObject) local.getExpr()).getInitialValue(0));
        assertEquals(builder.getExpression("%param"), local.getResultRegister());
    }

    @Test
    public void testPointerFunctionParameterWithArrayInput() {
        // given
        String input = """
                %func = OpFunction %void None %void_func
                %param = OpFunctionParameter %int_ptr
                """;

        ArrayType inputType = builder.mockVectorType("%array", "%int", 2);
        builder.mockFunctionType("%void_func", "%void", "%int_ptr");
        builder.setEntryPointId("%func");
        Expression i1 = expressions.makeValue(1, (IntegerType) builder.getType("%int"));
        Expression i2 = expressions.makeValue(2, (IntegerType) builder.getType("%int"));
        Expression value = expressions.makeArray(inputType, List.of(i1, i2));
        builder.addInput("%param", value);

        // when
        visit(input);

        // then
        Function function = builder.getCurrentFunction();
        Local local = (Local) function.getEvents().get(0);
        assertNotNull(function);
        assertEquals("%func", function.getName());
        assertEquals(1, function.getParameterRegisters().size());
        assertEquals("%param", function.getParameterRegisters().get(0).getName());
        assertEquals(builder.getType("%int_ptr"), function.getParameterRegisters().get(0).getType());
        assertEquals(HelperInputs.castPointerId("%param"), ((VirtualMemoryObject) local.getExpr()).getName());
        assertEquals(value.getOperands().get(0), ((VirtualMemoryObject) local.getExpr()).getInitialValue(0));
        assertEquals(value.getOperands().get(1), ((VirtualMemoryObject) local.getExpr()).getInitialValue(8));
        assertEquals(builder.getExpression("%param"), local.getResultRegister());
    }

    @Test
    public void testPointerFunctionParameterWithNoInput() {
        // given
        String input = """
                %func = OpFunction %void None %void_func
                %param = OpFunctionParameter %int_ptr
                """;

        builder.mockFunctionType("%void_func", "%void", "%int_ptr");
        builder.setEntryPointId("%func");

        // when
        visit(input);

        // then
        Function function = builder.getCurrentFunction();
        Local local = (Local) function.getEvents().get(0);
        assertNotNull(function);
        assertEquals("%func", function.getName());
        assertEquals(1, function.getParameterRegisters().size());
        assertEquals("%param", function.getParameterRegisters().get(0).getName());
        assertEquals(builder.getType("%int_ptr"), function.getParameterRegisters().get(0).getType());
        assertEquals(HelperInputs.castPointerId("%param"), ((VirtualMemoryObject) local.getExpr()).getName());
        assertEquals(builder.getExpression("%param"), local.getResultRegister());
        ArrayType type = (ArrayType) ((ScopedPointerVariable) builder.getExpression(HelperInputs.castPointerId("%param"))).getInnerType();
        assertEquals(builder.getType("%int"), type.getElementType());
        assertEquals(10, type.getNumElements());
    }


    private void visit(String text) {
        builder.getControlFlowBuilder().getOrCreateLabel("%mock_label");
        builder.getControlFlowBuilder().startBlock("%mock_label");
        builder.setArch(Arch.VULKAN);
        new MockSpirvParser(text).spv().accept(visitor);
    }
}
