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
        String path = Paths.get(getTestResourcePath("parsers/program/spirv/valid/fibonacci.spv.dis")).toString();
        try (FileInputStream stream = new FileInputStream(path)) {
            CharStream charStream = CharStreams.fromStream(stream);
            ParserSpirv parser = new ParserSpirv();
            Program program = parser.parse(charStream);
            assertNotNull(program);
        }
    }

    @Test
    public void testParsingInvalidProgram() throws IOException {
        doTestParsingInvalidProgram("malformed-selection-merge-label.spv.dis");
        doTestParsingInvalidProgram("malformed-selection-merge.spv.dis");
        doTestParsingInvalidProgram("malformed-loop-merge.spv.dis");
        doTestParsingInvalidProgram("malformed-loop-merge-true-label.spv.dis");
    }

    private void doTestParsingInvalidProgram(String file) throws IOException {
        String path = Paths.get(getTestResourcePath("parsers/program/spirv/invalid/" + file)).toString();
        try (FileInputStream stream = new FileInputStream(path)) {
            CharStream charStream = CharStreams.fromStream(stream);
            ParserSpirv parser = new ParserSpirv();
            try {
                parser.parse(charStream);
                fail("Should throw exception");
            } catch (ParsingException e) {
                assertEquals("Unexpected operation 'OpLogicalNot'", e.getMessage());
            }
        }
    }
}
