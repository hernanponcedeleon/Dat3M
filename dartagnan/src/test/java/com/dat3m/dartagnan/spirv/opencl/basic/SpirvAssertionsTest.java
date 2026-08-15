package com.dat3m.dartagnan.spirv.opencl.basic;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Method;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.verification.ResultStatus;
import com.dat3m.dartagnan.utils.TestHelper;
import com.dat3m.dartagnan.verification.Task;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.nio.file.Path;
import java.io.IOException;
import java.util.Arrays;
import java.util.EnumSet;

import static com.dat3m.dartagnan.configuration.Property.PROGRAM_SPEC;
import static com.dat3m.dartagnan.utils.ResourceHelper.getRootPath;
import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static com.dat3m.dartagnan.verification.ResultStatus.PASS;
import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class SpirvAssertionsTest {

    private final Path modelPath = getRootPath("cat/opencl.cat");
    private final Path programPath;
    private final int bound;
    private final ResultStatus expected;

    public SpirvAssertionsTest(String file, int bound, ResultStatus expected) {
        this.programPath = getTestResourcePath("spirv/opencl/basic/" + file);
        this.bound = bound;
        this.expected = expected;
    }

    @Parameterized.Parameters(name = "{index}: {0}, {1}, {2}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
                {"idx-overflow.spvasm", 1, PASS},
        });
    }

    @Test
    public void test() throws Exception {
        assertEquals(expected, TestHelper.createAndRunSolver(mkTask(), Method.EAGER));
    }


    private Task mkTask() throws Exception {
        Task.TaskBuilder builder = Task.builder()
                .withConfig(TestHelper.getBasicConfig())
                .withBound(bound)
                .withTarget(Arch.OPENCL);
        Program program = new ProgramParser().parse(programPath);
        Wmm mcm = new ParserCat().parse(modelPath);
        return builder.build(program, mcm, EnumSet.of(PROGRAM_SPEC));
    }
}
