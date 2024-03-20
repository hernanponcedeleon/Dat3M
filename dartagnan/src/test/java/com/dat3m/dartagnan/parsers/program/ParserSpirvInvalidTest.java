package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.exception.ParsingException;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.FileInputStream;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.Arrays;

import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static org.junit.Assert.*;

@RunWith(Parameterized.class)
public class ParserSpirvInvalidTest {

    private final String file;
    private final String error;

    public ParserSpirvInvalidTest(String file, String error) {
        this.file = file;
        this.error = error;
    }

    @Parameterized.Parameters(name = "{index}: {0}, {1}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
                {"malformed-selection-merge-label.spv.dis", "Unexpected operation 'OpLogicalNot'"},
                {"malformed-selection-merge.spv.dis", "Unexpected operation 'OpLogicalNot'"},
                {"malformed-loop-merge.spv.dis", "Unexpected operation 'OpLogicalNot'"},
                {"malformed-loop-merge-true-label.spv.dis", "Unexpected operation 'OpLogicalNot'"}
        });
    }

    @Test
    public void testParsingProgram() throws IOException {
        String path = Paths.get(getTestResourcePath("parsers/program/spirv/invalid/" + file)).toString();
        try (FileInputStream stream = new FileInputStream(path)) {
            CharStream charStream = CharStreams.fromStream(stream);
            ParserSpirv parser = new ParserSpirv();
            try {
                parser.parse(charStream);
                fail("Should throw exception");
            } catch (ParsingException e) {
                assertEquals(error, e.getMessage());
            }
        }
    }
}
