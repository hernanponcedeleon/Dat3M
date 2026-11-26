package com.dat3m.dartagnan.litmus;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.OptionNames;
import com.dat3m.dartagnan.configuration.ProgressModel;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.task.Task;
import com.dat3m.dartagnan.task.verification.VerificationStatus;
import com.dat3m.dartagnan.task.verification.VerificationTask;
import com.dat3m.dartagnan.task.verification.VerificationTaskSolver;
import com.dat3m.dartagnan.test.TestHelper;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.sosy_lab.java_smt.SolverContextFactory;

import java.io.IOException;
import java.nio.file.Path;
import java.util.Arrays;
import java.util.EnumSet;
import java.util.List;

import static com.dat3m.dartagnan.configuration.Method.EAGER;
import static com.dat3m.dartagnan.configuration.OptionNames.INITIALIZE_REGISTERS;
import static com.dat3m.dartagnan.configuration.Property.CAT_SPEC;
import static com.dat3m.dartagnan.configuration.Property.PROGRAM_SPEC;
import static com.dat3m.dartagnan.task.verification.VerificationStatus.*;
import static com.dat3m.dartagnan.test.ResourceHelper.getRootPath;
import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class VulkanPaperTest {

    private final Path oldModel = getRootPath("cat/vulkan.cat");
    private final Path oldModelChains = getRootPath("cat/vulkan-chains.cat");
    private final Path newModel = getRootPath("cat/vulkan-new.cat");
    private final Path newModelChains = getRootPath("cat/vulkan-new-chains.cat");
    private final Path programPath;
    private final List<VerificationStatus> expectedOldModel;
    private final List<VerificationStatus> expectedNewModel;

    public VulkanPaperTest(String file, List<VerificationStatus> expectedOldModel, List<VerificationStatus> expectedNewModel) {
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

    private void runTest(VerificationStatus expected, Path modelPath, Property property) throws Exception {
        Task.TaskBuilder builder = Task.builder()
                .withSolver(SolverContextFactory.Solvers.Z3)
                .withTarget(Arch.VULKAN)
                .withProgressModel(ProgressModel.defaultHierarchy())
                .withOption(OptionNames.PHANTOM_REFERENCES, "true")
                .withOption(INITIALIZE_REGISTERS, "true");

        Program program = TestHelper.parseProgram(programPath);
        Wmm model = TestHelper.parseWmm(modelPath);
        VerificationTask task = builder.build(program, model, EnumSet.of(property));

        try (VerificationTaskSolver solver = VerificationTaskSolver.createWithMethod(task, EAGER)) {
            solver.run();
            assertEquals(expected, solver.getResult().getStatus());
        }
    }
}
