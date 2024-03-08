package com.dat3m.dartagnan.spirv;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.ProgramBuilderSpv;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.memory.Location;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.specification.*;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.solving.AssumeSolver;
import com.dat3m.dartagnan.verification.solving.IncrementalSolver;
import com.dat3m.dartagnan.verification.solving.RefinementSolver;
import com.dat3m.dartagnan.verification.solving.TwoSolvers;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.sosy_lab.common.ShutdownManager;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.log.BasicLogManager;
import org.sosy_lab.java_smt.SolverContextFactory;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverContext;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.EnumSet;
import java.util.List;

import static com.dat3m.dartagnan.configuration.Property.PROGRAM_SPEC;
import static com.dat3m.dartagnan.program.specification.AbstractAssert.*;
import static com.dat3m.dartagnan.utils.ResourceHelper.getRootPath;
import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class SpirvTest {

    // TODO: Replace with Vulkan when RA is fixed
    private final String modelPath = getRootPath("cat/sc.cat");
    private final String programPath;
    private final Result expected;
    private final String grid;
    private final String specType;
    private final String spec;

    public SpirvTest(String file, Result expected, String grid, String specType, String spec) {
        this.programPath = getTestResourcePath("spirv/" + file);
        this.expected = expected;
        this.grid = grid;
        this.specType = specType;
        this.spec = spec;
    }

    @Parameterized.Parameters(name = "{index}: {0}, file={1}, expected={2}, grid={3}, specType={4}, spec={5}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
                {"empty.spv.dis", PASS, "1,1,1", ASSERT_TYPE_FORALL, "true"},
                {"empty.spv.dis", PASS, "1,1,1", ASSERT_TYPE_EXISTS, "true"},
                {"empty.spv.dis", FAIL, "1,1,1", ASSERT_TYPE_NOT_EXISTS, "true"},
                {"empty.spv.dis", FAIL, "1,1,1", ASSERT_TYPE_FORALL, "false"},
                {"empty.spv.dis", FAIL, "1,1,1", ASSERT_TYPE_EXISTS, "false"},
                {"empty.spv.dis", PASS, "1,1,1", ASSERT_TYPE_NOT_EXISTS, "false"},
                {"init.spv.dis", PASS, "1,1,1", ASSERT_TYPE_FORALL, "%v1=7 %v2=123 %v3=0"},
                {"read-write.spv.dis", PASS, "1,1,1", ASSERT_TYPE_FORALL, "%v1=2 %v2=1"},
                {"vector-init.spv.dis", PASS, "1,1,1", ASSERT_TYPE_FORALL, "%v3v[0]=2 %v3v[8]=1 %v3v[16]=0"},
                {"vector.spv.dis", PASS, "1,1,1", ASSERT_TYPE_FORALL, "%v3v[0]=0 %v3v[8]=1 %v3v[16]=2"},
                {"vector-read-write.spv.dis", PASS, "1,1,1", ASSERT_TYPE_FORALL, "%v3v[0]=2 %v3v[8]=1 %v3v[16]=0"},
                {"ids.spv.dis", PASS, "2,2,2", ASSERT_TYPE_FORALL,
                        "%out[0]=0 %out[8]=0 %out[16]=0 " +
                                "%out[24]=1 %out[32]=0 %out[40]=0 " +
                                "%out[48]=0 %out[56]=1 %out[64]=0 " +
                                "%out[72]=1 %out[80]=1 %out[88]=0 " +
                                "%out[96]=0 %out[104]=0 %out[112]=1 " +
                                "%out[120]=1 %out[128]=0 %out[136]=1 " +
                                "%out[144]=0 %out[152]=1 %out[160]=1 " +
                                "%out[168]=1 %out[176]=1 %out[184]=1"},
        });
    }

    @Test
    public void testAllSolvers() throws Exception {
        // TODO: Remove time printing
        long start = System.currentTimeMillis();
        try (SolverContext ctx = mkCtx(); ProverEnvironment prover = mkProver(ctx)) {
            assertEquals(expected, IncrementalSolver.run(ctx, prover, mkTask()).getResult());
        }

        System.out.println("1: " + (System.currentTimeMillis() - start));
        start = System.currentTimeMillis();
        try (SolverContext ctx = mkCtx(); ProverEnvironment prover = mkProver(ctx)) {
            assertEquals(expected, RefinementSolver.run(ctx, prover, mkTask()).getResult());
        }

        System.out.println("2: " + (System.currentTimeMillis() - start));
        start = System.currentTimeMillis();
        try (SolverContext ctx = mkCtx(); ProverEnvironment prover = mkProver(ctx)) {
            assertEquals(expected, AssumeSolver.run(ctx, prover, mkTask()).getResult());
        }

        System.out.println("3: " + (System.currentTimeMillis() - start));
        start = System.currentTimeMillis();
        try (SolverContext ctx = mkCtx(); ProverEnvironment prover1 = mkProver(ctx);
             ProverEnvironment prover2 = mkProver(ctx)) {
            assertEquals(expected, TwoSolvers.run(ctx, prover1, prover2, mkTask()).getResult());
        }
        System.out.println("4: " + (System.currentTimeMillis() - start));
    }

    private SolverContext mkCtx() throws InvalidConfigurationException {
        Configuration cfg = Configuration.builder().build();
        return SolverContextFactory.createSolverContext(
                cfg,
                BasicLogManager.create(cfg),
                ShutdownManager.create().getNotifier(),
                SolverContextFactory.Solvers.Z3);
    }

    private ProverEnvironment mkProver(SolverContext ctx) {
        return ctx.newProverEnvironment(SolverContext.ProverOptions.GENERATE_MODELS);
    }

    private VerificationTask mkTask() throws Exception {
        VerificationTask.VerificationTaskBuilder builder = VerificationTask.builder().withTarget(Arch.VULKAN);
        // TODO: assertions should be parsed from the test file
        Program program = new ProgramParser().parse(new File(programPath));
        AbstractAssert specification = mkAssert(program, spec);
        specification.setType(specType);
        program.setSpecification(specification);
        Wmm mcm = new ParserCat().parse(new File(modelPath));
        return builder.build(program, mcm, EnumSet.of(PROGRAM_SPEC));
    }

    private AbstractAssert mkAssert(Program program, String raw) {
        String[] parts = raw.split(" ");
        List<AbstractAssert> parsed = new ArrayList<>();
        for (String part : parts) {
            if ("true".equals(part)) {
                parsed.add(new AssertTrue());
            } else if ("false".equals(part)) {
                parsed.add(new AssertNot(new AssertTrue()));
            } else {
                String[] subs = part.split("=");
                if (subs.length == 2) {
                    Expression e1 = mkVar(program, subs[0]);
                    Expression e2 = mkVar(program, subs[1]);
                    parsed.add(new AssertBasic(e1, COpBin.EQ, e2));
                } else {
                    throw new RuntimeException("Cannot parse assertion component " + part);
                }
            }
        }
        return parsed.stream().reduce(new AssertTrue(), AssertCompositeAnd::new);
    }

    private Expression mkVar(Program program, String raw) {
        if (raw.startsWith("%")) {
            String varName = getVarName(raw);
            int offset = getOffset(raw);
            for (MemoryObject memoryObject : program.getMemory().getObjects()) {
                if (varName.equals(memoryObject.getCVar())) {
                    return new Location(varName, memoryObject, offset);
                }
            }
            throw new RuntimeException("Cannot parse assertion component " + raw);
        }
        IntegerType type = TypeFactory.getInstance().getIntegerType(64);
        return ExpressionFactory.getInstance().makeValue(Long.parseLong(raw), type);
    }

    private String getVarName(String raw) {
        int i1 = raw.indexOf("[");
        if (i1 >= 0) {
            return raw.substring(0, i1);
        }
        return raw;
    }

    private int getOffset(String raw) {
        int i1 = raw.indexOf("[");
        int i2 = raw.indexOf("]");
        if (i1 >= 0 && i2 > i1) {
            return Integer.parseInt(raw.substring(i1 + 1, i2));
        }
        return 0;
    }
}
