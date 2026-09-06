package com.dat3m.dartagnan.asm.riscv.ck;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Method;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.verification.ResultStatus;
import com.dat3m.dartagnan.utils.TestHelper;
import com.dat3m.dartagnan.verification.Task;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.sosy_lab.java_smt.SolverContextFactory;

import java.nio.file.Path;
import java.io.IOException;
import java.util.Arrays;
import java.util.EnumSet;

import static com.dat3m.dartagnan.configuration.Property.PROGRAM_SPEC;
import static com.dat3m.dartagnan.configuration.Property.TERMINATION;
import static com.dat3m.dartagnan.utils.ResourceHelper.getRootPath;
import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class AsmCkRISCVTest {

    private final Path modelPath = getRootPath("cat/riscv.cat");
    private final Path programPath;
    private final int bound;
    private final ResultStatus expected;

    public AsmCkRISCVTest(String file, int bound, ResultStatus expected) {
        this.programPath = getTestResourcePath("asm/riscv/ck/" + file + ".ll");
        this.bound = bound;
        this.expected = expected;
    }

    @Parameterized.Parameters(name = "{index}: {0}, {1}, {2}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
            {"spsc_queue", 1, ResultStatus.PASS},
        });
    }

    @Test
    public void testAllSolvers() throws Exception {
        assertEquals(expected, TestHelper.createAndRunSolver(mkTask(), Method.LAZY));
        assertEquals(expected, TestHelper.createAndRunSolver(mkTask(), Method.EAGER));
    }

    private Task mkTask() throws Exception {
        Task.TaskBuilder builder = Task.builder()
                .withSolver(SolverContextFactory.Solvers.YICES2)
                .withBound(bound)
                .withTarget(Arch.RISCV);
        Program program = new ProgramParser().parse(programPath);
        Wmm mcm = new ParserCat().parse(modelPath);
        return builder.build(program, mcm, EnumSet.of(TERMINATION, PROGRAM_SPEC));
    }
}
