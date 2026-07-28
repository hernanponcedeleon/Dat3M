package com.dat3m.dartagnan.litmus;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Method;
import com.dat3m.dartagnan.configuration.Property;
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
import java.util.List;

import static com.dat3m.dartagnan.configuration.Property.CAT_SPEC;
import static com.dat3m.dartagnan.configuration.Property.PROGRAM_SPEC;
import static com.dat3m.dartagnan.utils.ResourceHelper.getRootPath;
import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class VulkanPaperTest {

    private final String oldModel = getRootPath("cat/vulkan.cat");
    private final String oldModelChains = getRootPath("cat/vulkan-chains.cat");
    private final String newModel = getRootPath("cat/vulkan-fixed.cat");
    private final String newModelChains = getRootPath("cat/vulkan-fixed-chains.cat");
    private final String programPath;
    private final List<Result> expectedOldModel;
    private final List<Result> expectedNewModel;

    public VulkanPaperTest(String file, List<Result> expectedOldModel, List<Result> expectedNewModel) {
        this.programPath = getRootPath("litmus/VULKAN/Paper/" + file + ".litmus");
        this.expectedOldModel = expectedOldModel;
        this.expectedNewModel = expectedNewModel;
    }

    @Parameterized.Parameters(name = "{index}: {0}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
                {"figure-1-a", List.of(FAIL, FAIL, PASS, PASS), List.of(FAIL, FAIL, PASS, PASS)},
                {"figure-1-b", List.of(PASS, PASS, FAIL, FAIL), List.of(PASS, PASS, FAIL, FAIL)},
                {"figure-1-c", List.of(FAIL, FAIL, PASS, PASS), List.of(FAIL, FAIL, PASS, PASS)},
                {"figure-2-1", List.of(PASS, PASS, FAIL, FAIL), List.of(PASS, PASS, FAIL, FAIL)},
                {"figure-2-2", List.of(FAIL, FAIL, PASS, PASS), List.of(FAIL, FAIL, PASS, PASS)},
                {"figure-3", List.of(PASS, FAIL, FAIL, PASS), List.of(PASS, FAIL, FAIL, PASS)},
                {"figure-5-a", List.of(FAIL, FAIL, PASS, PASS), List.of(PASS, PASS, PASS, PASS)},
                {"figure-5-b", List.of(PASS, PASS, PASS, PASS), List.of(PASS, PASS, PASS, PASS)},
                {"figure-6-1", List.of(PASS, PASS, FAIL, FAIL), List.of(PASS, PASS, FAIL, FAIL)},
                {"figure-6-2", List.of(FAIL, FAIL, PASS, PASS), List.of(PASS, PASS, FAIL, FAIL)},
                {"figure-7", List.of(FAIL, FAIL, FAIL, FAIL), List.of(FAIL, FAIL, PASS, PASS)},
                {"figure-8", List.of(PASS, PASS, FAIL, FAIL), List.of(PASS, PASS, PASS, PASS)},
                {"figure-9", List.of(PASS, PASS, FAIL, FAIL), List.of(PASS, FAIL, FAIL, PASS)},
                {"figure-10", List.of(PASS, FAIL, FAIL, PASS), List.of(PASS, PASS, FAIL, FAIL)},
                {"figure-12", List.of(FAIL, FAIL, PASS, PASS), List.of(FAIL, FAIL, PASS, PASS)},
                {"figure-14-a", List.of(FAIL, FAIL, PASS, PASS), List.of(PASS, PASS, PASS, PASS)},
                {"figure-14-b", List.of(PASS, PASS, PASS, PASS), List.of(PASS, PASS, PASS, PASS)},
                {"figure-15-1", List.of(PASS, PASS, FAIL, FAIL), List.of(PASS, PASS, FAIL, FAIL)},
                {"figure-15-2", List.of(PASS, FAIL, FAIL, PASS), List.of(PASS, PASS, FAIL, FAIL)},
                {"figure-15-3", List.of(PASS, PASS, FAIL, FAIL), List.of(PASS, PASS, FAIL, FAIL)},
                {"figure-15-4", List.of(PASS, FAIL, FAIL, PASS), List.of(PASS, PASS, FAIL, FAIL)},
                {"figure-16", List.of(FAIL, FAIL, FAIL, FAIL), List.of(FAIL, FAIL, PASS, PASS)},
                {"figure-17-1", List.of(PASS, PASS, FAIL, FAIL), List.of(PASS, PASS, FAIL, FAIL)},
                {"figure-17-2", List.of(PASS, FAIL, FAIL, PASS), List.of(PASS, PASS, FAIL, FAIL)},
        });
    }

    @Test
    public void testOldModel() throws Exception {
        runTest(expectedOldModel.get(0), oldModel, PROGRAM_SPEC);
        runTest(expectedOldModel.get(1), oldModelChains, PROGRAM_SPEC);
        runTest(expectedOldModel.get(2), oldModel, CAT_SPEC);
        runTest(expectedOldModel.get(3), oldModelChains, CAT_SPEC);
    }

    @Test
    public void testNewModel() throws Exception {
        runTest(expectedNewModel.get(0), newModel, PROGRAM_SPEC);
        runTest(expectedNewModel.get(1), newModelChains, PROGRAM_SPEC);
        runTest(expectedNewModel.get(2), newModel, CAT_SPEC);
        runTest(expectedNewModel.get(3), newModelChains, CAT_SPEC);
    }

    private void runTest(Result expected, String modelPath, Property property) throws Exception {
        VerificationTask.VerificationTaskBuilder builder = VerificationTask.builder()
                .withConfig(TestHelper.getBasicConfig())
                .withTarget(Arch.VULKAN);
        Program program = new ProgramParser().parse(new File(programPath));
        Wmm mcm = new ParserCat().parse(new File(modelPath));
        VerificationTask task = builder.build(program, mcm, EnumSet.of(property));
        assertEquals(expected, TestHelper.createAndRunSolver(task, Method.EAGER));
    }
}
