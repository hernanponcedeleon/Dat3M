package com.dat3m.dartagnan.litmus;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Method;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.verification.ResultStatus;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.VerificationTaskSolver;
import com.dat3m.dartagnan.verification.Task;
import com.dat3m.dartagnan.wmm.Wmm;
import com.google.common.collect.ImmutableMap;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.EnumSet;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.utils.Utils.hasExtension;
import static com.dat3m.dartagnan.test.TestHelper.*;
import static com.dat3m.dartagnan.test.ResourceHelper.getRootPath;
import static com.dat3m.dartagnan.test.ResourceHelper.getTestResourcePath;
import static com.dat3m.dartagnan.verification.ResultStatus.FAIL;
import static com.dat3m.dartagnan.verification.ResultStatus.PASS;
import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class BranchTest {

    @Parameterized.Parameters(name = "{index}: {0}")
    public static Iterable<Object[]> data() throws IOException {
        ImmutableMap<String, ResultStatus> expected = readExpectedResults();

        Wmm linuxWmm = parseWmm(getRootPath("cat/linux-kernel.cat"));
        Wmm aarch64Wmm = parseWmm(getRootPath("cat/aarch64.cat"));

        List<Object[]> data;
        try (Stream<Path> fileStream = Files.walk(getTestResourcePath("branch/C/"))) {
            data = fileStream
                    .filter(Files::isRegularFile)
                    .filter(f -> hasExtension(f, EXTENSION_LITMUS))
                    .map(f -> new Object[]{f, expected.get(f.getFileName().toString()), linuxWmm})
                    .collect(Collectors.toList());
        }

        try (Stream<Path> fileStream = Files.walk(getTestResourcePath("branch/AARCH64/"))) {
            data.addAll(fileStream.
                    filter(Files::isRegularFile)
                    .filter(f -> hasExtension(f, EXTENSION_LITMUS))
                    .map(f -> new Object[]{f, expected.get(f.getFileName().toString()), aarch64Wmm})
                    .toList());
        }

        return data;
    }

    private static ImmutableMap<String, ResultStatus> readExpectedResults() throws IOException {
        ImmutableMap.Builder<String, ResultStatus> builder;
        try (var reader = Files.newBufferedReader(getTestResourcePath("branch/expected.csv"))) {
            builder = new ImmutableMap.Builder<>();
            String str;
            while ((str = reader.readLine()) != null) {
                String[] line = str.split(",");
                if (line.length == 2) {
                    builder.put(line[0], Integer.parseInt(line[1]) == 1 ? PASS : FAIL);
                }
            }
        }
        return builder.build();
    }

    private final Path path;
    private final Wmm wmm;
    private final ResultStatus expected;

    public BranchTest(Path path, ResultStatus expected, Wmm wmm) {
        this.path = path;
        this.expected = expected;
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
            assertEquals(expected, solver.getResult().getStatus());
        }
    }
}
