package com.dat3m.dartagnan.spirv.basic;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.encoding.ProverWithTracker;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.solving.AssumeSolver;
import com.dat3m.dartagnan.verification.solving.RefinementSolver;
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
        this.programPath = getTestResourcePath("spirv/basic/" + file);
        this.bound = bound;
        this.expected = expected;
    }

    @Parameterized.Parameters(name = "{index}: {0}, {1}, {2}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
                {"empty-exists-false.spv.dis", 1, FAIL},
                {"empty-exists-true.spv.dis", 1, PASS},
                {"empty-forall-false.spv.dis", 1, FAIL},
                {"empty-forall-true.spv.dis", 1, PASS},
                {"empty-not-exists-false.spv.dis", 1, PASS},
                {"empty-not-exists-true.spv.dis", 1, FAIL},
                {"init-forall.spv.dis", 1, PASS},
                {"init-forall-split.spv.dis", 1, PASS},
                {"init-forall-not-exists.spv.dis", 1, PASS},
                {"init-forall-not-exists-fail.spv.dis", 1, FAIL},
                {"uninitialized-exists.spv.dis", 1, PASS},
                {"uninitialized-forall.spv.dis", 1, FAIL},
                {"uninitialized-private-exists.spv.dis", 1, PASS},
                {"uninitialized-private-forall.spv.dis", 1, FAIL},
                {"undef-exists.spv.dis", 1, PASS},
                {"undef-forall.spv.dis", 1, FAIL},
                {"read-write.spv.dis", 1, PASS},
                {"vector-init.spv.dis", 1, PASS},
                {"vector.spv.dis", 1, PASS},
                {"alignment.spv.dis", 1, PASS},
                {"array.spv.dis", 1, PASS},
                {"array-of-vector.spv.dis", 1, PASS},
                {"array-of-vector1.spv.dis", 1, PASS},
                {"vector-read-write.spv.dis", 1, PASS},
                {"spec-id-integer.spv.dis", 1, PASS},
                {"spec-id-boolean.spv.dis", 1, PASS},
                {"mixed-size.spv.dis", 1, PASS},
                {"ids.spv.dis", 1, PASS},
                {"builtin-constant.spv.dis", 1, PASS},
                {"builtin-variable.spv.dis", 1, PASS},
                {"builtin-default-config.spv.dis", 1, PASS},
                {"builtin-all-123.spv.dis", 1, PASS},
                {"builtin-all-321.spv.dis", 1, PASS},
                {"branch-cond-ff.spv.dis", 1, PASS},
                {"branch-cond-ff-inverted.spv.dis", 1, PASS},
                {"branch-cond-bf.spv.dis", 1, UNKNOWN},
                {"branch-cond-bf.spv.dis", 2, PASS},
                {"branch-cond-fb.spv.dis", 1, UNKNOWN},
                {"branch-cond-fb.spv.dis", 2, PASS},
                {"branch-race.spv.dis", 1, PASS},
                {"branch-loop.spv.dis", 2, UNKNOWN},
                {"branch-loop.spv.dis", 3, PASS},
                {"branch-struct-if.spv.dis", 1, PASS},
                {"branch-struct-if-inverted.spv.dis", 1, PASS},
                {"branch-struct-if-else.spv.dis", 1, PASS},
                {"branch-struct-if-else-inverted.spv.dis", 1, PASS},
                {"loop-struct-cond.spv.dis", 1, UNKNOWN},
                {"loop-struct-cond.spv.dis", 2, PASS},
                {"loop-struct-cond-suffix.spv.dis", 1, UNKNOWN},
                {"loop-struct-cond-suffix.spv.dis", 2, PASS},
                {"loop-struct-cond-sequence.spv.dis", 2, UNKNOWN},
                {"loop-struct-cond-sequence.spv.dis", 3, PASS},
                {"loop-struct-cond-nested.spv.dis", 2, UNKNOWN},
                {"loop-struct-cond-nested.spv.dis", 3, PASS},
                {"phi.spv.dis", 1, PASS},
                {"phi-unstruct-true.spv.dis", 1, PASS},
                {"phi-unstruct-false.spv.dis", 1, PASS},
                {"cmpxchg-const-const.spv.dis", 1, PASS},
                {"cmpxchg-const-reg.spv.dis", 1, PASS},
                {"cmpxchg-reg-const.spv.dis", 1, PASS},
                {"cmpxchg-reg-reg.spv.dis", 1, PASS},
                {"memory-scopes.spv.dis", 1, PASS},
                {"rmw-extremum-true.spv.dis", 1, PASS},
                {"rmw-extremum-false.spv.dis", 1, FAIL},
                {"push-constants.spv.dis", 1, PASS},
                {"push-constants-pod.spv.dis", 1, PASS},
                {"push-constant-mixed.spv.dis", 1, PASS}
        });
    }

    @Test
    public void testAllSolvers() throws Exception {
        try (SolverContext ctx = mkCtx(); ProverWithTracker prover = mkProver(ctx)) {
             assertEquals(expected, RefinementSolver.run(ctx, prover, mkTask()).getResult());
        }
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
