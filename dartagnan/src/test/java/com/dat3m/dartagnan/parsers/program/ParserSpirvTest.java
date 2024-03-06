package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.program.Program;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.junit.Test;

import java.io.FileInputStream;
import java.io.IOException;
import java.nio.file.Paths;

import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static org.junit.Assert.assertNotNull;

public class ParserSpirvTest {

    @Test
    public void testParsingProgram() throws IOException {
        String path = Paths.get(getTestResourcePath("parsers/program/spirv/fibonacci.spv.dis")).toString();
        try (FileInputStream stream = new FileInputStream(path)) {
            CharStream charStream = CharStreams.fromStream(stream);
            ParserSpirv parser = new ParserSpirv();
            Program program = parser.parse(charStream);
            assertNotNull(program);
        }
    }
}
