package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockProgramBuilderSpv;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockSpirvParser;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.Skip;
import com.dat3m.dartagnan.program.event.functions.ValueFunctionCall;
import com.dat3m.dartagnan.program.event.functions.VoidFunctionCall;
import org.junit.Test;

import java.util.List;

import static org.junit.Assert.*;

public class VisitorOpsFunctionTest {

    private final MockProgramBuilderSpv builder = new MockProgramBuilderSpv();

    @Test
    public void testFunctionWithoutParameters() {
        // given
        String input = "%func = OpFunction %void None %void_func";
        builder.mockVoidType("%void");
        Type typeFunc = builder.mockFunctionType("%void_func", "%void");

        // when
        visit(input);

        // then
        Function function = builder.getCurrentFunction();
        assertEquals("%func", function.getName());
        assertEquals(typeFunc, function.getFunctionType());
        assertTrue(function.getParameterRegisters().isEmpty());
        assertEquals(function, builder.getExpression("%func"));
    }

    @Test
    public void testFunctionWithParameters() {
        // given
        String input = """
                %func = OpFunction %int None %int_func
                %param_int = OpFunctionParameter %int
                %param_ptr = OpFunctionParameter %ptr
                %param_arr = OpFunctionParameter %arr
                """;
        Type typeInt = builder.mockIntType("%int", 64);
        Type typePtr = builder.mockPtrType("%ptr", "%int", "Uniform");
        Type typeArr = builder.mockVectorType("%arr", "%int", 10);
        Type typeFunction = builder.mockFunctionType("%int_func", "%int", "%int", "%ptr", "%arr");

        // when
        visit(input);

        // then
        Function function = builder.getCurrentFunction();
        assertNotNull(function);
        assertEquals("%func", function.getName());
        assertEquals(typeFunction, function.getFunctionType());

        List<Register> registers = function.getParameterRegisters();
        assertEquals(3, registers.size());
        assertEquals("%param_int", registers.get(0).getName());
        assertEquals(typeInt, registers.get(0).getType());
        assertEquals("%param_ptr", registers.get(1).getName());
        assertEquals(typePtr, registers.get(1).getType());
        assertEquals("%param_arr", registers.get(2).getName());
        assertEquals(typeArr, registers.get(2).getType());

        assertEquals(function, builder.getExpression("%func"));
        assertEquals(registers.get(0), builder.getExpression("%param_int"));
        assertEquals(registers.get(1), builder.getExpression("%param_ptr"));
        assertEquals(registers.get(2), builder.getExpression("%param_arr"));
    }

    @Test(expected = ParsingException.class)
    public void testFunctionWithMismatchingType() {
        // given
        String input = "%func = OpFunction %void None %void_func";
        builder.mockVoidType("%void");
        builder.mockVoidType("%void_func");

        // when
        visit(input);
    }

    @Test(expected = ParsingException.class)
    public void testFunctionWithMismatchingReturnType() {
        // given
        String input = "%func = OpFunction %mismatching None %void_func";
        builder.mockVoidType("%void");
        builder.mockIntType("%mismatching", 64);
        builder.mockFunctionType("%void_func", "%void");

        // when
        visit(input);
    }

    @Test
    public void testFunctionWithMismatchingParameterTypes() {
        doTestFunctionParameters("""
                        %func = OpFunction %int None %int_func
                        %param_int = OpFunctionParameter %int
                        %param_ptr = OpFunctionParameter %ptr
                        %mismatching = OpFunctionParameter %ptr
                        """,
                "Mismatching argument type in function '%func' " +
                        "for argument '%mismatching'");
    }

    @Test
    public void testFunctionWithMissingParameters() {
        doTestFunctionParameters("""
                        %func = OpFunction %int None %int_func
                        %param_int = OpFunctionParameter %int
                        %param_ptr = OpFunctionParameter %ptr
                        OpFunctionEnd
                        """,
                "Illegal attempt to exit a function definition");
    }

    @Test
    public void testFunctionWithExtraParameters() {
        doTestFunctionParameters("""
                        %func = OpFunction %int None %int_func
                        %param_int = OpFunctionParameter %int
                        %param_ptr = OpFunctionParameter %ptr
                        %param_arr = OpFunctionParameter %arr
                        %extra = OpFunctionParameter %arr
                        """,
                "Attempt to declare function parameter '%extra' " +
                        "outside of a function definition");
    }

    @Test
    public void testFunctionWithIncorrectParameterOrder() {
        // given
        doTestFunctionParameters("""
                        %func = OpFunction %int None %int_func
                        %param_int = OpFunctionParameter %int
                        %param_arr = OpFunctionParameter %arr
                        %param_ptr = OpFunctionParameter %ptr
                        """,
                "Mismatching argument type in function '%func' " +
                        "for argument '%param_arr'");
    }

    @Test
    public void testFunctionWithDuplicatedParameterNames() {
        // given
        doTestFunctionParameters("""
                        %func = OpFunction %int None %int_func
                        %unique = OpFunctionParameter %int
                        %duplicated = OpFunctionParameter %ptr
                        %duplicated = OpFunctionParameter %arr
                        """,
                "Duplicated parameter id '%duplicated' in function '%func'");
    }

    private void doTestFunctionParameters(String input, String error) {
        builder.mockIntType("%int", 64);
        builder.mockPtrType("%ptr", "%int", "Uniform");
        builder.mockVectorType("%arr", "%int", 10);
        builder.mockFunctionType("%int_func", "%int", "%int", "%ptr", "%arr");

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
        builder.mockVoidType("%void");
        builder.mockFunctionType("%void_func", "%void");
        visit(input);

        try {
            // when
            builder.addEvent(new Skip());
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
                %param1 = OpFunctionParameter %int
                %param2 = OpFunctionParameter %arr
                OpFunctionEnd
                %main = OpFunction %void None %main_func
                %ret = OpFunctionCall %bool %func %arg1 %arg2
                """;

        builder.mockVoidType("%void");
        builder.mockBoolType("%bool");
        builder.mockIntType("%int", 64);
        builder.mockVectorType("%arr", "%int", 4);
        builder.mockFunctionType("%main_func", "%void");
        builder.mockFunctionType("%bool_func", "%bool", "%int", "%arr");

        Expression arg1 = builder.mockConstant("%arg1", "%int", 1);
        Expression arg2 = builder.mockConstant("%arg2", "%arr", List.of(1, 2, 3, 4));

        // when
        visit(input);

        // then
        Function func = getFunction("%func");
        Function main = getFunction("%main");

        ValueFunctionCall call = (ValueFunctionCall) main.getEvents().get(0);
        assertEquals(main, call.getFunction());
        assertEquals(func, call.getCalledFunction());
        assertEquals(main.getRegister("%ret"), call.getResultRegister());

        assertEquals(2, call.getArguments().size());
        assertEquals(arg1, call.getArguments().get(0));
        assertEquals(arg2, call.getArguments().get(1));

        assertTrue(builder.getForwardFunctions().isEmpty());
    }

    @Test
    public void testRecursiveFunctionCall() {
        // given
        String input = """
                %func = OpFunction %bool None %bool_func
                %param1 = OpFunctionParameter %int
                %param2 = OpFunctionParameter %arr
                %ret = OpFunctionCall %bool %func %arg1 %arg2
                """;

        builder.mockVoidType("%void");
        builder.mockBoolType("%bool");
        builder.mockIntType("%int", 64);
        builder.mockVectorType("%arr", "%int", 4);
        builder.mockFunctionType("%bool_func", "%bool", "%int", "%arr");

        Expression arg1 = builder.mockConstant("%arg1", "%int", 1);
        Expression arg2 = builder.mockConstant("%arg2", "%arr", List.of(1, 2, 3, 4));

        // when
        visit(input);

        // then
        Function func = getFunction("%func");
        ValueFunctionCall call = (ValueFunctionCall) func.getEvents().get(0);
        assertEquals(func, call.getFunction());
        assertEquals(func, call.getCalledFunction());
        assertEquals(func.getRegister("%ret"), call.getResultRegister());

        assertEquals(2, call.getArguments().size());
        assertEquals(arg1, call.getArguments().get(0));
        assertEquals(arg2, call.getArguments().get(1));

        assertTrue(builder.getForwardFunctions().isEmpty());
    }

    @Test
    public void testForwardFunctionCall() {
        // given
        String input = """
                %main = OpFunction %void None %main_func
                %ret = OpFunctionCall %bool %func %arg1 %arg2
                OpFunctionEnd
                %func = OpFunction %bool None %bool_func
                %param1 = OpFunctionParameter %int
                %param2 = OpFunctionParameter %arr
                """;

        builder.mockVoidType("%void");
        builder.mockBoolType("%bool");
        builder.mockIntType("%int", 64);
        builder.mockVectorType("%arr", "%int", 4);
        builder.mockFunctionType("%main_func", "%void");
        builder.mockFunctionType("%bool_func", "%bool", "%int", "%arr");

        Expression arg1 = builder.mockConstant("%arg1", "%int", 1);
        Expression arg2 = builder.mockConstant("%arg2", "%arr", List.of(1, 2, 3, 4));

        // when
        visit(input);

        // then
        Function main = getFunction("%main");
        Function func = getFunction("%func");

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

        assertTrue(builder.getForwardFunctions().isEmpty());
    }

    @Test
    public void testFunctionCallMismatchingArguments() {
        doTestFunctionCallMismatchingParameters("""
                %func = OpFunction %bool None %bool_func
                %param1 = OpFunctionParameter %int
                %param2 = OpFunctionParameter %arr
                OpFunctionEnd
                %main = OpFunction %void None %main_func
                %ret = OpFunctionCall %bool %func %arg1 %arg2
                """);
    }

    @Test
    public void testRecursiveFunctionCallMismatchingArguments() {
        doTestFunctionCallMismatchingParameters("""
                %func = OpFunction %bool None %bool_func
                %param1 = OpFunctionParameter %int
                %param2 = OpFunctionParameter %arr
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
                %param1 = OpFunctionParameter %int
                %param2 = OpFunctionParameter %arr
                """);
    }

    @Test
    public void testFunctionCallMismatchingReturnType() {
        doTestFunctionCallMismatchingParameters("""
                %func = OpFunction %bool None %bool_func
                %param1 = OpFunctionParameter %int
                %param2 = OpFunctionParameter %arr
                OpFunctionEnd
                %main = OpFunction %void None %main_func
                %ret = OpFunctionCall %void %func %arg1 %arg2
                """);
    }

    private void doTestFunctionCallMismatchingParameters(String input) {
        // given
        builder.mockVoidType("%void");
        builder.mockBoolType("%bool");
        builder.mockIntType("%int", 64);
        builder.mockVectorType("%arr", "%int", 4);
        builder.mockFunctionType("%main_func", "%void");
        builder.mockFunctionType("%bool_func", "%bool", "%int", "%arr");
        builder.mockConstant("%arg1", "%int", 1);
        builder.mockConstant("%arg2", "%int", 2);

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

        builder.mockVoidType("%void");
        builder.mockBoolType("%bool");
        builder.mockIntType("%int", 64);
        builder.mockVectorType("%arr", "%int", 4);
        builder.mockFunctionType("%main_func", "%void");
        builder.mockFunctionType("%bool_func", "%bool", "%int", "%arr");
        builder.mockConstant("%arg1", "%int", 1);
        builder.mockConstant("%arg2", "%arr", List.of(1, 2, 3, 4));

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
                %p2 = OpFunctionParameter %bool
                %c21 = OpFunctionCall %void %f1
                %c22 = OpFunctionCall %bool %f2 %a2
                %c23 = OpFunctionCall %int %f3 %a3
                OpFunctionEnd
                %f3 = OpFunction %int None %int_func
                %p3 = OpFunctionParameter %int
                OpFunctionEnd
                %main = OpFunction %void None %void_func
                OpFunctionEnd
                """;

        builder.mockVoidType("%void");
        builder.mockBoolType("%bool");
        builder.mockIntType("%int", 64);
        builder.mockFunctionType("%void_func", "%void");
        builder.mockFunctionType("%bool_func", "%bool", "%bool");
        builder.mockFunctionType("%int_func", "%int", "%int");

        Expression a2 = builder.mockConstant("%a2", "%bool", true);
        Expression a3 = builder.mockConstant("%a3", "%int", 1);

        // when
        visit(input);

        // then
        Function f1 = getFunction("%f1");
        Function f2 = getFunction("%f2");
        Function f3 = getFunction("%f3");

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

        assertNotNull(getFunction("%main"));
        assertTrue(builder.getForwardFunctions().isEmpty());
    }

    private void visit(String text) {
        builder.mockLabel();
        new MockSpirvParser(text).spv().accept(new VisitorOpsFunction(builder));
    }

    private Function getFunction(String id) {
        Function function = (Function) builder.getExpression(id);
        assertNotNull(function);
        return function;
    }
}
