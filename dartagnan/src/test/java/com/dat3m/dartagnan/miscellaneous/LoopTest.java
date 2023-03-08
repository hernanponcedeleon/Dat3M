package com.dat3m.dartagnan.miscellaneous;

import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.processing.LoopUnrolling;
import com.dat3m.dartagnan.program.processing.compilation.Compilation;
import com.dat3m.dartagnan.utils.ResourceHelper;
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

@RunWith(Parameterized.class)
public class LoopTest {

    @Parameterized.Parameters(name = "{index}: {0}")
    public static Iterable<Object[]> data() throws IOException {
        try (Stream<Path> fileStream = Files.walk(Paths.get(ResourceHelper.TEST_RESOURCE_PATH + "loops/"))) {
            return fileStream
                    .filter(Files::isRegularFile)
                    .filter(f -> (f.toString().endsWith("litmus")))
                    .map(f -> new Object[]{f.toString()})
                    .collect(Collectors.toList());
        }
    }

    private final String path;

    public LoopTest(String path) {
        this.path = path;
    }

    @Test
    public void test() throws Exception {
        Program p = new ProgramParser().parse(new File(path));
        Compilation.newInstance().run(p);
        LoopUnrolling.newInstance().run(p);
    }
}
