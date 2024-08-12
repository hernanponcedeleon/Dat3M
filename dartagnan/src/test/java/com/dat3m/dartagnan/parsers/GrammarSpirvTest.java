package com.dat3m.dartagnan.parsers;

import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockSpirvParser;
import org.antlr.v4.runtime.ParserRuleContext;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.LinkedList;
import java.util.List;

import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static org.junit.Assert.assertNull;

@RunWith(Parameterized.class)
public class GrammarSpirvTest {

    private final String filename;

    public GrammarSpirvTest(String filename) {
        this.filename = filename;
    }

    @Parameterized.Parameters(name = "{index}: {0}")
    public static Iterable<Object[]> data() throws IOException {
        List<Object[]> data = new LinkedList<>();
        listFiles(Paths.get(getTestResourcePath("parsers/program/spirv")), data);
        listFiles(Paths.get(getTestResourcePath("spirv")), data);
        return data;
    }

    private static void listFiles(Path path, List<Object[]> result) throws IOException {
        try (DirectoryStream<Path> files = Files.newDirectoryStream(path)) {
            for (Path file : files) {
                if (Files.isDirectory(file)) {
                    listFiles(file, result);
                } else {
                    result.add(new Object[]{file.toAbsolutePath().toString()});
                }
            }
        }
    }

    @Test
    public void testParsingFile() throws IOException {
        Path path = Paths.get(filename);
        String input = Files.readString(path, StandardCharsets.UTF_8);
        SpirvParser parser = new MockSpirvParser(input);
        ParserRuleContext parserEntryPoint = parser.spv();
        SpirvBaseVisitor<?> visitor = new SpirvBaseVisitor<>();
        assertNull(parserEntryPoint.accept(visitor));
    }
}
