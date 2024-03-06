package com.dat3m.dartagnan.parsers;

import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockSpirvParser;
import org.antlr.v4.runtime.ParserRuleContext;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;

@RunWith(Parameterized.class)
public class GrammarSpirvTest {

    private static final String PATH = "parsers/program/spirv/";

    private final String filename;

    public GrammarSpirvTest(String filename) {
        this.filename = filename;
    }

    @Parameterized.Parameters(name = "{index}: {0}")
    public static Iterable<Object[]> data() throws IOException {
        String path = Paths.get(getTestResourcePath(PATH)).toString();
        File dir = new File(path);
        File[] files = dir.listFiles();
        assertNotNull(files);
        return Stream.of(files)
                .filter(file -> !file.isDirectory())
                .map(f -> new Object[]{f.getName()})
                .toList();
    }

    @Test
    public void testParsingFile() throws IOException {
        Path path = Paths.get(getTestResourcePath(PATH + filename));
        String input = Files.readString(path, StandardCharsets.UTF_8);
        SpirvParser parser = new MockSpirvParser(input);
        ParserRuleContext parserEntryPoint = parser.spv();
        SpirvBaseVisitor<?> visitor = new SpirvBaseVisitor<>();
        assertNull(parserEntryPoint.accept(visitor));
    }
}
