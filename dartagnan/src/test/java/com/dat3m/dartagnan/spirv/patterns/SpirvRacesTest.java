package com.dat3m.dartagnan.spirv.patterns;

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

import static com.dat3m.dartagnan.configuration.OptionNames.IGNORE_FILTER_SPECIFICATION;
import static com.dat3m.dartagnan.configuration.Property.CAT_SPEC;
import static com.dat3m.dartagnan.utils.ResourceHelper.getRootPath;
import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class SpirvRacesTest {

    private final String modelPath = getRootPath("cat/spirv.cat");
    private final String programPath;
    private final boolean filter;
    private final Result expected;

    public SpirvRacesTest(String file, boolean filter, Result expected) {
        this.programPath = getTestResourcePath("spirv/patterns/" + file);
        this.filter = filter;
        this.expected = expected;
    }

    @Parameterized.Parameters(name = "{index}: {0}, {1}, {2}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
                {"CORR.spv.dis", false, PASS},
                {"IRIW.spv.dis", false, PASS},
                {"SB.spv.dis", false, PASS},

                {"MP.spv.dis", false, FAIL},
                {"MP.spv.dis", true, PASS},
                {"MP-acq2rx.spv.dis", false, FAIL},
                {"MP-acq2rx.spv.dis", true, FAIL},
                {"MP-rel2rx.spv.dis", false, FAIL},
                {"MP-rel2rx.spv.dis", true, FAIL},
        });
    }

    @Test
    public void testAllSolvers() throws Exception {
        /* TODO: Very slow, enable when Vulkan memory model is more efficient in CAAT
        try (SolverContext ctx = mkCtx(); ProverWithTracker prover = mkProver(ctx)) {
             assertEquals(expected, RefinementSolver.run(ctx, prover, mkTask()).getResult());
        }*/
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
        Configuration config = Configuration.builder()
                .setOption(IGNORE_FILTER_SPECIFICATION, Boolean.toString(!filter))
                .build();
        VerificationTask.VerificationTaskBuilder builder = VerificationTask.builder()
                .withConfig(config)
                .withTarget(Arch.VULKAN);
        Program program = new ProgramParser().parse(new File(programPath));
        Wmm mcm = new ParserCat().parse(new File(modelPath));
        return builder.build(program, mcm, EnumSet.of(CAT_SPEC));
    }
}