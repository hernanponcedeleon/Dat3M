package com.dat3m.dartagnan.litmus;

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

import static com.dat3m.dartagnan.configuration.OptionNames.INITIALIZE_REGISTERS;
import static com.dat3m.dartagnan.configuration.OptionNames.USE_INTEGERS;
import static com.dat3m.dartagnan.configuration.Property.PROGRAM_SPEC;
import static com.dat3m.dartagnan.utils.ResourceHelper.getRootPath;
import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class LitmusVulkanTangleTest {

    private final String modelPath = getRootPath("cat/vulkan.cat");
    private final String programPath;
    private final Result expected;

    public LitmusVulkanTangleTest(String file, Result expected) {
        this.programPath = getRootPath("litmus/VULKAN/Tangle/" + file + ".litmus");
        this.expected = expected;
    }

    @Parameterized.Parameters(name = "{index}: {0}, {1}, {2}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
                {"basic-groupAll-all", PASS},
                {"basic-groupAll-none", PASS},
                {"basic-groupAll-some", PASS},
                {"basic-groupAny-all", PASS},
                {"basic-groupAny-none", PASS},
                {"basic-groupAny-some", PASS},
                {"basic-group-ids", PASS},
                {"basic-group-subgroups", PASS},
                {"out-of-thin-air", PASS},
                {"reordering-ww-no-dep", PASS},
                {"reordering-ww-dep", PASS},
                {"reordering-wr-no-dep", PASS},
                {"reordering-wr-dep", PASS},
                {"reordering-rw-no-dep", PASS},
                {"reordering-rw-dep", PASS},
                {"propagation", PASS},
                {"chain-1", PASS},
                {"chain-2", FAIL},
                {"chain-3", FAIL},
                {"branch-1", PASS},
                {"branch-2", PASS},
                {"branch-3", PASS},
                {"loop-1", FAIL},
                {"loop-2", PASS},
                {"loop-3", FAIL},
                {"loop-4", FAIL},
        });
    }

    @Test
    public void test() throws Exception {
        Configuration cfg = Configuration.builder()
                .setOption(INITIALIZE_REGISTERS, "true")
                .setOption(USE_INTEGERS, "true")
                .build();
        try (SolverContext ctx = mkCtx(cfg); ProverWithTracker prover = mkProver(ctx)) {
            assertEquals(expected, AssumeSolver.run(ctx, prover, mkTask(cfg)).getResult());
        }
    }

    private SolverContext mkCtx(Configuration cfg) throws InvalidConfigurationException {
        return SolverContextFactory.createSolverContext(
                cfg,
                BasicLogManager.create(cfg),
                ShutdownManager.create().getNotifier(),
                SolverContextFactory.Solvers.Z3);
    }

    private ProverWithTracker mkProver(SolverContext ctx) {
        return new ProverWithTracker(ctx, "", SolverContext.ProverOptions.GENERATE_MODELS);
    }

    private VerificationTask mkTask(Configuration cfg) throws Exception {
        VerificationTask.VerificationTaskBuilder builder = VerificationTask.builder()
                .withConfig(cfg)
                .withTarget(Arch.VULKAN);
        Program program = new ProgramParser().parse(new File(programPath));
        Wmm mcm = new ParserCat().parse(new File(modelPath));
        return builder.build(program, mcm, EnumSet.of(PROGRAM_SPEC));
    }
}
