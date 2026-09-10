package com.dat3m.dartagnan.exception;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.utils.Utils.hasExtension;
import static com.dat3m.dartagnan.test.ResourceHelper.getTestResourcePath;
import static com.dat3m.dartagnan.test.TestHelper.EXTENSION_LITMUS;
import static com.dat3m.dartagnan.test.TestHelper.parseProgram;

@RunWith(Parameterized.class)
public class ArrayIllegalTest {

    @Parameterized.Parameters(name = "{index}: {0}")
    public static Iterable<Object[]> data() throws IOException {
        try (Stream<Path> fileStream = Files.walk(getTestResourcePath("arrays/error/"))) {
            return fileStream
                    .filter(Files::isRegularFile)
                    .filter(f -> hasExtension(f, EXTENSION_LITMUS))
                    .map(f -> new Object[]{f})
                    .collect(Collectors.toList());
        }
    }

    private final Path path;

    public ArrayIllegalTest(Path path) {
        this.path = path;
    }

    @Test(expected = ParsingException.class)
    public void test() throws Exception {
        parseProgram(path);
    }
}
