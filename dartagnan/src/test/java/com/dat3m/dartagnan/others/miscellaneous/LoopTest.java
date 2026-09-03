package com.dat3m.dartagnan.others.miscellaneous;

import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.processing.LoopUnrolling;
import com.dat3m.dartagnan.program.processing.compilation.Compilation;
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
public class LoopTest {

    @Parameterized.Parameters(name = "{index}: {0}")
    public static Iterable<Object[]> data() throws IOException {
        try (Stream<Path> fileStream = Files.walk(getTestResourcePath("loops/"))) {
            return fileStream
                    .filter(Files::isRegularFile)
                    .filter(f -> getFileExtension(f).equals("litmus"))
                    .map(f -> new Object[]{f})
                    .collect(Collectors.toList());
        }
    }

    private final Path path;

    public LoopTest(Path path) {
        this.path = path;
    }

    @Test
    public void test() throws Exception {
        Program p = new ProgramParser().parse(path);
        Compilation.newInstance().run(p);
        LoopUnrolling.newInstance().run(p);
    }
}
