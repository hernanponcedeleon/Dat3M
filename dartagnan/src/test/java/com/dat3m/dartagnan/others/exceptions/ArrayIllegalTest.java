package com.dat3m.dartagnan.others.exceptions;

import com.dat3m.dartagnan.parsers.program.ProgramParser;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;

@RunWith(Parameterized.class)
public class ArrayIllegalTest {

    @Parameterized.Parameters(name = "{index}: {0}")
    public static Iterable<Object[]> data() throws IOException {
        try (Stream<Path> fileStream = Files.walk(Paths.get(getTestResourcePath("arrays/error/")))) {
            return fileStream
                    .filter(Files::isRegularFile)
                    .filter(f -> (f.toString().endsWith("litmus")))
                    .map(f -> new Object[]{f.toString()})
                    .collect(Collectors.toList());
        }
    }

    private final String path;

    public ArrayIllegalTest(String path) {
        this.path = path;
    }

    @Test(expected = RuntimeException.class)
    public void test() throws Exception {
        new ProgramParser().parse(new File(path));
    }
}
