package com.dat3m.dartagnan.others.exceptions;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.utils.Utils.getFileExtension;
import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;

@RunWith(Parameterized.class)
public class ArrayIllegalTest {

    @Parameterized.Parameters(name = "{index}: {0}")
    public static Iterable<Object[]> data() throws IOException {
        try (Stream<Path> fileStream = Files.walk(getTestResourcePath("arrays/error/"))) {
            return fileStream
                    .filter(Files::isRegularFile)
                    .filter(f -> getFileExtension(f).equals("litmus"))
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
        new ProgramParser().parse(path);
    }
}
