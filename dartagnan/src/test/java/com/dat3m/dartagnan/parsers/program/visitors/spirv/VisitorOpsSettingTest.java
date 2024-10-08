package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockProgramBuilder;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockSpirvParser;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import org.junit.Test;

import java.util.List;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

public class VisitorOpsSettingTest {

    private final MockProgramBuilder builder = new MockProgramBuilder();

    @Test
    public void testEntryPoint() {
        // given
        String input = "OpEntryPoint GLCompute %main \"main\" %gl_GlobalInvocationID";
        builder.mockVoidType("%void");
        FunctionType type = builder.mockFunctionType("%func", "%void");
        Function function = new Function("%main", type, List.of(), 0, null);
        builder.startCurrentFunction(function);
        builder.endCurrentFunction();

        // when
        visit(input);
        Program program = builder.build();

        // then
        assertEquals(type, function.getFunctionType());
        assertEquals(1, program.getFunctions().size());
        assertEquals(function, program.getFunctions().get(0));
    }

    @Test
    public void testUndefinedEntryPoint() {
        // given
        String input = "OpEntryPoint GLCompute %expected \"main\" %gl_GlobalInvocationID";
        builder.mockVoidType("%void");
        FunctionType type = builder.mockFunctionType("%func", "%void");
        Function function = new Function("%defined", type, List.of(), 0, null);
        builder.startCurrentFunction(function);
        builder.endCurrentFunction();
        visit(input);

        try {
            // when
            builder.build();
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Cannot build the program, missing function definition '%expected'",
                    e.getMessage());
        }
    }

    @Test
    public void testUnclosedEntryPoint() {
        // given
        String input = "OpEntryPoint GLCompute %main \"main\" %gl_GlobalInvocationID";
        builder.mockVoidType("%void");
        FunctionType type = builder.mockFunctionType("%func", "%void");
        Function function = new Function("%main", type, List.of(), 0, null);
        builder.startCurrentFunction(function);
        visit(input);

        try {
            // when
            builder.build();
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Unclosed definition for function '%main'",
                    e.getMessage());
        }
    }

    @Test
    public void testMissingEntryPoint() {
        // given
        builder.mockVoidType("%void");
        FunctionType type = builder.mockFunctionType("%func", "%void");
        Function function = new Function("%main", type, List.of(), 0, null);
        builder.startCurrentFunction(function);
        builder.endCurrentFunction();

        try {
            // when
            builder.build();
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Cannot build the program, entryPointId is missing",
                    e.getMessage());
        }
    }

    @Test
    public void testMultipleEntryPoints() {
        // given
        String input = """
                OpEntryPoint GLCompute %ep1 "ep1"
                OpEntryPoint GLCompute %ep2 "ep2"
                """;

        try {
            // when
            visit(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Multiple entry points are not supported",
                    e.getMessage());
        }
    }

    private void visit(String text) {
        new MockSpirvParser(text).spv().accept(new VisitorOpsSetting(builder));
    }
}
