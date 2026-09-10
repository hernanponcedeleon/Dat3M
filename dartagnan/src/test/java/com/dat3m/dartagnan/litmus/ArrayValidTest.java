package com.dat3m.dartagnan.litmus;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Method;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.VerificationTaskSolver;
import com.dat3m.dartagnan.verification.Task;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.EnumSet;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.utils.Utils.hasExtension;
import static com.dat3m.dartagnan.test.TestHelper.*;
import static com.dat3m.dartagnan.test.ResourceHelper.getRootPath;
import static com.dat3m.dartagnan.test.ResourceHelper.getTestResourcePath;
import static com.dat3m.dartagnan.verification.ResultStatus.PASS;
import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class ArrayValidTest {

    @Parameterized.Parameters(name = "{index}: {0}")
    public static Iterable<Object[]> data() throws IOException {
        Wmm wmm = parseWmm(getRootPath("cat/linux-kernel.cat"));
        try (Stream<Path> fileStream = Files.walk(getTestResourcePath("arrays/ok/"))) {
            return fileStream
                    .filter(Files::isRegularFile)
                    .filter(f -> hasExtension(f, EXTENSION_LITMUS))
                    .map(f -> new Object[]{f, wmm})
                    .collect(Collectors.toList());
        }
    }

    private final Path path;
    private final Wmm wmm;

    public ArrayValidTest(Path path, Wmm wmm) {
        this.path = path;
        this.wmm = wmm;
    }

    @Test
    public void test() throws Exception {
        Program program = parseProgram(path);
        VerificationTask task = Task.builder()
                .withSolverTimeout(60)
                .withTarget(Arch.LKMM)
                .build(program, wmm, EnumSet.of(Property.PROGRAM_SPEC));

        try (VerificationTaskSolver solver = VerificationTaskSolver.createWithMethod(task, Method.EAGER)) {
            solver.run();
            assertEquals(PASS, solver.getResult().getStatus());
        }
    }
}
