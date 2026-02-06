package com.dat3m.dartagnan.spirv.opencl.alignment;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Method;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.TestHelper;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.EnumSet;

import static com.dat3m.dartagnan.configuration.Property.PROGRAM_SPEC;
import static com.dat3m.dartagnan.utils.ResourceHelper.getRootPath;
import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class SpirvAssertionsTest {

    private final String modelPath = getRootPath("cat/opencl.cat");
    private final String programPath;
    private final int bound;
    private final Result expected;

    public SpirvAssertionsTest(String file, int bound, Result expected) {
        this.programPath = getTestResourcePath("spirv/opencl/alignment/" + file);
        this.bound = bound;
        this.expected = expected;
    }

    @Parameterized.Parameters(name = "{index}: {0}, {1}, {2}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
                {"alignment1-array-global.spvasm", 9, PASS},
                {"alignment1-array-local.spvasm", 9, PASS},
                {"alignment1-array-pointer.spvasm", 9, PASS},
                {"alignment1-struct-global.spvasm", 9, PASS},
                {"alignment1-struct-local.spvasm", 9, PASS},
                {"alignment1-struct-pointer.spvasm", 9, PASS},
                {"alignment2-struct-global.spvasm", 17, PASS},
                {"alignment2-struct-local.spvasm", 17, PASS},
                {"alignment2-struct-pointer.spvasm", 17, PASS},
                {"alignment3-struct-global.spvasm", 9, PASS},
                {"alignment3-struct-local.spvasm", 9, PASS},
                {"alignment3-struct-pointer.spvasm", 9, PASS},
                {"alignment4-struct-global.spvasm", 25, PASS},
                {"alignment4-struct-local.spvasm", 25, PASS},
                {"alignment4-struct-pointer.spvasm", 25, PASS},
                {"alignment5-struct-global.spvasm", 17, PASS},
                {"alignment5-struct-local.spvasm", 17, PASS},
                {"alignment5-struct-pointer.spvasm", 17, PASS},
        });
    }

    @Test
    public void test() throws Exception {
        assertEquals(expected, TestHelper.createAndRunModelChecker(mkTask(), Method.EAGER));
    }

    private VerificationTask mkTask() throws Exception {
        VerificationTask.VerificationTaskBuilder builder = VerificationTask.builder()
                .withConfig(TestHelper.getBasicConfig())
                .withBound(bound)
                .withTarget(Arch.OPENCL);
        Program program = new ProgramParser().parse(new File(programPath));
        Wmm mcm = new ParserCat().parse(new File(modelPath));
        return builder.build(program, mcm, EnumSet.of(PROGRAM_SPEC));
    }
}
