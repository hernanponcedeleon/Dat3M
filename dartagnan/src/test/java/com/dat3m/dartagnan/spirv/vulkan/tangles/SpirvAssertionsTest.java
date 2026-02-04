package com.dat3m.dartagnan.spirv.vulkan.tangles;

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
import org.sosy_lab.common.configuration.Configuration;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.EnumSet;

import static com.dat3m.dartagnan.configuration.OptionNames.IGNORE_FILTER_SPECIFICATION;
import static com.dat3m.dartagnan.configuration.Property.PROGRAM_SPEC;
import static com.dat3m.dartagnan.utils.ResourceHelper.getRootPath;
import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class SpirvAssertionsTest {

    private final String modelPath = getRootPath("cat/vulkan.cat");
    private final String programPath;
    private final int bound;
    private final Result expected;

    public SpirvAssertionsTest(String file, int bound, Result expected) {
        this.programPath = getTestResourcePath("spirv/vulkan/tangles/" + file);
        this.bound = bound;
        this.expected = expected;
    }

    @Parameterized.Parameters(name = "{index}: {0}, {1}, {2}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
                {"basic-NonUniformArithmetic.spvasm", 1, PASS},
                {"basic-NonUniformBallot.spvasm", 1, PASS},
                {"basic-NonUniformShuffle.spvasm", 1, PASS},
                {"simt-step-fig4.spvasm", 4, FAIL},
                {"simt-step-fig10-dep.spvasm", 1, FAIL},
                {"simt-step-fig10-iadd-barrier.spvasm", 1, PASS},
                {"simt-step-fig10-iadd-trans.spvasm", 1, FAIL},
                {"simt-step-fig10-iadd.spvasm", 1, FAIL},
                {"simt-step-fig10-inc-barrier.spvasm", 1, PASS},
                {"simt-step-fig10.spvasm", 1, FAIL},
                {"simt-step-fig11.spvasm", 1, FAIL},
                {"basic-groupAll-all.spvasm", 1, PASS},
                {"basic-groupAll-none.spvasm", 1, PASS},
                {"basic-groupAll-some.spvasm", 1, PASS},
                {"basic-groupAny-all.spvasm", 1, PASS},
                {"basic-groupAny-none.spvasm", 1, PASS},
                {"basic-groupAny-some.spvasm", 1, PASS},
                {"basic-group-ids.spvasm", 1, PASS},
                {"basic-group-subgroups.spvasm", 1, PASS},
                {"branch-1.spvasm", 1, PASS},
                {"branch-2.spvasm", 1, PASS},
                {"branch-3.spvasm", 1, PASS},
                {"chain-1.spvasm", 1, PASS},
                {"chain-2.spvasm", 1, FAIL}, // Should be PASS unless dep prevents reordering
                {"chain-3.spvasm", 1, FAIL}, // Should be PASS unless dep prevents reordering
                {"loop-1.spvasm", 1, FAIL},
                {"loop-2.spvasm", 1, PASS},
                {"loop-3.spvasm", 1, FAIL}, // Should be PASS unless dep prevents reordering
                {"loop-4.spvasm", 1, FAIL},
                {"oota.spvasm", 1, PASS}, // I think we should allow OOTA
                {"propagation.spvasm", 1, PASS}, // Should be FAIL unless dep prevents reordering
                {"reordering-rw-dep.spvasm", 1, PASS}, // Should be FAIL unless dep prevents reordering
                {"reordering-rw-no-dep.spvasm", 1, PASS},
                {"reordering-wr-dep.spvasm", 1, PASS}, // Should be FAIL unless dep prevents reordering
                {"reordering-wr-no-dep.spvasm", 1, PASS},
                {"reordering-ww-dep.spvasm", 1, PASS}, // Should be FAIL unless dep prevents reordering
                {"reordering-ww-no-dep.spvasm", 1, PASS},
        });
    }

    @Test
    public void test() throws Exception {
        assertEquals(expected, TestHelper.createAndRunModelChecker(mkTask(), Method.EAGER));
    }

    private VerificationTask mkTask() throws Exception {
        VerificationTask.VerificationTaskBuilder builder = VerificationTask.builder()
                .withConfig(Configuration.builder()
                        .copyFrom(TestHelper.getBasicConfig())
                        .setOption(IGNORE_FILTER_SPECIFICATION, "true")
                        .build())
                .withTarget(Arch.VULKAN);
        Program program = new ProgramParser().parse(new File(programPath));
        Wmm mcm = new ParserCat().parse(new File(modelPath));
        return builder.build(program, mcm, EnumSet.of(PROGRAM_SPEC));
    }
}
