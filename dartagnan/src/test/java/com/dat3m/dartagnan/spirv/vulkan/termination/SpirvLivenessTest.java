package com.dat3m.dartagnan.spirv.vulkan.termination;

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
import com.dat3m.dartagnan.configuration.ProgressModel;
import com.dat3m.dartagnan.program.event.Tag;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.EnumSet;
import java.util.Map;

import static com.dat3m.dartagnan.configuration.Property.TERMINATION;
import static com.dat3m.dartagnan.utils.ResourceHelper.getRootPath;
import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class SpirvLivenessTest {

    private final String modelPath = getRootPath("cat/spirv.cat");
    private final String programPath;
    private final int bound;
    private final ProgressModel.Hierarchy progressModel;
    private final Result expected;

    public SpirvLivenessTest(String file, int bound, ProgressModel.Hierarchy progressModel, Result expected) {
        this.programPath = getTestResourcePath("spirv/vulkan/termination/" + file);
        this.bound = bound;
        this.progressModel = progressModel;
        this.expected = expected;
    }

    @Parameterized.Parameters(name = "{index}: {0}, {1}, {2}")
    public static Iterable<Object[]> data() throws IOException {

        ProgressModel.Hierarchy fairUniform = ProgressModel.uniform(ProgressModel.FAIR);
        ProgressModel.Hierarchy qfObe = ProgressModel.scoped(ProgressModel.FAIR, Map.of(
                                                Tag.Vulkan.QUEUE_FAMILY, ProgressModel.OBE));
        ProgressModel.Hierarchy qfObeSgUnfair = ProgressModel.scoped(ProgressModel.FAIR, Map.of(
                                                        Tag.Vulkan.QUEUE_FAMILY, ProgressModel.OBE,
                                                        Tag.Vulkan.SUB_GROUP, ProgressModel.UNFAIR));
        ProgressModel.Hierarchy qfObeSgObe = ProgressModel.scoped(ProgressModel.FAIR, Map.of(
                                                    Tag.Vulkan.QUEUE_FAMILY, ProgressModel.OBE,
                                                    Tag.Vulkan.SUB_GROUP, ProgressModel.OBE));
        ProgressModel.Hierarchy qfObeSgHsa = ProgressModel.scoped(ProgressModel.FAIR, Map.of(
                                                    Tag.Vulkan.QUEUE_FAMILY, ProgressModel.OBE,
                                                    Tag.Vulkan.SUB_GROUP, ProgressModel.HSA));
        ProgressModel.Hierarchy qfHsa = ProgressModel.scoped(ProgressModel.FAIR, Map.of(
                                                Tag.Vulkan.QUEUE_FAMILY, ProgressModel.HSA));
        ProgressModel.Hierarchy qfHsaSgUnfair = ProgressModel.scoped(ProgressModel.FAIR, Map.of(
                                                        Tag.Vulkan.QUEUE_FAMILY, ProgressModel.HSA,
                                                        Tag.Vulkan.SUB_GROUP, ProgressModel.UNFAIR));
        ProgressModel.Hierarchy qfHsaSgHsa = ProgressModel.scoped(ProgressModel.FAIR, Map.of(
                                                    Tag.Vulkan.QUEUE_FAMILY, ProgressModel.HSA,
                                                    Tag.Vulkan.SUB_GROUP, ProgressModel.HSA));
        ProgressModel.Hierarchy qfHsaSgObe = ProgressModel.scoped(ProgressModel.FAIR, Map.of(
                                                    Tag.Vulkan.QUEUE_FAMILY, ProgressModel.HSA,
                                                    Tag.Vulkan.SUB_GROUP, ProgressModel.OBE));

        return Arrays.asList(new Object[][]{
                {"non-uniform-barrier-1.spv.dis", 1, fairUniform, PASS},
                {"non-uniform-barrier-2.spv.dis", 1, fairUniform, FAIL},
                {"mp-groupID.spv.dis", 1, fairUniform, PASS},
                {"mp-groupID.spv.dis", 1, qfObe, FAIL},
                {"mp-groupID.spv.dis", 1, qfHsa, PASS},
                {"mp-groupID.spv.dis", 1, qfHsaSgUnfair, PASS},
                {"mp-atomicAdd-groupID.spv.dis", 1, fairUniform, PASS},
                {"mp-atomicAdd-groupID.spv.dis", 1, qfObe, PASS},
                {"mp-atomicAdd-groupID.spv.dis", 1, qfObeSgUnfair, PASS},
                {"mp-atomicAdd-groupID.spv.dis", 1, qfHsa, FAIL},
                {"mp-wg_obe-t_obe.spv.dis", 1, qfObeSgObe, PASS},
                {"mp-wg_obe-t_obe.spv.dis", 1, qfObeSgHsa, FAIL},
                {"mp-wg_obe-t_obe.spv.dis", 1, qfHsa, FAIL},
                {"mp-wg_obe-t_hsa.spv.dis", 1, qfObeSgHsa, PASS},
                {"mp-wg_obe-t_hsa.spv.dis", 1, qfObeSgObe, PASS},
                {"mp-wg_obe-t_hsa.spv.dis", 1, qfObeSgUnfair, FAIL},
                {"mp-wg_obe-t_hsa.spv.dis", 1, qfHsa, FAIL},
                {"mp-wg_hsa-t_obe.spv.dis", 1, qfHsaSgObe, PASS},
                {"mp-wg_hsa-t_obe.spv.dis", 1, qfHsaSgHsa, FAIL},
                {"mp-wg_hsa-t_obe.spv.dis", 1, qfObe, FAIL},
                {"mp-wg_hsa-t_hsa.spv.dis", 1, qfHsaSgHsa, PASS},
                {"mp-wg_hsa-t_hsa.spv.dis", 1, qfHsaSgObe, FAIL},
                {"mp-wg_hsa-t_hsa.spv.dis", 1, qfObe, FAIL},
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
                .withProgressModel(progressModel)
                .withTarget(Arch.VULKAN);
        Program program = new ProgramParser().parse(new File(programPath));
        Wmm mcm = new ParserCat().parse(new File(modelPath));
        return builder.build(program, mcm, EnumSet.of(TERMINATION));
    }
}
