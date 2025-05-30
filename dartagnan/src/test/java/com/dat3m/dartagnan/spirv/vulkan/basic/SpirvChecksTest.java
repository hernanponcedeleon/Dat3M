package com.dat3m.dartagnan.spirv.vulkan.basic;

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

import static com.dat3m.dartagnan.configuration.Property.CAT_SPEC;
import static com.dat3m.dartagnan.utils.ResourceHelper.getRootPath;
import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static com.dat3m.dartagnan.utils.Result.*;
import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class SpirvChecksTest {

    private final String modelPath = getRootPath("cat/spirv-check.cat");
    private final String programPath;
    private final int bound;
    private final Result expected;

    public SpirvChecksTest(String file, int bound, Result expected) {
        this.programPath = getTestResourcePath("spirv/vulkan/basic/" + file);
        this.bound = bound;
        this.expected = expected;
    }

    @Parameterized.Parameters(name = "{index}: {0}, {1}, {2}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
                {"empty-exists-false.spvasm", 1, PASS},
                {"empty-exists-true.spvasm", 1, PASS},
                {"empty-forall-false.spvasm", 1, PASS},
                {"empty-forall-true.spvasm", 1, PASS},
                {"empty-not-exists-false.spvasm", 1, PASS},
                {"empty-not-exists-true.spvasm", 1, PASS},
                {"init-forall.spvasm", 1, PASS},
                {"init-forall-split.spvasm", 1, PASS},
                {"init-forall-not-exists.spvasm", 1, PASS},
                {"init-forall-not-exists-fail.spvasm", 1, PASS},
                {"uninitialized-exists.spvasm", 1, PASS},
                {"uninitialized-forall.spvasm", 1, PASS},
                {"uninitialized-private-exists.spvasm", 1, PASS},
                {"uninitialized-private-forall.spvasm", 1, PASS},
                {"undef-exists.spvasm", 1, PASS},
                {"undef-forall.spvasm", 1, PASS},
                {"read-write-struct.spvasm", 1, PASS},
                {"read-write-vector.spvasm", 1, PASS},
                {"read-write.spvasm", 1, PASS},
                {"vector-init.spvasm", 1, PASS},
                {"vector.spvasm", 1, PASS},
                {"array.spvasm", 1, PASS},
                {"array-of-vector.spvasm", 1, PASS},
                {"array-of-vector1.spvasm", 1, PASS},
                {"vector-read-write.spvasm", 1, PASS},
                {"composite-construct.spvasm", 1, PASS},
                {"composite-extract.spvasm", 1, PASS},
                {"composite-initial.spvasm", 1, PASS},
                {"composite-insert.spvasm", 1, PASS},
                {"spec-id-integer.spvasm", 1, PASS},
                {"spec-id-boolean.spvasm", 1, PASS},
                {"mixed-size.spvasm", 1, PASS},
                {"ids.spvasm", 1, PASS},
                {"builtin-constant.spvasm", 1, PASS},
                {"builtin-variable.spvasm", 1, PASS},
                {"builtin-default-config.spvasm", 1, PASS},
                {"builtin-all-123.spvasm", 1, PASS},
                {"builtin-all-321.spvasm", 1, PASS},
                {"branch-cond-ff.spvasm", 1, PASS},
                {"branch-cond-ff-inverted.spvasm", 1, PASS},
                {"branch-cond-bf.spvasm", 1, UNKNOWN},
                {"branch-cond-bf.spvasm", 2, PASS},
                {"branch-cond-fb.spvasm", 1, UNKNOWN},
                {"branch-cond-fb.spvasm", 2, PASS},
                {"branch-race.spvasm", 1, PASS},
                {"branch-loop.spvasm", 2, UNKNOWN},
                {"branch-loop.spvasm", 3, PASS},
                {"branch-struct-if.spvasm", 1, PASS},
                {"branch-struct-if-inverted.spvasm", 1, PASS},
                {"branch-struct-if-else.spvasm", 1, PASS},
                {"branch-struct-if-else-inverted.spvasm", 1, PASS},
                {"loop-struct-cond.spvasm", 1, UNKNOWN},
                {"loop-struct-cond.spvasm", 2, PASS},
                {"loop-struct-cond-suffix.spvasm", 1, UNKNOWN},
                {"loop-struct-cond-suffix.spvasm", 2, PASS},
                {"loop-struct-cond-sequence.spvasm", 2, UNKNOWN},
                {"loop-struct-cond-sequence.spvasm", 3, PASS},
                {"loop-struct-cond-nested.spvasm", 2, UNKNOWN},
                {"loop-struct-cond-nested.spvasm", 3, PASS},
                {"phi.spvasm", 1, PASS},
                {"phi-unstruct-true.spvasm", 1, PASS},
                {"phi-unstruct-false.spvasm", 1, PASS},
                {"cmpxchg-const-const.spvasm", 1, PASS},
                {"cmpxchg-const-reg.spvasm", 1, PASS},
                {"cmpxchg-reg-const.spvasm", 1, PASS},
                {"cmpxchg-reg-reg.spvasm", 1, PASS},
                {"memory-scopes.spvasm", 1, PASS},
                {"rmw-extremum-true.spvasm", 1, PASS},
                {"rmw-extremum-false.spvasm", 1, PASS},
                {"push-constants.spvasm", 1, PASS},
                {"push-constants-pod.spvasm", 1, PASS},
                {"push-constant-mixed.spvasm", 1, PASS},
                {"bitwise-scalar.spvasm", 1, PASS},
                {"bitwise-vector.spvasm", 1, PASS},
                {"idx-overflow.spvasm", 1, PASS}
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
        return builder.build(program, mcm, EnumSet.of(CAT_SPEC));
    }
}
