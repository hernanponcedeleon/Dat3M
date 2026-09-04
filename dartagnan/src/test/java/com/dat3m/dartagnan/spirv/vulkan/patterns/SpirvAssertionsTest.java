package com.dat3m.dartagnan.spirv.vulkan.patterns;

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
import org.sosy_lab.common.configuration.Configuration;

import java.nio.file.Path;
import java.io.IOException;
import java.util.Arrays;
import java.util.EnumSet;

import static com.dat3m.dartagnan.configuration.OptionNames.IGNORE_FILTER_SPECIFICATION;
import static com.dat3m.dartagnan.configuration.Property.PROGRAM_SPEC;
import static com.dat3m.dartagnan.utils.ResourceHelper.getRootPath;
import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static com.dat3m.dartagnan.verification.ResultStatus.FAIL;
import static com.dat3m.dartagnan.verification.ResultStatus.PASS;
import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class SpirvAssertionsTest {

    private final Path modelPath = getRootPath("cat/vulkan.cat");
    private final Path programPath;
    private final ResultStatus expected;

    public SpirvAssertionsTest(String file, ResultStatus expected) {
        this.programPath = getTestResourcePath("spirv/vulkan/patterns/" + file);
        this.expected = expected;
    }

    @Parameterized.Parameters(name = "{index}: {0}, {1}, {2}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
                {"corr.spvasm", PASS},
                {"iriw.spvasm", PASS},
                {"mp.spvasm", PASS},
                {"mp-acq2rx.spvasm", FAIL},
                {"mp-rel2rx.spvasm", FAIL},
                {"sb.spvasm", PASS},
        });
    }

    @Test
    public void test() throws Exception {
        assertEquals(expected, TestHelper.createAndRunSolver(mkTask(), Method.EAGER));
    }

    private Task mkTask() throws Exception {
        Task.TaskBuilder builder = Task.builder()
                .withConfig(Configuration.builder()
                        .copyFrom(TestHelper.getBasicConfig())
                        .setOption(IGNORE_FILTER_SPECIFICATION, "true")
                        .build())
                .withTarget(Arch.VULKAN);
        Program program = new ProgramParser().parse(programPath);
        Wmm mcm = new ParserCat().parse(modelPath);
        return builder.build(program, mcm, EnumSet.of(PROGRAM_SPEC));
    }
}
