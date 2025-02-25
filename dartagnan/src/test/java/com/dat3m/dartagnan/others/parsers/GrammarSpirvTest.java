package com.dat3m.dartagnan.others.parsers;

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
        return listFiles(Paths.get(getTestResourcePath("spirv")));
    }

    private static List<Object[]> listFiles(Path path) throws IOException {
        List<Object[]> result = new LinkedList<>();
        try (DirectoryStream<Path> files = Files.newDirectoryStream(path)) {
            for (Path file : files) {
                if (Files.isDirectory(file)) {
                    result.addAll(listFiles(file));
                } else {
                    result.add(new Object[]{file.toAbsolutePath().toString()});
                }
            }
        }
        return result;
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
