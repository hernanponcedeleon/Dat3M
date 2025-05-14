package com.dat3m.dartagnan.llvm;

import com.dat3m.dartagnan.configuration.Alias;
import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.OptionNames;
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
import java.util.List;

import static com.dat3m.dartagnan.configuration.Alias.*;
import static com.dat3m.dartagnan.configuration.Arch.C11;
import static com.dat3m.dartagnan.configuration.Property.CAT_SPEC;
import static com.dat3m.dartagnan.utils.ResourceHelper.getRootPath;
import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class AllocFreeTest {

    private final String name;
    private final Arch target;
    private final Result expected;

    public AllocFreeTest(String name, Arch target, Result expected) {
        this.name = name;
        this.target = target;
        this.expected = expected;
    }

    @Parameterized.Parameters(name = "{index}: {0}, target={1}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
                {"test1_ok_1", C11, PASS},
                {"test1_ok_2", C11, PASS},
                {"test1_err_address", C11, FAIL},
                {"test1_err_race", C11, FAIL},
                {"test1_err_double_free_1", C11, FAIL},
                {"test1_err_double_free_2", C11, FAIL},
                {"test1_err_no_free", C11, FAIL},
                {"test1_err_no_alloc_1", C11, FAIL},
                {"test1_err_no_alloc_2", C11, FAIL},
                {"test1_err_use_before_alloc", C11, FAIL},
                {"test1_err_use_after_free", C11, FAIL},
        });
    }

    @Test
    public void testAssume() throws Exception {
        for (String mmPath : List.of("cat/rc11.cat", "cat/c11.cat", "cat/vmm.cat")) {
            for (Alias aliasMethod :  List.of(FIELD_INSENSITIVE , FIELD_SENSITIVE, FULL)) {
                Configuration cfg = mkConfiguration(aliasMethod);
                SolverContext ctx = mkCtx(cfg);
                AssumeSolver s = AssumeSolver.run(ctx, mkProver(ctx), mkTask(cfg, mmPath));
                assertEquals(expected, s.getResult());
            }
        }
    }

    @Test
    public void testRefinement() throws Exception {
        for (String mmPath : List.of("cat/rc11.cat", "cat/c11.cat", "cat/vmm.cat")) {
            for (Alias aliasMethod :  List.of(FIELD_INSENSITIVE , FIELD_SENSITIVE, FULL)) {
                Configuration cfg = mkConfiguration(aliasMethod);
                SolverContext ctx = mkCtx(cfg);
                RefinementSolver s = RefinementSolver.run(ctx, mkProver(ctx), mkTask(cfg, mmPath));
                assertEquals(expected, s.getResult());
            }
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

    private VerificationTask mkTask(Configuration configuration, String mmPath) throws Exception {
        VerificationTask.VerificationTaskBuilder builder = VerificationTask.builder()
                .withConfig(configuration)
                .withTarget(target);
        Program program = new ProgramParser().parse(new File(getTestResourcePath("alloc/" + name + ".ll")));
        Wmm mcm = new ParserCat().parse(new File(getRootPath(mmPath)));
        return builder.build(program, mcm, EnumSet.of(CAT_SPEC));
    }

    private Configuration mkConfiguration(Alias aliasMethod) throws InvalidConfigurationException {
        return Configuration.builder()
                .setOption(OptionNames.USE_INTEGERS, "true")
                .setOption(OptionNames.ALIAS_METHOD, aliasMethod.asStringOption())
                .build();
    }
}