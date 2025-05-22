package com.dat3m.dartagnan.spirv.vulkan.alignment;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.encoding.ProverWithTracker;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.solving.AssumeSolver;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.sosy_lab.common.ShutdownManager;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.log.BasicLogManager;
import org.sosy_lab.java_smt.SolverContextFactory;
import org.sosy_lab.java_smt.api.SolverContext;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.EnumSet;

import static com.dat3m.dartagnan.configuration.Property.PROGRAM_SPEC;
import static com.dat3m.dartagnan.utils.ResourceHelper.getRootPath;
import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static com.dat3m.dartagnan.utils.Result.*;
import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class SpirvAssertionsTest {

    private final String modelPath = getRootPath("cat/spirv.cat");
    private final String programPath;
    private final int bound;
    private final Result expected;

    public SpirvAssertionsTest(String file, int bound, Result expected) {
        this.programPath = getTestResourcePath("spirv/vulkan/alignment/" + file);
        this.bound = bound;
        this.expected = expected;
    }

    @Parameterized.Parameters(name = "{index}: {0}, {1}, {2}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
                // Compiler changes type to match alignment
                {"alignment1-array-local.spvasm", 9, PASS},
                {"alignment1-array-pointer.spvasm", 9, PASS},
                {"alignment1-struct-local.spvasm", 9, PASS},
                {"alignment1-struct-pointer.spvasm", 9, PASS},
                {"alignment2-struct-local.spvasm", 17, PASS},
                {"alignment2-struct-pointer.spvasm", 17, PASS},
                {"alignment3-struct-local.spvasm", 9, PASS},
                {"alignment3-struct-pointer.spvasm", 9, PASS},
                {"alignment4-struct-local.spvasm", 25, PASS},
                {"alignment4-struct-pointer.spvasm", 25, PASS},
                {"alignment5-struct-local.spvasm", 17, PASS},
                {"alignment5-struct-pointer.spvasm", 17, PASS},

                // Manual tests with stride greater than element size
                {"array-stride-array-initializer.spvasm", 9, PASS},
                {"array-stride-array-input.spvasm", 9, PASS},
                {"array-stride-array-overwrite-scalar.spvasm", 9, PASS},
                {"array-stride-array-overwrite-vector.spvasm", 9, PASS},
                {"array-stride-runtime-array-input.spvasm", 9, PASS},
                {"array-stride-runtime-array-overwrite-scalar.spvasm", 9, PASS},
                {"array-stride-runtime-array-overwrite-vector.spvasm", 9, PASS},
                {"pointer-stride-array-overwrite-scalar.spvasm", 9, PASS},
                {"pointer-stride-array-overwrite-vector.spvasm", 9, PASS},
                {"stride-scalar-overwrite-result-no-stride.spvasm", 17, PASS},
                {"stride-scalar-overwrite-result-stride.spvasm", 17, PASS},
                {"stride-vector-overwrite-result-no-stride.spvasm", 17, PASS},
                {"stride-vector-overwrite-result-stride.spvasm", 17, PASS},
        });
    }

    @Test
    public void test() throws Exception {
        try (SolverContext ctx = mkCtx(); ProverWithTracker prover = mkProver(ctx)) {
            assertEquals(expected, AssumeSolver.run(ctx, prover, mkTask()).getResult());
        }
    }

    private SolverContext mkCtx() throws InvalidConfigurationException {
        Configuration cfg = Configuration.builder().build();
        return SolverContextFactory.createSolverContext(
                cfg,
                BasicLogManager.create(cfg),
                ShutdownManager.create().getNotifier(),
                SolverContextFactory.Solvers.Z3);
    }

    private ProverWithTracker mkProver(SolverContext ctx) {
        return new ProverWithTracker(ctx, "", SolverContext.ProverOptions.GENERATE_MODELS);
    }

    private VerificationTask mkTask() throws Exception {
        VerificationTask.VerificationTaskBuilder builder = VerificationTask.builder()
                .withConfig(Configuration.builder().build())
                .withBound(bound)
                .withTarget(Arch.VULKAN);
        Program program = new ProgramParser().parse(new File(programPath));
        Wmm mcm = new ParserCat().parse(new File(modelPath));
        return builder.build(program, mcm, EnumSet.of(PROGRAM_SPEC));
    }
}
