package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.program.Program;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.junit.Test;

import java.io.FileInputStream;
import java.io.IOException;
import java.nio.file.Paths;

import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static org.junit.Assert.*;

public class ParserSpirvTest {

    @Test
    public void testParsingProgram() throws IOException {
        doTestParsingValidProgram("fibonacci.spv.dis");
        doTestParsingValidProgram("mp-memory-operands.spv.dis");
    }

    @Test
    public void testInvalidControlFlow() throws IOException {
        String error = "Unexpected operation 'OpLogicalNot'";
        doTestParsingInvalidProgram("control-flow/malformed-selection-merge-label.spv.dis", error);
        doTestParsingInvalidProgram("control-flow/malformed-selection-merge.spv.dis", error);
        doTestParsingInvalidProgram("control-flow/malformed-loop-merge.spv.dis", error);
        doTestParsingInvalidProgram("control-flow/malformed-loop-merge-true-label.spv.dis", error);
    }

    @Test
    public void testInvalidMemoryOperands() throws IOException {
        doTestParsingInvalidProgram("memory-operands/illegal-parameter-order-1.spv.dis", null);
        doTestParsingInvalidProgram("memory-operands/illegal-parameter-order-2.spv.dis", null);
        doTestParsingInvalidProgram("memory-operands/missing-alignment.spv.dis", null);
        doTestParsingInvalidProgram("memory-operands/missing-scope-1.spv.dis", null);
        doTestParsingInvalidProgram("memory-operands/missing-scope-2.spv.dis", null);
        doTestParsingInvalidProgram("memory-operands/unnecessary-alignment-1.spv.dis", null);
        doTestParsingInvalidProgram("memory-operands/unnecessary-alignment-2.spv.dis", null);
        doTestParsingInvalidProgram("memory-operands/unnecessary-alignment-3.spv.dis", null);
        doTestParsingInvalidProgram("memory-operands/unnecessary-scope-1.spv.dis", null);
        doTestParsingInvalidProgram("memory-operands/unnecessary-scope-2.spv.dis", null);
    }

    private void doTestParsingValidProgram(String file) throws IOException {
        String path = Paths.get(getTestResourcePath("parsers/program/spirv/valid/" + file)).toString();
        try (FileInputStream stream = new FileInputStream(path)) {
            CharStream charStream = CharStreams.fromStream(stream);
            ParserSpirv parser = new ParserSpirv();
            Program program = parser.parse(charStream);
            assertNotNull(program);
        }
    }

    private void doTestParsingInvalidProgram(String file, String error) throws IOException {
        String path = Paths.get(getTestResourcePath("parsers/program/spirv/invalid/" + file)).toString();
        try (FileInputStream stream = new FileInputStream(path)) {
            CharStream charStream = CharStreams.fromStream(stream);
            ParserSpirv parser = new ParserSpirv();
            try {
                parser.parse(charStream);
                fail("Should throw exception");
            } catch (ParsingException e) {
                if (error != null) {
                    assertEquals(error, e.getMessage());
                }
            }
        }
    }
}
