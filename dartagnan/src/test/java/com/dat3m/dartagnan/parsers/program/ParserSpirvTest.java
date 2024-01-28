package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.program.Program;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static org.junit.Assert.assertNotNull;

@RunWith(Parameterized.class)
public class ParserSpirvTest {

    private static final String PATH = "parsers/program/spirv/";

    private final String filename;

    public ParserSpirvTest(String filename) {
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
        Program program;
        Path path = Paths.get(getTestResourcePath(PATH + filename));
        try (FileInputStream stream = new FileInputStream(path.toString())) {
            CharStream charStream = CharStreams.fromStream(stream);
            ParserSpirv parser = new ParserSpirv();
            program = parser.parse(charStream);
        }
        assertNotNull(program);
    }
}
